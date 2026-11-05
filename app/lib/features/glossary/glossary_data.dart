/// One glossary term: a one-sentence definition and an example.
class GlossaryTerm {
  const GlossaryTerm({
    required this.term,
    required this.definition,
    required this.example,
  });

  final String term;
  final String definition;
  final String example;
}

/// Searchable terms in alphabetical order.
///
/// Definitions are plain language; the example ties each term to a real
/// calculation the app performs.
const List<GlossaryTerm> glossaryTerms = [
  GlossaryTerm(
    term: 'UMA',
    definition:
        'Unidad de Medida y Actualización: el valor oficial con el que se '
        'expresan multas, topes y exenciones.',
    example:
        'Las primeras 30 UMA diarias de tu aguinaldo están exentas de ISR.',
  ),
  GlossaryTerm(
    term: 'Salario diario',
    definition:
        'Lo que ganas por día: tu salario mensual dividido entre 30 días.',
    example: 'Con \$15,000.00 al mes, tu salario diario es de \$500.00.',
  ),
  GlossaryTerm(
    term: 'SDI',
    definition:
        'Salario Diario Integrado: tu salario diario más la parte proporcional '
        'de tus prestaciones, como aguinaldo y vacaciones.',
    example: 'Se usa para calcular indemnizaciones y cuotas del Seguro Social.',
  ),
  GlossaryTerm(
    term: 'Prima vacacional',
    definition:
        'Un pago extra sobre tus vacaciones: mínimo 25% del pago de tus días '
        'pendientes.',
    example: 'Si tus vacaciones pagan \$6,000.00, la prima suma \$1,500.00.',
  ),
  GlossaryTerm(
    term: 'Prima de antigüedad',
    definition:
        'Un pago por cada año que trabajaste: 12 días de salario por año.',
    example:
        'Con 3 años, te tocan 36 días, con tu salario topado a 2 salarios '
        'mínimos.',
  ),
  GlossaryTerm(
    term: 'Gravado',
    definition: 'La parte de un pago sobre la que sí se calcula ISR.',
    example: 'La parte gravada de tu aguinaldo paga impuestos.',
  ),
  GlossaryTerm(
    term: 'Exento',
    definition: 'La parte de un pago que no paga ISR.',
    example: 'Hasta 30 UMA diarias, tu aguinaldo está exento.',
  ),
  GlossaryTerm(
    term: 'Tasa marginal',
    definition:
        'El porcentaje que se aplica solo a la parte de tu ingreso que pasa '
        'cierto límite.',
    example:
        'En el tramo de 10.88%, solo el excedente paga esa tasa, no todo tu '
        'ingreso.',
  ),
  GlossaryTerm(
    term: 'Tasa efectiva',
    definition:
        'El porcentaje total que pagas de ISR sobre todo tu ingreso del '
        'periodo.',
    example:
        'Si te retienen \$300.00 de \$10,000.00, tu tasa efectiva es de 3%.',
  ),
  GlossaryTerm(
    term: 'Finiquito',
    definition:
        'Lo que tu patrón te paga al terminar la relación laboral: salarios, '
        'aguinaldo, vacaciones y prima.',
    example: 'Tu finiquito de \$16,697.26 incluye todo lo que te debían.',
  ),
  GlossaryTerm(
    term: 'Liquidación',
    definition:
        'La indemnización que se paga en despido injustificado: 3 meses más '
        '20 días por año.',
    example: 'Con 2 años, tu liquidación sería de 130 días de salario.',
  ),
  GlossaryTerm(
    term: 'Ingreso gravable',
    definition:
        'El ingreso sobre el que se calcula el ISR, antes de impuestos. '
        'Es el sueldo bruto más otras percepciones gravables.',
    example:
        'Si tu recibo dice "ingreso gravable: \$15,000.00", ese es el monto '
        'que capturas en la calculadora de ISR.',
  ),
  GlossaryTerm(
    term: 'ISR',
    definition:
        'Impuesto sobre la renta: el impuesto que se retiene de tu ingreso '
        'gravable.',
    example: 'De \$15,000.00 mensuales, te retienen \$1,402.82 de ISR.',
  ),
  GlossaryTerm(
    term: 'IVA',
    definition:
        'Impuesto al valor agregado: el 16% que se suma o se resta al precio '
        'de un bien o servicio.',
    example: '\$1,000.00 más 16% de IVA son \$1,160.00.',
  ),
];

List<GlossaryTerm> searchGlossary(String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) {
    return glossaryTerms;
  }
  return glossaryTerms
      .where(
        (term) =>
            term.term.toLowerCase().contains(normalized) ||
            term.definition.toLowerCase().contains(normalized) ||
            term.example.toLowerCase().contains(normalized),
      )
      .toList(growable: false);
}
