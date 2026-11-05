import 'package:calc_engine/calc_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  IsrResult calculate(Money income, [PayPeriod period = PayPeriod.monthly]) =>
      value(
        calculateIsr(
          IsrInput(taxableIncome: income, period: period),
          parameters2026,
        ),
      );

  group('ISR 2026', () {
    test('no withholding below the subsidy cap', () {
      final result = calculate(const Money(822275));

      expect(result.isrCaused, const Money(53565));
      expect(result.subsidy, const Money(53565));
      expect(result.isrWithheld, Money.zero);
    });

    test('bracket 3', () {
      final result = calculate(const Money(1000000));

      expect(result.bracketNumber, 3);
      expect(result.isrCaused, const Money(72902));
      expect(result.isrWithheld, const Money(19337));
    });

    test('subsidy cap exactly', () {
      final result = calculate(const Money(1149266));

      expect(result.subsidy, const Money(53565));
      expect(result.isrWithheld, const Money(35577));
    });

    test('cliff one cent above the cap', () {
      final result = calculate(const Money(1149267));

      expect(result.subsidy, Money.zero);
      expect(result.isrWithheld, const Money(89142));
    });

    test('bracket 5', () {
      final result = calculate(const Money(1500000));

      expect(result.bracketNumber, 5);
      expect(result.isrWithheld, const Money(140282));
    });

    test('last bracket', () {
      final result = calculate(const Money(50000000));

      expect(result.bracketNumber, 11);
      expect(result.isrWithheld, const Money(15951384));
    });

    test('fifteen-day period: cap is prorated, no subsidy', () {
      final result = calculate(const Money(750000), PayPeriod.fifteenDay);

      expect(result.isrCaused, const Money(70986));
      expect(result.subsidy, Money.zero);
      expect(result.isrWithheld, const Money(70986));
    });

    test('fifteen-day period below its cap keeps the subsidy', () {
      final result = calculate(const Money(500000), PayPeriod.fifteenDay);

      expect(result.subsidy, const Money(26430));
    });

    test('weekly period', () {
      final result = calculate(const Money(200000), PayPeriod.weekly);

      expect(result.isrCaused, const Money(13496));
      expect(result.subsidy, const Money(12334));
      expect(result.isrWithheld, const Money(1162));
    });

    test('net income is gross minus withholding', () {
      final result = calculate(const Money(1000000));

      expect(result.netIncome, const Money(980663));
      expect(result.effectiveRateBp, 193);
    });
  });
}
