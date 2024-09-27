import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../themes/theme_config.dart';
import '../t_popup/t_popup.dart';
import '../t_text_field/t_text_field.dart';

class TDropdownMenu<T> extends ConsumerStatefulWidget {
  const TDropdownMenu(
      {super.key, this.value, required this.entries, required this.onSelected});

  final T? value;
  final List<TDropdownMenuEntry<T>> entries;
  final void Function(TDropdownMenuEntry<T> item) onSelected;

  @override
  ConsumerState createState() => _TDropdownMenuState<T>();
}

class _TDropdownMenuState<T> extends ConsumerState<TDropdownMenu<T>> {
  late TextEditingController _textEditingController;
  final TPopupController _popupController = TPopupController();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _updateEditorToValue();
  }

  @override
  void didUpdateWidget(TDropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateEditorToValue();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TPopup(
      controller: _popupController,
      constrainFollowerWithTargetWidth: true,
      targetAnchor: Alignment.bottomCenter,
      followerAnchor: Alignment.topCenter,
      target: IgnorePointer(
        child: TTextField(
          textEditingController: _textEditingController,
          readOnly: true,
          showCursor: false,
          mouseCursor: SystemMouseCursors.basic,
          suffixIcon: const Icon(
            Symbols.arrow_drop_down_rounded,
          ),
        ),
      ),
      follower: Material(
        child: DecoratedBox(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: ThemeConfig.borderRadius4,
              boxShadow: ThemeConfig.boxShadow),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in widget.entries)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      widget.onSelected(entry);
                      _popupController.hidePopover?.call();
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(entry.label),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ));

  void _updateEditorToValue() {
    final value = widget.value;
    if (value != null) {
      _textEditingController.text =
          widget.entries.firstWhere((entry) => entry.value == value).label;
    }
  }
}

class TDropdownMenuEntry<T> {
  TDropdownMenuEntry({
    required this.label,
    required this.value,
  });

  final String label;
  final T value;
}