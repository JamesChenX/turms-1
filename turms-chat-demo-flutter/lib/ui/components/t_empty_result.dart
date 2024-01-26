import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../l10n/view_models/app_localizations_view_model.dart';
import '../themes/theme_config.dart';

class TEmptyResult extends ConsumerWidget {
  const TEmptyResult({super.key, this.icon = Symbols.description_rounded});

  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    return Center(
        child: ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.2126, 0.7152, 0.0722, 0, 0, //
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0, 0, 0, 1, 0,
      ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Opacity(
                opacity: 0.1,
                child: Icon(
                  icon,
                  size: 100,
                ),
              ),
              const Positioned(
                left: 40,
                top: 40,
                child: Opacity(
                  opacity: 0.5,
                  child: Icon(
                    Symbols.search_rounded,
                    size: 80,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(appLocalizations.noResultsFound,
              style: const TextStyle(
                  fontSize: 18, color: ThemeConfig.textColorSecondary)),
          const SizedBox(height: 32),
        ],
      ),
    ));
  }
}