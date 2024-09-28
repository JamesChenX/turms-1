import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import 'user_profile.dart';
import 'user_profile_view.dart';

class UserProfileController extends ConsumerState<UserProfile> {
  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    return UserProfileView(this);
  }
}
