/// Formats basis points as a percentage without converting to `double`.
String formatBasisPoints(int basisPoints) {
  final absolute = basisPoints.abs();
  final sign = basisPoints < 0 ? '-' : '';
  return '$sign${absolute ~/ 100}.${(absolute % 100).toString().padLeft(2, '0')}%';
}
