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
import '../../shared/widgets/app_text_field.dart';
import '../result/result_provider.dart';
import 'iva_result_view.dart';

class IvaScreen extends ConsumerStatefulWidget {
  const IvaScreen({super.key});

  @override
  ConsumerState<IvaScreen> createState() => _IvaScreenState();
}

class _IvaScreenState extends ConsumerState<IvaScreen> {
  final _amountController = TextEditingController();
  final _amountFocus = FocusNode();

  IvaMode _mode = IvaMode.add;
  IvaRate _rate = IvaRate.general;
  String? _amountError;
  String? _formError;

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  void _calculate() {
    FocusScope.of(context).unfocus();

    final amount = parseMoneyInput(_amountController.text);
    final amountError = _amountController.text.trim().isEmpty
        ? 'Escribe el monto.'
        : amount == null
        ? 'Escribe un monto válido. Ejemplo: 1,000.00.'
        : null;

    setState(() {
      _amountError = amountError;
      _formError = null;
    });

    if (amountError != null) {
      _amountFocus.requestFocus();
      return;
    }

    final outcome = calculateIva(
      IvaInput(amount: amount!, mode: _mode, rate: _rate),
    );

    if (outcome.isFailure) {
      setState(() => _formError = outcome.errorOrNull!.message);
      return;
    }

    ref
        .read(calcResultProvider.notifier)
        .update(ivaResultView(outcome.valueOrNull!));
    ref
        .read(storageControllerProvider.notifier)
        .addHistory(
          HistoryEntry(
            id: 'iva_${DateTime.now().microsecondsSinceEpoch}',
            type: 'IVA',
            date: dateOnly(DateTime.now()),
            inputSummary:
                'Monto ${formatMoney(amount)} · ${_mode.label} · ${_rate.label}',
            amount: outcome.valueOrNull!.total,
            paramsId: null,
          ),
        );
    context.push('/iva/resultado');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('IVA')),
      body: ListView(
        padding: AppSpacing.screen.copyWith(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxl,
        ),
        children: [
          Text(
            'Datos de tu IVA',
            style: textTheme.headlineMedium?.copyWith(color: palette.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Agrega el IVA a un monto o desglósalo de un total.',
            style: textTheme.bodyMedium?.copyWith(color: palette.inkMuted),
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppTextField(
            label: 'Monto',
            controller: _amountController,
            focusNode: _amountFocus,
            hint: '1,000.00',
            suffix: 'MXN',
            helper: 'El monto base o el total, según el modo.',
            errorText: _amountError,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            onChanged: (_) {
              if (_amountError != null) {
                setState(() => _amountError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppChoiceField<IvaMode>(
            label: 'Modo',
            value: _mode,
            options: const [
              AppChoiceOption(
                value: IvaMode.add,
                label: 'Agregar IVA',
                description: 'Suma el IVA al monto.',
              ),
              AppChoiceOption(
                value: IvaMode.breakdown,
                label: 'Desglosar IVA',
                description: 'Quita el IVA de un total.',
              ),
            ],
            helper: 'Elige si el monto ya incluye IVA.',
            onChanged: (value) {
              setState(() {
                _mode = value;
                _formError = null;
              });
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppChoiceField<IvaRate>(
            label: 'Tasa',
            value: _rate,
            options: const [
              AppChoiceOption(
                value: IvaRate.general,
                label: '16%',
                description: 'Tasa general.',
              ),
              AppChoiceOption(
                value: IvaRate.zero,
                label: '0%',
                description: 'Acto gravado con tasa cero.',
              ),
              AppChoiceOption(
                value: IvaRate.exempt,
                label: 'Exento',
                description: 'La operación no causa IVA.',
              ),
            ],
            helper: 'La tasa 0% y exento no son lo mismo.',
            onChanged: (value) {
              setState(() {
                _rate = value;
                _formError = null;
              });
            },
          ),
          if (_formError != null) ...[
            const SizedBox(height: AppSpacing.xl),
            AppFormError(_formError!),
          ],
        ],
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
