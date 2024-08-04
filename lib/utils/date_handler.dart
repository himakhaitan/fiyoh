String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
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