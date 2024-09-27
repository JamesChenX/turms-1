import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../t_text_field/t_text_field.dart';

class TSearchBar extends StatelessWidget {
  const TSearchBar(
      {super.key,
      required this.hintText,
      this.textEditingController,
      this.autofocus = false,
      this.focusNode,
      this.prefixIcon = const Icon(Symbols.search_rounded, size: 20),
      this.transformValue,
      this.onChanged,
      this.onSubmitted
      });

  final TextEditingController? textEditingController;
  final String hintText;
  final Widget prefixIcon;
  final bool autofocus;
  final FocusNode? focusNode;
  final String Function(String)? transformValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) => TTextField(
        textEditingController: textEditingController,
        autofocus: autofocus,
        focusNode: focusNode,
        hintText: hintText,
        prefixIcon: prefixIcon,
        showDeleteButtonIfHasText: true,
        transformValue: transformValue,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      );
}