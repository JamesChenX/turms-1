import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_localizations.dart';

final appLocalizationsViewModel = StateProvider<AppLocalizations>(
    (ref) => lookupAppLocalizations(const Locale('en')));