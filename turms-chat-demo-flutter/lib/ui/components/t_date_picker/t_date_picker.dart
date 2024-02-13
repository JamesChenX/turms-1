import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../l10n/view_models/app_localizations_view_model.dart';
import '../components.dart';
import 't_date_cell.dart';

class TDatePicker extends ConsumerWidget {
  const TDatePicker(
      {Key? key,
      required this.calendarDate,
      this.showPrevButtons = true,
      this.showNextButtons = true,
      this.onCalendarDateChanged,
      this.onDateChanged})
      : super(key: key);

  final DateTime calendarDate;
  final bool showPrevButtons;
  final bool showNextButtons;
  final ValueChanged<DateTime>? onCalendarDateChanged;
  final ValueChanged<DateTime>? onDateChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const itemCount = DateTime.daysPerWeek * 7;
    final localeName = ref.watch(appLocalizationsViewModel).localeName;
    final dateSymbols = DateFormat.EEEE(localeName).dateSymbols;
    final weekdays = dateSymbols.NARROWWEEKDAYS;
    final dateStr = DateFormat.yM(localeName).format(calendarDate);
    final thisMonthDays =
        DateUtils.getDaysInMonth(calendarDate.year, calendarDate.month);
    final thisMonthFirstDay =
        DateTime(calendarDate.year, calendarDate.month, 1);
    return Column(
      children: [
        _buildTitle(dateStr),
        const THorizontalDivider(),
        _buildBody(weekdays, thisMonthFirstDay, thisMonthDays)
      ],
    );
  }

  Widget _buildTitle(String dateStr) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(children: [
          if (showPrevButtons)
            TIconButton(
              iconData: Symbols.keyboard_double_arrow_left_rounded,
              iconColor: Colors.black45,
              iconHoverColor: Colors.black,
              addContainer: false,
              onTap: () => onCalendarDateChanged?.call(
                DateTime(calendarDate.year - 1, calendarDate.month),
              ),
            ),
          if (showPrevButtons)
            TIconButton(
              iconData: Symbols.keyboard_arrow_left_rounded,
              iconColor: Colors.black45,
              iconHoverColor: Colors.black,
              addContainer: false,
              onTap: () => onCalendarDateChanged?.call(
                DateTime(calendarDate.year, calendarDate.month - 1),
              ),
            ),
          Expanded(
            child: Text(
              dateStr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (showNextButtons)
            TIconButton(
              iconData: Symbols.keyboard_arrow_right_rounded,
              iconColor: Colors.black45,
              iconHoverColor: Colors.black,
              addContainer: false,
              onTap: () => onCalendarDateChanged?.call(
                DateTime(calendarDate.year, calendarDate.month + 1),
              ),
            ),
          if (showNextButtons)
            TIconButton(
              iconData: Symbols.keyboard_double_arrow_right_rounded,
              iconColor: Colors.black45,
              iconHoverColor: Colors.black,
              addContainer: false,
              onTap: () => onCalendarDateChanged?.call(
                DateTime(calendarDate.year + 1, calendarDate.month),
              ),
            ),
        ]),
      );

  Expanded _buildBody(
      List<String> weekdays, DateTime thisMonthFirstDay, int thisMonthDays) {
    final now = DateTime.now();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
          crossAxisCount: DateTime.daysPerWeek,
          children: [
            for (final weekday in weekdays)
              Center(
                child: Text(
                  weekday,
                ),
              ),
            for (var i = 0; i < thisMonthFirstDay.weekday; i++)
              const SizedBox.shrink(),
            for (var i = 1,
                    date = DateTime(
                        thisMonthFirstDay.year, thisMonthFirstDay.month, i);
                i <= thisMonthDays;
                i++,
                date = DateTime(
                    thisMonthFirstDay.year, thisMonthFirstDay.month, i))
              TDateCell(date: date, isToday: DateUtils.isSameDay(date, now),
                onTap: (DateTime value) {
                  onDateChanged?.call(value);
                },),
          ],
        ),
      ),
    );
  }
}