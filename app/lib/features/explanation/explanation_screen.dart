import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_empty_state.dart';
import '../../shared/widgets/app_money_text.dart';
import '../../shared/widgets/app_notice.dart';
import '../../shared/widgets/section_label.dart';
import '../result/calc_result_view.dart';
import '../result/result_provider.dart';

class ExplanationScreen extends ConsumerWidget {
  const ExplanationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(calcResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Así se calculó')),
      body: result == null
          ? AppEmptyState(
              title: 'Todavía no hay un cálculo',
              message:
                  'Primero calcula en una de las calculadoras para ver el '
                  'paso a paso.',
              icon: Icons.receipt_long_rounded,
              actionLabel: 'Ver calculadoras',
              onAction: () => context.go('/'),
            )
          : _ExplanationBody(result: result),
    );
  }
}

class _ExplanationBody extends StatelessWidget {
  const _ExplanationBody({required this.result});

  final CalcResultView result;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: AppSpacing.screen.copyWith(
        top: AppSpacing.md,
        bottom: AppSpacing.xxxl,
      ),
      children: [
        Text(
          result.explanationTitle,
          style: textTheme.headlineMedium?.copyWith(color: palette.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          result.explanationIntro,
          style: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const SectionLabel('Paso a paso'),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            children: [
              for (var i = 0; i < result.steps.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.lg),
                _StepRow(index: i + 1, step: result.steps[i]),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const SectionLabel('Fundamento'),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < result.sources.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.lg),
                _Source(source: result.sources[i]),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const SectionLabel('Qué no incluye'),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < result.exclusions.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.sm),
                _Bullet(result.exclusions[i]),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const AppNotice(
          'Herramienta de referencia. No sustituye asesoría legal, '
          'contable ni la determinación de la autoridad.',
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.index, required this.step});

  final int index;
  final ResultStep step;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.primarySoft,
            borderRadius: AppRadii.fullAll,
          ),
          child: Text(
            '$index',
            style: textTheme.labelSmall?.copyWith(
              color: palette.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.label,
                style: textTheme.titleSmall?.copyWith(color: palette.ink),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                step.detail,
                style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
              ),
              if (step.amount != null) ...[
                const SizedBox(height: AppSpacing.xs),
                AppMoneyText(money: step.amount!),
              ] else if (step.value != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  step.value!,
                  style: textTheme.titleSmall?.copyWith(color: palette.ink),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Source extends StatelessWidget {
  const _Source({required this.source});

  final ResultSource source;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          source.title,
          style: textTheme.titleSmall?.copyWith(color: palette.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          source.body,
          style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
        ),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 7),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: palette.accent,
            borderRadius: AppRadii.fullAll,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: palette.inkMuted),
          ),
        ),
      ],
    );
  }
}
