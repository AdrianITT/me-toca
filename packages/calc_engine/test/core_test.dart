import 'package:calc_engine/calc_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  group('Money', () {
    test('adds and subtracts in cents', () {
      expect(const Money(1500) + const Money(250), const Money(1750));
      expect(const Money(1500) - const Money(250), const Money(1250));
    });

    test('rounds half-up once per concept', () {
      // 1.00 / 8 = 0.125 -> 0.13
      expect(const Money(100).mulDiv(1, 8), const Money(13));
      // 1.01 / 2 = 0.505 -> 0.51
      expect(const Money(101).mulDiv(1, 2), const Money(51));
      // 5.00 x 25% = 1.25
      expect(const Money(500).percentage(2500), const Money(125));
    });

    test('never uses doubles for money', () {
      expect(const Money(9999999999).cents, isA<int>());
    });
  });

  group('ParameterRepository', () {
    test('January 2026 uses 2026-01', () {
      final outcome = ParameterRepository.forDate(DateTime.utc(2026, 1, 15));
      final parameters = outcome.valueOrNull;
      expect(parameters, isNotNull);
      expect(parameters!.id, '2026-01');
      expect(parameters.uma.daily, const Money(11314));
      expect(parameters.subsidyMonthly, const Money(53621));
    });

    test('February 1 switches UMA and subsidy', () {
      final parameters = ParameterRepository.forDate(DateTime.utc(2026, 2, 1))
          .valueOrNull!;
      expect(parameters.id, '2026-02');
      expect(parameters.uma.daily, const Money(11731));
      expect(parameters.subsidyMonthly, const Money(53565));
    });

    test('December 31 still uses 2026-02', () {
      final parameters = ParameterRepository.forDate(DateTime.utc(2026, 12, 31))
          .valueOrNull!;
      expect(parameters.id, '2026-02');
    });

    test('2025 has no table', () {
      final outcome = ParameterRepository.forDate(DateTime.utc(2025, 12, 31));
      expect(outcome.isFailure, isTrue);
      expect(outcome.errorOrNull!.code, CalcErrorCode.noParametersForDate);
    });

    test('2027 has no table yet', () {
      final outcome = ParameterRepository.forDate(DateTime.utc(2027, 1, 1));
      expect(outcome.isFailure, isTrue);
      expect(outcome.errorOrNull!.code, CalcErrorCode.noParametersForDate);
    });

    test('border stimulus stays disabled', () {
      final parameters = parameters2026;
      expect(parameters.borderStimulusActive, isFalse);
    });
  });

  group('Vacation table (Art. 76 LFT)', () {
    test('matches the published table', () {
      expect(vacationDaysForCompletedYears(1), 12);
      expect(vacationDaysForCompletedYears(5), 20);
      expect(vacationDaysForCompletedYears(6), 22);
      expect(vacationDaysForCompletedYears(10), 22);
      expect(vacationDaysForCompletedYears(11), 24);
      expect(vacationDaysForCompletedYears(25), 28);
      expect(vacationDaysForCompletedYears(31), 32);
      expect(vacationDaysForCompletedYears(40), 32);
    });
  });
}
