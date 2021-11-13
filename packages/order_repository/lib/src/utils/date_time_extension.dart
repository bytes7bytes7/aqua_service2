extension DateTimeM on DateTime {
  static DateTime from(DateTime other) {
    return DateTime(
      other.year,
      other.month,
      other.day,
      other.hour,
      other.minute,
      other.second,
      other.millisecond,
    );
  }
}
