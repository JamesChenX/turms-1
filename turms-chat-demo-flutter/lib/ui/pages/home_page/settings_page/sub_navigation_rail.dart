import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/t_tabs.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../themes/theme_config.dart';
import 'setting_form_field_groups.dart';

class SubNavigationRail extends ConsumerStatefulWidget {
  const SubNavigationRail({super.key, required this.onTabSelected});

  final void Function(int, TTab) onTabSelected;

  @override
  ConsumerState<SubNavigationRail> createState() => _SubNavigationRailState();
}

class _SubNavigationRailState extends ConsumerState<SubNavigationRail> {
  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
              border: Border(
                  right:
                      BorderSide(color: Color.fromARGB(255, 240, 240, 240)))),
          width: 140,
          // padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: ,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 8, bottom: 24),
                child: Text(
                    textAlign: TextAlign.start,
                    appLocalizations.settings,
                    style: const TextStyle(
                        fontSize: 16, color: ThemeConfig.secondaryTextColor)),
              ),
              TTabs(
                  tabs: [
                    for (final entry in formFieldGroupToContext.entries)
                      TTab(
                          id: entry.key,
                          text: entry.value.getTitle(appLocalizations))
                  ],
                  onTabSelected: (index, tab) =>
                      widget.onTabSelected(index, tab)),
            ],
          ),
        ),
      ],
    );
  }
}