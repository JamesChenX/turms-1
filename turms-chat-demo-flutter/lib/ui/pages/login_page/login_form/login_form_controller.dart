import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/app/models/app_settings.dart';
import '../../../../domain/app/repositories/app_settings_repository.dart';
import '../../../../domain/app/view_models/app_settings_view_model.dart';
import '../../../../domain/user/models/user.dart';
import '../../../../domain/user/models/user_settings.dart';
import '../../../../domain/user/repositories/user_login_info_repository.dart';
import '../../../../domain/user/repositories/user_settings_repository.dart';
import '../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../domain/user/view_models/user_login_infos_view_model.dart';
import '../../../../domain/user/view_models/user_settings_view_model.dart';
import '../../../../infra/sqlite/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
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
    appLocalizations = ref.read(appLocalizationsViewModel);
    appSettings = ref.read(appSettingsViewModel)!;
    userLoginInfos = ref.read(userLoginInfosViewModel);
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
    }
    await appSettingsRepository.upsertRememberMe(shouldRemember);
    // read user settings
    final userSettingsTableData =
        await userSettingsRepository.selectAll(userId);
    final userSettings = UserSettings.fromTableData(userSettingsTableData);
    ref.read(userSettingsViewModel.notifier).state = userSettings;

    // set status for logged in user
    ref.read(loggedInUserViewModel.notifier).state =
        User(userId: userId, name: 'James Chen');
    isWaitingLoginRequest = false;
    setState(() {});
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