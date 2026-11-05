import 'package:calc_engine/calc_engine.dart';

final LegalParameters parameters2026 = ParameterRepository.forDate(
  DateTime.utc(2026, 6, 1),
).valueOrNull!;

final LegalParameters parametersJanuary2026 = ParameterRepository.forDate(
  DateTime.utc(2026, 1, 15),
).valueOrNull!;

/// Unwraps a successful outcome or fails the test with the engine message.
T value<T>(CalcOutcome<T> outcome) {
  if (outcome.isFailure) {
    throw StateError(outcome.errorOrNull!.message);
  }
  return outcome.valueOrNull as T;
}
