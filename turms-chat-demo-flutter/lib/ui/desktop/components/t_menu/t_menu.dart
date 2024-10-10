import 'package:flutter/material.dart';

import '../../../themes/index.dart';

class TMenu<T> extends StatefulWidget {
  const TMenu(
      {super.key,
      this.value,
      required this.entries,
      required this.onSelected,
      this.dense = false});

  final T? value;
  final List<TMenuEntry<T>> entries;
  final void Function(TMenuEntry<T> item) onSelected;
  final bool dense;

  @override
  State<TMenu<T>> createState() => _TMenuState<T>();
}

class _TMenuState<T> extends State<TMenu<T>> {
  T? hoveredEntryValue;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entry in widget.entries)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) => setState(() {
                hoveredEntryValue = entry.value;
              }),
              onExit: (event) => setState(() {
                if (hoveredEntryValue == entry.value) {
                  hoveredEntryValue = null;
                }
              }),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  widget.onSelected(entry);
                },
                child: ColoredBox(
                  color: hoveredEntryValue == entry.value
                      ? context.appThemeExtension.menuItemHoveredColor
                      : context.appThemeExtension.menuItemColor,
                  child: widget.dense
                      ? Padding(
                          padding: Sizes.paddingV8H8,
                          child: Text(entry.label),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: Sizes.paddingV8H8,
                            child: Text(entry.label),
                          ),
                        ),
                ),
              ),
            )
        ],
      );
}

class TMenuEntry<T> {
  const TMenuEntry({
    required this.label,
    required this.value,
  });

  final String label;
  final T value;
}
