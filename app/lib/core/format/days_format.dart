/// Formats hundredths of a day without converting to `double`.
String formatDayHundredths(int hundredths) {
  final absolute = hundredths.abs();
  final sign = hundredths < 0 ? '-' : '';
  final fraction = (absolute % 100).toString().padLeft(2, '0');
  return '$sign${absolute ~/ 100}.$fraction';
}
