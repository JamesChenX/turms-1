import 'package:flutter/material.dart';

import '../../../themes/index.dart';
import '../index.dart';

/// TODO: listen to the keyboard to select the item
class TMenu<T> extends StatefulWidget {
  const TMenu(
      {super.key,
      this.value,
      required this.entries,
      required this.onSelected,
      this.dense = false,
      this.textAlign = TextAlign.start,
      this.padding = Sizes.paddingV8H8});

  final T? value;
  final List<TMenuEntry<T>> entries;
  final void Function(TMenuEntry<T> item) onSelected;
  final bool dense;
  final TextAlign textAlign;
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
    if (widget.dense) {
      return LayoutBuilder(builder: (context, constraints) {
        final minWidth =
            constraints.minWidth - menuDecoration.padding.horizontal;
        if (minWidth > 0) {
          return _buildContent(
              context, appThemeExtension, menuDecoration, minWidth);
        }
        return _buildContent(context, appThemeExtension, menuDecoration, null);
      });
    }
    return _buildContent(context, appThemeExtension, menuDecoration, null);
  }

  DecoratedBox _buildContent(
          BuildContext context,
          AppThemeExtension appThemeExtension,
          BoxDecoration menuDecoration,
          double? minWidth) =>
      DecoratedBox(
        decoration: menuDecoration,
        child: Padding(
          padding: menuDecoration.padding,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final entry in widget.entries)
                  _buildItem(context, appThemeExtension, entry, minWidth)
              ],
            ),
          ),
        ),
      );

  Widget _buildItem(BuildContext context, AppThemeExtension appThemeExtension,
      TMenuEntry<T> entry, double? minWidth) {
    if (identical(entry, TMenuEntry.separator)) {
      return const THorizontalDivider();
    }
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
          final onSelected = entry.onSelected;
          if (onSelected != null) {
            onSelected();
          }
          widget.onSelected(entry);
        },
        child: ColoredBox(
          color: hoveredEntryValue == entry.value
              ? appThemeExtension.menuItemHoveredColor
              : appThemeExtension.menuItemColor,
          child: widget.dense
              ? minWidth == null
                  ? text
                  : SizedBox(
                      width: minWidth,
                      child: text,
                    )
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
    this.onSelected,
  });

  static TMenuEntry<dynamic> separator =
      const TMenuEntry(label: '', value: null);

  final String label;
  final T value;
  final VoidCallback? onSelected;
}