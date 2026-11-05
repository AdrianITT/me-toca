import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';
import 'history_entry.dart';

/// Loads and saves settings and history with `SharedPreferences`.
///
/// Stored as one JSON blob per key. Load failures fall back to defaults.
class StorageService {
  const StorageService(this._preferences);

  static Future<StorageService> create() async {
    final preferences = await SharedPreferences.getInstance();
    return StorageService(preferences);
  }

  static const String _settingsKey = 'metoca.settings.v1';

  static const String _historyKey = HistoryStore.storageKey;

  factory StorageService.forTesting() => StorageService._inMemory();

  StorageService._inMemory() : _preferences = InMemoryPreferences();

  final Object _preferences;

  AppSettings loadSettings() {
    final raw = _read(_settingsKey);
    return raw == null ? AppSettings.defaults : AppSettings.decode(raw);
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _write(_settingsKey, settings.encode());
  }

  List<HistoryEntry> loadHistory() {
    final raw = _read(_historyKey);
    return raw == null ? const [] : HistoryStore.decode(raw);
  }

  Future<void> saveHistory(List<HistoryEntry> entries) async {
    await _write(_historyKey, HistoryStore.encode(entries));
  }

  String? _read(String key) {
    final prefs = _preferences;
    if (prefs is SharedPreferences) {
      return prefs.getString(key);
    }
    return (prefs as InMemoryPreferences).read(key);
  }

  Future<void> _write(String key, String value) async {
    final prefs = _preferences;
    if (prefs is SharedPreferences) {
      await prefs.setString(key, value);
    } else {
      (prefs as InMemoryPreferences).write(key, value);
    }
  }
}

class InMemoryPreferences {
  final Map<String, String> _values = {};

  String? read(String key) => _values[key];

  void write(String key, String value) => _values[key] = value;
}

class StorageController
    extends Notifier<({AppSettings settings, List<HistoryEntry> history})> {
  @override
  ({AppSettings settings, List<HistoryEntry> history}) build() {
    final service = ref.watch(storageServiceProvider);
    return (settings: service.loadSettings(), history: service.loadHistory());
  }

  Future<void> updateSettings(AppSettings settings) async {
    state = (settings: settings, history: state.history);
    await ref.read(storageServiceProvider).saveSettings(settings);
  }

  Future<void> addHistory(HistoryEntry entry) async {
    final next = HistoryStore.add(
      state.history,
      entry,
      isPro: state.settings.pro,
    );
    state = (settings: state.settings, history: next);
    await ref.read(storageServiceProvider).saveHistory(next);
  }

  /// Becoming Pro keeps everything; going back to Free trims to the cap.
  Future<void> applyPro(bool pro) async {
    final settings = state.settings.copyWith(pro: pro);
    final history = pro
        ? state.history
        : state.history.take(HistoryStore.freeLimit).toList(growable: false);
    state = (settings: settings, history: history);
    await ref.read(storageServiceProvider).saveSettings(settings);
    await ref.read(storageServiceProvider).saveHistory(history);
  }

  Future<void> removeHistory(String id) async {
    final next = HistoryStore.removeById(state.history, id);
    state = (settings: state.settings, history: next);
    await ref.read(storageServiceProvider).saveHistory(next);
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('Override with a real or fake StorageService');
});

final storageControllerProvider =
    NotifierProvider<
      StorageController,
      ({AppSettings settings, List<HistoryEntry> history})
    >(StorageController.new);

/// Holds inputs captured from a history row so the matching calculator can
/// reopen them. Consumed (and cleared) by that calculator's screen.
class PendingHistoryInputs
    extends Notifier<({String type, Map<String, dynamic> inputs})?> {
  @override
  ({String type, Map<String, dynamic> inputs})? build() => null;

  void set(String type, Map<String, dynamic> inputs) =>
      state = (type: type, inputs: inputs);

  void clear() => state = null;
}

final pendingHistoryInputsProvider =
    NotifierProvider<
      PendingHistoryInputs,
      ({String type, Map<String, dynamic> inputs})?
    >(PendingHistoryInputs.new);
