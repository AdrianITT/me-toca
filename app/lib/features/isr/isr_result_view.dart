import 'package:calc_engine/calc_engine.dart';

import '../../core/format/money_format.dart';
import '../../core/format/percent_format.dart';
import '../../core/legal/parameter_labels.dart';
import '../result/calc_result_view.dart';

CalcResultView isrResultView(IsrResult result, IsrInput input) {
  final period = input.period;
  final bracketRange = result.upper == null
      ? 'Desde ${formatMoney(result.lower)}.'
      : 'De ${formatMoney(result.lower)} a ${formatMoney(result.upper!)}.';

  final steps = <ResultStep>[
    for (final step in result.steps)
      if (step.label == 'Tasa efectiva')
        ResultStep(
          label: step.label,
          detail: step.detail,
          value: formatBasisPoints(result.effectiveRateBp),
        )
      else
        ResultStep.fromStep(step),
    ResultStep(
      label: 'Ingreso neto estimado',
      detail: 'Ingreso gravable menos el ISR a retener.',
      amount: result.netIncome,
    ),
  ];

  return CalcResultView(
    title: 'ISR',
    heroLabel: 'Te retienen',
    context: 'de ISR ${period.label}',
    amount: result.isrWithheld,
    parametersId: result.parametersId,
    sections: [
      ResultSection(
        label: 'Desglose',
        rows: [
          ResultRow(
            label: 'Tramo',
            value: 'Tramo ${result.bracketNumber}',
            hint: bracketRange,
          ),
          ResultRow(label: 'Ingreso gravable', amount: input.taxableIncome),
          ResultRow(label: 'Cuota fija', amount: result.fixed),
          ResultRow(label: 'Excedente', amount: result.excess),
          ResultRow(
            label: 'Tasa marginal',
            value: formatBasisPoints(result.rateBp),
          ),
          ResultRow(label: 'ISR causado', amount: result.isrCaused),
          ResultRow(
            label: 'Subsidio al empleo',
            amount: result.subsidy,
            hint: result.subsidy.isZero
                ? 'Sin subsidio para este ingreso.'
                : 'Se resta del ISR causado y no genera saldo a favor.',
          ),
          ResultRow(
            label: 'ISR a retener',
            amount: result.isrWithheld,
            emphasize: true,
          ),
          ResultRow(
            label: 'Tasa efectiva',
            value: formatBasisPoints(result.effectiveRateBp),
          ),
          ResultRow(label: 'Ingreso neto estimado', amount: result.netIncome),
        ],
      ),
    ],
    notes: const [
      'El subsidio no es reembolsable: solo reduce el ISR a cargo.',
      'Al cruzar el tope del subsidio, el apoyo desaparece por completo; por '
          'eso el ISR puede subir de golpe.',
    ],
    explanationTitle: 'Tu ISR, paso a paso',
    explanationIntro:
        'Ubicamos tu ingreso en la tarifa oficial del periodo, sumamos cuota '
        'fija y excedente, y restamos el subsidio si te corresponde.',
    steps: steps,
    sources: [
      const ResultSource(
        title: 'Artículo 96 LISR',
        body: 'Tarifa mensual, quincenal y semanal del Anexo 8 de la RMF 2026.',
      ),
      const ResultSource(
        title: 'Decreto de subsidio al empleo',
        body:
            'Monto único mensual de \$535.65, con tope de \$11,492.66 y '
            'equivalente proporcional por periodo.',
      ),
      ResultSource(
        title: 'Tablas usadas',
        body: parametersValidity(result.parametersId),
      ),
    ],
    exclusions: const [
      'No calcula ISR anual, RESICO, actividad empresarial ni plataformas '
          'digitales.',
      'No incluye otras retenciones, cuotas del IMSS ni aportaciones.',
      'No reemplaza el cálculo de tu patrón.',
    ],
    explanationPath: '/isr/explicacion',
  );
}
