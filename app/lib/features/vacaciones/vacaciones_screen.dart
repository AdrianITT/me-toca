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
import 'vacaciones_result_view.dart';

class VacacionesScreen extends ConsumerStatefulWidget {
  const VacacionesScreen({super.key});

  @override
  ConsumerState<VacacionesScreen> createState() => _VacacionesScreenState();
}

class _VacacionesScreenState extends ConsumerState<VacacionesScreen> {
  final _salaryController = TextEditingController();
  final _takenDaysController = TextEditingController(text: '0');
  final _salaryFocus = FocusNode();

  DateTime? _hireDate;
  late DateTime _cutoffDate;

  String? _salaryError;
  String? _hireError;
  String? _takenDaysError;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _cutoffDate = dateOnly(DateTime.now());

    final pending = ref.read(pendingHistoryInputsProvider);
    if (pending != null && pending.type == 'Vacaciones') {
      final i = pending.inputs;
      final salaryCents = i['salary'];
      if (salaryCents is int) {
        _salaryController.text = formatMoney(Money(salaryCents));
      }
      final hire = i['hire'];
      if (hire is String) {
        _hireDate = dateOnly(DateTime.parse(hire));
      }
      final cutoff = i['cutoff'];
      if (cutoff is String) {
        _cutoffDate = dateOnly(DateTime.parse(cutoff));
      }
      final taken = i['taken'];
      if (taken is int) {
        _takenDaysController.text = taken.toString();
      }
      ref.read(pendingHistoryInputsProvider.notifier).clear();
    }
  }

  @override
  void dispose() {
    _salaryController.dispose();
    _takenDaysController.dispose();
    _salaryFocus.dispose();
    super.dispose();
  }

  Future<void> _pickHireDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _hireDate ?? DateTime(now.year - 2, now.month, now.day),
      firstDate: DateTime(1960),
      lastDate: _cutoffDate,
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

  Future<void> _pickCutoffDate() async {
    final firstDate = _hireDate ?? DateTime(1960);
    final picked = await showDatePicker(
      context: context,
      initialDate: _cutoffDate.isBefore(firstDate) ? firstDate : _cutoffDate,
      firstDate: firstDate,
      lastDate: dateOnly(DateTime.now()),
      helpText: 'Fecha de corte',
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _cutoffDate = dateOnly(picked);
      _formError = null;
    });
  }

  void _fillExample() {
    setState(() {
      _salaryController.text = '15,000.00';
      _hireDate = DateTime.utc(2025, 1, 1);
      _cutoffDate = DateTime.utc(2026, 11, 30);
      _takenDaysController.text = '0';
      _salaryError = null;
      _hireError = null;
      _takenDaysError = null;
      _formError = null;
    });
  }

  void _calculate() {
    FocusScope.of(context).unfocus();

    final salary = parseMoneyInput(_salaryController.text);
    final takenDays = int.tryParse(_takenDaysController.text.trim());

    final salaryError = _salaryController.text.trim().isEmpty
        ? 'Escribe tu salario mensual.'
        : (salary == null || !salary.isPositive)
        ? 'Escribe un monto mayor a cero. Ejemplo: 15,000.00.'
        : null;
    final hireError = _hireDate == null ? 'Elige tu fecha de ingreso.' : null;
    final takenDaysError = takenDays == null
        ? 'Escribe un número de días.'
        : null;

    setState(() {
      _salaryError = salaryError;
      _hireError = hireError;
      _takenDaysError = takenDaysError;
      _formError = null;
    });

    if (salaryError != null) {
      _salaryFocus.requestFocus();
      return;
    }
    if (hireError != null || takenDaysError != null) {
      return;
    }

    HapticFeedback.mediumImpact();
    final parametersOutcome = ParameterRepository.forDate(_cutoffDate);
    if (parametersOutcome.isFailure) {
      setState(() => _formError = parametersOutcome.errorOrNull!.message);
      return;
    }

    final outcome = calculateVacaciones(
      VacacionesInput(
        hireDate: _hireDate!,
        cutoffDate: _cutoffDate,
        monthlySalary: salary!,
        takenDays: takenDays!,
      ),
      parametersOutcome.valueOrNull!,
    );

    if (outcome.isFailure) {
      setState(() => _formError = outcome.errorOrNull!.message);
      return;
    }

    final hireDate = _hireDate!;
    ref
        .read(calcResultProvider.notifier)
        .update(vacacionesResultView(outcome.valueOrNull!));
    ref
        .read(storageControllerProvider.notifier)
        .addHistory(
          HistoryEntry(
            id: 'vacaciones_${DateTime.now().microsecondsSinceEpoch}',
            type: 'Vacaciones',
            date: _cutoffDate,
            inputSummary:
                'Salario ${formatMoney(salary)} · '
                '${formatShortDate(hireDate)} → ${formatShortDate(_cutoffDate)}',
            amount: outcome.valueOrNull!.total,
            paramsId: outcome.valueOrNull!.parametersId,
            inputs: {
              'salary': salary.cents,
              'hire': hireDate.toUtc().toIso8601String(),
              'cutoff': _cutoffDate.toUtc().toIso8601String(),
              'taken': takenDays,
            },
          ),
        );
    context.push('/vacaciones/resultado');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Vacaciones')),
      body: ListView(
        padding: AppSpacing.screen.copyWith(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxl,
        ),
        children: [
          Text(
            'Datos de tus vacaciones',
            style: textTheme.headlineMedium?.copyWith(color: palette.ink),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Días que te tocan, pago y prima vacacional.',
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
            label: 'Fecha de corte',
            value: _cutoffDate,
            onTap: _pickCutoffDate,
            helper: 'Hoy o el día que quieres calcular.',
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
