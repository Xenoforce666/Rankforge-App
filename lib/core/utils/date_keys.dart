class DateKeys {
  DateKeys._();

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static String forDate(DateTime date) {
    final local = startOfDay(date);
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static DateTime parse(String key) {
    final parts = key.split('-');
    if (parts.length != 3) {
      return startOfDay(DateTime.now());
    }

    return DateTime(
      int.tryParse(parts[0]) ?? DateTime.now().year,
      int.tryParse(parts[1]) ?? DateTime.now().month,
      int.tryParse(parts[2]) ?? DateTime.now().day,
    );
  }

  static List<DateTime> lastSevenDays({DateTime? anchor}) {
    final today = startOfDay(anchor ?? DateTime.now());
    return List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );
  }

  static String weekdayLabel(DateTime date) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[date.weekday - 1];
  }
}
