import 'package:calc_engine/calc_engine.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'app_money_text.dart';

class BreakdownRow extends StatelessWidget {
  const BreakdownRow({
    super.key,
    required this.label,
    this.amount,
    this.value,
    this.hint,
    this.emphasize = false,
    this.topPadding = AppSpacing.md,
    this.bottomPadding = AppSpacing.md,
  }) : assert(
         amount != null || value != null || hint != null,
         'amount, value or hint required',
       );

  final String label;
  final Money? amount;
  final String? value;
  final String? hint;
  final bool emphasize;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final labelStyle =
        (emphasize ? textTheme.titleMedium : textTheme.bodyMedium)?.copyWith(
          color: emphasize ? palette.ink : palette.inkMuted,
        );

    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: labelStyle),
                if (hint != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    hint!,
                    style: textTheme.bodySmall?.copyWith(
                      color: palette.inkMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          if (amount != null)
            Flexible(child: AppMoneyText(money: amount!))
          else if (value != null)
            Flexible(
              child: Text(
                value!,
                textAlign: TextAlign.end,
                style: textTheme.bodyMedium?.copyWith(
                  color: palette.ink,
                  fontWeight: emphasize ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
