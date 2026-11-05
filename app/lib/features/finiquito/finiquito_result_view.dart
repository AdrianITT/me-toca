import 'package:calc_engine/calc_engine.dart';

import '../../core/format/days_format.dart';
import '../../core/legal/parameter_labels.dart';
import '../result/calc_result_view.dart';

CalcResultView finiquitoResultView(
  FiniquitoResult result,
  FiniquitoInput input,
) {
  final hasSeverance = result.severance.isPositive;
  final mightPayPrima =
      result.separationType != SeparationType.resignation ||
      result.completedYears >= 15;

  return CalcResultView(
    title: 'Finiquito',
    context: hasSeverance ? 'de finiquito y liquidación' : 'de finiquito',
    amount: result.total,
    parametersId: result.parametersId,
    sections: [
      ResultSection(
        label: 'Desglose',
        rows: [
          ResultRow(label: 'Salario diario', amount: result.dailySalary),
          ResultRow(
            label: 'Salarios pendientes',
            amount: result.pendingSalaries,
          ),
          ResultRow(label: 'Aguinaldo proporcional', amount: result.aguinaldo),
          ResultRow(
            label: 'Vacaciones proporcionales',
            amount: result.vacationPay,
            hint:
                '${result.vacationEntitledDays} días del año de servicio, '
                'menos ${input.takenVacationDays} tomados.',
          ),
          ResultRow(label: 'Prima vacacional', amount: result.vacationPremium),
          ResultRow(
            label: 'Subtotal del finiquito',
            amount: result.finiquitoTotal,
            emphasize: true,
          ),
        ],
      ),
      ResultSection(
        label: hasSeverance ? 'Antigüedad y liquidación' : 'Antigüedad',
        rows: [
          ResultRow(
            label: 'Prima de antigüedad',
            amount: result.primaAntiguedad,
            hint: mightPayPrima
                ? '${formatDayHundredths(result.primaAntiguedadDaysHundredths)} '
                      'días por año, con el salario topado a 2 salarios mínimos.'
                : 'En renuncia solo aplica con 15 años o más de servicio.',
          ),
          if (hasSeverance)
            ResultRow(
              label: 'Indemnización',
              amount: result.severance,
              hint:
                  '${formatDayHundredths(result.severanceDaysHundredths)} días: '
                  '3 meses más 20 días por año.',
            ),
          ResultRow(label: 'Total', amount: result.total, emphasize: true),
        ],
      ),
    ],
    notes: const [
      'El finiquito son tus prestaciones devengadas; la liquidación es la '
          'indemnización. Se muestran por separado.',
      'Montos brutos: esta versión no calcula ISR sobre el finiquito ni sobre '
          'la indemnización.',
    ],
    explanationTitle: 'Tu finiquito, paso a paso',
    explanationIntro:
        'Sumamos tus prestaciones devengadas. Si tu tipo de salida genera '
        'prima de antigüedad o indemnización, las mostramos por separado.',
    steps: mapSteps(result.steps),
    sources: [
      const ResultSource(
        title: 'Artículos 76 y 80 LFT',
        body: 'Días de vacaciones por antigüedad y prima vacacional del 25%.',
      ),
      const ResultSource(
        title: 'Artículo 87 LFT',
        body: '15 días de aguinaldo por año, como mínimo.',
      ),
      const ResultSource(
        title: 'Artículo 162 LFT',
        body:
            'Prima de antigüedad de 12 días por año, con el salario topado a '
            '2 salarios mínimos. En renuncia se paga desde los 15 años.',
      ),
      const ResultSource(
        title: 'Artículos 48 y 50 LFT',
        body:
            'Indemnización de 3 meses más 20 días por año, solo en despido '
            'injustificado.',
      ),
      ResultSource(
        title: 'Tablas usadas',
        body: parametersValidity(result.parametersId),
      ),
    ],
    exclusions: const [
      'No calcula ISR sobre el finiquito ni sobre la indemnización.',
      'No incluye prestaciones de tu contrato que no estén en la ley.',
      'No reemplaza el recibo ni el cálculo de tu patrón.',
    ],
    explanationPath: '/finiquito/explicacion',
  );
}
