import 'package:flutter/material.dart';

/// Fraunces for display and result amounts; Manrope for everything else.
abstract final class AppTypography {
  static const String displayFamily = 'Fraunces';
  static const String uiFamily = 'Manrope';

  static List<FontVariation> _fraunces(double weight, double size) => [
    FontVariation('wght', weight),
    const FontVariation('SOFT', 100),
    const FontVariation('WONK', 0),
    FontVariation('opsz', size),
  ];

  static List<FontVariation> _manrope(double weight) => [
    FontVariation('wght', weight),
  ];

  static TextStyle _display({
    required double size,
    required double weight,
    double height = 1.1,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: displayFamily,
      fontSize: size,
      fontWeight: FontWeight.values[((weight / 100).round() - 1)],
      height: height,
      letterSpacing: letterSpacing,
      fontVariations: _fraunces(weight, size),
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle _ui({
    required double size,
    required double weight,
    double height = 1.45,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: uiFamily,
      fontSize: size,
      fontWeight: FontWeight.values[((weight / 100).round() - 1)],
      height: height,
      letterSpacing: letterSpacing,
      fontVariations: _manrope(weight),
    );
  }

  static final TextTheme textTheme = TextTheme(
    displayLarge: _display(size: 56, weight: 700, height: 1.02),
    displayMedium: _display(size: 44, weight: 700, height: 1.06),
    displaySmall: _display(size: 32, weight: 700, height: 1.12),
    headlineLarge: _display(size: 32, weight: 600, height: 1.15),
    headlineMedium: _display(size: 24, weight: 600, height: 1.2),
    headlineSmall: _display(size: 20, weight: 600, height: 1.25),
    titleLarge: _ui(size: 20, weight: 600, height: 1.3),
    titleMedium: _ui(size: 16, weight: 600, height: 1.35),
    titleSmall: _ui(size: 14, weight: 600, height: 1.35),
    bodyLarge: _ui(size: 16, weight: 400, height: 1.45),
    bodyMedium: _ui(size: 15, weight: 400, height: 1.45),
    bodySmall: _ui(size: 14, weight: 400, height: 1.4),
    labelLarge: _ui(size: 15, weight: 600, height: 1.2),
    labelMedium: _ui(size: 12, weight: 600, height: 1.2, letterSpacing: 0.6),
    labelSmall: _ui(size: 12, weight: 500, height: 1.2),
  );
}
