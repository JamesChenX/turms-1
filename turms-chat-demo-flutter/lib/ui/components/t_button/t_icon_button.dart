import 'package:flutter/material.dart';

import '../../themes/theme_config.dart';
import '../t_tooltip/t_tooltip.dart';
import 't_button.dart';

class TIconButton extends StatelessWidget {
  const TIconButton(
      {super.key,
      this.addContainer = true,
      this.containerSize,
      this.containerColor,
      this.containerColorHovered,
      this.containerPadding,
      this.containerBorder,
      this.containerBorderHovered,
      this.containerBorderRadius,
      required this.iconData,
      this.iconFill,
      this.iconSize,
      this.iconWeight,
      this.iconColor,
      this.iconColorHovered,
      this.iconColorPressed,
      this.iconFlipX = false,
      this.iconRotate,
      this.disabled = false,
      this.tooltip,
      this.onTap,
      this.onPanDown});

  factory TIconButton.outlined(
          {required IconData iconData,
          bool? iconFill,
          double? iconSize,
          double? iconWeight,
          Color? iconColor,
          Color? iconColorHovered,
          Color? iconColorPressed,
          bool? iconFlipX,
          double? iconRotate,
          Size? containerSize,
          bool disabled = false,
          String? tooltip,
          VoidCallback? onTap}) =>
      TIconButton(
        iconData: iconData,
        iconFill: iconFill,
        iconSize: iconSize,
        iconWeight: iconWeight,
        iconColor: iconColor,
        iconColorHovered: iconColorHovered,
        iconColorPressed: iconColorPressed,
        iconFlipX: iconFlipX ?? false,
        iconRotate: iconRotate,
        onTap: onTap,
        containerSize: containerSize,
        containerColor: Colors.white,
        containerBorder: Border.all(color: ThemeConfig.dividerColor),
        containerBorderHovered: Border.all(color: ThemeConfig.primary),
        disabled: disabled,
        tooltip: tooltip,
      );

  final bool addContainer;
  final Size? containerSize;
  final Color? containerColor;
  final Color? containerColorHovered;
  final EdgeInsets? containerPadding;
  final BoxBorder? containerBorder;
  final BoxBorder? containerBorderHovered;
  final BorderRadiusGeometry? containerBorderRadius;

  final bool disabled;
  final String? tooltip;

  final VoidCallback? onTap;
  final GestureDragDownCallback? onPanDown;

  final IconData iconData;
  final bool? iconFill;
  final double? iconSize;
  final double? iconWeight;
  final Color? iconColor;
  final Color? iconColorHovered;
  final Color? iconColorPressed;
  final bool iconFlipX;
  final double? iconRotate;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    return TButton(
        addContainer: addContainer,
        containerWidth: containerSize?.width ?? 40,
        containerHeight: containerSize?.height ?? 40,
        containerColor: containerColor,
        containerColorHovered: containerColorHovered,
        containerPadding: containerPadding,
        containerBorder: containerBorder,
        containerBorderHovered: containerBorderHovered,
        containerBorderRadius:
            containerBorderRadius ?? ThemeConfig.borderRadius4,
        disabled: disabled,
        tooltip: tooltip,
        onTap: onTap,
        onPanDown: onPanDown,
        childHovered: _buildIcon(iconTheme, isHovered: true),
        childPressed: _buildIcon(iconTheme, isPressed: true),
        child: _buildIcon(iconTheme));
  }

  Widget _buildIcon(IconThemeData iconTheme,
      {bool isPressed = false, bool isHovered = false}) {
    Widget child = Icon(
      iconData,
      fill: (iconFill ?? false) ? 1 : 0,
      color: isPressed
          ? (iconColorPressed ?? iconColorHovered ?? iconColor)
          : isHovered
              ? (iconColorHovered ?? iconColor)
              : iconColor,
      weight: iconWeight ?? iconTheme.weight,
      size: iconSize ?? iconTheme.size,
    );
    if (iconFlipX) {
      child = Transform.flip(
        flipX: true,
        child: child,
      );
    }
    if (iconRotate != null) {
      child = Transform.rotate(
        angle: iconRotate!,
        child: child,
      );
    }
    return child;
  }
}
