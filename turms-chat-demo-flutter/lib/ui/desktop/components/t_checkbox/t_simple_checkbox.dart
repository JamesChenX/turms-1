import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../themes/theme_config.dart';

class TSimpleCheckbox extends StatefulWidget {
  const TSimpleCheckbox({
    Key? key,
    this.size = 16,
    this.activeBgColor = Colors.white,
    this.inactiveBgColor = Colors.white,
    this.activeBorderColor = ThemeConfig.borderColor,
    this.inactiveBorderColor = ThemeConfig.borderColor,
    required this.value,
    this.activeIcon = const Icon(
      Symbols.check_rounded,
      size: 14,
      color: Color(0xff10DC60),
      weight: 800,
    ),
    this.inactiveIcon,
    this.customBgColor = const Color(0xff10DC60),
    this.label,
    required this.onChanged,
  }) : super(key: key);

  final double size;

  final Color activeBgColor;

  final Color inactiveBgColor;

  final Color activeBorderColor;

  final Color inactiveBorderColor;

  final ValueChanged<bool> onChanged;

  final bool value;

  final Widget activeIcon;

  final Widget? inactiveIcon;

  final Color customBgColor;

  final String? label;

  @override
  _TSimpleCheckboxState createState() => _TSimpleCheckboxState();
}

class _TSimpleCheckboxState extends State<TSimpleCheckbox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      height: widget.size,
      width: widget.size,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: widget.value ? widget.activeBgColor : widget.inactiveBgColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
                color: widget.value
                    ? widget.activeBorderColor
                    : widget.inactiveBorderColor)),
        child: widget.value ? widget.activeIcon : widget.inactiveIcon,
      ),
    );
    final label = widget.label;
    if (label != null) {
      child = Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [child, Text(label)],
      );
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onChanged(!widget.value);
        },
        child: child,
      ),
    );
  }
}