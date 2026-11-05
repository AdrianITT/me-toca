import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, this.onDone});

  final VoidCallback? onDone;

  static const String _copy =
      'Calcula lo que te corresponde en aguinaldo, finiquito, vacaciones, '
      'ISR e IVA. Sin registro, sin internet, sin cuentas.';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen.copyWith(
            top: AppSpacing.xxxl,
            bottom: AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ME TOCA',
                style: textTheme.labelMedium?.copyWith(
                  color: palette.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Lo que te toca, claro y sin jerga',
                style: textTheme.headlineLarge?.copyWith(color: palette.ink),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _copy,
                style: textTheme.bodyLarge?.copyWith(color: palette.inkMuted),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const _Point(
                icon: Icons.payments_rounded,
                text: 'Cinco calculadoras 2026.',
              ),
              const SizedBox(height: AppSpacing.md),
              const _Point(
                icon: Icons.receipt_long_rounded,
                text: 'Cada resultado se explica paso a paso.',
              ),
              const SizedBox(height: AppSpacing.md),
              const _Point(
                icon: Icons.lock_outline_rounded,
                text: 'Todo se guarda solo en tu teléfono.',
              ),
              const SizedBox(height: AppSpacing.xxxl),
              AppButton(
                label: 'Empezar',
                onPressed: onDone ?? () => context.go('/'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        Icon(icon, size: 18, color: palette.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: palette.inkMuted),
          ),
        ),
      ],
    );
  }
}
