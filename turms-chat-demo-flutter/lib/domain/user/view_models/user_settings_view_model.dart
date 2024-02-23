import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_settings.dart';

late StateProviderRef<UserSettings?> userSettingsViewModelRef;
final userSettingsViewModel = StateProvider<UserSettings?>((ref) {
  userSettingsViewModelRef = ref;
  return null;
});
