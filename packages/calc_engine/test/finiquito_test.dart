import 'package:calc_engine/calc_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  FiniquitoResult calculate({
    DateTime? hireDate,
    DateTime? terminationDate,
    SeparationType type = SeparationType.resignation,
    Money pendingSalaries = const Money(230000),
    int takenDays = 0,
    WageZone zone = WageZone.general,
  }) => value(
    calculateFiniquito(
      FiniquitoInput(
        monthlySalary: const Money(1500000),
        hireDate: hireDate ?? DateTime.utc(2024, 3, 1),
        terminationDate: terminationDate ?? DateTime.utc(2026, 11, 30),
        separationType: type,
        pendingSalaries: pendingSalaries,
        takenVacationDays: takenDays,
        zone: zone,
      ),
      parameters2026,
    ),
  );

  group('Finiquito', () {
    test('resignation: base case', () {
      final result = calculate();

      expect(result.aguinaldoDays, 334);
      expect(result.aguinaldo, const Money(686301));
      expect(result.vacationPay, const Money(602740));
      expect(result.vacationPremium, const Money(150685));
      expect(result.primaAntiguedad, Money.zero);
      expect(result.finiquitoTotal, const Money(1669726));
      expect(result.severance, Money.zero);
      expect(result.total, const Money(1669726));
    });

    test('unjustified dismissal adds premium and severance', () {
      final result = calculate(type: SeparationType.unjustifiedDismissal);

      expect(result.finiquitoTotal, const Money(1669726));
      expect(result.primaAntiguedad, const Money(1652055));
      expect(result.severance, const Money(7253425));
      expect(result.total, const Money(10575206));
    });

    test('resignation with 15+ years pays seniority premium', () {
      final result = calculate(hireDate: DateTime.utc(2010, 1, 15));

      expect(result.completedYears, 16);
      expect(result.primaAntiguedad, const Money(10132603));
    });

    test('resignation under 15 years pays no seniority premium', () {
      final result = calculate();

      expect(result.completedYears, 2);
      expect(result.primaAntiguedad, Money.zero);
      expect(
        result.steps
            .firstWhere((step) => step.label == 'Prima de antigüedad')
            .detail,
        contains('15 años'),
      );
    });

    test('seniority premium is capped at two minimum wages', () {
      final result = value(
        calculateFiniquito(
          FiniquitoInput(
            monthlySalary: const Money(3000000),
            hireDate: DateTime.utc(2010, 1, 15),
            terminationDate: DateTime.utc(2026, 11, 30),
            separationType: SeparationType.unjustifiedDismissal,
            pendingSalaries: Money.zero,
          ),
          parameters2026,
        ),
      );

      // 630.08 x 12 x 6164 / 365 = 127,687.01
      expect(result.primaAntiguedad, const Money(12768701));
    });

    test('fine and severance stay separated', () {
      final result = calculate(type: SeparationType.unjustifiedDismissal);

      expect(
        result.finiquitoTotal + result.primaAntiguedad + result.severance,
        result.total,
      );
    });

    test('justified dismissal pays premium but no severance', () {
      final result = calculate(type: SeparationType.justifiedDismissal);

      expect(result.primaAntiguedad.isPositive, isTrue);
      expect(result.severance, Money.zero);
    });

    test('rejects a termination date before the hire date', () {
      final outcome = calculateFiniquito(
        FiniquitoInput(
          monthlySalary: const Money(1500000),
          hireDate: DateTime.utc(2026, 1, 1),
          terminationDate: DateTime.utc(2025, 1, 1),
        ),
        parameters2026,
      );

      expect(outcome.isFailure, isTrue);
      expect(
        outcome.errorOrNull!.message,
        'La fecha de baja no puede ser anterior a la de ingreso.',
      );
    });
  });
}
