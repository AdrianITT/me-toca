import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../shared/widgets/app_badge.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_notice.dart';
import '../../shared/widgets/section_label.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Historial',
            onPressed: () => context.push('/historial'),
            icon: const Icon(Icons.history_rounded),
          ),
          IconButton(
            tooltip: 'Ajustes',
            onPressed: () => context.push('/ajustes'),
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screen.copyWith(
          top: AppSpacing.xxl,
          bottom: AppSpacing.xxxl,
        ),
        children: [
          // Wrap instead of Row so the badge drops to a second line when
          // the system font is scaled up instead of overflowing.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              Text(
                'ME TOCA',
                style: textTheme.labelMedium?.copyWith(
                  color: palette.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const AppBadge('Tablas 2026'),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Text(
            '¿Cuánto te toca?',
            style: textTheme.headlineLarge?.copyWith(color: palette.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Calcula lo que te corresponde. Sin registro.',
            style: textTheme.bodyLarge?.copyWith(color: palette.inkMuted),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          const SectionLabel('Calculadoras'),
          const SizedBox(height: AppSpacing.md),
          _CalculatorCard(
            icon: Icons.card_giftcard_rounded,
            title: 'Aguinaldo',
            subtitle: 'Lo que te toca en diciembre.',
            onTap: () => context.push('/aguinaldo'),
          ),
          const SizedBox(height: AppSpacing.md),
          _CalculatorCard(
            icon: Icons.receipt_long_rounded,
            title: 'Finiquito',
            subtitle: 'Si renuncias o te despiden.',
            onTap: () => context.push('/finiquito'),
          ),
          const SizedBox(height: AppSpacing.md),
          _CalculatorCard(
            icon: Icons.beach_access_rounded,
            title: 'Vacaciones',
            subtitle: 'Días y prima vacacional.',
            onTap: () => context.push('/vacaciones'),
          ),
          const SizedBox(height: AppSpacing.md),
          _CalculatorCard(
            icon: Icons.payments_rounded,
            title: 'ISR',
            subtitle: 'Lo que te retienen del sueldo.',
            onTap: () => context.push('/isr'),
          ),
          const SizedBox(height: AppSpacing.md),
          _CalculatorCard(
            icon: Icons.percent_rounded,
            title: 'IVA',
            subtitle: 'Agrega o desglosa el IVA.',
            onTap: () => context.push('/iva'),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          const SectionLabel('Ayuda'),
          const SizedBox(height: AppSpacing.md),
          _CalculatorCard(
            icon: Icons.menu_book_rounded,
            title: 'Glosario',
            subtitle: 'Palabras de tu recibo, sin jerga.',
            onTap: () => context.push('/glosario'),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          const AppNotice(
            'Herramienta de referencia. No sustituye asesoría legal, '
            'contable ni la determinación de la autoridad.',
          ),
        ],
      ),
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  const _CalculatorCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final enabled = onTap != null;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: palette.primarySoft,
              borderRadius: AppRadii.mdAll,
            ),
            child: Icon(icon, size: 22, color: palette.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(color: palette.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (enabled)
            Icon(Icons.arrow_forward_rounded, size: 20, color: palette.inkMuted)
          else
            const AppBadge('Pronto'),
        ],
      ),
    );
  }
}
