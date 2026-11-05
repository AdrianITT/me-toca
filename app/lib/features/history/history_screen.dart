import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/format/date_format.dart';
import '../../core/storage/history_entry.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_empty_state.dart';
import '../../shared/widgets/app_money_text.dart';
import '../../shared/widgets/section_label.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.entries,
    required this.isPro,
    this.onDelete,
    this.onOpen,
  });

  final List<HistoryEntry> entries;
  final bool isPro;
  final ValueChanged<String>? onDelete;
  final ValueChanged<HistoryEntry>? onOpen;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: entries.isEmpty
          ? AppEmptyState(
              title: 'Todavía no hay cálculos',
              message: 'Tus últimos cálculos quedan guardados aquí.',
              icon: Icons.history_rounded,
              illustration: 'assets/illustrations/empty_history.png',
              actionLabel: 'Calcular',
              onAction: () => context.go('/'),
            )
          : ListView(
              padding: AppSpacing.screen.copyWith(
                top: AppSpacing.md,
                bottom: AppSpacing.xxxl,
              ),
              children: [
                if (!isPro) ...[
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'Guarda hasta ${HistoryStore.freeLimit} cálculos. Pro '
                      'los guarda todos.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: palette.inkMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
                for (final group in _groupByMonth(entries)) ...[
                  SectionLabel(_monthLabel(group.key)),
                  const SizedBox(height: AppSpacing.md),
                  for (final entry in group.value) ...[
                    _HistoryRow(
                      entry: entry,
                      onDelete: onDelete,
                      onOpen: onOpen,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
    );
  }
}

class _MonthGroup {
  const _MonthGroup(this.key, this.value);

  final DateTime key;
  final List<HistoryEntry> value;
}

List<_MonthGroup> _groupByMonth(List<HistoryEntry> entries) {
  final groups = <_MonthGroup>[];
  for (final entry in entries) {
    final key = DateTime(entry.date.year, entry.date.month);
    final index = groups.indexWhere((group) => group.key == key);
    if (index == -1) {
      groups.add(_MonthGroup(key, [entry]));
    } else {
      groups[index].value.add(entry);
    }
  }
  return groups;
}

String _monthLabel(DateTime month) {
  const months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];
  return '${months[month.month - 1]} de ${month.year}';
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.entry,
    this.onDelete,
    this.onOpen,
  });

  final HistoryEntry entry;
  final ValueChanged<String>? onDelete;
  final ValueChanged<HistoryEntry>? onOpen;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDelete?.call(entry.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: palette.error,
          borderRadius: AppRadii.lgAll,
        ),
        child: Icon(Icons.delete_outline_rounded, color: palette.surface),
      ),
      child: AppCard(
        onTap: onOpen == null ? null : () => onOpen!(entry),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.type,
                    style: textTheme.titleMedium?.copyWith(color: palette.ink),
                  ),
                ),
                AppMoneyText(money: entry.amount),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              entry.inputSummary,
              style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              formatLongDate(entry.date),
              style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
            ),
          ],
        ),
      ),
    );
  }
}

/// Static version info shown in settings.
const String appVersion = '0.1.0';

/// Static license attribution; no legal text is invented here.
const String licensesText =
    'Las fuentes Fraunces y Manrope se distribuyen con la Licencia '
    'SIL Open Font License 1.1 (ver assets/licenses/).';

/// Static privacy notice; no URL is invented.
const String privacyText =
    'Tus datos se guardan solo en tu teléfono. No hay cuentas, nube ni '
    'analytics de terceros.';

/// Static terms notice; no legal text is invented.
const String termsText =
    'Me Toca es una herramienta de referencia. No sustituye asesoría legal, '
    'contable ni la determinación de la autoridad.';
