import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 't_text_field.dart';

class TSearchBar extends StatelessWidget {
  const TSearchBar(
      {super.key,
      required this.hintText,
      this.autofocus = false,
      this.prefixIcon = const Icon(Symbols.search_rounded, size: 20),
      this.transformValue,
      this.onSubmitted});

  final String hintText;
  final Widget prefixIcon;
  final bool autofocus;
  final String Function(String)? transformValue;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) => TTextField(
        autofocus: autofocus,
        hintText: hintText,
        prefixIcon: prefixIcon,
        showDeleteButtonIfHasText: true,
        transformValue: transformValue,
        onSubmitted: onSubmitted,
      );
}