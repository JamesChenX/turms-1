import 'dart:math';

import 'package:flutter/material.dart';

import '../../themes/theme_config.dart';

class TTextButton extends StatefulWidget {
  const TTextButton(
      {super.key,
      required this.text,
      this.textStyle,
      this.textStyleHovered,
      this.width,
      this.backgroundColor = ThemeConfig.primary,
      this.backgroundColorHovered,
      EdgeInsets? padding,
      this.border,
      this.borderHovered,
      this.isLoading = false,
      this.onTap})
      : padding = padding ?? ThemeConfig.paddingV8H16;

  factory TTextButton.outlined(
          {required String text,
          VoidCallback? onTap,
          double? width,
          EdgeInsets? padding}) =>
      TTextButton(
        text: text,
        onTap: onTap,
        textStyle: const TextStyle(color: Colors.black),
        textStyleHovered: const TextStyle(color: ThemeConfig.primary),
        border: Border.all(color: ThemeConfig.dividerColor),
        borderHovered: Border.all(color: ThemeConfig.primary),
        backgroundColor: Colors.white,
        width: width,
        padding: padding,
      );

  final String text;
  final TextStyle? textStyle;
  final TextStyle? textStyleHovered;
  final double? width;
  final Color backgroundColor;
  final Color? backgroundColorHovered;
  final EdgeInsets padding;
  final BoxBorder? border;
  final BoxBorder? borderHovered;
  final bool isLoading;

  final VoidCallback? onTap;

  @override
  State<StatefulWidget> createState() => _TTextButtonState();
}

class _TTextButtonState extends State<TTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedDefaultTextStyle(
      style: _isHovered
          ? (widget.textStyleHovered ??
              widget.textStyle ??
              const TextStyle(color: Colors.white))
          : widget.textStyle ?? const TextStyle(color: Colors.white),
      duration: const Duration(milliseconds: 200),
      child: Text(
        widget.text,
        textAlign: TextAlign.center,
      ),
    );
    if (widget.isLoading) {
      child = Stack(
        children: [
          Visibility.maintain(
            child: child,
            visible: false,
          ),
          Positioned.fill(child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final size =
                    min(constraints.maxWidth, constraints.maxHeight) * 0.8;
                return SizedBox(
                  width: size,
                  height: size,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              },
            ),
          ))
        ],
      );
    }
    child = AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.isLoading
              ? widget.backgroundColor.withOpacity(0.5)
              : _isHovered
                  ? (widget.backgroundColorHovered ??
                      widget.backgroundColor.withOpacity(0.8))
                  : widget.backgroundColor,
          borderRadius: ThemeConfig.borderRadius4,
          border: _isHovered
              ? (widget.borderHovered ?? widget.border)
              : widget.border,
        ),
        padding: widget.padding,
        width: widget.width,
        child: child);
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: widget.isLoading || widget.onTap == null
            ? child
            : GestureDetector(
                onTap: widget.onTap,
                child: child,
              ));
  }
}