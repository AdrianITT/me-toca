import 'package:calc_engine/calc_engine.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/format/money_format.dart';
import '../../core/format/money_words.dart';

enum AppMoneySize { hero, body }

class AppMoneyText extends StatelessWidget {
  const AppMoneyText({
    super.key,
    required this.money,
    this.size = AppMoneySize.body,
    this.color,
    this.textAlign = TextAlign.start,
  });

  final Money money;
  final AppMoneySize size;
  final Color? color;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final isHero = size == AppMoneySize.hero;

    final numberStyle =
        (isHero ? textTheme.displayMedium! : textTheme.bodyLarge!).copyWith(
          color: color ?? palette.ink,
          fontFeatures: const [FontFeature.tabularFigures()],
        );
    final symbolStyle = (isHero ? textTheme.titleLarge! : textTheme.bodySmall!)
        .copyWith(
          color: palette.inkMuted,
          fontFeatures: const [FontFeature.tabularFigures()],
        );

    // Zero-width spaces after thousands separators let large amounts wrap
    // instead of overflowing when the system font is scaled up.
    final amount = formatMoney(money).replaceAll(',', ',\u200B');

    return Semantics(
      label: moneyToWordsEs(money),
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: r'$', style: symbolStyle),
            TextSpan(text: amount, style: numberStyle),
          ],
        ),
        textAlign: textAlign,
        softWrap: true,
      ),
    );
  }
}
