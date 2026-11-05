/// Visible validity label for a parameter set.
String parametersValidity(String parametersId) => switch (parametersId) {
  '2026-01' => 'Tablas vigentes del 1 al 31 de enero de 2026.',
  '2026-02' => 'Tablas vigentes desde el 1 de febrero de 2026.',
  _ => 'Tablas de $parametersId.',
};

String parametersShortLabel(String parametersId) => switch (parametersId) {
  '2026-01' => 'enero 2026',
  '2026-02' => 'febrero 2026',
  _ => parametersId,
};
