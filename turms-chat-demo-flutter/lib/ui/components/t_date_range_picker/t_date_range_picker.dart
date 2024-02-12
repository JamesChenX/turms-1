import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../components.dart';

part 't_date_range_input.dart';

part 't_date_range_picker_panel.dart';

class TDateRangePicker extends StatelessWidget {
  TDateRangePicker({Key? key}) : super(key: key);

  final _popupController = TPopupController();

  @override
  Widget build(BuildContext context) => TPopup(
      controller: _popupController,
      targetAnchor: Alignment.bottomCenter,
      followerAnchor: Alignment.topCenter,
      target: _TDateRangeInput(
        onFocusChanged: (_TDateRangeInputFocus value) {
          if (value == _TDateRangeInputFocus.none) {
            _popupController.hidePopover?.call();
          } else {
            _popupController.showPopover?.call();
          }
        },
      ),
      follower: const _TDateRangePickerPanel());
}