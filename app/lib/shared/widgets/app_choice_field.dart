import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';

class AppChoiceOption<T extends Object> {
  const AppChoiceOption({
    required this.value,
    required this.label,
    this.description,
  });

  final T value;
  final String label;
  final String? description;
}

/// Select field that opens a bottom sheet instead of a dropdown menu.
///
/// The sheet wraps and scrolls, so long Spanish labels survive large text
/// scaling without being clipped.
class AppChoiceField<T extends Object> extends StatelessWidget {
  const AppChoiceField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.helper,
    this.errorText,
  });

  final String label;
  final T value;
  final List<AppChoiceOption<T>> options;
  final ValueChanged<T> onChanged;
  final String? helper;
  final String? errorText;

  Future<void> _open(BuildContext context) async {
    final selected = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgTop),
      builder: (sheetContext) =>
          _ChoiceSheet<T>(title: label, selected: value, options: options),
    );
    if (selected != null && selected != value) {
      onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final hasError = errorText != null;
    final selectedOption = options.firstWhere(
      (option) => option.value == value,
      orElse: () => options.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(color: palette.ink)),
        const SizedBox(height: AppSpacing.sm),
        Material(
          color: palette.surfaceAlt.withValues(alpha: 0),
          child: InkWell(
            onTap: () => _open(context),
            borderRadius: AppRadii.mdAll,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppSpacing.minTouchTarget + AppSpacing.sm,
              ),
              padding: AppSpacing.field,
              decoration: BoxDecoration(
                color: palette.surfaceAlt,
                borderRadius: AppRadii.mdAll,
                border: Border.all(
                  color: hasError ? palette.error : palette.border,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedOption.label,
                      style: textTheme.bodyLarge?.copyWith(color: palette.ink),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.expand_more_rounded,
                    size: 20,
                    color: palette.inkMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (helper != null && !hasError) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            helper!,
            style: textTheme.bodySmall?.copyWith(color: palette.inkMuted),
          ),
        ],
        if (hasError) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            errorText!,
            style: textTheme.bodySmall?.copyWith(color: palette.error),
          ),
        ],
      ],
    );
  }
}

class _ChoiceSheet<T extends Object> extends StatelessWidget {
  const _ChoiceSheet({
    required this.title,
    required this.selected,
    required this.options,
  });

  final String title;
  final T selected;
  final List<AppChoiceOption<T>> options;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(color: palette.ink),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final option in options)
                _OptionRow<T>(
                  option: option,
                  isSelected: option.value == selected,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionRow<T extends Object> extends StatelessWidget {
  const _OptionRow({required this.option, required this.isSelected});

  final AppChoiceOption<T> option;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(option.value),
        borderRadius: AppRadii.mdAll,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: textTheme.bodyLarge?.copyWith(
                        color: isSelected ? palette.primary : palette.ink,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    if (option.description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        option.description!,
                        style: textTheme.bodySmall?.copyWith(
                          color: palette.inkMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: AppSpacing.md),
                Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: palette.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
