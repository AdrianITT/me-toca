import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radii.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/format/date_format.dart';

class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.helper,
    this.errorText,
    this.placeholder = 'Elige una fecha',
  });

  final String label;
  final DateTime? value;
  final VoidCallback? onTap;
  final String? helper;
  final String? errorText;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge?.copyWith(color: palette.ink)),
        const SizedBox(height: AppSpacing.sm),
        Material(
          color: palette.surfaceAlt.withValues(alpha: 0),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadii.mdAll,
            child: Container(
              constraints: const BoxConstraints(minHeight: 56),
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
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: palette.inkMuted,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      value == null ? placeholder : formatLongDate(value!),
                      style: textTheme.bodyLarge?.copyWith(
                        color: value == null ? palette.inkMuted : palette.ink,
                      ),
                    ),
                  ),
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
