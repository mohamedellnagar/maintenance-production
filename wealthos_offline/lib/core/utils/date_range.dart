/// أدوات لمقارنة التواريخ ضمن الفترات الزمنية (Salary/Expense History).
class DateRangeUtils {
  DateRangeUtils._();

  /// هل [date] يقع ضمن [start] و[end] (end اختياري = مفتوح حتى الآن).
  static bool contains(DateTime date, DateTime start, DateTime? end) {
    final afterStart = !date.isBefore(DateTime(start.year, start.month));
    if (end == null) return afterStart;
    final beforeEnd = !date.isAfter(DateTime(end.year, end.month + 1, 0, 23, 59));
    return afterStart && beforeEnd;
  }

  /// عدد الأشهر بين تاريخين (شامل الحدّين تقريبيًا).
  static int monthsBetween(DateTime a, DateTime b) {
    return (b.year - a.year) * 12 + (b.month - a.month);
  }

  /// قائمة برؤوس الأشهر بين تاريخين (لرسم التايم لاين).
  static List<DateTime> monthlyMarks(DateTime start, DateTime end,
      {int maxPoints = 24}) {
    final marks = <DateTime>[];
    var cursor = DateTime(start.year, start.month);
    final last = DateTime(end.year, end.month);
    while (!cursor.isAfter(last)) {
      marks.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    if (marks.length <= maxPoints) return marks;
    // تخفيف النقاط للحفاظ على وضوح الرسم.
    final step = (marks.length / maxPoints).ceil();
    return [
      for (var i = 0; i < marks.length; i += step) marks[i],
      marks.last,
    ];
  }
}
