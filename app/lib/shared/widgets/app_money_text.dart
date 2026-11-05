import 'package:calc_engine/calc_engine.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/format/money_format.dart';
import '../../core/format/money_words.dart';

enum AppMoneySize { hero, body }

class AppMoneyText extends StatefulWidget {
  const AppMoneyText({
    super.key,
    required this.money,
    this.size = AppMoneySize.body,
    this.color,
    this.textAlign = TextAlign.start,
    this.animate = false,
  });

  final Money money;
  final AppMoneySize size;
  final Color? color;
  final TextAlign textAlign;
  final bool animate;

  @override
  State<AppMoneyText> createState() => _AppMoneyTextState();
}

class _AppMoneyTextState extends State<AppMoneyText>
    with SingleTickerProviderStateMixin {
  late int _displayCents;
  AnimationController? _controller;
  Animation<int>? _animation;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _displayCents = widget.animate ? 0 : widget.money.cents;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.animate && !_started && _controller == null) {
      _started = true;
      final disable = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (disable) {
        _displayCents = widget.money.cents;
      } else {
        _controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 600),
        );
        _animation = IntTween(begin: 0, end: widget.money.cents).animate(
          CurvedAnimation(parent: _controller!, curve: Curves.easeOutCubic),
        );
        _animation!.addListener(() {
          setState(() => _displayCents = _animation!.value);
        });
        _controller!.forward();
      }
    }
  }

  @override
  void didUpdateWidget(covariant AppMoneyText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.money != widget.money) {
      _controller?.stop();
      _controller?.dispose();
      _controller = null;
      _animation = null;
      _started = false;
      _displayCents = widget.money.cents;
      if (widget.animate) {
        // Restart on next dependency change.
        _started = false;
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final isHero = widget.size == AppMoneySize.hero;

    final numberStyle =
        (isHero ? textTheme.displayMedium! : textTheme.bodyLarge!).copyWith(
          color: widget.color ?? palette.ink,
          fontFeatures: const [FontFeature.tabularFigures()],
        );
    final symbolStyle = (isHero ? textTheme.titleLarge! : textTheme.bodySmall!)
        .copyWith(
          color: palette.inkMuted,
          fontFeatures: const [FontFeature.tabularFigures()],
        );

    final amount = formatMoney(Money(_displayCents)).replaceAll(',', ',\u200B');

    return Semantics(
      label: moneyToWordsEs(widget.money),
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: r'$', style: symbolStyle),
            TextSpan(text: amount, style: numberStyle),
          ],
        ),
        textAlign: widget.textAlign,
        softWrap: true,
      ),
    );
  }
}
