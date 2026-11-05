import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/storage/app_settings.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/section_label.dart';
import '../history/history_screen.dart' as history_info;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.settings,
    required this.onThemeChanged,
    required this.onZoneChanged,
    this.onProTap,
  });

  final AppSettings settings;
  final ValueChanged<AppThemeChoice> onThemeChanged;
  final ValueChanged<WageZoneChoice> onZoneChanged;
  final VoidCallback? onProTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: AppSpacing.screen.copyWith(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxxl,
        ),
        children: [
          const SectionLabel('Apariencia'),
          const SizedBox(height: AppSpacing.md),
          for (final choice in AppThemeChoice.values)
            _ChoiceRow(
              label: choice.label,
              selected: settings.theme == choice,
              onTap: () => onThemeChanged(choice),
            ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionLabel('Zona salarial'),
          const SizedBox(height: AppSpacing.md),
          for (final choice in WageZoneChoice.values)
            _ChoiceRow(
              label: choice.label,
              selected: settings.zone == choice,
              onTap: () => onZoneChanged(choice),
            ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionLabel('Tablas'),
          const SizedBox(height: AppSpacing.md),
          Text(
            '2026, vigente desde el 1 de febrero',
            style: textTheme.bodyLarge?.copyWith(color: palette.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Administración del SAT, CONASAMI e INEGI.',
            style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
          ),
          TextButton.icon(
            onPressed: () => _showSources(context),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text('Ver fuentes'),
            style: TextButton.styleFrom(
              foregroundColor: palette.primary,
              minimumSize: const Size(
                AppSpacing.minTouchTarget,
                AppSpacing.minTouchTarget,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionLabel('Privacidad y legal'),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(
            label: 'Privacidad',
            body: history_info.privacyText,
            onTap: () =>
                _showInfo(context, 'Privacidad', history_info.privacyText),
          ),
          _InfoRow(
            label: 'Términos',
            body: history_info.termsText,
            onTap: () => _showInfo(context, 'Términos', history_info.termsText),
          ),
          _InfoRow(
            label: 'Licencias',
            body: history_info.licensesText,
            onTap: () =>
                _showInfo(context, 'Licencias', history_info.licensesText),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const SectionLabel('Me Toca Pro'),
          const SizedBox(height: AppSpacing.md),
          Text(
            settings.pro
                ? 'Pro activo. Sin anuncios e historial ilimitado.'
                : 'Una vez. Para siempre. Sin anuncios, PDF con desglose e '
                      'historial ilimitado.',
            style: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: settings.pro ? 'Pro activo' : 'Comprar una vez',
            onPressed: settings.pro ? null : onProTap,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Restaurar compra',
            variant: AppButtonVariant.secondary,
            onPressed: settings.pro ? null : onProTap,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Versión ${history_info.appVersion}',
            style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
          ),
        ],
      ),
    );
  }

  void _showSources(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen.copyWith(
            top: AppSpacing.lg,
            bottom: AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fuentes oficiales',
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              const _SourceItem(
                name: 'SAT — Anexo 8 RMF 2026',
                note: 'Tarifa oficial de ISR mensual, quincenal y semanal.',
              ),
              _SourceItem(
                name: 'DOF 31 dic 2025',
                note: 'Subsidio al empleo 2026.',
              ),
              const _SourceItem(
                name: 'CONASAMI',
                note: 'Salarios mínimos 2026, zona general y frontera.',
              ),
              const _SourceItem(
                name: 'INEGI — DOF',
                note: 'UMA 2026 vigente desde el 1 de febrero.',
              ),
              const _SourceItem(
                name: 'Ley Federal del Trabajo',
                note:
                    'Aguinaldo, vacaciones, prima de antigüedad e '
                    'indemnización.',
              ),
              const _SourceItem(
                name: 'SAT — LIVA',
                note: 'IVA 16%, 0% y exento.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfo(BuildContext context, String title, String body) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screen.copyWith(
            top: AppSpacing.lg,
            bottom: AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(body, style: Theme.of(sheetContext).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: textTheme.bodyLarge?.copyWith(
                    color: selected ? palette.primary : palette.ink,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: palette.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.body,
    required this.onTap,
  });

  final String label;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class _SourceItem extends StatelessWidget {
  const _SourceItem({required this.name, required this.note});

  final String name;
  final String note;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: textTheme.titleSmall?.copyWith(color: palette.ink)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            note,
            style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
          ),
        ],
      ),
    );
  }
}
