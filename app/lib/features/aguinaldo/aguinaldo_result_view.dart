import 'package:calc_engine/calc_engine.dart';

import '../../core/legal/parameter_labels.dart';
import '../result/calc_result_view.dart';

CalcResultView aguinaldoResultView(AguinaldoResult result) {
  return CalcResultView(
    title: 'Aguinaldo',
    context: 'de aguinaldo',
    amount: result.aguinaldo,
    parametersId: result.parametersId,
    sections: [
      ResultSection(
        label: 'Desglose',
        rows: [
          ResultRow(label: 'Salario diario', amount: result.dailySalary),
          ResultRow(
            label: 'Días trabajados',
            value: '${result.daysWorked} días',
          ),
          ResultRow(label: 'Aguinaldo proporcional', amount: result.aguinaldo),
          ResultRow(label: 'Parte exenta', amount: result.exempt),
          ResultRow(label: 'Parte gravada', amount: result.taxable),
        ],
      ),
    ],
    explanationTitle: 'Tu aguinaldo, paso a paso',
    explanationIntro:
        'Multiplicamos tu salario diario por los días que trabajaste y por '
        'los días de aguinaldo, y dividimos entre los días del periodo.',
    steps: mapSteps(result.steps),
    sources: [
      const ResultSource(
        title: 'Artículo 87 LFT',
        body: '15 días de aguinaldo por año, como mínimo.',
      ),
      const ResultSource(
        title: 'Artículo 93 LISR',
        body: 'Las primeras 30 UMA diarias del aguinaldo están exentas de ISR.',
      ),
      ResultSource(
        title: 'Tablas usadas',
        body: parametersValidity(result.parametersId),
      ),
    ],
    exclusions: const [
      'No calcula el ISR final sobre la parte gravada.',
      'No incluye prestaciones de tu contrato que no estén en la ley.',
      'No reemplaza el recibo ni el cálculo de tu patrón.',
    ],
    explanationPath: '/aguinaldo/explicacion',
  );
}
