import 'package:calc_engine/calc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/format/money_format.dart';
import '../../core/storage/history_entry.dart';
import '../../core/storage/storage_providers.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_choice_field.dart';
import '../../shared/widgets/app_form_error.dart';
import '../../shared/widgets/app_notice.dart';
import '../../shared/widgets/app_text_field.dart';
import '../result/result_provider.dart';
import 'isr_result_view.dart';

class IsrScreen extends ConsumerStatefulWidget {
  const IsrScreen({super.key});

  @override
  ConsumerState<IsrScreen> createState() => _IsrScreenState();
}

class _IsrScreenState extends ConsumerState<IsrScreen> {
  final _incomeController = TextEditingController();
  final _incomeFocus = FocusNode();

  PayPeriod _period = PayPeriod.monthly;
  String? _incomeError;
  String? _formError;

  @override
  void initState() {
    super.initState();
    final pending = ref.read(pendingHistoryInputsProvider);
    if (pending != null && pending.type == 'ISR') {
      final i = pending.inputs;
      final incomeCents = i['income'];
      if (incomeCents is int) {
        _incomeController.text = formatMoney(Money(incomeCents));
      }
      final period = i['period'];
      if (period is String) {
        final match = PayPeriod.values
            .where((value) => value.name == period)
            .firstOrNull;
        if (match != null) {
          _period = match;
        }
      }
      ref.read(pendingHistoryInputsProvider.notifier).clear();
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _incomeFocus.dispose();
    super.dispose();
  }

  void _fillExample() {
    setState(() {
      _incomeController.text = '15,000.00';
      _period = PayPeriod.monthly;
      _incomeError = null;
      _formError = null;
    });
  }

  void _calculate() {
    FocusScope.of(context).unfocus();

    final income = parseMoneyInput(_incomeController.text);
    final incomeError = _incomeController.text.trim().isEmpty
        ? 'Escribe tu ingreso del periodo.'
        : income == null
        ? 'Escribe un monto válido. Ejemplo: 15,000.00.'
        : null;

    setState(() {
      _incomeError = incomeError;
      _formError = null;
    });

    if (incomeError != null) {
      _incomeFocus.requestFocus();
      return;
    }

    HapticFeedback.mediumImpact();
    final today = dateOnly(DateTime.now());
    final parametersOutcome = ParameterRepository.forDate(today);
    if (parametersOutcome.isFailure) {
      setState(() => _formError = parametersOutcome.errorOrNull!.message);
      return;
    }

    final input = IsrInput(taxableIncome: income!, period: _period);
    final outcome = calculateIsr(input, parametersOutcome.valueOrNull!);

    if (outcome.isFailure) {
      setState(() => _formError = outcome.errorOrNull!.message);
      return;
    }

    ref
        .read(calcResultProvider.notifier)
        .update(isrResultView(outcome.valueOrNull!, input));
    ref
        .read(storageControllerProvider.notifier)
        .addHistory(
          HistoryEntry(
            id: 'isr_${DateTime.now().microsecondsSinceEpoch}',
            type: 'ISR',
            date: dateOnly(DateTime.now()),
            inputSummary: 'Ingreso ${formatMoney(income)} · ${_period.label}',
            amount: outcome.valueOrNull!.isrWithheld,
            paramsId: outcome.valueOrNull!.parametersId,
            inputs: {'income': income.cents, 'period': _period.name},
          ),
        );
    context.push('/isr/resultado');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('ISR')),
      body: FocusTraversalGroup(
        child: ListView(
          padding: AppSpacing.screen.copyWith(
            top: AppSpacing.sm,
            bottom: AppSpacing.xxl,
          ),
          children: [
            Text(
              'Datos de tu ISR',
              style: textTheme.headlineMedium?.copyWith(color: palette.ink),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Lo que te retienen de tu ingreso en el periodo.',
              style: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _fillExample,
                icon: const Icon(Icons.play_arrow_rounded, size: 18),
                label: const Text('Probar con ejemplo'),
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
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Ingreso gravable del periodo',
              controller: _incomeController,
              focusNode: _incomeFocus,
              hint: '15,000.00',
              suffix: 'MXN',
              helper:
                  'El ingreso antes de impuestos. Lo encuentras en tu '
                  'recibo de nómina como "ingreso gravable" o "sueldo bruto".',
              errorText: _incomeError,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              onChanged: (_) {
                if (_incomeError != null) {
                  setState(() => _incomeError = null);
                }
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            AppChoiceField<PayPeriod>(
              label: 'Periodo de pago',
              value: _period,
              options: const [
                AppChoiceOption(
                  value: PayPeriod.monthly,
                  label: 'Mensual',
                  description: 'Tarifa de 30 días.',
                ),
                AppChoiceOption(
                  value: PayPeriod.fifteenDay,
                  label: 'Quincenal',
                  description: 'Tarifa de 15 días.',
                ),
                AppChoiceOption(
                  value: PayPeriod.weekly,
                  label: 'Semanal',
                  description: 'Tarifa de 7 días.',
                ),
              ],
              helper: 'Cada periodo usa su propia tarifa oficial.',
              onChanged: (value) {
                setState(() {
                  _period = value;
                  _formError = null;
                });
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppNotice(
              'Si solo sabes lo que te llega (neto), esta calculadora no lo '
              'invierte. Pide tu recibo de nómina o usa el monto bruto de tu '
              'contrato.',
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.push('/glosario'),
                icon: const Icon(Icons.menu_book_rounded, size: 16),
                label: const Text('Ver glosario'),
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
            if (_formError != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppFormError(_formError!),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: AppButton(label: 'Calcular', onPressed: _calculate),
        ),
      ),
    );
  }
}
