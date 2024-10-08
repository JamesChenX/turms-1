part of 'settings_pane.dart';

class _SettingsPaneController extends ConsumerState<SettingsPane> {
  late AppLocalizations appLocalizations;
  late Map<HomePageAction, Shortcut> actionToShortcut;

  late bool useSystemLocale;
  late ThemeMode themeMode;

  final GlobalKey scrollViewKey = GlobalKey();
  final AutostartManager autostartManager = AutostartManager.create(
      appName: AppConfig.packageInfo.appName,
      appPath: Platform.resolvedExecutable,
      args: []);

  late UserSettings userSettings;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    actionToShortcut = ref.watch(actionToShortcutViewModel);
    final localInfo = ref.watch(localeInfoViewModel);
    useSystemLocale = localInfo.isSystemLocale;
    final theme = ref.watch(themeViewModel);
    themeMode = theme.extension<AppThemeExtension>()!.themeMode;
    userSettings = ref.watch(userSettingsViewModel)!;

    return _SettingsPaneView(this);
  }

  Future<void> updateActionOnClose(SettingActionOnClose value) async {
    final userSettingsController = ref.read(userSettingsViewModel.notifier);
    await userSettingsRepository.upsert(
        ref.read(loggedInUserViewModel)!.userId,
        UserSettingId.actionOnClose.name,
        UserSettingId.actionOnClose.convertValueToString(value));
    userSettingsController.state!.actionOnClose = value;
    userSettingsViewModelRef.notifyListeners();
  }

  Future<void> updateCheckForUpdatesAutomatically(bool value) async {
    await userSettingsRepository.upsert(
        ref.read(loggedInUserViewModel)!.userId,
        UserSettingId.checkForUpdatesAutomatically.name,
        UserSettingId.checkForUpdatesAutomatically.convertValueToString(value));
    ref
        .read(userSettingsViewModel.notifier)
        .state!
        .checkForUpdatesAutomatically = value;
    userSettingsViewModelRef.notifyListeners();
  }

  Future<void> updateLaunchOnStartup(bool value) async {
    final userSettingsController = ref.read(userSettingsViewModel.notifier);
    try {
      if (value) {
        await autostartManager.enable();
      } else {
        await autostartManager.disable();
      }
    } catch (e) {
      unawaited(TToast.showToast(
          context, appLocalizations.failedToUpdateSettings(e.toString())));
    }
    userSettingsController.state!.launchOnStartup = value;
    userSettingsViewModelRef.notifyListeners();
  }

  Future<void> updateLocale(SettingLocale value) async {
    final Locale locale;
    if (value == SettingLocale.system) {
      locale = ref.read(localeInfoViewModel.notifier).useSystemLocale().locale;
      await userSettingsRepository.upsert(
        ref.read(loggedInUserViewModel)!.userId,
        UserSettingId.locale.name,
        UserSettings.unsetValue,
      );
      ref.read(userSettingsViewModel.notifier).state!.locale = null;
    } else {
      final newLocale = ref
          .read(localeInfoViewModel.notifier)
          .updateLocaleIfSupported(value.name)
          ?.locale;
      assert(newLocale != null, 'Unsupported locale: ${value.name}');
      locale = newLocale!;
      await userSettingsRepository.upsert(
          ref.read(loggedInUserViewModel)!.userId,
          UserSettingId.locale.name,
          UserSettingId.locale.convertValueToString(locale));
      ref.read(userSettingsViewModel.notifier).state!.locale = locale;
    }
    userSettingsViewModelRef.notifyListeners();
  }

  Future<void> updateNewMessageNotification(bool value) async {
    await userSettingsRepository.upsert(
        ref.read(loggedInUserViewModel)!.userId,
        UserSettingId.newMessageNotification.name,
        UserSettingId.newMessageNotification.convertValueToString(value));
    ref.read(userSettingsViewModel.notifier).state!.newMessageNotification =
        value;
    userSettingsViewModelRef.notifyListeners();
  }

  Future<void> updateShortcut(
      {bool notify = true,
      bool resetConflictedShortcuts = true,
      required HomePageAction action,
      ShortcutActivator? shortcutActivator}) async {
    final userSettingId = action.userSettingId;
    final userId = ref.read(loggedInUserViewModel)!.userId;
    final userSettingsController = ref.read(userSettingsViewModel.notifier);
    if (shortcutActivator == null) {
      await userSettingsRepository.upsert(
        userId,
        userSettingId.name,
        UserSettings.unsetValue,
      );
    } else {
      if (resetConflictedShortcuts) {
        for (final homePageAction in HomePageAction.values) {
          if (action != homePageAction &&
              (actionToShortcut[homePageAction]!
                      .shortcutActivator
                      ?.hasSameKeys(shortcutActivator) ??
                  false)) {
            await updateShortcut(notify: false, action: homePageAction);
          }
        }
      }
      await userSettingsRepository.upsert(userId, userSettingId.name,
          userSettingId.convertValueToString(shortcutActivator));
    }
    final userSettings = userSettingsController.state!;
    switch (action) {
      case HomePageAction.showChatPage:
        userSettings.shortcutShowChatPage = Shortcut(shortcutActivator, true);
        break;
      case HomePageAction.showContactsPage:
        userSettings.shortcutShowContactsPage =
            Shortcut(shortcutActivator, true);
        break;
      case HomePageAction.showFilesPage:
        userSettings.shortcutShowFilesPage = Shortcut(shortcutActivator, true);
        break;
      case HomePageAction.showSettingsDialog:
        userSettings.shortcutShowSettingsDialog =
            Shortcut(shortcutActivator, true);
        break;
      case HomePageAction.showAboutDialog:
        userSettings.shortcutShowAboutDialog =
            Shortcut(shortcutActivator, true);
        break;
    }
    if (notify) {
      userSettingsViewModelRef.notifyListeners();
    }
  }

  Future<void> updateThemeMode(ThemeMode value) async {
    final userSettingsController = ref.read(userSettingsViewModel.notifier);
    await userSettingsRepository.upsert(
        ref.read(loggedInUserViewModel)!.userId,
        UserSettingId.theme.name,
        UserSettingId.theme.convertValueToString(value));
    userSettingsController.state!.theme = value;
    userSettingsViewModelRef.notifyListeners();
  }

  bool hasAnyShortcutChanged() {
    for (final homePageAction in HomePageAction.values) {
      final hasSameKeys = actionToShortcut[homePageAction]
              ?.shortcutActivator
              ?.hasSameKeys(homePageAction.defaultShortcutActivator) ??
          false;
      if (!hasSameKeys) {
        return true;
      }
    }
    return false;
  }

  Future<void> resetShortcuts() async {
    for (final homePageAction in HomePageAction.values) {
      await updateShortcut(
          notify: false,
          resetConflictedShortcuts: false,
          action: homePageAction,
          shortcutActivator: homePageAction.defaultShortcutActivator);
    }
    userSettingsViewModelRef.notifyListeners();
  }
}
