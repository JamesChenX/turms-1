part of 'settings_pane.dart';

class _SettingsPaneView extends StatelessWidget {
  const _SettingsPaneView(this._settingsPaneController, {super.key});

  final _SettingsPaneController _settingsPaneController;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        key: _settingsPaneController.scrollViewKey,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: TForm(
            formData: TFormData(groups: _buildFormGroups(context)),
          ),
        ),
      );

  List<TFormFieldGroup> _buildFormGroups(BuildContext context) {
    final appLocalizations = _settingsPaneController.appLocalizations;
    return [
      for (final entry in formFieldGroupToContext.entries)
        switch (entry.key) {
          SettingFormFieldGroup.launchAndExit =>
            _buildLaunchAndExitFieldGroup(entry.value, appLocalizations),
          SettingFormFieldGroup.shortcuts => _buildShortcutsFieldGroup(
              entry.value,
              appLocalizations,
              _settingsPaneController.actionToShortcut,
              context),
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
              onChanged: _settingsPaneController.updateLaunchOnStartup,
              value:
                  _settingsPaneController.userSettings.launchOnStartup ?? false,
            ),
            TFormFieldRadioGroup<SettingActionOnClose>(
              label: appLocalizations.actionOnClose,
              groupValue: _settingsPaneController.userSettings.actionOnClose ??
                  SettingActionOnClose.minimizeToTray,
              onChanged: _settingsPaneController.updateActionOnClose,
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
                    actionToShortcut[HomePageAction.showChatPage]!.keyList,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) {
                  // final registry = ShortcutRegistry.maybeOf(context);
                  _settingsPaneController.updateShortcut(
                      HomePageAction.showChatPage,
                      LogicalKeySet.fromSet(keys.toSet()));
                }),
            TFormFieldShortcutTextField(
                label: '${appLocalizations.goToContactsPage}:',
                initialKeys:
                    actionToShortcut[HomePageAction.showContactsPage]!.keyList,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) =>
                    _settingsPaneController.updateShortcut(
                        HomePageAction.showContactsPage,
                        LogicalKeySet.fromSet(keys.toSet()))),
            TFormFieldShortcutTextField(
                label: '${appLocalizations.goToFilesPage}:',
                initialKeys:
                    actionToShortcut[HomePageAction.showFilesPage]!.keyList,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) =>
                    _settingsPaneController.updateShortcut(
                        HomePageAction.showFilesPage,
                        LogicalKeySet.fromSet(keys.toSet()))),
            TFormFieldShortcutTextField(
                label: '${appLocalizations.openSettingsDialog}:',
                initialKeys:
                    actionToShortcut[HomePageAction.showSettingsDialog]!
                        .keyList,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) =>
                    _settingsPaneController.updateShortcut(
                        HomePageAction.showSettingsDialog,
                        LogicalKeySet.fromSet(keys.toSet()))),
            TFormFieldShortcutTextField(
                label: '${appLocalizations.openAboutDialog}:',
                initialKeys:
                    actionToShortcut[HomePageAction.showAboutDialog]!.keyList,
                onShortcutChanged: (List<LogicalKeyboardKey> keys) =>
                    _settingsPaneController.updateShortcut(
                        HomePageAction.showAboutDialog,
                        LogicalKeySet.fromSet(keys.toSet()))),
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
              value:
                  _settingsPaneController.userSettings.newMessageNotification ??
                      false,
              onChanged: _settingsPaneController.updateNewMessageNotification,
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
              value: _settingsPaneController.useSystemLocale
                  ? SettingLocale.system
                  : _nameToLocale[
                      _settingsPaneController.appLocalizations.localeName]!,
              entries: [
                TDropdownMenuEntry(
                    label: appLocalizations.systemLanguage,
                    value: SettingLocale.system),
                TDropdownMenuEntry(label: 'English', value: SettingLocale.en),
                TDropdownMenuEntry(label: '简体中文', value: SettingLocale.zhCn),
              ],
              onSelected: (SettingLocale value) async {
                await _settingsPaneController.updateLocale(value);
              },
            ),
            TFormFieldSelect(
              label: appLocalizations.theme,
              value: _settingsPaneController.userSettings.theme,
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
                await _settingsPaneController.updateThemeMode(value);
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
              value: _settingsPaneController
                      .userSettings.checkForUpdatesAutomatically ??
                  false,
              onChanged:
                  _settingsPaneController.updateCheckForUpdatesAutomatically,
            )
          ]);
}

final _nameToLocale = {
  for (SettingLocale locale in SettingLocale.values) locale.name: locale
};
