/// App settings and user preferences
class Settings {
  /// Assistant mode: "productivity", "learning", or "casual"
  final String assistantMode;

  /// Whether push notifications are enabled
  final bool notificationsEnabled;

  /// Accent color: "purple", "pink", "cyan", "lime"
  final String accentColor;

  /// Whether text-to-speech is enabled
  final bool soundEnabled;

  /// Voice speed for text-to-speech (0.5 - 2.0)
  final double voiceSpeed;

  /// Theme mode (for future expansion)
  /// Currently always "dark" for MVP
  final String themeMode;

  const Settings({
    required this.assistantMode,
    required this.notificationsEnabled,
    required this.accentColor,
    this.soundEnabled = true,
    this.voiceSpeed = 1.0,
    this.themeMode = 'dark',
  });

  /// Default settings for new users
  factory Settings.defaultSettings() {
    return const Settings(
      assistantMode: 'productivity',
      notificationsEnabled: true,
      accentColor: 'purple',
      soundEnabled: true,
      voiceSpeed: 1.0,
      themeMode: 'dark',
    );
  }

  /// Create a copy with updated fields
  Settings copyWith({
    String? assistantMode,
    bool? notificationsEnabled,
    String? accentColor,
    bool? soundEnabled,
    double? voiceSpeed,
    String? themeMode,
  }) {
    return Settings(
      assistantMode: assistantMode ?? this.assistantMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      accentColor: accentColor ?? this.accentColor,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      voiceSpeed: voiceSpeed ?? this.voiceSpeed,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  /// Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'assistant_mode': assistantMode,
      'notifications_enabled': notificationsEnabled ? 1 : 0,
      'accent_color': accentColor,
      'sound_enabled': soundEnabled ? 1 : 0,
      'voice_speed': voiceSpeed,
      'theme_mode': themeMode,
    };
  }

  /// Create from Map
  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      assistantMode: map['assistant_mode'] as String? ?? 'productivity',
      notificationsEnabled: (map['notifications_enabled'] as int?) == 1,
      accentColor: map['accent_color'] as String? ?? 'purple',
      soundEnabled: (map['sound_enabled'] as int?) == 1,
      voiceSpeed: (map['voice_speed'] as num?)?.toDouble() ?? 1.0,
      themeMode: map['theme_mode'] as String? ?? 'dark',
    );
  }

  /// Validate assistant mode
  bool get isValidMode {
    return ['productivity', 'learning', 'casual'].contains(assistantMode);
  }

  /// Validate accent color
  bool get isValidColor {
    return ['purple', 'pink', 'cyan', 'lime'].contains(accentColor);
  }

  /// Validate voice speed
  bool get isValidVoiceSpeed {
    return voiceSpeed >= 0.5 && voiceSpeed <= 2.0;
  }

  /// Get assistant mode display name
  String get assistantModeDisplayName {
    switch (assistantMode) {
      case 'productivity':
        return 'Productivity';
      case 'learning':
        return 'Learning';
      case 'casual':
        return 'Casual';
      default:
        return 'Unknown';
    }
  }

  /// Get assistant mode emoji
  String get assistantModeEmoji {
    switch (assistantMode) {
      case 'productivity':
        return '🎯';
      case 'learning':
        return '📚';
      case 'casual':
        return '💬';
      default:
        return '🤖';
    }
  }

  /// Get assistant mode description
  String get assistantModeDescription {
    switch (assistantMode) {
      case 'productivity':
        return 'Focused on tasks, goals, and actionable outcomes';
      case 'learning':
        return 'Patient explanations and educational content';
      case 'casual':
        return 'Friendly conversations and general chat';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Settings(mode: $assistantMode, color: $accentColor, '
        'notifications: $notificationsEnabled, sound: $soundEnabled)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Settings &&
        other.assistantMode == assistantMode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.accentColor == accentColor &&
        other.soundEnabled == soundEnabled &&
        other.voiceSpeed == voiceSpeed &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode {
    return assistantMode.hashCode ^
        notificationsEnabled.hashCode ^
        accentColor.hashCode ^
        soundEnabled.hashCode ^
        voiceSpeed.hashCode ^
        themeMode.hashCode;
  }
}
