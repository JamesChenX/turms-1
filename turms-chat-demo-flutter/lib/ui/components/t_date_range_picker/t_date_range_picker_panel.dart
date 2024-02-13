part of 't_date_range_picker.dart';

class _TDateRangePickerPanel extends StatefulWidget {
  const _TDateRangePickerPanel(
      {Key? key,
      required this.availableStartDate,
      required this.availableEndDate,
      required this.initialDateRange,
      required this.onDateChanged})
      : super(key: key);

  final DateTime availableStartDate;
  final DateTime availableEndDate;
  final DateTimeRange initialDateRange;
  final ValueChanged<DateTime> onDateChanged;

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
        child: Container(
          width: 576,
          height: 310,
          child: DecoratedBox(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: ThemeConfig.borderRadius4,
                boxShadow: ThemeConfig.boxShadow),
            child: Row(
              children: [
                Expanded(
                    child: TDatePicker(
                  calendarDate: calenderDate,
                  availableStartDate: widget.availableStartDate,
                  availableEndDate: widget.availableEndDate,
                  selectedStartDate: selectedStartDate,
                  selectedEndDate: selectedEndDate,
                  showNextButtons: false,
                  onCalendarDateChanged: (value) =>
                      setState(() => calenderDate = value),
                  onDateChanged: widget.onDateChanged,
                )),
                Expanded(
                    child: TDatePicker(
                  calendarDate: DateUtils.addMonthsToMonthDate(calenderDate, 1),
                      availableStartDate: widget.availableStartDate,
                      availableEndDate: widget.availableEndDate,
                  selectedStartDate: selectedStartDate,
                  selectedEndDate: selectedEndDate,
                  showPrevButtons: false,
                  onCalendarDateChanged: (value) => setState(() =>
                      calenderDate = DateTime(value.year, value.month - 1)),
                  onDateChanged: widget.onDateChanged,
                ))
              ],
            ),
          ),
        ),
      );
}