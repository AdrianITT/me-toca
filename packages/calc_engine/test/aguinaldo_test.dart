import 'package:calc_engine/calc_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  group('Aguinaldo', () {
    test('full year', () {
      final result = value(
        calculateAguinaldo(
          AguinaldoInput(
            monthlySalary: const Money(1500000),
            hireDate: DateTime.utc(2020, 1, 1),
            calculationDate: DateTime.utc(2026, 12, 31),
          ),
          parameters2026,
        ),
      );

      expect(result.aguinaldo, const Money(750000));
      expect(result.exempt, const Money(351930));
      expect(result.taxable, const Money(398070));
      expect(result.daysWorked, 365);
    });

    test('proportional from July 1', () {
      final result = value(
        calculateAguinaldo(
          AguinaldoInput(
            monthlySalary: const Money(1500000),
            hireDate: DateTime.utc(2026, 7, 1),
            calculationDate: DateTime.utc(2026, 12, 31),
          ),
          parameters2026,
        ),
      );

      expect(result.daysWorked, 184);
      expect(result.aguinaldo, const Money(378082));
    });

    test('one day worked', () {
      final result = value(
        calculateAguinaldo(
          AguinaldoInput(
            monthlySalary: const Money(1500000),
            hireDate: DateTime.utc(2026, 12, 31),
            calculationDate: DateTime.utc(2026, 12, 31),
          ),
          parameters2026,
        ),
      );

      expect(result.aguinaldo, const Money(2055));
    });

    test('company grants 20 days', () {
      final result = value(
        calculateAguinaldo(
          AguinaldoInput(
            monthlySalary: const Money(1500000),
            hireDate: DateTime.utc(2020, 1, 1),
            calculationDate: DateTime.utc(2026, 12, 31),
            companyAguinaldoDays: 20,
          ),
          parameters2026,
        ),
      );

      expect(result.aguinaldo, const Money(1000000));
    });

    test('January exemption uses the 2025 UMA', () {
      final result = value(
        calculateAguinaldo(
          AguinaldoInput(
            monthlySalary: const Money(1500000),
            hireDate: DateTime.utc(2020, 1, 1),
            calculationDate: DateTime.utc(2026, 12, 31),
          ),
          parametersJanuary2026,
        ),
      );

      expect(result.exempt, const Money(339420));
      expect(result.taxable, const Money(410580));
    });

    test('rejects a salary of zero', () {
      final outcome = calculateAguinaldo(
        AguinaldoInput(
          monthlySalary: Money.zero,
          hireDate: DateTime.utc(2020, 1, 1),
          calculationDate: DateTime.utc(2026, 12, 31),
        ),
        parameters2026,
      );

      expect(outcome.isFailure, isTrue);
      expect(outcome.errorOrNull!.code, CalcErrorCode.invalidInput);
    });
  });
}
