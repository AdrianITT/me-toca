import '../dates.dart';
import '../format.dart';
import '../money.dart';
import '../parameters.dart';
import '../result.dart';

class AguinaldoInput {
  const AguinaldoInput({
    required this.monthlySalary,
    required this.hireDate,
    required this.calculationDate,
    this.companyAguinaldoDays = 15,
  });

  final Money monthlySalary;
  final DateTime hireDate;

  /// Calculation or exit date. Days are counted up to this date.
  final DateTime calculationDate;

  /// Days granted by the company. Legal minimum is 15.
  final int companyAguinaldoDays;
}

class AguinaldoResult {
  const AguinaldoResult({
    required this.aguinaldo,
    required this.exempt,
    required this.taxable,
    required this.dailySalary,
    required this.daysWorked,
    required this.aguinaldoDays,
    required this.daysInPeriod,
    required this.periodStart,
    required this.periodEnd,
    required this.parametersId,
    required this.steps,
  });

  /// Proportional or full aguinaldo.
  final Money aguinaldo;

  /// Exempt part (30 UMA).
  final Money exempt;

  /// Taxable part.
  final Money taxable;

  final Money dailySalary;
  final int daysWorked;
  final int aguinaldoDays;
  final int daysInPeriod;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String parametersId;
  final List<CalcStep> steps;
}

CalcOutcome<AguinaldoResult> calculateAguinaldo(
  AguinaldoInput input,
  LegalParameters parameters,
) {
  if (!input.monthlySalary.isPositive) {
    return invalidInput('Escribe un salario mayor a cero.');
  }
  if (input.companyAguinaldoDays < parameters.aguinaldoMinDays) {
    return invalidInput(
      'El aguinaldo mínimo legal es de ${parameters.aguinaldoMinDays} días.',
    );
  }
  final hire = dateOnly(input.hireDate);
  final cut = dateOnly(input.calculationDate);
  if (cut.isBefore(hire)) {
    return invalidInput(
      'La fecha de cálculo no puede ser anterior a la de ingreso.',
    );
  }

  final year = cut.year;
  final periodStart = DateTime.utc(year, 1, 1);
  final periodEnd = DateTime.utc(year, 12, 31);
  final daysInPeriod = daysInYear(year);

  final workedFrom = hire.isAfter(periodStart) ? hire : periodStart;
  final daysWorked = daysInclusive(workedFrom, cut);

  final dailySalary = input.monthlySalary.mulDiv(1, 30);

  // Single rounding: monthly salary x days worked x days granted
  // divided by one month of 30 days and the days of the period.
  final aguinaldo = input.monthlySalary.mulDiv(
    daysWorked * input.companyAguinaldoDays,
    30 * daysInPeriod,
  );

  final exemptCap = parameters.uma.daily.times(30);
  final exempt = aguinaldo.min(exemptCap);
  final taxable = aguinaldo - exempt;

  final steps = <CalcStep>[
    CalcStep(
      label: 'Salario diario',
      detail: 'Salario mensual entre 30.',
      amount: dailySalary,
    ),
    CalcStep(
      label: 'Días trabajados',
      detail:
          'Del ${formatDate(workedFrom)} al ${formatDate(cut)}, '
          'contando ambos extremos.',
    ),
    CalcStep(
      label: 'Aguinaldo proporcional',
      detail:
          'Salario diario × $daysWorked días × '
          '${input.companyAguinaldoDays} días ÷ $daysInPeriod días del periodo.',
      amount: aguinaldo,
    ),
    CalcStep(
      label: 'Parte exenta',
      detail: 'La parte menor entre el aguinaldo y 30 UMA diarias.',
      amount: exempt,
    ),
    CalcStep(
      label: 'Parte gravada',
      detail: 'Aguinaldo menos la parte exenta.',
      amount: taxable,
    ),
  ];

  return CalcSuccess(
    AguinaldoResult(
      aguinaldo: aguinaldo,
      exempt: exempt,
      taxable: taxable,
      dailySalary: dailySalary,
      daysWorked: daysWorked,
      aguinaldoDays: input.companyAguinaldoDays,
      daysInPeriod: daysInPeriod,
      periodStart: periodStart,
      periodEnd: periodEnd,
      parametersId: parameters.id,
      steps: steps,
    ),
  );
}
