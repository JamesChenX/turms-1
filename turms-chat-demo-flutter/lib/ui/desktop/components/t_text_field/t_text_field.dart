import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../infra/task/debouncer.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../index.dart';

const _kToolbarScreenPadding = 8.0;

class TTextField extends ConsumerStatefulWidget {
  const TTextField(
      {super.key,
      this.textEditingController,
      this.autofocus = false,
      this.focusNode,
      this.mouseCursor,
      this.hintText,
      this.prefixIcon,
      this.prefixIconConstraints,
      this.suffixIcon,
      this.showDeleteButtonIfHasText = false,
      this.showCursor = true,
      this.readOnly = false,
      this.enableInteractiveSelection,
      this.maxLength,
      this.expands = false,
      this.style,
      this.textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      this.debounceTimeout,
      this.transformValue,
      this.onChanged,
      this.onSubmitted,
      this.onCaretMoved,
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
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final bool showDeleteButtonIfHasText;
  final bool showCursor;
  final bool readOnly;
  final bool? enableInteractiveSelection;
  final int? maxLength;
  final bool expands;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextStyle? style;
  final Duration? debounceTimeout;
  final String Function(String value)? transformValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<Offset>? onCaretMoved;
  final ValueChanged<PointerDownEvent>? onTapOutside;

  @override
  ConsumerState<TTextField> createState() => _TTextFieldState();
}

class _TTextFieldState extends ConsumerState<TTextField> {
  late GlobalKey _fieldKey;
  TextEditingController? _textEditingController;
  Debouncer? _debouncer;

  @override
  void initState() {
    super.initState();
    if (widget.textEditingController == null) {
      _textEditingController = TextEditingController();
    }
    final debounceTimeout = widget.debounceTimeout;
    if (debounceTimeout != null) {
      _debouncer = Debouncer(timeout: debounceTimeout);
    }
    if (widget.onCaretMoved != null) {
      _fieldKey = GlobalKey();
    }
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefixIcon = widget.prefixIcon;
    final controller =
        (widget.textEditingController ?? _textEditingController)!;
    final showSuffixIcon = (widget.suffixIcon != null) ||
        (widget.showDeleteButtonIfHasText && controller.text.isNotEmpty);
    final suffixIcon = widget.suffixIcon;
    return TextField(
      controller: controller,
      contextMenuBuilder: contextMenuBuilder,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      mouseCursor: widget.mouseCursor,
      showCursor: widget.showCursor,
      readOnly: widget.readOnly,
      maxLines: widget.expands ? null : 1,
      maxLength: widget.maxLength,
      textAlign: widget.textAlign,
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
          final localDebouncer = _debouncer;
          if (localDebouncer != null) {
            localDebouncer.run(() {
              widget.onChanged?.call(value);
              _tryNotifyCaretPositionChanged();
            });
          } else {
            widget.onChanged?.call(value);
            _tryNotifyCaretPositionChanged();
          }
          setState(() {});
        });
      },
      onSubmitted: _debouncer == null
          ? widget.onSubmitted
          : (value) {
              _debouncer?.cancel();
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
        hintStyle: TextStyle(color: Colors.grey[600]!),
        filled: true,
        fillColor: const Color.fromARGB(255, 226, 226, 226),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        prefixIcon: prefixIcon,
        prefixIconConstraints: prefixIcon == null
            ? null
            : const BoxConstraints.tightFor(width: 24),
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
                      _tryNotifyCaretPositionChanged();
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

  void _tryNotifyCaretPositionChanged() {
    final onCaretMoved = widget.onCaretMoved;
    if (onCaretMoved == null) {
      return;
    }
    final currentContext = _fieldKey.currentContext;
    if (currentContext == null) {
      return;
    }
    final fieldBox = currentContext.findRenderObject();
    final caretPosition =
        fieldBox is RenderBox ? _getCaretPosition(fieldBox) : null;
    if (caretPosition == null) {
      return;
    }
    onCaretMoved.call(caretPosition);
  }

  RenderEditable? _findRenderEditable(RenderObject root) {
    RenderEditable? renderEditable;
    void recursiveFinder(RenderObject child) {
      if (child is RenderEditable) {
        renderEditable = child;
        return;
      }
      child.visitChildren(recursiveFinder);
    }

    root.visitChildren(recursiveFinder);
    return renderEditable;
  }

  TextSelectionPoint _globalize(TextSelectionPoint point, RenderBox box) =>
      TextSelectionPoint(
        box.localToGlobal(point.point),
        point.direction,
      );

  Offset? _getCaretPosition(RenderBox box) {
    final renderEditable = _findRenderEditable(box);
    if (renderEditable == null || !renderEditable.hasFocus) {
      return null;
    }
    final selection = renderEditable.selection;
    if (selection == null) {
      return null;
    }
    final firstEndpoint =
        renderEditable.getEndpointsForSelection(selection).firstOrNull;
    if (firstEndpoint == null) {
      return null;
    }
    final point = _globalize(
      firstEndpoint,
      renderEditable,
    );

    final cursorOffset = renderEditable.cursorOffset;

    return point.point;
  }
}

final _allowedContextButtonTypes = Set.unmodifiable([
  ContextMenuButtonType.cut,
  ContextMenuButtonType.copy,
  ContextMenuButtonType.paste,
  ContextMenuButtonType.selectAll,
  ContextMenuButtonType.delete,
  ContextMenuButtonType.custom,
]);

Widget contextMenuBuilder(
    BuildContext context, EditableTextState editableTextState) {
  final labelToOnPressed = <String, VoidCallback>{};
  final menuEntries = <TMenuEntry<String>>[];
  for (final item in editableTextState.contextMenuButtonItems) {
    final onPressed = item.onPressed;
    if (onPressed != null && _allowedContextButtonTypes.contains(item.type)) {
      final label = item.label ??
          AdaptiveTextSelectionToolbar.getButtonLabel(context, item);
      labelToOnPressed[label] = onPressed;
      menuEntries.add(TMenuEntry(label: label, value: label));
    }
  }
  final paddingAbove =
      MediaQuery.paddingOf(context).top + _kToolbarScreenPadding;
  final localAdjustment = Offset(_kToolbarScreenPadding, paddingAbove);
  return Padding(
    padding: EdgeInsets.fromLTRB(
      _kToolbarScreenPadding,
      paddingAbove,
      _kToolbarScreenPadding,
      _kToolbarScreenPadding,
    ),
    child: CustomSingleChildLayout(
      delegate: DesktopTextSelectionToolbarLayoutDelegate(
        anchor: editableTextState.contextMenuAnchors.primaryAnchor -
            localAdjustment,
      ),
      child: Material(
        child: TMenu(
          dense: true,
          entries: menuEntries,
          onSelected: (item) {
            labelToOnPressed[item.value]?.call();
          },
        ),
      ),
    ),
  );
}
