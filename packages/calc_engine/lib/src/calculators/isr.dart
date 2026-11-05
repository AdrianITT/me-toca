import '../format.dart';
import '../money.dart';
import '../parameters.dart';
import '../result.dart';

class IsrInput {
  const IsrInput({
    required this.taxableIncome,
    this.period = PayPeriod.monthly,
  });

  final Money taxableIncome;
  final PayPeriod period;
}

class IsrResult {
  const IsrResult({
    required this.bracketNumber,
    required this.lower,
    required this.upper,
    required this.fixed,
    required this.rateBp,
    required this.excess,
    required this.isrCaused,
    required this.subsidy,
    required this.isrWithheld,
    required this.effectiveRateBp,
    required this.netIncome,
    required this.parametersId,
    required this.steps,
  });

  final int bracketNumber;
  final Money lower;
  final Money? upper;
  final Money fixed;
  final int rateBp;
  final Money excess;
  final Money isrCaused;
  final Money subsidy;
  final Money isrWithheld;
  final int effectiveRateBp;
  final Money netIncome;
  final String parametersId;
  final List<CalcStep> steps;
}

CalcOutcome<IsrResult> calculateIsr(
  IsrInput input,
  LegalParameters parameters,
) {
  final income = input.taxableIncome;
  if (income.isNegative) {
    return invalidInput('El ingreso no puede ser negativo.');
  }

  final table = parameters.isrTableFor(input.period);

  if (income.isZero) {
    return CalcSuccess(
      IsrResult(
        bracketNumber: 1,
        lower: Money.zero,
        upper: table.first.upper,
        fixed: Money.zero,
        rateBp: table.first.rateBp,
        excess: Money.zero,
        isrCaused: Money.zero,
        subsidy: Money.zero,
        isrWithheld: Money.zero,
        effectiveRateBp: 0,
        netIncome: Money.zero,
        parametersId: parameters.id,
        steps: const [
          CalcStep(
            label: 'ISR a retener',
            detail: 'No hay ingreso gravable en el periodo.',
            amount: Money.zero,
          ),
        ],
      ),
    );
  }

  final index = table.indexWhere((bracket) => bracket.contains(income));
  if (index < 0) {
    return const CalcFailure(
      CalcError(
        CalcErrorCode.unsupportedPeriod,
        'No encontramos un tramo de ISR para ese ingreso.',
      ),
    );
  }
  final bracket = table[index];
  final excess = income - bracket.lower;

  // One rounding for the whole concept: fixed quota plus excess at the rate.
  final isrCaused = Money(
    Money.divideHalfUp(
      bracket.fixed.cents * 10000 + excess.cents * bracket.rateBp,
      10000,
    ),
  );

  // The income cap prorates with the same 30.4-day base as the subsidy.
  final cap = input.period.isMonthly
      ? parameters.subsidyIncomeCap
      : parameters.subsidyIncomeCap.mulDiv(input.period.prorationTenths, 304);
  final subsidy = income <= cap
      ? (input.period.isMonthly
            ? parameters.subsidyMonthly
            : parameters.subsidyMonthly.mulDiv(
                input.period.prorationTenths,
                304,
              ))
      : Money.zero;

  final isrWithheld = (isrCaused - subsidy).max(Money.zero);
  final effectiveRateBp = Money.divideHalfUp(
    isrWithheld.cents * 10000,
    income.cents,
  );
  final netIncome = income - isrWithheld;

  final steps = <CalcStep>[
    CalcStep(
      label: 'Tramo',
      detail:
          'Tramo ${index + 1} de la tarifa '
          '${input.period.label} de 2026.',
    ),
    CalcStep(
      label: 'Cuota fija',
      detail: 'Cuota fija del tramo.',
      amount: bracket.fixed,
    ),
    CalcStep(
      label: 'Excedente',
      detail: 'Ingreso gravable menos el límite inferior del tramo.',
      amount: excess,
    ),
    CalcStep(
      label: 'ISR causado',
      detail:
          'Cuota fija más el excedente por la tasa de '
          '${formatBasisPoints(bracket.rateBp)}.',
      amount: isrCaused,
    ),
    CalcStep(
      label: 'Subsidio al empleo',
      detail: subsidy.isZero
          ? (income <= cap
                ? 'El subsidio no alcanza a cubrir el ISR causado.'
                : 'Sin subsidio: el ingreso supera el tope del periodo. '
                      'El subsidio desaparece por completo.')
          : 'Se resta del ISR causado. No genera saldo a favor.',
      amount: subsidy,
    ),
    CalcStep(
      label: 'ISR a retener',
      detail: 'ISR causado menos el subsidio, nunca menor a cero.',
      amount: isrWithheld,
    ),
    CalcStep(
      label: 'Tasa efectiva',
      detail: 'ISR a retener entre el ingreso gravable.',
      amount: null,
    ),
  ];

  return CalcSuccess(
    IsrResult(
      bracketNumber: index + 1,
      lower: bracket.lower,
      upper: bracket.upper,
      fixed: bracket.fixed,
      rateBp: bracket.rateBp,
      excess: excess,
      isrCaused: isrCaused,
      subsidy: subsidy,
      isrWithheld: isrWithheld,
      effectiveRateBp: effectiveRateBp,
      netIncome: netIncome,
      parametersId: parameters.id,
      steps: steps,
    ),
  );
}
