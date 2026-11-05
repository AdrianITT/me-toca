import 'parameters.dart';
import 'result.dart';
import 'tables/parameters_2026.dart';

/// Resolves the verified parameter set for a date of the event.
abstract final class ParameterRepository {
  static List<LegalParameters> get all => List.unmodifiable(_all);

  static CalcOutcome<LegalParameters> forDate(DateTime date) {
    for (final parameters in _all) {
      if (!parameters.isValidOn(date)) {
        continue;
      }
      if (!parameters.verified) {
        return const CalcFailure(
          CalcError(
            CalcErrorCode.unverifiedParameters,
            'Las tablas de esa fecha todavía no están verificadas.',
          ),
        );
      }
      return CalcSuccess(parameters);
    }
    return const CalcFailure(
      CalcError(
        CalcErrorCode.noParametersForDate,
        'Todavía no tenemos las tablas de ese año. Revisa la fecha.',
      ),
    );
  }

  static final List<LegalParameters> _all = [
    parameters2026January,
    parameters2026February,
  ];
}
