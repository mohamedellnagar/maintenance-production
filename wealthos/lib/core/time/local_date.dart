/// A timezone-free calendar date (year/month/day).
///
/// Recurrence logic and due dates use this instead of [DateTime] so that no
/// UTC/DST conversion can shift a calendar day. Internally, arithmetic and the
/// [epochDay] round-trip go through UTC, which is stable across time zones.
class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day);

  final int year;
  final int month; // 1..12
  final int day; // 1..31

  factory LocalDate.fromDateTime(DateTime dt) =>
      LocalDate(dt.year, dt.month, dt.day);

  /// Today in the device's local zone. Only used at the composition root via an
  /// injected clock — never inside domain logic directly.
  factory LocalDate.today() => LocalDate.fromDateTime(DateTime.now());

  /// Days since 1970-01-01 (UTC-based, so it is a pure calendar count).
  factory LocalDate.fromEpochDay(int epochDay) {
    final dt = DateTime.utc(1970, 1, 1).add(Duration(days: epochDay));
    return LocalDate(dt.year, dt.month, dt.day);
  }

  int get epochDay =>
      DateTime.utc(year, month, day).difference(DateTime.utc(1970)).inDays;

  /// Local midnight [DateTime] for this date (used when writing a transaction).
  DateTime toDateTime() => DateTime(year, month, day);

  /// ISO weekday: Monday = 1 … Sunday = 7.
  int get weekday => DateTime.utc(year, month, day).weekday;

  LocalDate addDays(int days) => LocalDate.fromEpochDay(epochDay + days);

  /// Adds [months], clamping the day to the last day of the target month.
  LocalDate addMonths(int months) {
    final total = (year * 12 + (month - 1)) + months;
    final y = total ~/ 12;
    final m = total % 12 + 1;
    final d = day < daysInMonthOf(y, m) ? day : daysInMonthOf(y, m);
    return LocalDate(y, m, d);
  }

  int get daysInMonth => daysInMonthOf(year, month);

  bool isBefore(LocalDate other) => epochDay < other.epochDay;
  bool isAfter(LocalDate other) => epochDay > other.epochDay;
  bool isSameOrBefore(LocalDate other) => epochDay <= other.epochDay;
  bool isSameOrAfter(LocalDate other) => epochDay >= other.epochDay;

  @override
  int compareTo(LocalDate other) => epochDay.compareTo(other.epochDay);

  @override
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => '$year-${_two(month)}-${_two(day)}';

  static String _two(int v) => v < 10 ? '0$v' : '$v';

  static bool isLeapYear(int year) =>
      (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

  static int daysInMonthOf(int year, int month) => switch (month) {
    1 || 3 || 5 || 7 || 8 || 10 || 12 => 31,
    4 || 6 || 9 || 11 => 30,
    2 => isLeapYear(year) ? 29 : 28,
    _ => 30,
  };
}

/// Injectable "today" provider so time can be controlled in tests.
typedef Clock = LocalDate Function();

LocalDate systemToday() => LocalDate.today();
