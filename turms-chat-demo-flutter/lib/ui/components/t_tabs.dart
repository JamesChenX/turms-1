import 'package:flutter/material.dart';

import '../themes/theme_config.dart';

class TTabs extends StatefulWidget {
  const TTabs({super.key, required this.tabs, required this.onTabSelected});

  final List<TTab> tabs;
  final void Function(int index, TTab tab) onTabSelected;

  @override
  State<TTabs> createState() => _TTabsState();
}

class _TTabsState extends State<TTabs> {
  Object? _hoveringTabId;
  Object? _selectedTabId;

  @override
  Widget build(BuildContext context) => Column(
        children: widget.tabs.indexed.map((item) {
          final (index, tab) = item;
          final isSelected = _selectedTabId == tab.id;
          return _buildTab(tab, index, isSelected);
        }).toList(),
      );

  Widget _buildTab(TTab tab, int index, bool isSelected) {
    final child = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveringTabId = tab.id),
      onExit: (_) => setState(() {
        if (_hoveringTabId == tab.id) {
          _hoveringTabId = null;
        }
      }),
      child: GestureDetector(
          onTap: () {
            _selectedTabId = tab.id;
            widget.onTabSelected(index, tab);
            setState(() {});
          },
          child: SizedBox(
            width: double.maxFinite,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              // width: 110,
              child: Text(tab.text,
                  style: isSelected
                      ? const TextStyle(color: ThemeConfig.primary)
                      : const TextStyle(
                          color: Color.fromARGB(255, 89, 89, 89))),
              decoration: BoxDecoration(
                borderRadius: ThemeConfig.borderRadius4,
                color: isSelected || _hoveringTabId == tab.id
                    ? const Color.fromARGB(255, 246, 246, 246)
                    : null,
              ),
            ),
          )),
    );
    if (index == 0) {
      return child;
    }
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: child,
    );
  }
}

class TTab {
  TTab({required this.id, required this.text});

  final Object id;
  final String text;
}