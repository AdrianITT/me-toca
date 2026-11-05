import 'package:calc_engine/calc_engine.dart';

/// Calculator-agnostic result shown by [ResultScreen] and
/// [ExplanationScreen].
///
/// Each calculator maps its engine result into this view so the presentation
/// layer stays the same for all five calculators.
class CalcResultView {
  const CalcResultView({
    required this.title,
    required this.context,
    required this.amount,
    required this.parametersId,
    required this.sections,
    required this.explanationTitle,
    required this.explanationIntro,
    required this.steps,
    required this.sources,
    required this.exclusions,
    required this.explanationPath,
    this.notes = const [],
    this.heroLabel = 'Te tocan',
  });

  /// App bar title, for example `Aguinaldo`.
  final String title;

  /// Hero subline, for example `de aguinaldo`.
  final String context;

  /// Hero label, for example `Te tocan` or `Te retienen`.
  final String heroLabel;

  final Money amount;

  /// Validity id of the parameter set, or null when the calculator does not
  /// depend on yearly tables (IVA).
  final String? parametersId;
  final List<ResultSection> sections;

  final String explanationTitle;
  final String explanationIntro;
  final List<ResultStep> steps;

  /// Legal basis shown in the explanation screen.
  final List<ResultSource> sources;

  /// What the calculation does not include.
  final List<String> exclusions;

  /// Extra notices shown on the result screen, above the explanation button.
  final List<String> notes;

  final String explanationPath;
}

class ResultSection {
  const ResultSection({this.label, required this.rows});

  final String? label;
  final List<ResultRow> rows;
}

class ResultRow {
  const ResultRow({
    required this.label,
    this.amount,
    this.value,
    this.hint,
    this.emphasize = false,
  }) : assert(
         amount != null || value != null || hint != null,
         'amount, value or hint required',
       );

  final String label;
  final Money? amount;
  final String? value;
  final String? hint;
  final bool emphasize;
}

/// One explained step with either a money amount or a text value.
class ResultStep {
  const ResultStep({
    required this.label,
    required this.detail,
    this.amount,
    this.value,
  });

  factory ResultStep.fromStep(CalcStep step) =>
      ResultStep(label: step.label, detail: step.detail, amount: step.amount);

  final String label;
  final String detail;
  final Money? amount;
  final String? value;
}

class ResultSource {
  const ResultSource({required this.title, required this.body});

  final String title;
  final String body;
}

List<ResultStep> mapSteps(Iterable<CalcStep> steps) =>
    steps.map(ResultStep.fromStep).toList(growable: false);
