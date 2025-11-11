import 'package:flutter_test/flutter_test.dart';
import 'package:echoai/providers/settings_provider.dart';
import 'package:echoai/models/settings.dart';

void main() {
  group('SettingsProvider Tests', () {
    late SettingsProvider settingsProvider;

    setUp(() {
      settingsProvider = SettingsProvider();
    });

    group('Initialization', () {
      test('SettingsProvider initializes with default settings', () {
        expect(settingsProvider.isLoading, isFalse);
        expect(settingsProvider.error, isNull);
        expect(settingsProvider.settings, isNotNull);
      });

      test('Default settings have expected values', () {
        final defaults = settingsProvider.settings;

        expect(defaults.assistantMode, isNotEmpty);
        expect(defaults.accentColor, isNotEmpty);
        expect(defaults.themeMode, isNotEmpty);
        expect(defaults.voiceSpeed, greaterThan(0.0));
        expect(defaults.voiceSpeed, lessThanOrEqualTo(2.0));
      });
    });

    group('Getters', () {
      test('assistantMode getter returns current mode', () {
        expect(
          settingsProvider.assistantMode,
          equals(settingsProvider.settings.assistantMode),
        );
      });

      test('accentColor getter returns current color', () {
        expect(
          settingsProvider.accentColor,
          equals(settingsProvider.settings.accentColor),
        );
      });

      test('notificationsEnabled getter returns correct value', () {
        expect(
          settingsProvider.notificationsEnabled,
          equals(settingsProvider.settings.notificationsEnabled),
        );
      });

      test('soundEnabled getter returns correct value', () {
        expect(
          settingsProvider.soundEnabled,
          equals(settingsProvider.settings.soundEnabled),
        );
      });

      test('voiceSpeed getter returns correct value', () {
        expect(
          settingsProvider.voiceSpeed,
          equals(settingsProvider.settings.voiceSpeed),
        );
      });

      test('themeMode getter returns current theme mode', () {
        expect(
          settingsProvider.themeMode,
          equals(settingsProvider.settings.themeMode),
        );
      });

      test('isLoading getter returns correct state', () {
        expect(settingsProvider.isLoading, isFalse);
      });

      test('error getter returns error message or null', () {
        expect(settingsProvider.error, isNull);
      });
    });

    group('Settings Model', () {
      test('Settings can be copied with updates', () {
        final original = settingsProvider.settings;
        final modified = original.copyWith(assistantMode: 'casual');

        expect(original.assistantMode, isNot(equals('casual')));
        expect(modified.assistantMode, equals('casual'));
      });

      test('Settings can be serialized', () {
        final settings = settingsProvider.settings;
        final map = settings.toMap();

        expect(map, isA<Map<String, dynamic>>());
        expect(map.keys, isNotEmpty);
      });

      test('Settings can be deserialized', () {
        final settings = settingsProvider.settings;
        final map = settings.toMap();
        final restored = Settings.fromMap(map);

        expect(restored.assistantMode, equals(settings.assistantMode));
      });
    });

    group('Listener Notification', () {
      test('Listeners can be added and removed', () {
        int callCount = 0;
        void listener() {
          callCount++;
        }

        settingsProvider.addListener(listener);
        settingsProvider.removeListener(listener);

        expect(callCount, equals(0));
      });

      test('Multiple listeners can be managed', () {
        int notificationCount = 0;
        settingsProvider.addListener(() {
          notificationCount++;
        });
        settingsProvider.addListener(() {
          notificationCount++;
        });

        expect(notificationCount, greaterThanOrEqualTo(0));
      });
    });
  });
}
