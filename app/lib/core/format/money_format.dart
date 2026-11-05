import 'package:calc_engine/calc_engine.dart';
import 'package:intl/intl.dart';

final NumberFormat _grouped = NumberFormat.decimalPattern('es_MX');

/// Formats cents without ever converting money to `double`.
String formatMoney(Money money) {
  final absolute = money.cents.abs();
  final units = absolute ~/ 100;
  final cents = (absolute % 100).toString().padLeft(2, '0');
  final sign = money.isNegative ? '-' : '';
  return '$sign${_grouped.format(units)}.$cents';
}

/// Parses a user amount into cents.
///
/// Accepts `15000`, `15,000`, `15,000.00` and `$15,000.50`. Returns null when
/// the text is not a valid amount with at most two decimals.
Money? parseMoneyInput(String raw) {
  var text = raw.trim().replaceAll(RegExp(r'[\s$]'), '');
  text = text.replaceAll(',', '');
  if (text.isEmpty) {
    return null;
  }
  final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(text);
  if (match == null) {
    return null;
  }
  final units = int.tryParse(match.group(1)!);
  if (units == null) {
    return null;
  }
  final decimals = (match.group(2) ?? '').padRight(2, '0');
  return Money(units * 100 + int.parse(decimals));
}
