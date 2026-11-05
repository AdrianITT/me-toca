import '../dates.dart';
import '../format.dart';
import '../money.dart';
import '../parameters.dart';
import '../result.dart';
import '../tables/vacation_days.dart';

class VacacionesInput {
  const VacacionesInput({
    required this.hireDate,
    required this.cutoffDate,
    required this.monthlySalary,
    this.takenDays = 0,
  });

  final DateTime hireDate;
  final DateTime cutoffDate;
  final Money monthlySalary;
  final int takenDays;
}

class VacacionesResult {
  const VacacionesResult({
    required this.completedYears,
    required this.entitledDays,
    required this.takenDays,
    required this.pendingDays,
    required this.dailySalary,
    required this.vacationPay,
    required this.premium,
    required this.total,
    required this.parametersId,
    required this.steps,
  });

  final int completedYears;
  final int entitledDays;
  final int takenDays;
  final int pendingDays;
  final Money dailySalary;
  final Money vacationPay;
  final Money premium;
  final Money total;
  final String parametersId;
  final List<CalcStep> steps;
}

CalcOutcome<VacacionesResult> calculateVacaciones(
  VacacionesInput input,
  LegalParameters parameters,
) {
  if (!input.monthlySalary.isPositive) {
    return invalidInput('Escribe un salario mayor a cero.');
  }
  if (input.takenDays < 0) {
    return invalidInput('Los días tomados no pueden ser negativos.');
  }
  final hire = dateOnly(input.hireDate);
  final cutoff = dateOnly(input.cutoffDate);
  if (cutoff.isBefore(hire)) {
    return invalidInput(
      'La fecha de corte no puede ser anterior a la de ingreso.',
    );
  }

  final completed = completedYears(hire, cutoff);
  if (completed < 1) {
    return invalidInput(
      'Aún no cumples un año de antigüedad. '
      'Tus vacaciones proporcionales se calculan en el finiquito.',
    );
  }

  final entitledDays = vacationDaysForCompletedYears(completed);
  final pendingDays = (entitledDays - input.takenDays).clamp(0, entitledDays);

  final dailySalary = input.monthlySalary.mulDiv(1, 30);
  final vacationPay = input.monthlySalary.mulDiv(pendingDays, 30);
  final premium = vacationPay.percentage(parameters.vacationPremiumBp);
  final total = vacationPay + premium;

  final steps = <CalcStep>[
    CalcStep(
      label: 'Antigüedad',
      detail:
          'Del ${formatDate(hire)} al ${formatDate(cutoff)}: '
          '$completed ${completed == 1 ? 'año cumplido' : 'años cumplidos'}.',
    ),
    CalcStep(
      label: 'Días que te corresponden',
      detail: 'Tabla del artículo 76 de la Ley Federal del Trabajo.',
      amount: null,
    ),
    CalcStep(
      label: 'Días pendientes',
      detail:
          '$entitledDays días que corresponden menos '
          '${input.takenDays} días tomados.',
    ),
    CalcStep(
      label: 'Pago de vacaciones',
      detail: 'Salario diario × $pendingDays días.',
      amount: vacationPay,
    ),
    CalcStep(
      label: 'Prima vacacional',
      detail:
          'Pago de vacaciones × '
          '${formatBasisPoints(parameters.vacationPremiumBp)}.',
      amount: premium,
    ),
    CalcStep(
      label: 'Total',
      detail: 'Vacaciones más prima vacacional.',
      amount: total,
    ),
  ];

  return CalcSuccess(
    VacacionesResult(
      completedYears: completed,
      entitledDays: entitledDays,
      takenDays: input.takenDays,
      pendingDays: pendingDays,
      dailySalary: dailySalary,
      vacationPay: vacationPay,
      premium: premium,
      total: total,
      parametersId: parameters.id,
      steps: steps,
    ),
  );
}
