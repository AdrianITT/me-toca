import 'package:calc_engine/calc_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  IvaResult calculate(
    Money amount, {
    IvaMode mode = IvaMode.add,
    IvaRate rate = IvaRate.general,
  }) => value(calculateIva(IvaInput(amount: amount, mode: mode, rate: rate)));

  group('IVA', () {
    test('adds 16%', () {
      final result = calculate(const Money(100000));

      expect(result.subtotal, const Money(100000));
      expect(result.tax, const Money(16000));
      expect(result.total, const Money(116000));
    });

    test('breaks down a total with 16% included', () {
      final result = calculate(const Money(116000), mode: IvaMode.breakdown);

      expect(result.subtotal, const Money(100000));
      expect(result.tax, const Money(16000));
      expect(result.total, const Money(116000));
    });

    test('0% is a taxed act at zero rate', () {
      final result = calculate(const Money(100000), rate: IvaRate.zero);

      expect(result.tax, Money.zero);
      expect(result.total, const Money(100000));
      expect(result.steps[1].detail, contains('tasa 0%'));
    });

    test('exempt is not the same as 0%', () {
      final result = calculate(const Money(100000), rate: IvaRate.exempt);

      expect(result.tax, Money.zero);
      expect(result.total, const Money(100000));
      expect(result.steps.first.detail, contains('no causa IVA'));
    });

    test('8% border rate is not available', () {
      final outcome = calculateIva(
        const IvaInput(amount: Money(100000), rate: IvaRate.border),
      );

      expect(outcome.isFailure, isTrue);
      expect(outcome.errorOrNull!.code, CalcErrorCode.unsupportedPeriod);
    });

    test('rejects a negative amount', () {
      final outcome = calculateIva(const IvaInput(amount: Money(-1)));

      expect(outcome.isFailure, isTrue);
      expect(outcome.errorOrNull!.code, CalcErrorCode.invalidInput);
    });
  });
}
