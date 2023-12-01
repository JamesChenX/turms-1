import 'package:flutter/material.dart';

import '../themes/theme_config.dart';

class TTextButton extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final Color? backgroundHoverColor;
  final EdgeInsets padding;
  final bool enableBorder;

  final VoidCallback onPressed;

  const TTextButton(
      {super.key,
      required this.text,
      this.textStyle,
      this.backgroundColor = ThemeConfig.primary,
      this.backgroundHoverColor,
      // this.backgroundHoverColor = ThemeConfig.primary,
      this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      this.enableBorder = false,
      required this.onPressed});

  @override
  State<StatefulWidget> createState() => _TTextButtonState();
}

class _TTextButtonState extends State<TTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    Widget child;
    child = Container(
        decoration: BoxDecoration(
            color: _isHovered
                ? (widget.backgroundHoverColor ??
                    widget.backgroundColor.withOpacity(0.8))
                : widget.backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: widget.enableBorder
                ? Border.all(width: 0.2, color: Color.fromARGB(255, 37, 36, 35))
                : null,
            boxShadow: widget.enableBorder
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                    ),
                  ]
                : null),
        padding: widget.padding,
        child: Text(text,
            textAlign: TextAlign.center,
            style: widget.textStyle ?? const TextStyle(color: Colors.white)));
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: child,
        ));
  }
}