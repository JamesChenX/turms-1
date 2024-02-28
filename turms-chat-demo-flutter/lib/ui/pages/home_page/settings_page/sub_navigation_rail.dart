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
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
                  color:
                      ThemeConfig.settingPageSubNavigationRailDividerColor))),
      width: 140,
      // padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: ,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
            child: Text(
                textAlign: TextAlign.start,
                appLocalizations.settings,
                style: const TextStyle(
                    fontSize: 16, color: ThemeConfig.textColorSecondary)),
          ),
          // Note that we don't change the tab color when the tab is selected
          // because we have only a few settings, and the UI will be weired
          // if we change the color when the tab is selected.
          TTabs(tabs: [
            for (final entry in formFieldGroupToContext.entries)
              TTab(id: entry.key, text: entry.value.getTitle(appLocalizations))
          ], onTabSelected: (index, tab) => widget.onTabSelected(index, tab)),
        ],
      ),
    );
  }
}
