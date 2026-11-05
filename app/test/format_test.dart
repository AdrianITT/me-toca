import 'package:calc_engine/calc_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metoca/core/format/money_format.dart';
import 'package:metoca/core/format/money_words.dart';

void main() {
  group('formatMoney', () {
    test('groups thousands and keeps two decimals', () {
      expect(formatMoney(const Money(750000)), '7,500.00');
      expect(formatMoney(const Money(1669726)), '16,697.26');
      expect(formatMoney(Money.zero), '0.00');
    });
  });

  group('parseMoneyInput', () {
    test('accepts common formats', () {
      expect(parseMoneyInput('15000'), const Money(1500000));
      expect(parseMoneyInput('15,000'), const Money(1500000));
      expect(parseMoneyInput('15,000.00'), const Money(1500000));
      expect(parseMoneyInput(r'$1,234.50'), const Money(123450));
      expect(parseMoneyInput('0.75'), const Money(75));
    });

    test('rejects invalid formats', () {
      expect(parseMoneyInput(''), isNull);
      expect(parseMoneyInput('12.345'), isNull);
      expect(parseMoneyInput('abc'), isNull);
      expect(parseMoneyInput('-10'), isNull);
    });
  });

  group('moneyToWordsEs', () {
    test('speaks amounts for accessibility', () {
      expect(moneyToWordsEs(const Money(750000)), 'siete mil quinientos pesos');
      expect(
        moneyToWordsEs(const Money(123450)),
        'mil doscientos treinta y cuatro pesos con cincuenta centavos',
      );
      expect(moneyToWordsEs(const Money(100)), 'un peso');
      expect(moneyToWordsEs(const Money(2100000)), 'veintiún mil pesos');
      expect(moneyToWordsEs(const Money(100000000)), 'un millón de pesos');
    });
  });
}
