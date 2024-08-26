String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}

const monthNames = [
  'Jan',
  'Feb',
  'March',
  'April',
  'May',
  'June',
  'July',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec'
];
String getMonthName(int month) {
  return monthNames[month - 1];
}

DateTime getLastDayOfMonth(DateTime date) {
  DateTime firstDayOfNextMonth = DateTime(date.year, date.month + 1, 1);
  DateTime lastDayOfCurrentMonth =
      firstDayOfNextMonth.subtract(const Duration(days: 1));
  return lastDayOfCurrentMonth;
}

DateTime getFirstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}
