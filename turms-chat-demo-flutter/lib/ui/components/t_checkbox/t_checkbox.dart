import 'package:flutter/material.dart';

import '../../themes/theme_config.dart';

class TCheckbox extends StatefulWidget {
  const TCheckbox(this.initialValue, this.text,
      {super.key, required this.onCheckedChanged});

  final bool initialValue;
  final String text;

  final void Function(bool checked) onCheckedChanged;

  @override
  State<StatefulWidget> createState() => _TCheckboxState();
}

class _TCheckboxState extends State<TCheckbox> {
  bool? isChecked;

  @override
  Widget build(BuildContext context) {
    isChecked ??= widget.initialValue;
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            isChecked = !isChecked!;
            widget.onCheckedChanged(isChecked!);
            setState(() {});
          },
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            AbsorbPointer(
              child: Checkbox(
                // focusNode: FocusNode(skipTraversal: true),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
                splashRadius: 0,
                side: const BorderSide(
                  color: ThemeConfig.checkboxColor,
                  width: 2,
                ),
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = !isChecked!;
                  });
                  widget.onCheckedChanged(isChecked!);
                },
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(widget.text,
                style: const TextStyle(
                    color: ThemeConfig.textColorSecondary, fontSize: 16))
          ]),
        ));
  }
}
