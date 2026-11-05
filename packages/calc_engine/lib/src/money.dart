/// Immutable money value stored in cents.
///
/// The engine never uses `double` for money. Every division rounds half-up
/// exactly once, at the moment a concept is closed.
class Money implements Comparable<Money> {
  const Money(this.cents);

  static const Money zero = Money(0);

  /// Amount in cents. May be negative only for intermediate results.
  final int cents;

  bool get isZero => cents == 0;

  bool get isPositive => cents > 0;

  bool get isNegative => cents < 0;

  Money operator +(Money other) => Money(cents + other.cents);

  Money operator -(Money other) => Money(cents - other.cents);

  Money operator -() => Money(-cents);

  Money times(int factor) => Money(cents * factor);

  bool operator <(Money other) => cents < other.cents;

  bool operator <=(Money other) => cents <= other.cents;

  bool operator >(Money other) => cents > other.cents;

  bool operator >=(Money other) => cents >= other.cents;

  /// Multiplies by `numerator / denominator` with a single half-up rounding.
  Money mulDiv(int numerator, int denominator) =>
      Money(divideHalfUp(cents * numerator, denominator));

  /// Applies a rate expressed in basis points (16% = 1600).
  Money percentage(int basisPoints) => mulDiv(basisPoints, 10000);

  Money min(Money other) => cents <= other.cents ? this : other;

  Money max(Money other) => cents >= other.cents ? this : other;

  /// Rounds `numerator / denominator` half-up, away from zero.
  ///
  /// Use this when a concept combines several terms before the only rounding.
  static int divideHalfUp(int numerator, int denominator) {
    if (denominator <= 0) {
      throw ArgumentError.value(denominator, 'denominator', 'must be > 0');
    }
    final sign = numerator.isNegative ? -1 : 1;
    final absolute = numerator.abs();
    return sign * ((2 * absolute + denominator) ~/ (2 * denominator));
  }

  @override
  int compareTo(Money other) => cents.compareTo(other.cents);

  @override
  bool operator ==(Object other) => other is Money && other.cents == cents;

  @override
  int get hashCode => cents.hashCode;

  @override
  String toString() => 'Money($cents)';
}
