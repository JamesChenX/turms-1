import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../l10n/view_models/date_format_view_models.dart';
import '../../themes/theme_config.dart';
import '../components.dart';
import '../t_date_picker/t_date_picker.dart';

part 't_date_range_input.dart';

part 't_date_range_picker_panel.dart';

class TDateRangePicker extends StatefulWidget {
  TDateRangePicker(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      required this.initialDateRange})
      : super(key: key);

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange initialDateRange;

  final _popupController = TPopupController();

  @override
  State<TDateRangePicker> createState() => _TDateRangePickerState();
}

const groupId = 'dateRangePicker';

class _TDateRangePickerState extends State<TDateRangePicker> {
  late FocusNode startDateFocusNode;
  late FocusNode endDateFocusNode;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    startDateFocusNode = FocusNode()..addListener(_onFocusChanged);
    endDateFocusNode = FocusNode()..addListener(_onFocusChanged);
    selectedStartDate = widget.initialDateRange.start;
    selectedEndDate = widget.initialDateRange.end;
  }

  @override
  void dispose() {
    startDateFocusNode.dispose();
    endDateFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TPopup(
      controller: widget._popupController,
      targetAnchor: Alignment.bottomCenter,
      followerAnchor: Alignment.topCenter,
      offset: const Offset(0, 4),
      target: TapRegion(
        groupId: groupId,
        onTapOutside: (_) {
          startDateFocusNode.unfocus();
          endDateFocusNode.unfocus();
        },
        child: _TDateRangeInput(
          startDate: selectedStartDate,
          startDateFocusNode: startDateFocusNode,
          endDate: selectedEndDate,
          endDateFocusNode: endDateFocusNode,
        ),
      ),
      follower: TapRegion(
        groupId: groupId,
        child: _TDateRangePickerPanel(
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          initialDateRange: widget.initialDateRange,
          onDateChanged: (DateTime value) {
            if (startDateFocusNode.hasFocus) {
              selectedStartDate = value;
            } else {
              selectedEndDate = value;
            }
            setState(() {});
          },
        ),
      ));

  void _onFocusChanged() {
    if (startDateFocusNode.hasFocus || endDateFocusNode.hasFocus) {
      widget._popupController.showPopover?.call();
    } else {
      widget._popupController.hidePopover?.call();
    }
  }
}