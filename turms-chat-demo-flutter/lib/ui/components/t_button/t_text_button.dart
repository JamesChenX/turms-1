import 'dart:math';

import 'package:flutter/material.dart';

import '../../themes/theme_config.dart';
import 't_button.dart';

class TTextButton extends StatelessWidget {
  const TTextButton(
      {super.key,
      required this.text,
      this.textStyle,
      this.textStyleHovered,
      this.addContainer = true,
      this.containerWidth,
      this.containerColor = ThemeConfig.primary,
      this.containerColorHovered,
      EdgeInsets? containerPadding,
      this.containerBorder,
      this.containerBorderHovered,
      this.isLoading = false,
      this.disabled = false,
      this.onTap})
      : containerPadding = containerPadding ?? ThemeConfig.paddingV8H16;

  factory TTextButton.outlined(
          {required String text,
          double? width,
          EdgeInsets? padding,
          VoidCallback? onTap}) =>
      TTextButton(
        text: text,
        textStyle: const TextStyle(color: Colors.black),
        textStyleHovered: const TextStyle(color: ThemeConfig.primary),
        containerBorder: Border.all(color: ThemeConfig.dividerColor),
        containerBorderHovered: Border.all(color: ThemeConfig.primary),
        containerColor: Colors.white,
        containerWidth: width,
        containerPadding: padding,
        onTap: onTap,
      );

  final bool addContainer;
  final double? containerWidth;
  final Color containerColor;
  final Color? containerColorHovered;
  final EdgeInsets containerPadding;
  final BoxBorder? containerBorder;
  final BoxBorder? containerBorderHovered;
  final bool isLoading;
  final bool disabled;
  final VoidCallback? onTap;

  final String text;
  final TextStyle? textStyle;
  final TextStyle? textStyleHovered;

  @override
  Widget build(BuildContext context) => TButton(
      addContainer: addContainer,
      containerWidth: containerWidth,
      containerColor: containerColor,
      containerColorHovered: containerColorHovered,
      containerPadding: containerPadding,
      containerBorder: containerBorder,
      containerBorderHovered: containerBorderHovered,
      isLoading: isLoading,
      disabled: disabled,
      onTap: onTap,
      childHovered: AnimatedDefaultTextStyle(
        style: textStyleHovered ??
            textStyle ??
            const TextStyle(color: Colors.white),
        duration: const Duration(milliseconds: 200),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
      child: AnimatedDefaultTextStyle(
        style: textStyle ?? const TextStyle(color: Colors.white),
        duration: const Duration(milliseconds: 200),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ));
}
