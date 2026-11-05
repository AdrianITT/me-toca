import 'dart:convert';

/// Settings persisted in `SharedPreferences`.
///
/// Stored as a single JSON blob under one key so the model can grow without
/// renaming preference keys.
enum AppThemeChoice { system, light, dark }

enum WageZoneChoice { general, border }

extension AppThemeChoiceLabel on AppThemeChoice {
  String get label => switch (this) {
    AppThemeChoice.system => 'Sistema',
    AppThemeChoice.light => 'Claro',
    AppThemeChoice.dark => 'Oscuro',
  };

  String get storageName => name;
}

extension WageZoneChoiceLabel on WageZoneChoice {
  String get label => switch (this) {
    WageZoneChoice.general => 'General',
    WageZoneChoice.border => 'Frontera',
  };

  String get storageName => name;
}

class AppSettings {
  const AppSettings({
    this.theme = AppThemeChoice.system,
    this.zone = WageZoneChoice.general,
    this.pro = false,
    this.consentDone = false,
    this.onboardingSeen = false,
  });

  final AppThemeChoice theme;
  final WageZoneChoice zone;

  /// True once the paid Pro entitlement is confirmed.
  final bool pro;

  /// True once the ads consent message has been shown.
  final bool consentDone;

  /// True once the one-screen onboarding has been dismissed.
  final bool onboardingSeen;

  static const AppSettings defaults = AppSettings();

  Map<String, dynamic> toJson() => {
    'theme': theme.storageName,
    'zone': zone.storageName,
    'pro': pro,
    'consentDone': consentDone,
    'onboardingSeen': onboardingSeen,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      theme: _themeFrom(json['theme']),
      zone: _zoneFrom(json['zone']),
      pro: json['pro'] == true,
      consentDone: json['consentDone'] == true,
      onboardingSeen: json['onboardingSeen'] == true,
    );
  }

  String encode() => jsonEncode(toJson());

  /// A single corrupt value never breaks the app: fall back to defaults.
  static AppSettings decode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return AppSettings.fromJson(decoded);
      }
    } on FormatException {
      return defaults;
    }
    return defaults;
  }

  AppSettings copyWith({
    AppThemeChoice? theme,
    WageZoneChoice? zone,
    bool? pro,
    bool? consentDone,
    bool? onboardingSeen,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      zone: zone ?? this.zone,
      pro: pro ?? this.pro,
      consentDone: consentDone ?? this.consentDone,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
    );
  }
}

AppThemeChoice _themeFrom(Object? value) {
  for (final choice in AppThemeChoice.values) {
    if (choice.storageName == value) {
      return choice;
    }
  }
  return AppThemeChoice.system;
}

WageZoneChoice _zoneFrom(Object? value) {
  for (final choice in WageZoneChoice.values) {
    if (choice.storageName == value) {
      return choice;
    }
  }
  return WageZoneChoice.general;
}
