import 'dart:math';

import 'package:flutter/material.dart';

import '../../themes/theme_config.dart';
import '../t_tooltip/t_tooltip.dart';

class TButton extends StatefulWidget {
  const TButton(
      {super.key,
      required this.addContainer,
      this.containerWidth,
      this.containerHeight,
      this.containerColor,
      this.containerColorHovered,
      this.containerPadding,
      this.containerBorder,
      this.containerBorderHovered,
      this.containerBorderRadius = ThemeConfig.borderRadius4,
      this.isLoading = false,
      this.disabled = false,
      this.tooltip,
      this.onTap,
      this.onPanDown,
      this.childHovered,
      this.childPressed,
      required this.child});

  final bool addContainer;
  final double? containerWidth;
  final double? containerHeight;
  final Color? containerColor;
  final Color? containerColorHovered;
  final EdgeInsets? containerPadding;
  final BoxBorder? containerBorder;
  final BoxBorder? containerBorderHovered;
  final BorderRadiusGeometry? containerBorderRadius;

  final bool isLoading;
  final bool disabled;
  final String? tooltip;
  final VoidCallback? onTap;
  final GestureDragDownCallback? onPanDown;

  final Widget? childHovered;
  final Widget? childPressed;
  final Widget child;

  @override
  State<TButton> createState() => _TButtonState();
}

class _TButtonState extends State<TButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    var child = _isPressed
        ? (widget.childPressed ?? widget.childHovered ?? widget.child)
        : _isHovered
            ? widget.childHovered ?? widget.child
            : widget.child;
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
    if (widget.addContainer) {
      child = AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.disabled
                ? ThemeConfig.colorDisabled
                : widget.isLoading
                    ? widget.containerColor?.withOpacity(0.5)
                    : _isHovered
                        ? (widget.containerColorHovered ??
                            widget.containerColor?.withOpacity(0.8))
                        : widget.containerColor,
            borderRadius: widget.containerBorderRadius,
            border: _isHovered
                ? (widget.containerBorderHovered ?? widget.containerBorder)
                : widget.containerBorder,
          ),
          padding: widget.containerPadding,
          width: widget.containerWidth,
          height: widget.containerHeight,
          child: child);
    }
    if (widget.tooltip != null) {
      child = TTooltip(
        message: widget.tooltip,
        preferBelow: true,
        waitDuration: const Duration(milliseconds: 1000),
        child: child,
      );
    }
    return RepaintBoundary(
      child: MouseRegion(
          cursor: widget.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          onEnter: (_) {
            _isHovered = true;
            setState(() {});
          },
          onExit: (_) {
            _isHovered = false;
            _isPressed = false;
            setState(() {});
          },
          child: GestureDetector(
            onTap: () {
              if (!widget.disabled && !widget.isLoading) {
                widget.onTap?.call();
              }
            },
            onPanDown: (details) {
              _isPressed = true;
              widget.onPanDown?.call(details);
              setState(() {});
            },
            child: child,
          )),
    );
  }
}
