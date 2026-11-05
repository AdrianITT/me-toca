import 'package:calc_engine/calc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/format/date_format.dart';
import '../../core/format/money_format.dart';
import '../../core/storage/history_entry.dart';
import '../../core/storage/storage_providers.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_date_field.dart';
import '../../shared/widgets/app_form_error.dart';
import '../../shared/widgets/app_text_field.dart';
import '../result/result_provider.dart';
import 'aguinaldo_result_view.dart';

class AguinaldoScreen extends ConsumerStatefulWidget {
  const AguinaldoScreen({super.key});

  @override
  ConsumerState<AguinaldoScreen> createState() => _AguinaldoScreenState();
}

class _AguinaldoScreenState extends ConsumerState<AguinaldoScreen> {
  final _salaryController = TextEditingController();
  final _daysController = TextEditingController(text: '15');
  final _salaryFocus = FocusNode();

  DateTime? _hireDate;
  late DateTime _calculationDate;
  bool _advancedOpen = false;

  String? _salaryError;
  String? _hireError;
  String? _daysError;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _calculationDate = dateOnly(DateTime.now());

    final pending = ref.read(pendingHistoryInputsProvider);
    if (pending != null && pending.type == 'Aguinaldo') {
      final i = pending.inputs;
      final salaryCents = i['salary'];
      if (salaryCents is int) {
        _salaryController.text = formatMoney(Money(salaryCents));
      }
      final hire = i['hire'];
      if (hire is String) {
        _hireDate = dateOnly(DateTime.parse(hire));
      }
      final calc = i['calc'];
      if (calc is String) {
        _calculationDate = dateOnly(DateTime.parse(calc));
      }
      final days = i['days'];
      if (days is int) {
        _daysController.text = days.toString();
      }
      ref.read(pendingHistoryInputsProvider.notifier).clear();
    }
  }

  @override
  void dispose() {
    _salaryController.dispose();
    _daysController.dispose();
    _salaryFocus.dispose();
    super.dispose();
  }

  Future<void> _pickHireDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _hireDate ?? DateTime(now.year - 1, now.month, now.day),
      firstDate: DateTime(1960),
      lastDate: DateTime(now.year, 12, 31),
      helpText: 'Fecha de ingreso',
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _hireDate = dateOnly(picked);
      _hireError = null;
      _formError = null;
    });
  }

  Future<void> _pickCalculationDate() async {
    final firstDate = _hireDate ?? DateTime(1960);
    final picked = await showDatePicker(
      context: context,
      initialDate: _calculationDate.isBefore(firstDate)
          ? firstDate
          : _calculationDate,
      firstDate: firstDate,
      lastDate: DateTime(DateTime.now().year, 12, 31),
      helpText: 'Fecha de cálculo o salida',
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _calculationDate = dateOnly(picked);
      _formError = null;
    });
  }

  void _fillExample() {
    setState(() {
      _salaryController.text = '15,000.00';
      _hireDate = DateTime.utc(2020, 1, 1);
      _calculationDate = DateTime.utc(2026, 12, 31);
      _daysController.text = '15';
      _salaryError = null;
      _hireError = null;
      _daysError = null;
      _formError = null;
    });
  }

  void _calculate() {
    FocusScope.of(context).unfocus();

    final salary = parseMoneyInput(_salaryController.text);
    final days = int.tryParse(_daysController.text.trim());

    String? salaryError;
    if (_salaryController.text.trim().isEmpty) {
      salaryError = 'Escribe tu salario mensual.';
    } else if (salary == null || !salary.isPositive) {
      salaryError = 'Escribe un monto mayor a cero. Ejemplo: 15,000.00.';
    }

    final hireError = _hireDate == null ? 'Elige tu fecha de ingreso.' : null;
    final daysError = (days == null || days < 15)
        ? 'El mínimo legal es de 15 días.'
        : null;
    final formError = _hireDate != null && _calculationDate.isBefore(_hireDate!)
        ? 'La fecha de cálculo no puede ser anterior a la de ingreso.'
        : null;

    setState(() {
      _salaryError = salaryError;
      _hireError = hireError;
      _daysError = daysError;
      _formError = formError;
    });

    if (salaryError != null) {
      _salaryFocus.requestFocus();
      return;
    }
    if (hireError != null || daysError != null || formError != null) {
      return;
    }

    HapticFeedback.mediumImpact();
    final parametersOutcome = ParameterRepository.forDate(_calculationDate);
    if (parametersOutcome.isFailure) {
      setState(() => _formError = parametersOutcome.errorOrNull!.message);
      return;
    }

    final outcome = calculateAguinaldo(
      AguinaldoInput(
        monthlySalary: salary!,
        hireDate: _hireDate!,
        calculationDate: _calculationDate,
        companyAguinaldoDays: days!,
      ),
      parametersOutcome.valueOrNull!,
    );

    if (outcome.isFailure) {
      setState(() => _formError = outcome.errorOrNull!.message);
      return;
    }

    final result = outcome.valueOrNull!;
    final hireDate = _hireDate!;
    ref.read(calcResultProvider.notifier).update(aguinaldoResultView(result));
    ref
        .read(storageControllerProvider.notifier)
        .addHistory(
          HistoryEntry(
            id: 'aguinaldo_${DateTime.now().microsecondsSinceEpoch}',
            type: 'Aguinaldo',
            date: _calculationDate,
            inputSummary:
                'Salario ${formatMoney(salary)} · '
                '${formatShortDate(hireDate)} → ${formatShortDate(_calculationDate)}',
            amount: result.aguinaldo,
            paramsId: result.parametersId,
            inputs: {
              'salary': salary.cents,
              'hire': hireDate.toUtc().toIso8601String(),
              'calc': _calculationDate.toUtc().toIso8601String(),
              'days': days,
            },
          ),
        );
    context.push('/aguinaldo/resultado');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Aguinaldo')),
      body: FocusTraversalGroup(
        child: ListView(
          padding: AppSpacing.screen.copyWith(
            top: AppSpacing.sm,
            bottom: AppSpacing.xxl,
          ),
          children: [
            Text(
              'Datos de tu aguinaldo',
              style: textTheme.headlineMedium?.copyWith(color: palette.ink),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Máximo un minuto. Nada sale de tu teléfono.',
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
              label: 'Salario mensual bruto',
              controller: _salaryController,
              focusNode: _salaryFocus,
              hint: '15,000.00',
              suffix: 'MXN',
              helper: 'Antes de impuestos.',
              errorText: _salaryError,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                if (_salaryError != null) {
                  setState(() => _salaryError = null);
                }
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            AppDateField(
              label: 'Fecha de ingreso',
              value: _hireDate,
              onTap: _pickHireDate,
              helper: 'El día que empezaste a trabajar.',
              errorText: _hireError,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppDateField(
              label: 'Fecha de cálculo o salida',
              value: _calculationDate,
              onTap: _pickCalculationDate,
              helper: 'Hoy o el día de tu salida.',
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  setState(() => _advancedOpen = !_advancedOpen);
                },
                icon: Icon(
                  _advancedOpen
                      ? Icons.expand_less_rounded
                      : Icons.tune_rounded,
                  size: 18,
                ),
                label: Text(
                  _advancedOpen
                      ? 'Ocultar opciones avanzadas'
                      : 'Opciones avanzadas',
                ),
                style: TextButton.styleFrom(
                  foregroundColor: palette.inkMuted,
                  minimumSize: const Size(
                    AppSpacing.minTouchTarget,
                    AppSpacing.minTouchTarget,
                  ),
                  padding: EdgeInsets.zero,
                  textStyle: textTheme.labelLarge,
                ),
              ),
            ),
            if (_advancedOpen) ...[
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Días de aguinaldo de tu empresa',
                controller: _daysController,
                suffix: 'días',
                helper: 'Mínimo legal: 15 días.',
                errorText: _daysError,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) {
                  if (_daysError != null) {
                    setState(() => _daysError = null);
                  }
                },
              ),
            ],
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
