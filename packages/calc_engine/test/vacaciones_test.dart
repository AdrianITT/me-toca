import 'package:calc_engine/calc_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  VacacionesResult calculate({
    required DateTime hireDate,
    required DateTime cutoffDate,
    int takenDays = 0,
  }) => value(
    calculateVacaciones(
      VacacionesInput(
        hireDate: hireDate,
        cutoffDate: cutoffDate,
        monthlySalary: const Money(1500000),
        takenDays: takenDays,
      ),
      parameters2026,
    ),
  );

  group('Vacaciones', () {
    test('year 1: 12 days', () {
      final result = calculate(
        hireDate: DateTime.utc(2025, 3, 1),
        cutoffDate: DateTime.utc(2026, 3, 1),
      );

      expect(result.entitledDays, 12);
      expect(result.pendingDays, 12);
      expect(result.vacationPay, const Money(600000));
      expect(result.premium, const Money(150000));
      expect(result.total, const Money(750000));
    });

    test('year 10: 22 days', () {
      final result = calculate(
        hireDate: DateTime.utc(2016, 3, 1),
        cutoffDate: DateTime.utc(2026, 3, 1),
      );

      expect(result.entitledDays, 22);
      expect(result.vacationPay, const Money(1100000));
    });

    test('year 11: 24 days', () {
      final result = calculate(
        hireDate: DateTime.utc(2015, 3, 1),
        cutoffDate: DateTime.utc(2026, 3, 1),
      );

      expect(result.entitledDays, 24);
    });

    test('year 25: 28 days', () {
      final result = calculate(
        hireDate: DateTime.utc(2001, 3, 1),
        cutoffDate: DateTime.utc(2026, 3, 1),
      );

      expect(result.entitledDays, 28);
    });

    test('year 31: 32 days', () {
      final result = calculate(
        hireDate: DateTime.utc(1995, 3, 1),
        cutoffDate: DateTime.utc(2026, 3, 1),
      );

      expect(result.entitledDays, 32);
    });

    test('5 taken days leave 7 pending', () {
      final result = calculate(
        hireDate: DateTime.utc(2025, 3, 1),
        cutoffDate: DateTime.utc(2026, 3, 1),
        takenDays: 5,
      );

      expect(result.pendingDays, 7);
      expect(result.vacationPay, const Money(350000));
      expect(result.premium, const Money(87500));
    });

    test('more taken days than entitled never goes negative', () {
      final result = calculate(
        hireDate: DateTime.utc(2025, 3, 1),
        cutoffDate: DateTime.utc(2026, 3, 1),
        takenDays: 20,
      );

      expect(result.pendingDays, 0);
      expect(result.total, Money.zero);
    });

    test('less than one year points to the finiquito', () {
      final outcome = calculateVacaciones(
        VacacionesInput(
          hireDate: DateTime.utc(2026, 1, 1),
          cutoffDate: DateTime.utc(2026, 11, 30),
          monthlySalary: const Money(1500000),
        ),
        parameters2026,
      );

      expect(outcome.isFailure, isTrue);
      expect(outcome.errorOrNull!.code, CalcErrorCode.invalidInput);
    });
  });
}
