import '../format.dart';
import '../money.dart';
import '../result.dart';

enum IvaMode {
  add(label: 'agregar IVA'),
  breakdown(label: 'desglosar IVA');

  const IvaMode({required this.label});

  final String label;
}

/// IVA rates available in the MVP.
///
/// [border] exists in the model but is intentionally disabled: the 2026
/// border stimulus decree could not be verified.
enum IvaRate {
  general(label: '16%', rateBp: 1600),
  zero(label: '0%', rateBp: 0),
  border(label: '8% frontera', rateBp: 800),
  exempt(label: 'exento', rateBp: null);

  const IvaRate({required this.label, required this.rateBp});

  final String label;
  final int? rateBp;
}

class IvaInput {
  const IvaInput({
    required this.amount,
    this.mode = IvaMode.add,
    this.rate = IvaRate.general,
  });

  final Money amount;
  final IvaMode mode;
  final IvaRate rate;
}

class IvaResult {
  const IvaResult({
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.mode,
    required this.rate,
    required this.steps,
  });

  final Money subtotal;
  final Money tax;
  final Money total;
  final IvaMode mode;
  final IvaRate rate;
  final List<CalcStep> steps;
}

CalcOutcome<IvaResult> calculateIva(IvaInput input) {
  if (input.amount.isNegative) {
    return invalidInput('El monto no puede ser negativo.');
  }
  if (input.rate == IvaRate.border) {
    return const CalcFailure(
      CalcError(
        CalcErrorCode.unsupportedPeriod,
        'La tasa del 8% de la región fronteriza no está disponible.',
      ),
    );
  }

  final amount = input.amount;
  final rateBp = input.rate.rateBp;

  if (rateBp == null) {
    final steps = <CalcStep>[
      const CalcStep(
        label: 'Exento',
        detail:
            'La operación no causa IVA. No es lo mismo que una tasa 0%: '
            'el exento no se grava y no se puede acreditar.',
        amount: Money.zero,
      ),
      CalcStep(
        label: 'Total',
        detail: 'El monto se queda igual.',
        amount: amount,
      ),
    ];
    return CalcSuccess(
      IvaResult(
        subtotal: amount,
        tax: Money.zero,
        total: amount,
        mode: input.mode,
        rate: input.rate,
        steps: steps,
      ),
    );
  }

  switch (input.mode) {
    case IvaMode.add:
      final tax = amount.percentage(rateBp);
      final total = amount + tax;
      return CalcSuccess(
        IvaResult(
          subtotal: amount,
          tax: tax,
          total: total,
          mode: input.mode,
          rate: input.rate,
          steps: <CalcStep>[
            CalcStep(
              label: 'Subtotal',
              detail: 'Monto capturado.',
              amount: amount,
            ),
            CalcStep(
              label: 'IVA',
              detail:
                  'Subtotal × ${input.rate.label}.'
                  '${rateBp == 0 ? ' Es un acto gravado a tasa 0%.' : ''}',
              amount: tax,
            ),
            CalcStep(
              label: 'Total',
              detail: 'Subtotal más IVA.',
              amount: total,
            ),
          ],
        ),
      );
    case IvaMode.breakdown:
      final subtotal = Money(
        Money.divideHalfUp(amount.cents * 10000, 10000 + rateBp),
      );
      final tax = amount - subtotal;
      return CalcSuccess(
        IvaResult(
          subtotal: subtotal,
          tax: tax,
          total: amount,
          mode: input.mode,
          rate: input.rate,
          steps: <CalcStep>[
            CalcStep(
              label: 'Subtotal',
              detail:
                  'Monto total entre 1 más la tasa de '
                  '${formatBasisPoints(rateBp)}.',
              amount: subtotal,
            ),
            CalcStep(
              label: 'IVA',
              detail: 'Total menos el subtotal.',
              amount: tax,
            ),
            CalcStep(
              label: 'Total',
              detail: 'Monto capturado, IVA incluido.',
              amount: amount,
            ),
          ],
        ),
      );
  }
}
