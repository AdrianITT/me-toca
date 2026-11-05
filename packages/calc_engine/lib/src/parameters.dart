import 'dates.dart';
import 'money.dart';

/// Salary zone used to cap the seniority premium.
enum WageZone { general, border }

class Uma {
  const Uma({required this.daily, required this.monthly, required this.annual});

  final Money daily;
  final Money monthly;
  final Money annual;
}

class MinimumWage {
  const MinimumWage({required this.general, required this.border});

  final Money general;
  final Money border;

  Money forZone(WageZone zone) => zone == WageZone.border ? border : general;
}

class IsrBracket {
  const IsrBracket({
    required this.lower,
    this.upper,
    required this.fixed,
    required this.rateBp,
  });

  /// Lower limit, inclusive.
  final Money lower;

  /// Upper limit, inclusive. Null on the last bracket.
  final Money? upper;

  /// Fixed quota.
  final Money fixed;

  /// Marginal rate in basis points (10.88% = 1088).
  final int rateBp;

  bool contains(Money income) {
    if (income < lower) {
      return false;
    }
    final limit = upper;
    return limit == null || income <= limit;
  }
}

/// Pay period for ISR. Each period has its own official table.
enum PayPeriod {
  monthly(label: 'mensual', prorationTenths: 304),
  fifteenDay(label: 'quincenal', prorationTenths: 150),
  weekly(label: 'semanal', prorationTenths: 70);

  const PayPeriod({required this.label, required this.prorationTenths});

  final String label;

  /// Tenths of a day used to prorate monthly amounts.
  ///
  /// 30.4 days = 304 tenths, 15 days = 150 tenths, 7 days = 70 tenths.
  final int prorationTenths;

  bool get isMonthly => this == PayPeriod.monthly;
}

/// Verified legal parameters for a validity window.
///
/// Parameters are selected by the date of the event, never by calendar year.
class LegalParameters {
  const LegalParameters({
    required this.id,
    required this.validFrom,
    required this.validTo,
    required this.uma,
    required this.minimumWage,
    required this.isrMonthly,
    required this.isrFifteenDay,
    required this.isrSevenDay,
    required this.subsidyMonthly,
    required this.subsidyIncomeCap,
    required this.aguinaldoMinDays,
    required this.borderStimulusActive,
    required this.vacationPremiumBp,
    required this.primaAntiguedadDays,
    required this.primaAntiguedadCap,
    required this.severanceBaseDays,
    required this.severanceDaysPerYear,
    required this.source,
    required this.verified,
  });

  final String id;
  final DateTime validFrom;
  final DateTime validTo;
  final Uma uma;
  final MinimumWage minimumWage;
  final List<IsrBracket> isrMonthly;
  final List<IsrBracket> isrFifteenDay;
  final List<IsrBracket> isrSevenDay;
  final Money subsidyMonthly;
  final Money subsidyIncomeCap;
  final int aguinaldoMinDays;
  final bool borderStimulusActive;
  final int vacationPremiumBp;
  final int primaAntiguedadDays;
  final int primaAntiguedadCap;

  /// Base severance: three months expressed in days (Art. 48 LFT).
  final int severanceBaseDays;

  /// Additional severance days per year of service (Art. 50 LFT).
  final int severanceDaysPerYear;

  final String source;
  final bool verified;

  List<IsrBracket> isrTableFor(PayPeriod period) => switch (period) {
    PayPeriod.monthly => isrMonthly,
    PayPeriod.fifteenDay => isrFifteenDay,
    PayPeriod.weekly => isrSevenDay,
  };

  bool isValidOn(DateTime date) {
    final day = dateOnly(date);
    return !day.isBefore(dateOnly(validFrom)) &&
        !day.isAfter(dateOnly(validTo));
  }
}
