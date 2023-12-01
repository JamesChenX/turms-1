import 'package:flutter/material.dart';

import 't_tooltip.dart';

class TIconButton extends StatefulWidget {
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

  final String tooltip;

  final VoidCallback? onPressed;

  const TIconButton(
      {super.key,
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
      required this.tooltip,
      this.onPressed});

  // this.iconHoverColor ??= iconColor;

  @override
  State<StatefulWidget> createState() => _TIconButtonState();
}

class _TIconButtonState extends State<TIconButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final icon = Icon(
      widget.iconData,
      fill: (widget.iconFill ?? false) ? 1 : 0,
      color: isHovered
          ? (widget.iconHoverColor ?? widget.iconColor)
          : widget.iconColor,
      weight: widget.iconWeight ?? iconTheme.weight,
      size: widget.iconSize ?? iconTheme.size,
    );
    final body = TTooltip(
      message: widget.tooltip,
      preferBelow: true,
      waitDuration: const Duration(milliseconds: 1000),
      // showDuration: Duration.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: AnimatedContainer(
            color:
                isHovered ? (widget.hoverColor ?? widget.color) : widget.color,
            // color: ThemeConfig.primary,
            height: widget.size?.height ?? 40,
            width: widget.size?.width ?? 40,
            // decoration: BoxDecoration(
            //     shape: BoxShape.circle, color: ThemeConfig.primary),
            duration: const Duration(milliseconds: 100),
            child: widget.iconFlipX
                ? Transform.flip(
                    flipX: true,
                    child: icon,
                  )
                : icon),
      ),
    );
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: widget.onPressed == null
            ? body
            : GestureDetector(
                onTap: widget.onPressed,
                child: body,
              ));
  }
}