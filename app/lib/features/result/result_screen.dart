import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/format/money_format.dart';
import '../../core/legal/parameter_labels.dart';
import '../../core/storage/storage_providers.dart';
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
              illustration: 'assets/illustrations/empty_result.png',
              actionLabel: 'Ver calculadoras',
              onAction: () => context.go('/'),
            )
          : _ResultBody(result: result),
    );
  }
}

class _ResultBody extends ConsumerWidget {
  const _ResultBody({required this.result});

  final CalcResultView result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              AppMoneyText(
                money: result.amount,
                size: AppMoneySize.hero,
                animate: true,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                result.context,
                style: textTheme.titleMedium?.copyWith(color: palette.primary),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () async {
              HapticFeedback.lightImpact();
              await Clipboard.setData(
                ClipboardData(text: formatMoney(result.amount)),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Monto copiado')));
              }
            },
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('Copiar monto'),
            style: TextButton.styleFrom(
              foregroundColor: palette.inkMuted,
              padding: EdgeInsets.zero,
              minimumSize: const Size(
                AppSpacing.minTouchTarget,
                AppSpacing.minTouchTarget,
              ),
            ),
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
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Compartir',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _shareText(context, result);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppButton(
                label: 'PDF',
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _sharePdf(context, ref, result);
                },
              ),
            ),
          ],
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

String _buildShareText(CalcResultView result) {
  final buffer = StringBuffer();
  buffer.writeln('Me Toca — ${result.title}');
  buffer.writeln(
    '${result.heroLabel} ${formatMoney(result.amount)} ${result.context}',
  );
  buffer.writeln();
  for (final section in result.sections) {
    if (section.label != null) {
      buffer.writeln('${section.label}:');
    }
    for (final row in section.rows) {
      final value = row.amount != null
          ? formatMoney(row.amount!)
          : (row.value ?? '');
      buffer.writeln('  ${row.label}: $value');
    }
    buffer.writeln();
  }
  if (result.parametersId != null) {
    buffer.writeln('Tablas: ${parametersShortLabel(result.parametersId!)}.');
  }
  buffer.writeln('Herramienta de referencia. No sustituye asesoría legal.');
  return buffer.toString();
}

Future<void> _shareText(BuildContext context, CalcResultView result) async {
  await SharePlus.instance.share(
    ShareParams(
      text: _buildShareText(result),
      subject: 'Me Toca — ${result.title}',
    ),
  );
}

Future<void> _sharePdf(
  BuildContext context,
  WidgetRef ref,
  CalcResultView result,
) async {
  final isPro = ref.read(storageControllerProvider).settings.pro;
  if (!isPro) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El PDF con desglose está disponible en Me Toca Pro.'),
        ),
      );
    }
    return;
  }

  final document = pw.Document();
  document.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context pdfContext) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Me Toca — ${result.title}',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              '${result.heroLabel} ${formatMoney(result.amount)} ${result.context}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),
            for (final section in result.sections) ...[
              if (section.label != null)
                pw.Text(
                  section.label!,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              pw.SizedBox(height: 4),
              for (final row in section.rows)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(row.label),
                    pw.Text(
                      row.amount != null
                          ? formatMoney(row.amount!)
                          : (row.value ?? ''),
                    ),
                  ],
                ),
              pw.SizedBox(height: 12),
            ],
            pw.SizedBox(height: 16),
            pw.Text(
              'Herramienta de referencia. No sustituye asesoría legal, '
              'contable ni la determinación de la autoridad.',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        );
      },
    ),
  );

  final bytes = await document.save();
  await Printing.sharePdf(
    bytes: bytes,
    filename: 'me-toca-${result.title.toLowerCase()}.pdf',
  );
}
