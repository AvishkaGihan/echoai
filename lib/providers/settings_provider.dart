// lib/providers/settings_provider.dart

import 'package:flutter/foundation.dart';

import '../models/settings.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

/// Settings state provider
class SettingsProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  // State
  Settings _settings = Settings.defaultSettings();
  bool _isLoading = false;
  String? _error;

  // ========================================
  // GETTERS
  // ========================================

  /// Current settings
  Settings get settings => _settings;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Error message
  String? get error => _error;

  /// Quick access getters
  String get assistantMode => _settings.assistantMode;
  String get accentColor => _settings.accentColor;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  bool get soundEnabled => _settings.soundEnabled;
  double get voiceSpeed => _settings.voiceSpeed;
  String get themeMode => _settings.themeMode;

  // ========================================
  // INITIALIZATION
  // ========================================

  /// Load settings from database
  Future<void> loadSettings() async {
    _setLoading(true);
    _clearError();

    final result = await _databaseService.getSettings();

    result.when(
      success: (settings) {
        _settings = settings;
        _setLoading(false);
      },
      error: (message) {
        // If error loading, use defaults
        _settings = Settings.defaultSettings();
        _setError(message);
        _setLoading(false);
      },
    );
  }

  // ========================================
  // ASSISTANT MODE
  // ========================================

  /// Set assistant mode
  Future<void> setAssistantMode(String mode) async {
    if (!AppConstants.assistantModes.contains(mode)) {
      _setError('Invalid assistant mode: $mode');
      return;
    }

    _settings = _settings.copyWith(assistantMode: mode);
    notifyListeners();

    await _saveSettings();
  }

  /// Cycle to next assistant mode
  Future<void> cycleAssistantMode() async {
    final currentIndex = AppConstants.assistantModes.indexOf(
      _settings.assistantMode,
    );
    final nextIndex = (currentIndex + 1) % AppConstants.assistantModes.length;
    final nextMode = AppConstants.assistantModes[nextIndex];

    await setAssistantMode(nextMode);
  }

  // ========================================
  // APPEARANCE
  // ========================================

  /// Set accent color
  Future<void> setAccentColor(String color) async {
    if (!AppConstants.accentColors.containsKey(color)) {
      _setError('Invalid accent color: $color');
      return;
    }

    _settings = _settings.copyWith(accentColor: color);
    notifyListeners();

    await _saveSettings();
  }

  /// Set theme mode (for future expansion)
  Future<void> setThemeMode(String mode) async {
    if (mode != 'dark' && mode != 'light') {
      _setError('Invalid theme mode: $mode');
      return;
    }

    _settings = _settings.copyWith(themeMode: mode);
    notifyListeners();

    await _saveSettings();
  }

  // ========================================
  // NOTIFICATIONS
  // ========================================

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    _settings = _settings.copyWith(
      notificationsEnabled: !_settings.notificationsEnabled,
    );
    notifyListeners();

    await _saveSettings();
  }

  /// Set notifications enabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    notifyListeners();

    await _saveSettings();
  }

  // ========================================
  // SOUND & VOICE
  // ========================================

  /// Toggle sound
  Future<void> toggleSound() async {
    _settings = _settings.copyWith(soundEnabled: !_settings.soundEnabled);
    notifyListeners();

    await _saveSettings();
  }

  /// Set sound enabled
  Future<void> setSoundEnabled(bool enabled) async {
    _settings = _settings.copyWith(soundEnabled: enabled);
    notifyListeners();

    await _saveSettings();
  }

  /// Set voice speed
  Future<void> setVoiceSpeed(double speed) async {
    // Clamp speed to valid range
    final clampedSpeed = speed.clamp(
      AppConstants.minVoiceSpeed,
      AppConstants.maxVoiceSpeed,
    );

    _settings = _settings.copyWith(voiceSpeed: clampedSpeed);
    notifyListeners();

    await _saveSettings();
  }

  /// Increase voice speed
  Future<void> increaseVoiceSpeed() async {
    final newSpeed = (_settings.voiceSpeed + 0.25).clamp(
      AppConstants.minVoiceSpeed,
      AppConstants.maxVoiceSpeed,
    );
    await setVoiceSpeed(newSpeed);
  }

  /// Decrease voice speed
  Future<void> decreaseVoiceSpeed() async {
    final newSpeed = (_settings.voiceSpeed - 0.25).clamp(
      AppConstants.minVoiceSpeed,
      AppConstants.maxVoiceSpeed,
    );
    await setVoiceSpeed(newSpeed);
  }

  /// Reset voice speed to default
  Future<void> resetVoiceSpeed() async {
    await setVoiceSpeed(AppConstants.defaultVoiceSpeed);
  }

  // ========================================
  // RESET
  // ========================================

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    _settings = Settings.defaultSettings();
    notifyListeners();

    await _saveSettings();
  }

  /// Reset specific setting category
  Future<void> resetCategory(String category) async {
    switch (category) {
      case 'appearance':
        _settings = _settings.copyWith(
          accentColor: 'purple',
          themeMode: 'dark',
        );
        break;
      case 'voice':
        _settings = _settings.copyWith(
          soundEnabled: true,
          voiceSpeed: AppConstants.defaultVoiceSpeed,
        );
        break;
      case 'notifications':
        _settings = _settings.copyWith(notificationsEnabled: true);
        break;
      case 'assistant':
        _settings = _settings.copyWith(assistantMode: 'productivity');
        break;
    }

    notifyListeners();
    await _saveSettings();
  }

  // ========================================
  // VALIDATION
  // ========================================

  /// Validate current settings
  bool validateSettings() {
    if (!_settings.isValidMode) {
      _setError('Invalid assistant mode');
      return false;
    }

    if (!_settings.isValidColor) {
      _setError('Invalid accent color');
      return false;
    }

    if (!_settings.isValidVoiceSpeed) {
      _setError('Invalid voice speed');
      return false;
    }

    return true;
  }

  // ========================================
  // EXPORT/IMPORT (Future Feature)
  // ========================================

  /// Export settings as Map
  Map<String, dynamic> exportSettings() {
    return _settings.toMap();
  }

  /// Import settings from Map
  Future<void> importSettings(Map<String, dynamic> settingsMap) async {
    try {
      _settings = Settings.fromMap(settingsMap);

      if (!validateSettings()) {
        throw Exception('Invalid settings data');
      }

      notifyListeners();
      await _saveSettings();
    } catch (e) {
      _setError('Failed to import settings: $e');
    }
  }

  // ========================================
  // PRIVATE METHODS
  // ========================================

  /// Save settings to database
  Future<void> _saveSettings() async {
    final result = await _databaseService.saveSettings(_settings);

    result.when(
      success: (_) {
        // Settings saved successfully
        _clearError();
      },
      error: (message) {
        _setError(message);
      },
    );
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _error = null;
  }
}
