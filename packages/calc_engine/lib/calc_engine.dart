/// Me Toca calculation engine.
///
/// Pure Dart: no Flutter, no network, no storage. Money is always in cents.
library;

export 'src/calculators/aguinaldo.dart';
export 'src/calculators/finiquito.dart';
export 'src/calculators/isr.dart';
export 'src/calculators/iva.dart';
export 'src/calculators/vacaciones.dart';
export 'src/dates.dart' show dateOnly, daysInclusive, daysInYear, isLeapYear;
export 'src/money.dart';
export 'src/parameter_repository.dart';
export 'src/parameters.dart';
export 'src/result.dart';
export 'src/tables/vacation_days.dart' show vacationDaysForCompletedYears;
