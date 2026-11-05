import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData light() => _build(AppPalette.light, Brightness.light);

  static ThemeData dark() => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: palette.primary,
          brightness: brightness,
        ).copyWith(
          primary: palette.primary,
          onPrimary: palette.onPrimary,
          primaryContainer: palette.primarySoft,
          onPrimaryContainer: palette.primary,
          secondary: palette.accent,
          onSecondary: brightness == Brightness.light
              ? palette.ink
              : palette.canvas,
          secondaryContainer: palette.accentSoft,
          onSecondaryContainer: palette.ink,
          surface: palette.surface,
          onSurface: palette.ink,
          surfaceContainerHighest: palette.surfaceAlt,
          onSurfaceVariant: palette.inkMuted,
          outline: palette.border,
          outlineVariant: palette.border,
          error: palette.error,
          onError: palette.onPrimary,
          shadow: palette.shadow,
          surfaceTint: palette.canvas,
        );

    final textTheme = AppTypography.textTheme.apply(
      bodyColor: palette.ink,
      displayColor: palette.ink,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: AppRadii.mdAll,
      borderSide: BorderSide(color: palette.border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.canvas,
      canvasColor: palette.canvas,
      textTheme: textTheme,
      extensions: [palette],
      iconTheme: IconThemeData(color: palette.ink),
      dividerColor: palette.border,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: palette.canvas,
        foregroundColor: palette.ink,
        surfaceTintColor: palette.canvas,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: palette.ink),
        iconTheme: IconThemeData(color: palette.ink),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceAlt,
        contentPadding: AppSpacing.field,
        hintStyle: textTheme.bodyLarge?.copyWith(color: palette.inkMuted),
        suffixStyle: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.mdAll,
          borderSide: BorderSide(color: palette.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.mdAll,
          borderSide: BorderSide(color: palette.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadii.mdAll,
          borderSide: BorderSide(color: palette.error, width: 1.5),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: palette.error),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: palette.primary,
        selectionColor: palette.primarySoft,
        selectionHandleColor: palette.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: palette.canvas),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdAll),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: palette.surface,
        headerBackgroundColor: palette.primary,
        headerForegroundColor: palette.onPrimary,
        surfaceTintColor: palette.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SoftPageTransitionsBuilder(),
          TargetPlatform.iOS: SoftPageTransitionsBuilder(),
          TargetPlatform.macOS: SoftPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Fade plus an 8px rise, 200ms, easeOutCubic. No bounce.
class SoftPageTransitionsBuilder extends PageTransitionsBuilder {
  const SoftPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.of(context).disableAnimations) {
      return child;
    }
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
