import 'package:flutter/material.dart';

/// Raw palette values. Every color in the app must come from here or from
/// [AppPalette].
abstract final class AppColors {
  // Light
  static const lightCanvas = Color(0xFFFBF7F0);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceAlt = Color(0xFFF4EEE3);
  static const lightInk = Color(0xFF1E2A24);
  static const lightInkMuted = Color(0xFF5C6B62);
  static const lightPrimary = Color(0xFF2F6B4F);
  static const lightPrimarySoft = Color(0xFFDCEBE2);
  static const lightAccent = Color(0xFFAE552C);
  static const lightAccentSoft = Color(0xFFF2D9C8);
  static const lightBorder = Color(0xFFE8E0D3);
  static const lightSuccess = Color(0xFF2F7D5B);
  static const lightWarning = Color(0xFFB87333);
  static const lightError = Color(0xFFC2453F);

  // Dark
  static const darkCanvas = Color(0xFF121614);
  static const darkSurface = Color(0xFF1A211D);
  static const darkSurfaceAlt = Color(0xFF232C27);
  static const darkInk = Color(0xFFF3EEE5);
  static const darkInkMuted = Color(0xFFA9B5AD);
  static const darkPrimary = Color(0xFF7FC8A3);
  static const darkPrimarySoft = Color(0xFF25382F);
  static const darkAccent = Color(0xFFF2A87E);
  static const darkAccentSoft = Color(0xFF3A2A21);
  static const darkBorder = Color(0xFF2E3833);
  static const darkSuccess = Color(0xFF8FD3AF);
  static const darkWarning = Color(0xFFE0A66B);
  static const darkError = Color(0xFFF08A84);
}

/// App-specific color tokens exposed through [ThemeData.extensions].
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.canvas,
    required this.surface,
    required this.surfaceAlt,
    required this.ink,
    required this.inkMuted,
    required this.primary,
    required this.primarySoft,
    required this.accent,
    required this.accentSoft,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
    required this.onPrimary,
    required this.shadow,
  });

  final Color canvas;
  final Color surface;
  final Color surfaceAlt;
  final Color ink;
  final Color inkMuted;
  final Color primary;
  final Color primarySoft;
  final Color accent;
  final Color accentSoft;
  final Color border;
  final Color success;
  final Color warning;
  final Color error;
  final Color onPrimary;
  final Color shadow;

  static const light = AppPalette(
    canvas: AppColors.lightCanvas,
    surface: AppColors.lightSurface,
    surfaceAlt: AppColors.lightSurfaceAlt,
    ink: AppColors.lightInk,
    inkMuted: AppColors.lightInkMuted,
    primary: AppColors.lightPrimary,
    primarySoft: AppColors.lightPrimarySoft,
    accent: AppColors.lightAccent,
    accentSoft: AppColors.lightAccentSoft,
    border: AppColors.lightBorder,
    success: AppColors.lightSuccess,
    warning: AppColors.lightWarning,
    error: AppColors.lightError,
    onPrimary: AppColors.lightSurface,
    shadow: AppColors.lightInk,
  );

  static const dark = AppPalette(
    canvas: AppColors.darkCanvas,
    surface: AppColors.darkSurface,
    surfaceAlt: AppColors.darkSurfaceAlt,
    ink: AppColors.darkInk,
    inkMuted: AppColors.darkInkMuted,
    primary: AppColors.darkPrimary,
    primarySoft: AppColors.darkPrimarySoft,
    accent: AppColors.darkAccent,
    accentSoft: AppColors.darkAccentSoft,
    border: AppColors.darkBorder,
    success: AppColors.darkSuccess,
    warning: AppColors.darkWarning,
    error: AppColors.darkError,
    onPrimary: AppColors.darkCanvas,
    shadow: AppColors.lightInk,
  );

  @override
  AppPalette copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceAlt,
    Color? ink,
    Color? inkMuted,
    Color? primary,
    Color? primarySoft,
    Color? accent,
    Color? accentSoft,
    Color? border,
    Color? success,
    Color? warning,
    Color? error,
    Color? onPrimary,
    Color? shadow,
  }) {
    return AppPalette(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      canvas: mix(canvas, other.canvas),
      surface: mix(surface, other.surface),
      surfaceAlt: mix(surfaceAlt, other.surfaceAlt),
      ink: mix(ink, other.ink),
      inkMuted: mix(inkMuted, other.inkMuted),
      primary: mix(primary, other.primary),
      primarySoft: mix(primarySoft, other.primarySoft),
      accent: mix(accent, other.accent),
      accentSoft: mix(accentSoft, other.accentSoft),
      border: mix(border, other.border),
      success: mix(success, other.success),
      warning: mix(warning, other.warning),
      error: mix(error, other.error),
      onPrimary: mix(onPrimary, other.onPrimary),
      shadow: mix(shadow, other.shadow),
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
