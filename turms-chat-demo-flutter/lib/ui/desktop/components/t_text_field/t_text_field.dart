import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../infra/task/debouncer.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../t_button/t_icon_button.dart';

class TTextField extends ConsumerStatefulWidget {
  const TTextField(
      {super.key,
      this.textEditingController,
      this.autofocus = false,
      this.focusNode,
      this.mouseCursor,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.showDeleteButtonIfHasText = false,
      this.showCursor = true,
      this.readOnly = false,
      this.enableInteractiveSelection,
      this.maxLength,
      this.expands = false,
      this.style,
      TextAlignVertical? textAlignVertical,
      this.debounceTimeout,
      this.transformValue,
      this.onChanged,
      this.onSubmitted,
      this.onTapOutside})
      : assert(!showDeleteButtonIfHasText || suffixIcon == null),
        textAlignVertical = textAlignVertical ??
            (expands ? TextAlignVertical.top : TextAlignVertical.center);

  final TextEditingController? textEditingController;
  final bool autofocus;
  final FocusNode? focusNode;
  final SystemMouseCursor? mouseCursor;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showDeleteButtonIfHasText;
  final bool showCursor;
  final bool readOnly;
  final bool? enableInteractiveSelection;
  final int? maxLength;
  final bool expands;
  final TextAlignVertical textAlignVertical;
  final TextStyle? style;
  final Duration? debounceTimeout;
  final String Function(String value)? transformValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<PointerDownEvent>? onTapOutside;

  @override
  ConsumerState<TTextField> createState() => _TTextFieldState();
}

class _TTextFieldState extends ConsumerState<TTextField> {
  TextEditingController? textEditingController;
  Debouncer? debouncer;

  @override
  void initState() {
    super.initState();
    if (widget.textEditingController == null) {
      textEditingController = TextEditingController();
    }
    final debounceTimeout = widget.debounceTimeout;
    if (debounceTimeout != null) {
      debouncer = Debouncer(timeout: debounceTimeout);
    }
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefixIcon = widget.prefixIcon;
    final controller = (widget.textEditingController ?? textEditingController)!;
    final showSuffixIcon = (widget.suffixIcon != null) ||
        (widget.showDeleteButtonIfHasText && controller.text.isNotEmpty);
    final suffixIcon = widget.suffixIcon;
    return TextField(
      controller: controller,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      mouseCursor: widget.mouseCursor,
      showCursor: widget.showCursor,
      readOnly: widget.readOnly,
      maxLines: widget.expands ? null : 1,
      maxLength: widget.maxLength,
      textAlignVertical: widget.textAlignVertical,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      expands: widget.expands,
      onChanged: (value) {
        // To get an accurate "controller.value.composing",
        // we have to use "addPostFrameCallback".
        // FIXME: https://github.com/flutter/flutter/issues/128565
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.value.composing != TextRange.empty) {
            return;
          }
          final transformValue = widget.transformValue;
          if (transformValue != null) {
            final result = transformValue(value);
            if (result != value) {
              controller.value = TextEditingValue(
                text: result,
                selection: TextSelection.collapsed(offset: result.length),
              );
              value = result;
            }
          }
          final localDebouncer = debouncer;
          if (localDebouncer != null) {
            localDebouncer.run(() {
              widget.onChanged?.call(value);
            });
          } else {
            widget.onChanged?.call(value);
          }
          setState(() {});
        });
      },
      onSubmitted: debouncer == null
          ? widget.onSubmitted
          : (value) {
              debouncer?.cancel();
              widget.onSubmitted?.call(value);
            },
      onTapOutside: widget.onTapOutside,
      style: widget.style ??
          const TextStyle(
              fontSize: 14,
              // cursor height
              height: 1.2),
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIcon == null
            ? null
            : const BoxConstraints.tightFor(width: 30),
        suffixIcon: suffixIcon ??
            (showSuffixIcon
                ? TIconButton(
                    addContainer: false,
                    iconData: Symbols.close_rounded,
                    iconSize: 20,
                    tooltip: ref.watch(appLocalizationsViewModel).close,
                    onTap: () {
                      controller.clear();
                      widget.onChanged?.call('');
                      setState(() {});
                    },
                  )
                : null),
        suffixIconConstraints:
            showSuffixIcon ? const BoxConstraints.tightFor(width: 30) : null,
        isCollapsed: true,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
