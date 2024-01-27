import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/user/models/user_setting_ids.dart';
import '../../../../domain/user/repositories/user_settings_repository.dart';
import '../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../domain/user/view_models/user_settings_view_model.dart';
import '../../../../infra/keyboard/shortcut_extensions.dart';
import '../../../components/t_dropdown_menu.dart';
import '../../../components/t_form/t_form.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../l10n/view_models/use_system_locale_view_model.dart';
import '../../../themes/app_theme_view_model.dart';
import '../action_to_shortcut_view_model.dart';
import '../home_page_action.dart';
import 'setting_action_on_close.dart';
import 'setting_form_field_groups.dart';
import 'setting_locale.dart';

class SettingsPane extends ConsumerStatefulWidget {
  const SettingsPane(
      {super.key, required this.onSettingFormFieldGroupScrolled});

  final void Function(int index) onSettingFormFieldGroupScrolled;

  @override
  ConsumerState<SettingsPane> createState() => _SettingsPaneState();
}

class _SettingsPaneState extends ConsumerState<SettingsPane> {
  GlobalKey _scrollViewKey = GlobalKey();
  SettingActionOnClose _actionOnClose = SettingActionOnClose.minimizeToTray;

  bool _newMessageNotification = true;

  bool _launchOnStartup = false;

  bool _checkForUpdatesAutomatically = true;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        key: _scrollViewKey,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: TForm(
            formData: TFormData(groups: _buildFormGroups(context)),
          ),
        ),
      );

  List<TFormFieldGroup> _buildFormGroups(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final actionToShortcut = ref.watch(actionToShortcutViewModel);
    return [
      for (final entry in formFieldGroupToContext.entries)
        switch (entry.key) {
          SettingFormFieldGroup.launchAndExit =>
            _buildLaunchAndExitFieldGroup(entry.value, appLocalizations),
          SettingFormFieldGroup.shortcuts => _buildShortcutsFieldGroup(
              entry.value, appLocalizations, actionToShortcut, context),
          SettingFormFieldGroup.notifications =>
            _buildNotificationsFieldGroup(entry.value, appLocalizations),
          SettingFormFieldGroup.appearance =>
            _buildAppearanceFieldGroup(entry.value, appLocalizations),
          SettingFormFieldGroup.update =>
            _buildUpdateFieldGroup(entry.value, appLocalizations),
        }
    ];
  }

  TFormFieldGroup _buildLaunchAndExitFieldGroup(
          SettingFormFieldGroupContext context,
          AppLocalizations appLocalizations) =>
      TFormFieldGroup(
          title: context.getTitle(appLocalizations),
          titleKey: context.key,
          fields: [
            TFormFieldCheckbox(
              label: appLocalizations.launchOnStartup,
              onChanged: (value) {
                _launchOnStartup = value;
                setState(() {});
              },
              value: _launchOnStartup,
            ),
            TFormFieldRadioGroup<SettingActionOnClose>(
              label: appLocalizations.actionOnClose,
              groupValue: _actionOnClose,
              onChanged: (SettingActionOnClose value) {
                _actionOnClose = value;
                setState(() {});
              },
              radios: [
                TFormFieldRadio(
                  value: SettingActionOnClose.minimizeToTray,
                  label: appLocalizations.minimizeToTray,
                ),
                TFormFieldRadio(
                  value: SettingActionOnClose.exit,
                  label: appLocalizations.exit,
                )
              ],
            )
          ]);

  TFormFieldGroup _buildShortcutsFieldGroup(
          SettingFormFieldGroupContext formFieldGroupContext,
          AppLocalizations appLocalizations,
          Map<HomePageAction, ShortcutActivator> actionToShortcut,
          BuildContext context) =>
      TFormFieldGroup(
          title: formFieldGroupContext.getTitle(appLocalizations),
          titleKey: formFieldGroupContext.key,
          fields: [
            // todo: shortcut conflict
            TFormFieldShortcutTextField(
                label: '${appLocalizations.goToChatPage}:',
                initialKeys:
                    actionToShortcut[HomePageAction.showChatPage]!.keys,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) {
                  final registry = ShortcutRegistry.maybeOf(context);
                  actionToShortcut[HomePageAction.showChatPage] =
                      LogicalKeySet.fromSet(keys.toSet());
                }),
            TFormFieldShortcutTextField(
                label: '${appLocalizations.goToContactsPage}:',
                initialKeys:
                    actionToShortcut[HomePageAction.showContactsPage]!.keys,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) =>
                    actionToShortcut[HomePageAction.showContactsPage] =
                        LogicalKeySet.fromSet(keys.toSet())),
            TFormFieldShortcutTextField(
                label: '${appLocalizations.goToFilesPage}:',
                initialKeys:
                    actionToShortcut[HomePageAction.showFilesPage]!.keys,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) =>
                    actionToShortcut[HomePageAction.showFilesPage] =
                        LogicalKeySet.fromSet(keys.toSet())),
            TFormFieldShortcutTextField(
                label: '${appLocalizations.openSettingsDialog}:',
                initialKeys:
                    actionToShortcut[HomePageAction.showSettingsDialog]!.keys,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) =>
                    actionToShortcut[HomePageAction.showSettingsDialog] =
                        LogicalKeySet.fromSet(keys.toSet())),
            TFormFieldShortcutTextField(
                label: '${appLocalizations.openAboutDialog}:',
                initialKeys:
                    actionToShortcut[HomePageAction.showAboutDialog]!.keys,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) =>
                    actionToShortcut[HomePageAction.showAboutDialog] =
                        LogicalKeySet.fromSet(keys.toSet())),
          ]);

  TFormFieldGroup _buildNotificationsFieldGroup(
          SettingFormFieldGroupContext context,
          AppLocalizations appLocalizations) =>
      TFormFieldGroup(
          title: context.getTitle(appLocalizations),
          titleKey: context.key,
          fields: [
            TFormFieldCheckbox(
              label: appLocalizations.newMessageNotification,
              value: _newMessageNotification,
              onChanged: (bool value) {
                _newMessageNotification = value;
                setState(() {});
              },
            )
          ]);

  TFormFieldGroup _buildAppearanceFieldGroup(
          SettingFormFieldGroupContext context,
          AppLocalizations appLocalizations) =>
      TFormFieldGroup(
          title: context.getTitle(appLocalizations),
          titleKey: context.key,
          fields: [
            TFormFieldSelect(
              label: appLocalizations.language,
              value: ref.watch(useSystemLocaleViewModel)
                  ? SettingLocale.system
                  : _nameToLocale[
                      ref.watch(appLocalizationsViewModel).localeName]!,
              entries: [
                TDropdownMenuEntry(
                    label: appLocalizations.systemLanguage,
                    value: SettingLocale.system),
                TDropdownMenuEntry(label: 'English', value: SettingLocale.en),
                TDropdownMenuEntry(label: '简体中文', value: SettingLocale.zhCn),
              ],
              onSelected: (SettingLocale value) {
                switch (value) {
                  case SettingLocale.system:
                    ref.read(useSystemLocaleViewModel.notifier).state = true;
                    ref.read(appLocalizationsViewModel.notifier).state =
                        lookupAppLocalizations(
                            WidgetsBinding.instance.platformDispatcher.locale);
                    break;
                  case SettingLocale.en:
                    ref.read(useSystemLocaleViewModel.notifier).state = false;
                    ref.read(appLocalizationsViewModel.notifier).state =
                        lookupAppLocalizations(Locale(value.name));
                    break;
                  case SettingLocale.zhCn:
                    ref.read(useSystemLocaleViewModel.notifier).state = false;
                    ref.read(appLocalizationsViewModel.notifier).state =
                        lookupAppLocalizations(Locale(value.name));
                    break;
                }
              },
            ),
            TFormFieldSelect(
              label: appLocalizations.theme,
              value: ref.watch(appThemeViewModel).themeMode,
              entries: [
                TDropdownMenuEntry(
                    label: appLocalizations.systemTheme,
                    value: ThemeMode.system),
                TDropdownMenuEntry(
                    label: appLocalizations.lightTheme, value: ThemeMode.light),
                TDropdownMenuEntry(
                    label: appLocalizations.darkTheme, value: ThemeMode.dark),
              ],
              onSelected: (ThemeMode value) async {
                final previousTheme =
                    ref.read(userSettingsViewModel.notifier).state?.theme;
                final themeStr = value.name;
                if (previousTheme != themeStr) {
                  await userSettingsRepository.upsert(
                      ref.read(loggedInUserViewModel)!.userId,
                      UserSettingIds.theme,
                      themeStr);
                  ref.read(userSettingsViewModel.notifier).state!.theme =
                      themeStr;
                  userSettingsViewModelRef.notifyListeners();
                }
              },
            )
          ]);

  TFormFieldGroup _buildUpdateFieldGroup(SettingFormFieldGroupContext context,
          AppLocalizations appLocalizations) =>
      TFormFieldGroup(
          title: context.getTitle(appLocalizations),
          titleKey: context.key,
          fields: [
            TFormFieldCheckbox(
              label: appLocalizations.checkForUpdatesAutomatically,
              value: _checkForUpdatesAutomatically,
              onChanged: (bool value) {
                _checkForUpdatesAutomatically = value;
                setState(() {});
              },
            )
          ]);
}

final _nameToLocale = {
  for (SettingLocale locale in SettingLocale.values) locale.name: locale
};