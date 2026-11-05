import '../dates.dart';
import '../format.dart';
import '../money.dart';
import '../parameters.dart';
import '../result.dart';
import '../tables/vacation_days.dart';

enum SeparationType {
  resignation(label: 'renuncia'),
  unjustifiedDismissal(label: 'despido injustificado'),
  justifiedDismissal(label: 'despido justificado'),
  contractEnd(label: 'término de contrato'),
  mutualAgreement(label: 'mutuo consentimiento');

  const SeparationType({required this.label});

  final String label;

  bool get paysSeverance => this == SeparationType.unjustifiedDismissal;
}

class FiniquitoInput {
  const FiniquitoInput({
    required this.monthlySalary,
    required this.hireDate,
    required this.terminationDate,
    this.separationType = SeparationType.resignation,
    this.takenVacationDays = 0,
    this.pendingSalaries = Money.zero,
    this.zone = WageZone.general,
  });

  final Money monthlySalary;
  final DateTime hireDate;
  final DateTime terminationDate;
  final SeparationType separationType;
  final int takenVacationDays;
  final Money pendingSalaries;
  final WageZone zone;
}

class FiniquitoResult {
  const FiniquitoResult({
    required this.separationType,
    required this.dailySalary,
    required this.pendingSalaries,
    required this.aguinaldo,
    required this.vacationPay,
    required this.vacationPremium,
    required this.primaAntiguedad,
    required this.finiquitoTotal,
    required this.severance,
    required this.total,
    required this.serviceDays,
    required this.completedYears,
    required this.aguinaldoDays,
    required this.vacationEntitledDays,
    required this.vacationPendingDaysHundredths,
    required this.primaAntiguedadDaysHundredths,
    required this.severanceDaysHundredths,
    required this.parametersId,
    required this.steps,
  });

  final SeparationType separationType;
  final Money dailySalary;
  final Money pendingSalaries;
  final Money aguinaldo;
  final Money vacationPay;
  final Money vacationPremium;
  final Money primaAntiguedad;

  /// Accrued benefits only: salaries, aguinaldo, vacation and premium.
  /// The seniority premium is presented as its own line, as in the plan.
  final Money finiquitoTotal;

  /// Statutory severance. Separate from the finiquito.
  final Money severance;

  final Money total;
  final int serviceDays;
  final int completedYears;
  final int aguinaldoDays;
  final int vacationEntitledDays;

  /// Pending vacation days, in hundredths of a day.
  final int vacationPendingDaysHundredths;

  /// Seniority premium days, in hundredths of a day.
  final int primaAntiguedadDaysHundredths;

  /// Severance days, in hundredths of a day.
  final int severanceDaysHundredths;

  final String parametersId;
  final List<CalcStep> steps;
}

CalcOutcome<FiniquitoResult> calculateFiniquito(
  FiniquitoInput input,
  LegalParameters parameters,
) {
  if (!input.monthlySalary.isPositive) {
    return invalidInput('Escribe un salario mayor a cero.');
  }
  if (input.takenVacationDays < 0) {
    return invalidInput(
      'Los días de vacaciones tomados no pueden ser negativos.',
    );
  }
  if (input.pendingSalaries.isNegative) {
    return invalidInput('Los salarios pendientes no pueden ser negativos.');
  }
  final hire = dateOnly(input.hireDate);
  final termination = dateOnly(input.terminationDate);
  if (termination.isBefore(hire)) {
    return invalidInput(
      'La fecha de baja no puede ser anterior a la de ingreso.',
    );
  }

  final serviceDays = daysInclusive(hire, termination);
  final yearsCompleted = completedYears(hire, termination);
  final dailySalary = input.monthlySalary.mulDiv(1, 30);

  // --- Aguinaldo: calendar year of the termination date.
  final yearStart = DateTime.utc(termination.year, 1, 1);
  final aguinaldoStart = hire.isAfter(yearStart) ? hire : yearStart;
  final aguinaldoDaysWorked = daysInclusive(aguinaldoStart, termination);
  final daysInCalendarYear = daysInYear(termination.year);
  final aguinaldo = input.monthlySalary.mulDiv(
    aguinaldoDaysWorked * parameters.aguinaldoMinDays,
    30 * daysInCalendarYear,
  );

  // --- Vacation for the service year in course.
  final serviceYearStart = addYearsClamped(hire, yearsCompleted);
  final serviceYearDays = serviceYearLength(serviceYearStart);
  final elapsedDays = daysInclusive(serviceYearStart, termination);
  final entitledDays = vacationDaysForCompletedYears(yearsCompleted + 1);
  final pendingNumerator =
      entitledDays * elapsedDays - input.takenVacationDays * serviceYearDays;
  final hasPendingVacation = pendingNumerator > 0;

  final vacationPay = hasPendingVacation
      ? input.monthlySalary.mulDiv(pendingNumerator, 30 * serviceYearDays)
      : Money.zero;
  final vacationPremium = vacationPay.percentage(parameters.vacationPremiumBp);
  final vacationPendingHundredths = hasPendingVacation
      ? Money.divideHalfUp(pendingNumerator * 100, serviceYearDays)
      : 0;

  // --- Seniority premium (Art. 162 LFT).
  // On resignation it only applies with 15 or more years of service.
  final primaApplies =
      input.separationType != SeparationType.resignation ||
      yearsCompleted >= 15;
  final primaCap = parameters.minimumWage
      .forZone(input.zone)
      .times(parameters.primaAntiguedadCap);
  final isSalaryCapped = input.monthlySalary > primaCap.times(30);
  final primaAntiguedad = !primaApplies
      ? Money.zero
      : isSalaryCapped
      ? primaCap.times(parameters.primaAntiguedadDays).mulDiv(serviceDays, 365)
      : input.monthlySalary.mulDiv(
          parameters.primaAntiguedadDays * serviceDays,
          30 * 365,
        );
  final primaDaysHundredths = primaApplies
      ? Money.divideHalfUp(
          parameters.primaAntiguedadDays * serviceDays * 100,
          365,
        )
      : 0;

  // --- Severance: only unjustified dismissal (Arts. 48 and 50 LFT).
  final severanceApplies = input.separationType.paysSeverance;
  final severanceDaysNumerator =
      parameters.severanceBaseDays * 365 +
      parameters.severanceDaysPerYear * serviceDays;
  final severance = severanceApplies
      ? input.monthlySalary.mulDiv(severanceDaysNumerator, 30 * 365)
      : Money.zero;
  final severanceDaysHundredths = severanceApplies
      ? Money.divideHalfUp(severanceDaysNumerator * 100, 365)
      : 0;

  final finiquitoTotal =
      input.pendingSalaries + aguinaldo + vacationPay + vacationPremium;
  final total = finiquitoTotal + primaAntiguedad + severance;

  final steps = <CalcStep>[
    CalcStep(
      label: 'Salario diario',
      detail: 'Salario mensual entre 30.',
      amount: dailySalary,
    ),
    CalcStep(
      label: 'Salarios pendientes',
      detail: 'Dato capturado por ti.',
      amount: input.pendingSalaries,
    ),
    CalcStep(
      label: 'Aguinaldo proporcional',
      detail:
          'Del ${formatDate(aguinaldoStart)} al '
          '${formatDate(termination)}: $aguinaldoDaysWorked días de '
          '$daysInCalendarYear del año.',
      amount: aguinaldo,
    ),
    CalcStep(
      label: 'Vacaciones proporcionales',
      detail: hasPendingVacation
          ? '$entitledDays días del año de servicio en curso, '
                'proporcionales a $elapsedDays de $serviceYearDays días, '
                'menos ${input.takenVacationDays} días tomados.'
          : 'No hay días pendientes en el año de servicio en curso.',
      amount: vacationPay,
    ),
    CalcStep(
      label: 'Prima vacacional',
      detail:
          'Vacaciones × '
          '${formatBasisPoints(parameters.vacationPremiumBp)}.',
      amount: vacationPremium,
    ),
    CalcStep(
      label: 'Subtotal del finiquito',
      detail:
          'Prestaciones devengadas, sin prima de antigüedad '
          'ni indemnización.',
      amount: finiquitoTotal,
    ),
    CalcStep(
      label: 'Prima de antigüedad',
      detail: !primaApplies
          ? 'En renuncia solo aplica con 15 años o más de servicio.'
          : '${parameters.primaAntiguedadDays} días por año, con el salario '
                'topado a ${parameters.primaAntiguedadCap} salarios mínimos '
                '(${input.zone == WageZone.border ? 'frontera' : 'general'}).',
      amount: primaAntiguedad,
    ),
    if (severanceApplies)
      CalcStep(
        label: 'Indemnización',
        detail:
            '${parameters.severanceBaseDays ~/ 30} meses más '
            '${parameters.severanceDaysPerYear} días por año, '
            'con fracción proporcional.',
        amount: severance,
      ),
    CalcStep(
      label: 'Total',
      detail: 'Finiquito más liquidación.',
      amount: total,
    ),
  ];

  return CalcSuccess(
    FiniquitoResult(
      separationType: input.separationType,
      dailySalary: dailySalary,
      pendingSalaries: input.pendingSalaries,
      aguinaldo: aguinaldo,
      vacationPay: vacationPay,
      vacationPremium: vacationPremium,
      primaAntiguedad: primaAntiguedad,
      finiquitoTotal: finiquitoTotal,
      severance: severance,
      total: total,
      serviceDays: serviceDays,
      completedYears: yearsCompleted,
      aguinaldoDays: aguinaldoDaysWorked,
      vacationEntitledDays: entitledDays,
      vacationPendingDaysHundredths: vacationPendingHundredths,
      primaAntiguedadDaysHundredths: primaDaysHundredths,
      severanceDaysHundredths: severanceDaysHundredths,
      parametersId: parameters.id,
      steps: steps,
    ),
  );
}
