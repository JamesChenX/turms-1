part of 'settings_pane.dart';

class _SettingsPaneController extends ConsumerState<SettingsPane> {
  late AppLocalizations appLocalizations;
  late Map<HomePageAction, ShortcutActivator> actionToShortcut;

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
    useSystemLocale = ref.watch(useSystemLocaleViewModel);
    themeMode = ref.watch(appThemeViewModel).themeMode;
    userSettings = ref.watch(userSettingsViewModel)!;

    return _SettingsPaneView(this);
  }

  Future<void> updateLocale(SettingLocale value) async {
    final Locale locale;
    if (value case SettingLocale.system) {
      ref.read(useSystemLocaleViewModel.notifier).state = true;
      locale = WidgetsBinding.instance.platformDispatcher.locale;
      await userSettingsRepository.delete(
        ref.read(loggedInUserViewModel)!.userId,
        UserSettingId.locale.name,
      );
    } else {
      ref.read(useSystemLocaleViewModel.notifier).state = false;
      locale = Locale(value.name);
      await userSettingsRepository.upsert(
          ref.read(loggedInUserViewModel)!.userId,
          UserSettingId.locale.name,
          UserSettingId.locale.convertValueToString(locale));
    }
    ref.read(appLocalizationsViewModel.notifier).state =
        lookupAppLocalizations(locale);
    ref.read(userSettingsViewModel.notifier).state!.locale = locale;
    userSettingsViewModelRef.notifyListeners();
  }

  Future<void> updateLaunchOnStartup(bool value) async {
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
    ref.read(userSettingsViewModel.notifier).state!.launchOnStartup = value;
    userSettingsViewModelRef.notifyListeners();
  }

  Future<void> updateActionOnClose(SettingActionOnClose value) async {
    await userSettingsRepository.upsert(
        ref.read(loggedInUserViewModel)!.userId,
        UserSettingId.actionOnClose.name,
        UserSettingId.actionOnClose.convertValueToString(value));
    ref.read(userSettingsViewModel.notifier).state!.actionOnClose = value;
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

  Future<void> updateThemeMode(ThemeMode value) async {
    await userSettingsRepository.upsert(
        ref.read(loggedInUserViewModel)!.userId,
        UserSettingId.theme.name,
        UserSettingId.theme.convertValueToString(value));
    ref.read(userSettingsViewModel.notifier).state!.theme = value;
    userSettingsViewModelRef.notifyListeners();
  }
}
