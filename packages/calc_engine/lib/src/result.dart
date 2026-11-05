import 'money.dart';

/// Human readable error codes from the engine contract.
enum CalcErrorCode {
  invalidInput,
  noParametersForDate,
  unverifiedParameters,
  unsupportedPeriod,
}

class CalcError {
  const CalcError(this.code, this.message);

  final CalcErrorCode code;
  final String message;

  @override
  String toString() => 'CalcError(${code.name}): $message';
}

/// One explained step of a calculation.
///
/// [amount] is null when the step is not a monetary value (days, dates,
/// ratios). The UI decides how to format it.
class CalcStep {
  const CalcStep({required this.label, required this.detail, this.amount});

  final String label;
  final String detail;
  final Money? amount;
}

sealed class CalcOutcome<T> {
  const CalcOutcome();

  bool get isSuccess => this is CalcSuccess<T>;

  bool get isFailure => this is CalcFailure<T>;

  T? get valueOrNull =>
      this is CalcSuccess<T> ? (this as CalcSuccess<T>).value : null;

  CalcError? get errorOrNull =>
      this is CalcFailure<T> ? (this as CalcFailure<T>).error : null;
}

final class CalcSuccess<T> extends CalcOutcome<T> {
  const CalcSuccess(this.value);

  final T value;
}

final class CalcFailure<T> extends CalcOutcome<T> {
  const CalcFailure(this.error);

  final CalcError error;
}

CalcFailure<T> invalidInput<T>(String message) =>
    CalcFailure<T>(CalcError(CalcErrorCode.invalidInput, message));
