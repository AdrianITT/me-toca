/// Internal text helpers for step explanations.
///
/// Money is never formatted here: every amount travels as [Money] so the UI
/// chooses the final format.
String formatDate(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  return '$day/$month/${value.year}';
}

String formatBasisPoints(int basisPoints) {
  final whole = basisPoints ~/ 100;
  final fraction = (basisPoints % 100).toString().padLeft(2, '0');
  return '$whole.$fraction%';
}
