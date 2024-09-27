import 'package:flutter/material.dart';

import '../../../themes/theme_config.dart';

class TRadio<T> extends StatefulWidget {
  const TRadio({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = 16,
    this.radioColor = const Color(0xff10DC60),
    this.activeBgColor = Colors.white,
    this.inactiveBgColor = Colors.white,
    this.activeBorderColor = ThemeConfig.borderColor,
    this.inactiveBorderColor = ThemeConfig.borderColor,
    this.toggleable = false,
    this.label,
  }) : super(key: key);

  /// type of [double] which is GFSize ie, small, medium and large and can use any double value
  final double size;

  /// type pf [Color] used to change the checkcolor when the radio button is active
  final Color radioColor;

  /// type of [Color] used to change the backgroundColor of the active radio button
  final Color activeBgColor;

  /// type of [Color] used to change the backgroundColor of the inactive radio button
  final Color inactiveBgColor;

  /// type of [Color] used to change the border color of the active radio button
  final Color activeBorderColor;

  /// type of [Color] used to change the border color of the inactive radio button
  final Color inactiveBorderColor;

  /// Called when the user checks or unchecks the radio button
  final ValueChanged<T> onChanged;

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons. Radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  /// sets the radio value
  final bool toggleable;

  final String? label;

  @override
  _TRadioState<T> createState() => _TRadioState<T>();
}

class _TRadioState<T> extends State<TRadio<T>> with TickerProviderStateMixin {
  bool selected = false;
  T? groupValue;

  void onStatusChange() {
    groupValue = widget.value;
    _handleChanged(widget.value == groupValue);
  }

  void _handleChanged(bool selected) {
    if (selected) {
      widget.onChanged(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    selected = widget.value == widget.groupValue;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onStatusChange,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              height: widget.size,
              width: widget.size,
              decoration: BoxDecoration(
                  color:
                      selected ? widget.activeBgColor : widget.inactiveBgColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: selected
                          ? widget.activeBorderColor
                          : widget.inactiveBorderColor)),
              child: selected
                  ? Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: widget.radioColor),
                        child: SizedBox(
                            width: widget.size * 0.5,
                            height: widget.size * 0.5),
                      ),
                    )
                  : null),
          if (widget.label != null)
            const SizedBox(
              width: 8,
            ),
          if (widget.label != null) Text(widget.label!)
        ]),
      ),
    );
  }
}