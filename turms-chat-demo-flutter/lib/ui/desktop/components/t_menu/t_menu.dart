import 'package:flutter/material.dart';

import '../../../themes/index.dart';

class TMenu<T> extends StatefulWidget {
  const TMenu(
      {super.key,
      this.value,
      required this.entries,
      required this.onSelected,
      this.dense = false,
      this.textAlign,
      this.padding = Sizes.paddingV8H8});

  final T? value;
  final List<TMenuEntry<T>> entries;
  final void Function(TMenuEntry<T> item) onSelected;
  final bool dense;
  final TextAlign? textAlign;
  final EdgeInsets padding;

  @override
  State<TMenu<T>> createState() => _TMenuState<T>();
}

class _TMenuState<T> extends State<TMenu<T>> {
  T? hoveredEntryValue;

  @override
  Widget build(BuildContext context) {
    final appThemeExtension = context.appThemeExtension;
    final menuDecoration = appThemeExtension.menuDecoration;
    return DecoratedBox(
      decoration: menuDecoration,
      child: Padding(
        padding: menuDecoration.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in widget.entries)
              _buildItem(context, appThemeExtension, entry)
          ],
        ),
      ),
    );
  }

  MouseRegion _buildItem(BuildContext context,
      AppThemeExtension appThemeExtension, TMenuEntry<T> entry) {
    final text = Padding(
      padding: widget.padding,
      child: Text(
        entry.label,
        textAlign: widget.textAlign,
        style: appThemeExtension.menuItemTextStyle,
      ),
    );
    return MouseRegion(
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
              ? appThemeExtension.menuItemHoveredColor
              : appThemeExtension.menuItemColor,
          child: widget.dense
              ? text
              : SizedBox(
                  width: double.infinity,
                  child: text,
                ),
        ),
      ),
    );
  }
}

class TMenuEntry<T> {
  const TMenuEntry({
    required this.label,
    required this.value,
  });

  final String label;
  final T value;
}
