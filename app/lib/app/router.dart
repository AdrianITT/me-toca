import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/storage/storage_providers.dart';
import '../features/aguinaldo/aguinaldo_screen.dart';
import '../features/explanation/explanation_screen.dart';
import '../features/finiquito/finiquito_screen.dart';
import '../features/home/home_screen.dart';
import '../features/glossary/glossary_screen.dart';
import '../features/history/history_screen.dart';
import '../features/isr/isr_screen.dart';
import '../features/iva/iva_screen.dart';
import '../features/result/result_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/vacaciones/vacaciones_screen.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _page(state, const HomeScreen()),
      ),
      GoRoute(
        path: '/aguinaldo',
        pageBuilder: (context, state) => _page(state, const AguinaldoScreen()),
      ),
      GoRoute(
        path: '/aguinaldo/resultado',
        pageBuilder: (context, state) => _page(state, const ResultScreen()),
      ),
      GoRoute(
        path: '/aguinaldo/explicacion',
        pageBuilder: (context, state) =>
            _page(state, const ExplanationScreen()),
      ),
      GoRoute(
        path: '/finiquito',
        pageBuilder: (context, state) => _page(state, const FiniquitoScreen()),
      ),
      GoRoute(
        path: '/finiquito/resultado',
        pageBuilder: (context, state) => _page(state, const ResultScreen()),
      ),
      GoRoute(
        path: '/finiquito/explicacion',
        pageBuilder: (context, state) =>
            _page(state, const ExplanationScreen()),
      ),
      GoRoute(
        path: '/vacaciones',
        pageBuilder: (context, state) => _page(state, const VacacionesScreen()),
      ),
      GoRoute(
        path: '/vacaciones/resultado',
        pageBuilder: (context, state) => _page(state, const ResultScreen()),
      ),
      GoRoute(
        path: '/vacaciones/explicacion',
        pageBuilder: (context, state) =>
            _page(state, const ExplanationScreen()),
      ),
      GoRoute(
        path: '/isr',
        pageBuilder: (context, state) => _page(state, const IsrScreen()),
      ),
      GoRoute(
        path: '/isr/resultado',
        pageBuilder: (context, state) => _page(state, const ResultScreen()),
      ),
      GoRoute(
        path: '/isr/explicacion',
        pageBuilder: (context, state) =>
            _page(state, const ExplanationScreen()),
      ),
      GoRoute(
        path: '/iva',
        pageBuilder: (context, state) => _page(state, const IvaScreen()),
      ),
      GoRoute(
        path: '/iva/resultado',
        pageBuilder: (context, state) => _page(state, const ResultScreen()),
      ),
      GoRoute(
        path: '/iva/explicacion',
        pageBuilder: (context, state) =>
            _page(state, const ExplanationScreen()),
      ),
      GoRoute(
        path: '/historial',
        builder: (context, state) => Consumer(
          builder: (context, ref, _) {
            final storage = ref.watch(storageControllerProvider);
            return HistoryScreen(
              entries: storage.history,
              isPro: storage.settings.pro,
              onDelete: (id) => ref
                  .read(storageControllerProvider.notifier)
                  .removeHistory(id),
              onOpen: (entry) {
                final inputs = entry.inputs;
                if (inputs == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Este cálculo no se puede reabrir.'),
                    ),
                  );
                  return;
                }
                ref
                    .read(pendingHistoryInputsProvider.notifier)
                    .set(entry.type, inputs);
                final route = _routeForHistoryType(entry.type);
                if (route != null) {
                  context.push(route);
                }
              },
            );
          },
        ),
      ),
      GoRoute(
        path: '/ajustes',
        builder: (context, state) => Consumer(
          builder: (context, ref, _) {
            final storage = ref.watch(storageControllerProvider);
            final controller = ref.read(storageControllerProvider.notifier);
            return SettingsScreen(
              settings: storage.settings,
              onThemeChanged: (choice) => controller.updateSettings(
                storage.settings.copyWith(theme: choice),
              ),
              onZoneChanged: (choice) => controller.updateSettings(
                storage.settings.copyWith(zone: choice),
              ),
              onProTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('La compra llegará en la próxima versión.'),
                ),
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: '/glosario',
        builder: (context, state) => const GlossaryScreen(),
      ),
    ],
  );
}

String? _routeForHistoryType(String type) => switch (type) {
  'Aguinaldo' => '/aguinaldo',
  'Finiquito' => '/finiquito',
  'Vacaciones' => '/vacaciones',
  'ISR' => '/isr',
  'IVA' => '/iva',
  _ => null,
};

/// 200ms fade plus an 8px rise. No bounce.
Page<void> _page(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 160),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.of(context).disableAnimations) {
        return child;
      }
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
