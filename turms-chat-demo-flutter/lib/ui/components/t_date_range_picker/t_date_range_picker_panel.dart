part of 't_date_range_picker.dart';

class _TDateRangePickerPanel extends StatelessWidget {
  const _TDateRangePickerPanel(
      {Key? key,
      required this.firstDate,
      required this.lastDate,
      required this.initialDateRange})
      : super(key: key);

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange initialDateRange;

  @override
  Widget build(BuildContext context) {
    final start = initialDateRange.start;
    return Material(
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
              Expanded(child: TDatePicker(date: start)),
              Expanded(
                  child: TDatePicker(
                      date: DateUtils.addMonthsToMonthDate(start, 1)))
            ],
          ),
        ),
      ),
    );
  }
}