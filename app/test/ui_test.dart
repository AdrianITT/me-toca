import 'package:calc_engine/calc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:metoca/app/router.dart';
import 'package:metoca/app/theme/theme.dart';
import 'package:metoca/features/aguinaldo/aguinaldo_result_view.dart';
import 'package:metoca/features/aguinaldo/aguinaldo_screen.dart';
import 'package:metoca/features/explanation/explanation_screen.dart';
import 'package:metoca/features/finiquito/finiquito_result_view.dart';
import 'package:metoca/features/finiquito/finiquito_screen.dart';
import 'package:metoca/features/home/home_screen.dart';
import 'package:metoca/features/isr/isr_result_view.dart';
import 'package:metoca/features/isr/isr_screen.dart';
import 'package:metoca/features/iva/iva_result_view.dart';
import 'package:metoca/features/iva/iva_screen.dart';
import 'package:metoca/features/result/calc_result_view.dart';
import 'package:metoca/features/result/result_provider.dart';
import 'package:metoca/core/storage/storage_providers.dart';
import 'package:metoca/features/result/result_screen.dart';
import 'package:metoca/features/vacaciones/vacaciones_result_view.dart';
import 'package:metoca/features/vacaciones/vacaciones_screen.dart';
import 'package:metoca/shared/widgets/app_money_text.dart';

final _parameters = ParameterRepository.forDate(DateTime.utc(2026, 6, 1))
    .valueOrNull!;

final _sample = calculateAguinaldo(
  AguinaldoInput(
    monthlySalary: const Money(1500000),
    hireDate: DateTime.utc(2020, 1, 1),
    calculationDate: DateTime.utc(2026, 12, 31),
  ),
  _parameters,
).valueOrNull!;

final _sampleView = aguinaldoResultView(_sample);

final _finiquitoInput = FiniquitoInput(
  monthlySalary: const Money(1500000),
  hireDate: DateTime.utc(2024, 3, 1),
  terminationDate: DateTime.utc(2026, 11, 30),
  separationType: SeparationType.unjustifiedDismissal,
  pendingSalaries: const Money(230000),
);

final _finiquitoSample = calculateFiniquito(
  _finiquitoInput,
  _parameters,
).valueOrNull!;

final _finiquitoSampleView = finiquitoResultView(
  _finiquitoSample,
  _finiquitoInput,
);

final _vacacionesSample = calculateVacaciones(
  VacacionesInput(
    hireDate: DateTime.utc(2025, 1, 1),
    cutoffDate: DateTime.utc(2026, 11, 30),
    monthlySalary: const Money(1500000),
  ),
  _parameters,
).valueOrNull!;

final _vacacionesSampleView = vacacionesResultView(_vacacionesSample);

final _isrInput = IsrInput(taxableIncome: const Money(1500000));

final _isrSample = calculateIsr(_isrInput, _parameters).valueOrNull!;

final _isrSampleView = isrResultView(_isrSample, _isrInput);

const _delegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

class _FakeResultController extends CalcResultController {
  _FakeResultController(this.view);

  final CalcResultView view;

  @override
  CalcResultView? build() => view;
}

Widget _wrap(Widget child, {ThemeData? theme, CalcResultView? view}) {
  return ProviderScope(
    overrides: [
      storageServiceProvider.overrideWithValue(StorageService.forTesting()),
      calcResultProvider.overrideWith(
        () => _FakeResultController(view ?? _sampleView),
      ),
    ],
    child: MaterialApp(
      theme: theme ?? AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: const Locale('es', 'MX'),
      supportedLocales: const [Locale('es', 'MX')],
      localizationsDelegates: _delegates,
      home: child,
    ),
  );
}

/// Tall phone viewport so the capture screen and the result fit without
/// scrolling in tests.
void _useTallScreen(WidgetTester tester, {double height = 1400}) {
  tester.view.physicalSize = Size(390, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _pumpRouter(WidgetTester tester, {double height = 1400}) async {
  _useTallScreen(tester, height: height);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(StorageService.forTesting()),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: createAppRouter(),
        locale: const Locale('es', 'MX'),
        supportedLocales: const [Locale('es', 'MX')],
        localizationsDelegates: _delegates,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openAguinaldo(WidgetTester tester) async {
  await tester.tap(find.text('Aguinaldo'));
  await tester.pumpAndSettle();
}

Future<void> _openFiniquito(WidgetTester tester) async {
  await tester.tap(find.text('Finiquito'));
  await tester.pumpAndSettle();
}

Future<void> _openVacaciones(WidgetTester tester) async {
  await tester.tap(find.text('Vacaciones'));
  await tester.pumpAndSettle();
}

Future<void> _openIsr(WidgetTester tester) async {
  await tester.tap(find.text('ISR'));
  await tester.pumpAndSettle();
}

Future<void> _openIva(WidgetTester tester) async {
  await tester.tap(find.text('IVA'));
  await tester.pumpAndSettle();
}

/// Opens a date field and confirms the date the picker already selected.
Future<void> _pickInitialDate(WidgetTester tester, Finder field) async {
  await tester.tap(field);
  await tester.pumpAndSettle();
  await tester.tap(find.text('ACEPTAR'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_MX');
  });

  testWidgets('home shows the five calculators and the legal notice', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: createAppRouter(),
          locale: const Locale('es', 'MX'),
          supportedLocales: const [Locale('es', 'MX')],
          localizationsDelegates: _delegates,
        ),
      ),
    );

    expect(find.text('¿Cuánto te toca?'), findsOneWidget);
    expect(find.text('Aguinaldo'), findsOneWidget);
    expect(find.text('Finiquito'), findsOneWidget);
    expect(find.text('Vacaciones'), findsOneWidget);
    expect(find.text('ISR'), findsOneWidget);
    expect(find.text('IVA'), findsOneWidget);
    expect(find.text('Pronto'), findsNothing);
    expect(find.textContaining('No sustituye asesoría legal'), findsOneWidget);
  });

  testWidgets('tapping Aguinaldo opens the capture screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: createAppRouter(),
          locale: const Locale('es', 'MX'),
          supportedLocales: const [Locale('es', 'MX')],
          localizationsDelegates: _delegates,
        ),
      ),
    );

    await tester.tap(find.text('Aguinaldo'));
    await tester.pumpAndSettle();

    expect(find.text('Datos de tu aguinaldo'), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);
    expect(find.text('Fecha de ingreso'), findsOneWidget);
  });

  testWidgets('aguinaldo form validates salary and hire date', (tester) async {
    await _pumpRouter(tester);
    await _openAguinaldo(tester);

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe tu salario mensual.'), findsOneWidget);
    expect(find.text('Elige tu fecha de ingreso.'), findsOneWidget);
    expect(find.text('Datos de tu aguinaldo'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '15,000');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe tu salario mensual.'), findsNothing);
    expect(find.text('Elige tu fecha de ingreso.'), findsOneWidget);
    expect(find.text('Datos de tu aguinaldo'), findsOneWidget);
  });

  testWidgets('a valid form computes the aguinaldo and explains it', (
    tester,
  ) async {
    await _pumpRouter(tester);
    await _openAguinaldo(tester);

    await tester.enterText(find.byType(TextField).first, '15,000');
    await _pickInitialDate(tester, find.text('Elige una fecha'));

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Te tocan'), findsOneWidget);
    expect(find.text('Salario diario'), findsOneWidget);

    final explanationButton = find.text('¿Cómo se calculó?');
    await tester.ensureVisible(explanationButton);
    await tester.pumpAndSettle();
    await tester.tap(explanationButton);
    await tester.pumpAndSettle();

    expect(find.text('Tu aguinaldo, paso a paso'), findsOneWidget);
    expect(find.text('Artículo 87 LFT'), findsOneWidget);
    expect(find.textContaining('Tablas vigentes'), findsOneWidget);
  });

  testWidgets('finiquito form validates and computes the full separation', (
    tester,
  ) async {
    await _pumpRouter(tester, height: 2600);
    await _openFiniquito(tester);

    expect(find.text('Datos de tu finiquito'), findsOneWidget);

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe tu salario mensual.'), findsOneWidget);
    expect(find.text('Elige tu fecha de ingreso.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '15,000');
    await _pickInitialDate(tester, find.text('Elige una fecha'));

    await tester.tap(find.text('Renuncia'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Despido injustificado'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('de finiquito y liquidación'), findsOneWidget);
    expect(find.text('Subtotal del finiquito'), findsOneWidget);
    expect(find.text('Prima de antigüedad'), findsOneWidget);
    expect(find.text('Indemnización'), findsOneWidget);

    await tester.tap(find.text('¿Cómo se calculó?'));
    await tester.pumpAndSettle();

    expect(find.text('Tu finiquito, paso a paso'), findsOneWidget);
    expect(find.text('Artículo 162 LFT'), findsOneWidget);
    expect(find.text('Artículos 48 y 50 LFT'), findsOneWidget);
  });

  testWidgets('vacaciones form validates and computes days and premium', (
    tester,
  ) async {
    await _pumpRouter(tester, height: 2600);
    await _openVacaciones(tester);

    expect(find.text('Datos de tus vacaciones'), findsOneWidget);

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe tu salario mensual.'), findsOneWidget);
    expect(find.text('Elige tu fecha de ingreso.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '15,000');
    await _pickInitialDate(tester, find.text('Elige una fecha'));

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('de vacaciones'), findsOneWidget);
    expect(find.text('Días pendientes'), findsOneWidget);
    expect(find.text('Prima vacacional'), findsOneWidget);
    expect(find.text('PRÓXIMOS AÑOS'), findsOneWidget);

    await tester.tap(find.text('¿Cómo se calculó?'));
    await tester.pumpAndSettle();

    expect(find.text('Tus vacaciones, paso a paso'), findsOneWidget);
    expect(find.text('Artículo 76 LFT'), findsOneWidget);
    expect(find.text('Artículo 80 LFT'), findsOneWidget);
  });

  testWidgets('vacaciones result shows days, pay and the next years table', (
    tester,
  ) async {
    _useTallScreen(tester, height: 2200);
    await tester.pumpWidget(
      _wrap(const ResultScreen(), view: _vacacionesSampleView),
    );
    await tester.pumpAndSettle();

    expect(find.text('de vacaciones'), findsOneWidget);
    expect(find.text('Días que te corresponden'), findsOneWidget);
    expect(find.text('Días tomados'), findsOneWidget);
    expect(find.text('Días pendientes'), findsOneWidget);
    expect(find.text('Pago de vacaciones'), findsOneWidget);
    expect(find.text('PRÓXIMOS AÑOS'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('isr form computes withholding and explains the bracket', (
    tester,
  ) async {
    await _pumpRouter(tester, height: 2600);
    await _openIsr(tester);

    expect(find.text('Datos de tu ISR'), findsOneWidget);

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe tu ingreso del periodo.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '15,000');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Te retienen'), findsOneWidget);
    expect(find.text('de ISR mensual'), findsOneWidget);
    expect(find.text('ISR a retener'), findsOneWidget);
    expect(find.text('Tasa efectiva'), findsOneWidget);
    expect(find.text('Ingreso neto estimado'), findsOneWidget);

    await tester.tap(find.text('¿Cómo se calculó?'));
    await tester.pumpAndSettle();

    expect(find.text('Tu ISR, paso a paso'), findsOneWidget);
    expect(find.text('Artículo 96 LISR'), findsOneWidget);
    expect(find.text('Decreto de subsidio al empleo'), findsOneWidget);
  });

  testWidgets('isr result shows the withholding and the effective rate', (
    tester,
  ) async {
    _useTallScreen(tester, height: 2200);
    await tester.pumpWidget(_wrap(const ResultScreen(), view: _isrSampleView));
    await tester.pumpAndSettle();

    expect(find.text('Te retienen'), findsOneWidget);
    expect(find.text('de ISR mensual'), findsOneWidget);
    expect(find.text('Subsidio al empleo'), findsOneWidget);
    expect(find.text('Tasa efectiva'), findsOneWidget);
    expect(find.text('Ingreso neto estimado'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('iva form adds tax and explains the rate', (tester) async {
    await _pumpRouter(tester, height: 2600);
    await _openIva(tester);

    expect(find.text('Datos de tu IVA'), findsOneWidget);

    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe el monto.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '1,000');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Total'), findsNWidgets(2));
    expect(find.text('total con IVA'), findsOneWidget);
    expect(find.text('Subtotal'), findsOneWidget);
    expect(find.text('Vigente'), findsNothing);

    await tester.tap(find.text('¿Cómo se calculó?'));
    await tester.pumpAndSettle();

    expect(find.text('Tu IVA, paso a paso'), findsOneWidget);
    expect(find.text('Artículo 2 LIVA'), findsOneWidget);
    expect(find.text('Artículo 9 LIVA'), findsOneWidget);
  });

  testWidgets('iva zero and exempt explain the difference', (tester) async {
    _useTallScreen(tester, height: 1600);

    await tester.pumpWidget(
      _wrap(
        const ResultScreen(),
        view: ivaResultView(
          calculateIva(
            const IvaInput(amount: Money(100000), rate: IvaRate.zero),
          ).valueOrNull!,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text(
        'La tasa 0% es un acto gravado: no se cobra IVA, pero la operación '
        'se declara.',
      ),
      findsOneWidget,
    );
    expect(find.text('total con IVA'), findsOneWidget);

    // Tear the tree down so the provider is rebuilt with the exempt view.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      _wrap(
        const ResultScreen(),
        view: ivaResultView(
          calculateIva(
            const IvaInput(amount: Money(100000), rate: IvaRate.exempt),
          ).valueOrNull!,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Exento significa que la operación no causa IVA. No es lo mismo que '
        'la tasa 0%.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('finiquito result separates finiquito from liquidation', (
    tester,
  ) async {
    _useTallScreen(tester, height: 2000);
    await tester.pumpWidget(
      _wrap(const ResultScreen(), view: _finiquitoSampleView),
    );
    await tester.pumpAndSettle();

    expect(find.text('Te tocan'), findsOneWidget);
    expect(find.text('de finiquito y liquidación'), findsOneWidget);
    expect(find.text('Subtotal del finiquito'), findsOneWidget);
    expect(find.text('Prima de antigüedad'), findsOneWidget);
    expect(find.text('Indemnización'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('finiquito explanation cites every legal source', (tester) async {
    _useTallScreen(tester, height: 2600);
    await tester.pumpWidget(
      _wrap(const ExplanationScreen(), view: _finiquitoSampleView),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tu finiquito, paso a paso'), findsOneWidget);
    expect(find.text('Artículos 76 y 80 LFT'), findsOneWidget);
    expect(find.text('Artículo 162 LFT'), findsOneWidget);
    expect(find.text('Artículos 48 y 50 LFT'), findsOneWidget);
    expect(find.textContaining('Tablas vigentes'), findsOneWidget);
  });

  testWidgets('result shows the hero amount and the breakdown', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(_wrap(const ResultScreen()));

      expect(find.text('Te tocan'), findsOneWidget);
      expect(find.byType(AppMoneyText), findsWidgets);
      expect(
        find.bySemanticsLabel(RegExp('siete mil quinientos pesos')),
        findsWidgets,
      );
      expect(find.text('Salario diario'), findsOneWidget);
      expect(find.text('Parte exenta'), findsOneWidget);
      expect(find.text('Parte gravada'), findsOneWidget);
      expect(find.text('¿Cómo se calculó?'), findsOneWidget);
    } finally {
      // The binding verifies handles before tearDown callbacks run.
      semantics.dispose();
    }
  });

  testWidgets('explanation lists every step and the legal sources', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap(const ExplanationScreen()));

    expect(find.text('Tu aguinaldo, paso a paso'), findsOneWidget);
    expect(find.text('Artículo 87 LFT'), findsOneWidget);
    expect(find.text('Artículo 93 LISR'), findsOneWidget);
    expect(find.textContaining('Tablas vigentes'), findsOneWidget);
    for (final step in _sample.steps) {
      expect(find.text(step.label), findsOneWidget);
    }
  });

  testWidgets('result and explanation survive dark mode and 200% text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: const ResultScreen(),
          ),
        ),
        theme: AppTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: const ExplanationScreen(),
          ),
        ),
        theme: AppTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty result state sends the user back to the calculator', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppTheme.light(), home: const ResultScreen()),
      ),
    );

    expect(find.text('Todavía no hay un cálculo'), findsOneWidget);
    expect(find.text('Ver calculadoras'), findsOneWidget);
  });

  testWidgets('home builds in light and dark without exceptions', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const HomeScreen()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(_wrap(const HomeScreen(), theme: AppTheme.dark()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('home and capture survive 200% text', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: const HomeScreen(),
          ),
        ),
        theme: AppTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: const AguinaldoScreen(),
          ),
        ),
        theme: AppTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: const FiniquitoScreen(),
          ),
        ),
        theme: AppTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: const VacacionesScreen(),
          ),
        ),
        theme: AppTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: const IsrScreen(),
          ),
        ),
        theme: AppTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: const IvaScreen(),
          ),
        ),
        theme: AppTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
