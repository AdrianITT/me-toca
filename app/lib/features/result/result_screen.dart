import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/legal/parameter_labels.dart';
import '../../shared/widgets/app_badge.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_empty_state.dart';
import '../../shared/widgets/app_money_text.dart';
import '../../shared/widgets/app_notice.dart';
import '../../shared/widgets/breakdown_row.dart';
import '../../shared/widgets/section_label.dart';
import 'calc_result_view.dart';
import 'result_provider.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(calcResultProvider);

    return Scaffold(
      appBar: AppBar(title: Text(result?.title ?? 'Resultado')),
      body: result == null
          ? AppEmptyState(
              title: 'Todavía no hay un cálculo',
              message:
                  'Captura tus datos en una calculadora para ver el resultado.',
              icon: Icons.receipt_long_rounded,
              actionLabel: 'Ver calculadoras',
              onAction: () => context.go('/'),
            )
          : _ResultBody(result: result),
    );
  }
}

class _ResultBody extends StatelessWidget {
  const _ResultBody({required this.result});

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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: palette.primarySoft,
            borderRadius: AppRadii.xlAll,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.heroLabel,
                style: textTheme.titleMedium?.copyWith(color: palette.primary),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppMoneyText(money: result.amount, size: AppMoneySize.hero),
              const SizedBox(height: AppSpacing.xs),
              Text(
                result.context,
                style: textTheme.titleMedium?.copyWith(color: palette.primary),
              ),
            ],
          ),
        ),
        if (result.parametersId != null) ...[
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const AppBadge('Vigente'),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Cálculo estimado con las tablas de '
                  '${parametersShortLabel(result.parametersId!)}.',
                  style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
        for (final section in result.sections) _Section(section: section),
        for (final note in result.notes) ...[
          AppNotice(note),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: '¿Cómo se calculó?',
          onPressed: () => context.push(result.explanationPath),
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

class _Section extends StatelessWidget {
  const _Section({required this.section});

  final ResultSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.label != null) ...[
            SectionLabel(section.label!),
            const SizedBox(height: AppSpacing.md),
          ],
          AppCard(
            child: Column(
              children: [
                for (var i = 0; i < section.rows.length; i++) ...[
                  if (i > 0) const _Divider(),
                  BreakdownRow(
                    label: section.rows[i].label,
                    amount: section.rows[i].amount,
                    value: section.rows[i].value,
                    hint: section.rows[i].hint,
                    emphasize: section.rows[i].emphasize,
                    topPadding: i == 0 ? 0 : AppSpacing.md,
                    bottomPadding: i == section.rows.length - 1
                        ? 0
                        : AppSpacing.md,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: context.palette.border);
  }
}
