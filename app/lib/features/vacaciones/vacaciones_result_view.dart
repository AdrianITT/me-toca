import 'package:calc_engine/calc_engine.dart';

import '../../core/legal/parameter_labels.dart';
import '../result/calc_result_view.dart';

CalcResultView vacacionesResultView(VacacionesResult result) {
  return CalcResultView(
    title: 'Vacaciones',
    context: 'de vacaciones',
    amount: result.total,
    parametersId: result.parametersId,
    sections: [
      ResultSection(
        label: 'Desglose',
        rows: [
          ResultRow(label: 'Salario diario', amount: result.dailySalary),
          ResultRow(
            label: 'Días que te corresponden',
            value: '${result.entitledDays} días',
            hint:
                'Por ${result.completedYears} '
                '${result.completedYears == 1 ? 'año cumplido' : 'años cumplidos'}.',
          ),
          ResultRow(label: 'Días tomados', value: '${result.takenDays} días'),
          ResultRow(
            label: 'Días pendientes',
            value: '${result.pendingDays} días',
          ),
          ResultRow(label: 'Pago de vacaciones', amount: result.vacationPay),
          ResultRow(label: 'Prima vacacional', amount: result.premium),
          ResultRow(label: 'Total', amount: result.total, emphasize: true),
        ],
      ),
      ResultSection(
        label: 'Próximos años',
        rows: [
          for (var extra = 1; extra <= 3; extra++)
            ResultRow(
              label: '${result.completedYears + extra} años',
              value:
                  '${vacationDaysForCompletedYears(result.completedYears + extra)} días',
            ),
        ],
      ),
    ],
    notes: const [
      'Solo se pagan los días pendientes. Los días que ya tomaste no se '
          'vuelven a pagar.',
    ],
    explanationTitle: 'Tus vacaciones, paso a paso',
    explanationIntro:
        'Revisamos los días que te corresponden por tu antigüedad, restamos '
        'los que ya tomaste y calculamos el pago con su prima.',
    steps: mapSteps(result.steps),
    sources: [
      const ResultSource(
        title: 'Artículo 76 LFT',
        body:
            'Días de vacaciones por antigüedad: 12 al primer año, 14 al '
            'segundo y 16 al tercero, hasta 32 días.',
      ),
      const ResultSource(
        title: 'Artículo 80 LFT',
        body: 'Prima vacacional mínima del 25% sobre el pago de vacaciones.',
      ),
      ResultSource(
        title: 'Tablas usadas',
        body: parametersValidity(result.parametersId),
      ),
    ],
    exclusions: const [
      'No calcula vacaciones proporcionales si aún no cumples un año; eso se '
          'resuelve en el finiquito.',
      'No incluye días de tu contrato que no estén en la ley.',
      'No reemplaza el recibo ni el cálculo de tu patrón.',
    ],
    explanationPath: '/vacaciones/explicacion',
  );
}
