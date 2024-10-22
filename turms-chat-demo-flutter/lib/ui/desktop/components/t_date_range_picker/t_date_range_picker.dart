import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../l10n/view_models/date_format_view_models.dart';
import '../../../themes/index.dart';

import '../index.dart';

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

const _dateRangePickerGroupId = 'dateRangePicker';

class _TDateRangePickerState extends State<TDateRangePicker> {
  late FocusNode startDateFocusNode;
  late FocusNode endDateFocusNode;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  DateTime? hoveredStartDate;
  DateTime? hoveredEndDate;

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
          groupId: _dateRangePickerGroupId,
          child: _TDateRangeInput(
            startDate: selectedStartDate,
            startDateFocusNode: startDateFocusNode,
            previewStartDate: hoveredStartDate,
            endDate: selectedEndDate,
            endDateFocusNode: endDateFocusNode,
            previewEndDate: hoveredEndDate,
          ),
        ),
        follower: TapRegion(
          groupId: _dateRangePickerGroupId,
          child: _TDateRangePickerPanel(
            availableStartDate: widget.firstDate,
            availableEndDate: widget.lastDate,
            hoveredStartDate: hoveredStartDate,
            hoveredEndDate: hoveredEndDate,
            initialDateRange: widget.initialDateRange,
            onDateChanged: (DateTime value) {
              if (startDateFocusNode.hasFocus) {
                selectedStartDate = value;
                if (selectedEndDate != null &&
                    value.isAfter(selectedEndDate!)) {
                  selectedEndDate = null;
                  endDateFocusNode.requestFocus();
                } else {
                  widget._popupController.hidePopover?.call();
                }
              } else {
                selectedEndDate = value;
                if (selectedStartDate != null &&
                    value.isBefore(selectedStartDate!)) {
                  selectedStartDate = null;
                  startDateFocusNode.requestFocus();
                } else {
                  widget._popupController.hidePopover?.call();
                }
              }
              setState(() {});
            },
            onMouseRegionEntered: (DateTime value) {
              if (startDateFocusNode.hasFocus) {
                hoveredStartDate = value;
              } else {
                hoveredEndDate = value;
              }
              setState(() {});
            },
            onMouseRegionExited: (DateTime value) {
              if (startDateFocusNode.hasFocus) {
                if (hoveredStartDate == value) {
                  hoveredStartDate = null;
                }
              } else {
                if (hoveredEndDate == value) {
                  hoveredEndDate = null;
                }
              }
              setState(() {});
            },
          ),
        ),
        onDismissed: () {
          startDateFocusNode.unfocus();
          endDateFocusNode.unfocus();
        },
      );

  void _onFocusChanged() {
    if (startDateFocusNode.hasFocus || endDateFocusNode.hasFocus) {
      widget._popupController.showPopover?.call();
    } else {
      widget._popupController.hidePopover?.call();
    }
  }
}
