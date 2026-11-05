import 'package:calc_engine/calc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/format/date_format.dart';
import '../../core/format/money_format.dart';
import '../../core/storage/app_settings.dart';
import '../../core/storage/history_entry.dart';
import '../../core/storage/storage_providers.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_choice_field.dart';
import '../../shared/widgets/app_date_field.dart';
import '../../shared/widgets/app_form_error.dart';
import '../../shared/widgets/app_text_field.dart';
import '../result/result_provider.dart';
import 'finiquito_result_view.dart';

class FiniquitoScreen extends ConsumerStatefulWidget {
  const FiniquitoScreen({super.key});

  @override
  ConsumerState<FiniquitoScreen> createState() => _FiniquitoScreenState();
}

class _FiniquitoScreenState extends ConsumerState<FiniquitoScreen> {
  final _salaryController = TextEditingController();
  final _takenDaysController = TextEditingController(text: '0');
  final _pendingSalariesController = TextEditingController(text: '0');
  final _salaryFocus = FocusNode();

  DateTime? _hireDate;
  late DateTime _terminationDate;
  SeparationType _separationType = SeparationType.resignation;
  bool _advancedOpen = false;

  String? _salaryError;
  String? _hireError;
  String? _takenDaysError;
  String? _pendingSalariesError;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _terminationDate = dateOnly(DateTime.now());

    final pending = ref.read(pendingHistoryInputsProvider);
    if (pending != null && pending.type == 'Finiquito') {
      final i = pending.inputs;
      final salaryCents = i['salary'];
      if (salaryCents is int) {
        _salaryController.text = formatMoney(Money(salaryCents));
      }
      final hire = i['hire'];
      if (hire is String) {
        _hireDate = dateOnly(DateTime.parse(hire));
      }
      final termination = i['termination'];
      if (termination is String) {
        _terminationDate = dateOnly(DateTime.parse(termination));
      }
      final separation = i['separation'];
      if (separation is String) {
        final match = SeparationType.values
            .where((value) => value.name == separation)
            .firstOrNull;
        if (match != null) {
          _separationType = match;
        }
      }
      final taken = i['taken'];
      if (taken is int) {
        _takenDaysController.text = taken.toString();
      }
      final pendingSalaries = i['pending'];
      if (pendingSalaries is int) {
        _pendingSalariesController.text = formatMoney(Money(pendingSalaries));
        _advancedOpen = pendingSalaries > 0;
      }
      ref.read(pendingHistoryInputsProvider.notifier).clear();
    }
  }

  @override
  void dispose() {
    _salaryController.dispose();
    _takenDaysController.dispose();
    _pendingSalariesController.dispose();
    _salaryFocus.dispose();
    super.dispose();
  }

  Future<void> _pickHireDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _hireDate ?? DateTime(now.year - 3, now.month, now.day),
      firstDate: DateTime(1960),
      lastDate: _terminationDate,
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

  Future<void> _pickTerminationDate() async {
    final firstDate = _hireDate ?? DateTime(1960);
    final picked = await showDatePicker(
      context: context,
      initialDate: _terminationDate.isBefore(firstDate)
          ? firstDate
          : _terminationDate,
      firstDate: firstDate,
      lastDate: dateOnly(DateTime.now()),
      helpText: 'Fecha de baja',
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _terminationDate = dateOnly(picked);
      _formError = null;
    });
  }

  void _fillExample() {
    setState(() {
      _salaryController.text = '15,000.00';
      _hireDate = DateTime.utc(2024, 3, 1);
      _terminationDate = DateTime.utc(2026, 11, 30);
      _separationType = SeparationType.resignation;
      _takenDaysController.text = '0';
      _pendingSalariesController.text = '2,300.00';
      _advancedOpen = true;
      _salaryError = null;
      _hireError = null;
      _takenDaysError = null;
      _pendingSalariesError = null;
      _formError = null;
    });
  }

  void _calculate() {
    FocusScope.of(context).unfocus();

    final salary = parseMoneyInput(_salaryController.text);
    final takenDays = int.tryParse(_takenDaysController.text.trim());
    final pendingText = _pendingSalariesController.text.trim();
    final pendingSalaries = pendingText.isEmpty
        ? Money.zero
        : parseMoneyInput(pendingText);

    final salaryError = _salaryController.text.trim().isEmpty
        ? 'Escribe tu salario mensual.'
        : (salary == null || !salary.isPositive)
        ? 'Escribe un monto mayor a cero. Ejemplo: 15,000.00.'
        : null;
    final hireError = _hireDate == null ? 'Elige tu fecha de ingreso.' : null;
    final takenDaysError = takenDays == null
        ? 'Escribe un número de días.'
        : null;
    final pendingSalariesError = pendingSalaries == null
        ? 'Escribe un monto válido o deja 0.'
        : null;
    final formError = _hireDate != null && _terminationDate.isBefore(_hireDate!)
        ? 'La fecha de baja no puede ser anterior a la de ingreso.'
        : null;

    setState(() {
      _salaryError = salaryError;
      _hireError = hireError;
      _takenDaysError = takenDaysError;
      _pendingSalariesError = pendingSalariesError;
      _formError = formError;
    });

    if (salaryError != null) {
      _salaryFocus.requestFocus();
      return;
    }
    if (hireError != null ||
        takenDaysError != null ||
        pendingSalariesError != null ||
        formError != null) {
      return;
    }

    HapticFeedback.mediumImpact();
    final parametersOutcome = ParameterRepository.forDate(_terminationDate);
    if (parametersOutcome.isFailure) {
      setState(() => _formError = parametersOutcome.errorOrNull!.message);
      return;
    }

    final input = FiniquitoInput(
      monthlySalary: salary!,
      hireDate: _hireDate!,
      terminationDate: _terminationDate,
      separationType: _separationType,
      takenVacationDays: takenDays!,
      pendingSalaries: pendingSalaries!,
      zone:
          ref.read(storageControllerProvider).settings.zone ==
              WageZoneChoice.border
          ? WageZone.border
          : WageZone.general,
    );
    final outcome = calculateFiniquito(input, parametersOutcome.valueOrNull!);

    if (outcome.isFailure) {
      setState(() => _formError = outcome.errorOrNull!.message);
      return;
    }

    final result = outcome.valueOrNull!;
    ref
        .read(calcResultProvider.notifier)
        .update(finiquitoResultView(result, input));
    final hireDate = _hireDate!;
    ref
        .read(storageControllerProvider.notifier)
        .addHistory(
          HistoryEntry(
            id: 'finiquito_${DateTime.now().microsecondsSinceEpoch}',
            type: 'Finiquito',
            date: _terminationDate,
            inputSummary:
                'Salario ${formatMoney(salary)} · '
                '${formatShortDate(hireDate)} → ${formatShortDate(_terminationDate)} · '
                '${_separationType.label}',
            amount: result.total,
            paramsId: result.parametersId,
            inputs: {
              'salary': salary.cents,
              'hire': hireDate.toUtc().toIso8601String(),
              'termination': _terminationDate.toUtc().toIso8601String(),
              'separation': _separationType.name,
              'taken': takenDays,
              'pending': pendingSalaries.cents,
            },
          ),
        );
    context.push('/finiquito/resultado');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Finiquito')),
      body: FocusTraversalGroup(
        child: ListView(
        padding: AppSpacing.screen.copyWith(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxl,
        ),
        children: [
          Text(
            'Datos de tu finiquito',
            style: textTheme.headlineMedium?.copyWith(color: palette.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Incluye lo que te deben al terminar la relación laboral.',
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            label: 'Fecha de baja',
            value: _terminationDate,
            onTap: _pickTerminationDate,
            helper: 'El último día que trabajaste.',
          ),
          const SizedBox(height: AppSpacing.xl),
          AppChoiceField<SeparationType>(
            label: 'Tipo de salida',
            value: _separationType,
            options: [
              for (final type in SeparationType.values)
                AppChoiceOption(value: type, label: _capitalize(type.label)),
            ],
            helper: 'Solo el despido injustificado genera indemnización.',
            onChanged: (value) {
              setState(() {
                _separationType = value;
                _formError = null;
              });
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            label: 'Días de vacaciones tomados',
            controller: _takenDaysController,
            suffix: 'días',
            helper: 'Deja 0 si no has tomado vacaciones.',
            errorText: _takenDaysError,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) {
              if (_takenDaysError != null) {
                setState(() => _takenDaysError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                setState(() => _advancedOpen = !_advancedOpen);
              },
              icon: Icon(
                _advancedOpen ? Icons.expand_less_rounded : Icons.tune_rounded,
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
              label: 'Salarios pendientes',
              controller: _pendingSalariesController,
              suffix: 'MXN',
              hint: '0.00',
              helper: 'Los días que ya trabajaste y aún no te pagan.',
              errorText: _pendingSalariesError,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              onChanged: (_) {
                if (_pendingSalariesError != null) {
                  setState(() => _pendingSalariesError = null);
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

String _capitalize(String text) =>
    text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}';
