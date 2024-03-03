class DateTimeUtils {
  DateTimeUtils._();

  static DateTime getFirstDateOfTheWeek(DateTime dateTime) =>
      dateTime.subtract(Duration(days: dateTime.weekday - 1));

  static DateTime getMostRecentWeekday(DateTime date, int weekday) =>
      DateTime(date.year, date.month, date.day - (date.weekday - weekday) % 7);

  static bool isBetween(DateTime date, DateTime? start, DateTime? end) =>
      (start != null && date.isAfter(start)) &&
      (end != null && date.isBefore(end));

// static List<String> getDaysOfWeek([String locale]) {
//   final now = DateTime.now();
//   final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
//   return List.generate(7, (index) => index)
//       .map((value) => DateFormat(DateFormat.WEEKDAY, locale)
//           .format(firstDayOfWeek.add(Duration(days: value))))
//       .toList();
// }
}
