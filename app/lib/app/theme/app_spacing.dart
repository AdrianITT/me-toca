import 'package:flutter/widgets.dart';

/// Spacing scale, base 4.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double giant = 56;

  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets card = EdgeInsets.all(xl);
  static const EdgeInsets field = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static const double minTouchTarget = 48;
}
