import 'package:calc_engine/calc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:metoca/app/theme/theme.dart';
import 'package:metoca/features/aguinaldo/aguinaldo_result_view.dart';
import 'package:metoca/features/explanation/explanation_screen.dart';
import 'package:metoca/features/result/calc_result_view.dart';
import 'package:metoca/core/storage/storage_providers.dart';
import 'package:metoca/features/result/result_provider.dart';
import 'package:metoca/features/result/result_screen.dart';

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

Widget _wrap(Widget child, {ThemeData? theme}) {
  return ProviderScope(
    overrides: [
      storageServiceProvider.overrideWithValue(StorageService.forTesting()),
      calcResultProvider.overrideWith(
        () => _FakeResultController(_sampleView),
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

void _useTallScreen(WidgetTester tester, {double height = 844}) {
  tester.view.physicalSize = Size(390, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('golden - result light', (tester) async {
    _useTallScreen(tester, height: 844);
    await tester.pumpWidget(_wrap(const ResultScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/result_light.png'),
    );
  });

  testWidgets('golden - result dark', (tester) async {
    _useTallScreen(tester, height: 844);
    await tester.pumpWidget(
      _wrap(const ResultScreen(), theme: AppTheme.dark()),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/result_dark.png'),
    );
  });

  testWidgets('golden - explanation light', (tester) async {
    _useTallScreen(tester, height: 844);
    await tester.pumpWidget(_wrap(const ExplanationScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/explanation_light.png'),
    );
  });

  testWidgets('golden - explanation dark', (tester) async {
    _useTallScreen(tester, height: 844);
    await tester.pumpWidget(
      _wrap(const ExplanationScreen(), theme: AppTheme.dark()),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/explanation_dark.png'),
    );
  });
}
