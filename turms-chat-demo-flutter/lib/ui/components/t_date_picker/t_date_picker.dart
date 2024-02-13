import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../infra/datetime/datetime_utils.dart';
import '../../l10n/view_models/app_localizations_view_model.dart';
import '../components.dart';
import '../t_button/t_icon_button.dart';
import 't_date_cell.dart';

class TDatePicker extends ConsumerWidget {
  const TDatePicker({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const itemCount = DateTime.daysPerWeek * 7;
    final localeName = ref.watch(appLocalizationsViewModel).localeName;
    final dateSymbols = DateFormat.EEEE(localeName).dateSymbols;
    final weekdays = dateSymbols.NARROWWEEKDAYS;
    final dateStr = DateFormat.yM(localeName).format(date);
    final thisMonthDays = DateUtils.getDaysInMonth(date.year, date.month);
    final thisMonthFirstDay = DateTime(date.year, date.month, 1);
    DateTimeUtils.getFirstDateOfTheWeek(
        date); // DateFormat.yMMMEd().dateSymbols.
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
          const TIconButton(
              iconData: Symbols.keyboard_double_arrow_left_rounded,
              iconColor: Colors.black45,
              iconHoverColor: Colors.black,
              addContainer: false),
          const TIconButton(
              iconData: Symbols.keyboard_arrow_left_rounded,
              iconColor: Colors.black45,
              iconHoverColor: Colors.black,
              addContainer: false),
          Expanded(
            child: Text(
              dateStr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const TIconButton(
              iconData: Symbols.keyboard_arrow_right_rounded,
              iconColor: Colors.black45,
              iconHoverColor: Colors.black,
              addContainer: false),
          const TIconButton(
              iconData: Symbols.keyboard_double_arrow_right_rounded,
              iconColor: Colors.black45,
              iconHoverColor: Colors.black,
              addContainer: false),
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
              TDateCell(date: date, isToday: DateUtils.isSameDay(date, now)),
          ],
        ),
      ),
    );
  }
}