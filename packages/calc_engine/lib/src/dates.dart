/// Calendar helpers used by the engine.
///
/// All dates are normalized to UTC midnight so arithmetic never depends on
/// daylight saving time or the device clock.
library;

DateTime dateOnly(DateTime value) =>
    DateTime.utc(value.year, value.month, value.day);

/// Number of days between [start] and [end], counting both ends.
int daysInclusive(DateTime start, DateTime end) {
  final from = dateOnly(start);
  final to = dateOnly(end);
  return to.difference(from).inDays + 1;
}

bool isLeapYear(int year) =>
    (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

int daysInYear(int year) => isLeapYear(year) ? 366 : 365;

/// Adds years keeping the day of month, clamped to the last valid day.
///
/// A February 29 hire date becomes February 28 on non-leap anniversaries.
DateTime addYearsClamped(DateTime date, int years) {
  final targetYear = date.year + years;
  final lastDayOfMonth = DateTime.utc(targetYear, date.month + 1, 0).day;
  final day = date.day > lastDayOfMonth ? lastDayOfMonth : date.day;
  return DateTime.utc(targetYear, date.month, day);
}

/// Completed anniversaries between [from] and [to].
///
/// Returns -1 when [to] is before [from].
int completedYears(DateTime from, DateTime to) {
  final start = dateOnly(from);
  final end = dateOnly(to);
  if (end.isBefore(start)) {
    return -1;
  }
  var years = end.year - start.year;
  if (addYearsClamped(start, years).isAfter(end)) {
    years -= 1;
  }
  return years;
}

/// Inclusive day count from [start] to [end] for a single service year.
int serviceYearLength(DateTime start) {
  final next = addYearsClamped(start, 1);
  return next.difference(dateOnly(start)).inDays;
}
