import 'dart:convert';

import 'package:calc_engine/calc_engine.dart';

/// One stored calculation, exactly the fields the plan defines:
/// id, type, date, inputSummary, amount, paramsId.
///
/// Amounts stay in cents; dates are UTC ISO-8601.
class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.type,
    required this.date,
    required this.inputSummary,
    required this.amount,
    this.paramsId,
  });

  /// Calculator id, for example `aguinaldo`.
  final String id;

  /// Display name, for example `Aguinaldo`.
  final String type;

  final DateTime date;
  final String inputSummary;
  final Money amount;

  /// Validity id of the parameter set used; null for IVA.
  final String? paramsId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'date': date.toUtc().toIso8601String(),
    'inputSummary': inputSummary,
    'amount': amount.cents,
    'paramsId': paramsId,
  };

  /// Lenient parser: malformed records return null and are skipped.
  static HistoryEntry? fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final type = json['type'];
    final dateText = json['date'];
    final inputSummary = json['inputSummary'];
    final amount = json['amount'];
    if (id is! String ||
        type is! String ||
        dateText is! String ||
        inputSummary is! String ||
        amount is! int) {
      return null;
    }
    final date = DateTime.tryParse(dateText);
    if (date == null) {
      return null;
    }
    final paramsId = json['paramsId'];
    return HistoryEntry(
      id: id,
      type: type,
      date: date.toUtc(),
      inputSummary: inputSummary,
      amount: Money(amount),
      paramsId: paramsId is String ? paramsId : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HistoryEntry &&
      other.id == id &&
      other.type == type &&
      other.date == date &&
      other.inputSummary == inputSummary &&
      other.amount == amount &&
      other.paramsId == paramsId;

  @override
  int get hashCode =>
      Object.hash(id, type, date, inputSummary, amount, paramsId);

  @override
  String toString() => 'HistoryEntry($id, ${amount.cents}, $date)';
}

class HistoryStore {
  const HistoryStore();

  static const int freeLimit = 10;

  static const String _key = 'metoca.history.v1';

  /// In-memory key shared with settings storage.
  static const String storageKey = _key;

  /// Most recent first.
  static List<HistoryEntry> decode(String raw) {
    Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      return const [];
    }
    if (decoded is! List) {
      return const [];
    }
    final entries = <HistoryEntry>[];
    for (final item in decoded) {
      if (item is Map<String, dynamic>) {
        final entry = HistoryEntry.fromJson(item);
        if (entry != null) {
          entries.add(entry);
        }
      }
    }
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  static String encode(List<HistoryEntry> entries) =>
      jsonEncode(entries.map((entry) => entry.toJson()).toList());

  /// Inserts at the head and applies the Free cap.
  static List<HistoryEntry> add(
    List<HistoryEntry> current,
    HistoryEntry entry, {
    required bool isPro,
  }) {
    final next = [entry, ...current];
    next.sort((a, b) => b.date.compareTo(a.date));
    return isPro ? next : next.take(freeLimit).toList(growable: false);
  }

  static List<HistoryEntry> removeById(List<HistoryEntry> current, String id) =>
      current.where((entry) => entry.id != id).toList(growable: false);
}
