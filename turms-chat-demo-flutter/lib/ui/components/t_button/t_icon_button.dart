import 'package:flutter/material.dart';

import '../t_tooltip.dart';

class TIconButton extends StatefulWidget {
  const TIconButton({super.key,
    this.addContainer = true,
    this.size,
    this.color,
    this.hoverColor,
    required this.iconData,
    this.iconFill,
    this.iconSize,
    this.iconWeight,
    this.iconColor,
    this.iconHoverColor,
    this.iconFlipX = false,
    this.tooltip,
    this.onTap,
    this.onTapDown});

  final bool addContainer;
  final Size? size;
  final Color? color;
  final Color? hoverColor;

  final IconData iconData;
  final bool? iconFill;
  final double? iconSize;
  final double? iconWeight;
  final Color? iconColor;
  final Color? iconHoverColor;
  final bool iconFlipX;

  final String? tooltip;

  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;

  // this.iconHoverColor ??= iconColor;

  @override
  State<StatefulWidget> createState() => _TIconButtonState();
}

class _TIconButtonState extends State<TIconButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    Widget child = Icon(
      widget.iconData,
      fill: (widget.iconFill ?? false) ? 1 : 0,
      color: isHovered
          ? (widget.iconHoverColor ?? widget.iconColor)
          : widget.iconColor,
      weight: widget.iconWeight ?? iconTheme.weight,
      size: widget.iconSize ?? iconTheme.size,
    );
    if (widget.iconFlipX) {
      child = Transform.flip(
        flipX: true,
        child: child,
      );
    }
    if (widget.addContainer) {
      child = ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: AnimatedContainer(
              color: isHovered
                  ? (widget.hoverColor ?? widget.color)
                  : widget.color,
              // color: ThemeConfig.primary,
              height: widget.size?.height ?? 40,
              width: widget.size?.width ?? 40,
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle, color: ThemeConfig.primary),
              duration: const Duration(milliseconds: 100),
              child: child));
    }
    if (widget.tooltip != null) {
      child = TTooltip(
        message: widget.tooltip,
        preferBelow: true,
        waitDuration: const Duration(milliseconds: 1000),
        child: child,
      );
    }
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        // TODO: darken on pressing
        child: widget.onTap == null && widget.onTapDown == null
            ? child
            : GestureDetector(
          onTap: widget.onTap,
          onTapDown: widget.onTapDown,
          child: child,
        ));
  }
}