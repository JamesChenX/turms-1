import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../domain/app/models/app_settings.dart';
import '../../../../domain/app/repositories/app_settings_repository.dart';
import '../../../../domain/app/view_models/app_settings_view_model.dart';
import '../../../../domain/user/models/setting_action_on_close.dart';
import '../../../../domain/user/models/user.dart';
import '../../../../domain/user/models/user_settings.dart';
import '../../../../domain/user/repositories/user_login_info_repository.dart';
import '../../../../domain/user/repositories/user_settings_repository.dart';
import '../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../domain/user/view_models/user_login_infos_view_model.dart';
import '../../../../domain/user/view_models/user_settings_view_model.dart';
import '../../../../infra/autostart/autostart_manager.dart';
import '../../../../infra/github/github_client.dart';
import '../../../../infra/logging/logger.dart';
import '../../../../infra/sqlite/app_database.dart';
import '../../../../infra/task/task_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../l10n/view_models/use_system_locale_view_model.dart';
import '../../home_page/home_page_action.dart';
import 'login_form.dart';
import 'login_form_view.dart';

class LoginFormController extends ConsumerState<LoginForm> {
  final formKey = GlobalKey<FormState>();

  bool isWaitingLoginRequest = false;

  late Int64 userId;
  late String password;
  bool? rememberMe;

  late AppLocalizations appLocalizations;
  late AppSettings appSettings;
  late List<UserLoginInfoTableData> userLoginInfos;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    appSettings = ref.watch(appSettingsViewModel)!;
    userLoginInfos = ref.watch(userLoginInfosViewModel);
    return LoginFormView(this);
  }

  void submit() {
    if (isWaitingLoginRequest || !formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();
    isWaitingLoginRequest = true;
    setState(() {});
    login();
  }

  Future<void> login() async {
    // TODO: use real API
    // Behavior as if we were waiting for a login response
    await Future.delayed(const Duration(seconds: 1));
    // store app settings
    final shouldRemember = rememberMe!;
    if (shouldRemember) {
      await userLoginInfoRepository.upsert(userId.toString(), password);
    } else {
      await userLoginInfoRepository.deleteAll();
    }
    // logger. TODO
    await appSettingsRepository.upsertRememberMe(shouldRemember);
    // read user settings
    final userSettings = await _getUserSettings();
    ref.read(userSettingsViewModel.notifier).state = userSettings;
    final locale = userSettings.locale;
    if (locale != null) {
      ref.read(useSystemLocaleViewModel.notifier).state = false;
      ref.read(appLocalizationsViewModel.notifier).state =
          lookupAppLocalizations(locale);
    }

    TaskUtils.addPeriodicTask(
        name: 'checkForUpdates',
        duration: const Duration(hours: 1),
        callback: () async {
          final checkForUpdates =
              ref.read(userSettingsViewModel)?.checkForUpdatesAutomatically ??
                  false;
          if (!checkForUpdates) {
            return true;
          }
          try {
            final file = await GithubUtils.downloadLatestApp();
            // TODO: pop up a dialog to notify user.
          } catch (e) {
            logger.w('Failed to download latest application: ${e.toString()}');
          }
          return true;
        });

    // set status for logged in user
    ref.read(loggedInUserViewModel.notifier).state =
        User(userId: userId, name: 'James Chen');
    isWaitingLoginRequest = false;
    setState(() {});
  }

  Future<UserSettings> _getUserSettings() async {
    final userSettingsTableData =
        await userSettingsRepository.selectAll(userId);
    final (userSettings, exception) =
        UserSettings.fromTableData(userSettingsTableData);
    if (exception != null) {
      if (kReleaseMode) {
        logger.w('Failed to read user settings: ${exception.toString()}');
      } else {
        throw exception;
      }
    }

    for (final type in HomePageAction.values) {
      switch (type) {
        case HomePageAction.showChatPage:
          if (!userSettings.shortcutShowChatPage.$2) {
            userSettings.shortcutShowChatPage =
                (type.defaultShortcutActivator, true);
          }
          break;
        case HomePageAction.showContactsPage:
          if (!userSettings.shortcutShowContactsPage.$2) {
            userSettings.shortcutShowContactsPage =
                (type.defaultShortcutActivator, true);
          }
          break;
        case HomePageAction.showFilesPage:
          if (!userSettings.shortcutShowFilesPage.$2) {
            userSettings.shortcutShowFilesPage =
                (type.defaultShortcutActivator, true);
          }
          break;
        case HomePageAction.showSettingsDialog:
          if (!userSettings.shortcutShowSettingsDialog.$2) {
            userSettings.shortcutShowSettingsDialog =
                (type.defaultShortcutActivator, true);
          }
          break;
        case HomePageAction.showAboutDialog:
          if (!userSettings.shortcutShowAboutDialog.$2) {
            userSettings.shortcutShowAboutDialog =
                (type.defaultShortcutActivator, true);
          }
          break;
      }
    }
    return userSettings
      // Set default values if the user never set them.
      ..actionOnClose ??= SettingActionOnClose.minimizeToTray
      ..newMessageNotification ??= true
      ..launchOnStartup ??= await autostartManager.isEnabled()
      ..checkForUpdatesAutomatically ??= true;
  }

  void setUserId(String? newValue) {
    if (newValue != null) {
      userId = Int64.parseInt(newValue);
    }
  }

  void setPassword(String? newValue) {
    if (newValue != null) {
      password = newValue;
    }
  }
}
