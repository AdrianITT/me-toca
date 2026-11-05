import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/router.dart';
import 'app/theme/app_colors.dart';
import 'app/theme/app_spacing.dart';
import 'app/theme/app_typography.dart';
import 'app/theme/theme.dart';
import 'core/storage/app_settings.dart';
import 'core/storage/storage_providers.dart';
import 'features/history/history_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/settings/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _SplashScreen());
  await initializeDateFormatting('es_MX');
  final storageService = await StorageService.create();
  runApp(
    ProviderScope(
      overrides: [storageServiceProvider.overrideWithValue(storageService)],
      child: const MeTocaApp(),
    ),
  );
}

/// Riverpod-friendly route hosts that need live storage state. Those pages
/// are built by the router into simple hosts so the router file stays thin.
class SettingsRoute extends ConsumerWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageControllerProvider);
    final controller = ref.read(storageControllerProvider.notifier);

    return SettingsScreen(
      settings: storage.settings,
      onThemeChanged: (choice) =>
          controller.updateSettings(storage.settings.copyWith(theme: choice)),
      onZoneChanged: (choice) =>
          controller.updateSettings(storage.settings.copyWith(zone: choice)),
      onProTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La compra llegará en la próxima versión.'),
        ),
      ),
    );
  }
}

class HistoryRoute extends ConsumerWidget {
  const HistoryRoute({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageControllerProvider);

    return HistoryScreen(
      entries: storage.history,
      isPro: storage.settings.pro,
      onDelete: (id) =>
          ref.read(storageControllerProvider.notifier).removeHistory(id),
    );
  }
}

class MeTocaApp extends ConsumerStatefulWidget {
  const MeTocaApp({super.key});

  @override
  ConsumerState<MeTocaApp> createState() => _MeTocaAppState();
}

class _MeTocaAppState extends ConsumerState<MeTocaApp> {
  late final _router = createAppRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  Future<void> _markOnboardingSeen() async {
    final controller = ref.read(storageControllerProvider.notifier);
    await controller.updateSettings(
      ref
          .read(storageControllerProvider)
          .settings
          .copyWith(onboardingSeen: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(storageControllerProvider).settings;

    return MaterialApp.router(
      title: 'Me Toca',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (settings.theme) {
        AppThemeChoice.system => ThemeMode.system,
        AppThemeChoice.light => ThemeMode.light,
        AppThemeChoice.dark => ThemeMode.dark,
      },
      routerConfig: _router,
      locale: const Locale('es', 'MX'),
      supportedLocales: const [Locale('es', 'MX')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        if (settings.onboardingSeen) {
          return child!;
        }
        return OnboardingScreen(onDone: _markOnboardingSeen);
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDark = brightness == Brightness.dark;

    final canvas = isDark ? AppColors.darkCanvas : AppColors.lightCanvas;
    final primarySoft = isDark
        ? AppColors.darkPrimarySoft
        : AppColors.lightPrimarySoft;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final inkMuted = isDark ? AppColors.darkInkMuted : AppColors.lightInkMuted;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? AppTheme.dark() : AppTheme.light(),
      home: Scaffold(
        backgroundColor: canvas,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: primarySoft,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(
                  Icons.card_giftcard_rounded,
                  size: 44,
                  color: primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'ME TOCA',
                style: AppTypography.textTheme.labelMedium?.copyWith(
                  color: primary,
                  letterSpacing: 2.4,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Lo que te toca, claro y sin jerga',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
