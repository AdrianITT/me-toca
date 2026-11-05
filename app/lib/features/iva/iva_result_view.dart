import 'package:calc_engine/calc_engine.dart';

import '../result/calc_result_view.dart';

CalcResultView ivaResultView(IvaResult result) {
  final isBreakdown = result.mode == IvaMode.breakdown;
  final rateHint = switch (result.rate) {
    IvaRate.general => 'Tasa general del 16%.',
    IvaRate.zero => 'Tasa 0%: acto gravado sin IVA.',
    IvaRate.exempt => 'Exento: la operación no causa IVA.',
    IvaRate.border => 'Tasa no disponible.',
  };

  return CalcResultView(
    title: 'IVA',
    heroLabel: 'Total',
    context: isBreakdown ? 'subtotal sin IVA' : 'total con IVA',
    amount: isBreakdown ? result.subtotal : result.total,
    parametersId: null,
    sections: [
      ResultSection(
        label: 'Desglose',
        rows: [
          ResultRow(label: 'Subtotal', amount: result.subtotal),
          ResultRow(label: 'IVA', amount: result.tax, hint: rateHint),
          ResultRow(label: 'Total', amount: result.total, emphasize: true),
        ],
      ),
    ],
    notes: switch (result.rate) {
      IvaRate.zero => const [
        'La tasa 0% es un acto gravado: no se cobra IVA, pero la operación '
            'se declara.',
      ],
      IvaRate.exempt => const [
        'Exento significa que la operación no causa IVA. No es lo mismo que '
            'la tasa 0%.',
      ],
      _ => const [],
    },
    explanationTitle: 'Tu IVA, paso a paso',
    explanationIntro: isBreakdown
        ? 'Quitamos el IVA incluido: dividimos el total entre 1 más la tasa.'
        : 'Multiplicamos el monto por la tasa y sumamos el IVA al subtotal.',
    steps: mapSteps(result.steps),
    sources: const [
      ResultSource(
        title: 'Artículo 2 LIVA',
        body:
            'Tasa general del 16% para la mayoría de los actos o actividades.',
      ),
      ResultSource(
        title: 'Artículo 9 LIVA',
        body: 'Los supuestos exentos no causan IVA. No es lo mismo que 0%.',
      ),
      ResultSource(
        title: 'Tasa 0%',
        body:
            'Es un acto gravado con tasa cero: no se traslada IVA, pero se '
            'declara.',
      ),
    ],
    exclusions: const [
      'No calcula retenciones de IVA.',
      'No incluye la tasa del 8% de la región fronteriza: no está verificada '
          'para 2026.',
      'No reemplaza la factura ni el cálculo de tu contador.',
    ],
    explanationPath: '/iva/explicacion',
  );
}
