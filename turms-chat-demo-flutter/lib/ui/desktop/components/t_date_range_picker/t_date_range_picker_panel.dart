part of 't_date_range_picker.dart';

class _TDateRangePickerPanel extends StatefulWidget {
  const _TDateRangePickerPanel({
    Key? key,
    required this.availableStartDate,
    required this.availableEndDate,
    required this.hoveredStartDate,
    required this.hoveredEndDate,
    required this.initialDateRange,
    required this.onDateChanged,
    required this.onMouseRegionEntered,
    required this.onMouseRegionExited,
  }) : super(key: key);

  final DateTime availableStartDate;
  final DateTime availableEndDate;
  final DateTimeRange initialDateRange;
  final DateTime? hoveredStartDate;
  final DateTime? hoveredEndDate;

  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<DateTime> onMouseRegionEntered;
  final ValueChanged<DateTime> onMouseRegionExited;

  @override
  State<_TDateRangePickerPanel> createState() => _TDateRangePickerPanelState();
}

class _TDateRangePickerPanelState extends State<_TDateRangePickerPanel> {
  late DateTime calenderDate;
  late DateTime selectedStartDate;
  late DateTime selectedEndDate;

  @override
  void initState() {
    super.initState();
    final initialDateRange = widget.initialDateRange;
    calenderDate = initialDateRange.start;
    selectedStartDate = initialDateRange.start;
    selectedEndDate = initialDateRange.end;
  }

  @override
  Widget build(BuildContext context) => Material(
        child: SizedBox(
          width: Sizes.dateRangePickerWidth,
          height: Sizes.dateRangePickerHeight,
          child: DecoratedBox(
            decoration: context.appThemeExtension.popupDecoration,
            child: Row(
              children: [
                Expanded(
                    child: TDatePicker(
                  calendarDate: calenderDate,
                  availableStartDate: widget.availableStartDate,
                  availableEndDate: widget.availableEndDate,
                  selectedStartDate: selectedStartDate,
                  selectedEndDate: selectedEndDate,
                  hoveredStartDate: widget.hoveredStartDate,
                  hoveredEndDate: widget.hoveredEndDate,
                  showNextButtons: false,
                  onCalendarDateChanged: (value) =>
                      setState(() => calenderDate = value),
                  onDateChanged: widget.onDateChanged,
                  onMouseRegionEntered: widget.onMouseRegionEntered,
                  onMouseRegionExited: widget.onMouseRegionExited,
                )),
                Expanded(
                    child: TDatePicker(
                  calendarDate: DateUtils.addMonthsToMonthDate(calenderDate, 1),
                  availableStartDate: widget.availableStartDate,
                  availableEndDate: widget.availableEndDate,
                  selectedStartDate: selectedStartDate,
                  selectedEndDate: selectedEndDate,
                  hoveredStartDate: widget.hoveredStartDate,
                  hoveredEndDate: widget.hoveredEndDate,
                  showPrevButtons: false,
                  onCalendarDateChanged: (value) => setState(() =>
                      calenderDate = DateTime(value.year, value.month - 1)),
                  onDateChanged: widget.onDateChanged,
                  onMouseRegionEntered: widget.onMouseRegionEntered,
                  onMouseRegionExited: widget.onMouseRegionExited,
                ))
              ],
            ),
          ),
        ),
      );
}
