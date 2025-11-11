import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ========================================
  // APP INFO
  // ========================================
  static const String appName = 'EchoAI';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'AI-powered personal assistant with voice and text';

  // ========================================
  // COLOR PALETTE - Futuristic Bold Theme
  // ========================================

  /// Primary purple color
  static const Color primaryPurple = Color(0xFFA78BFA);

  /// Accent cyan color
  static const Color accentCyan = Color(0xFF22D3EE);

  /// Accent pink color
  static const Color accentPink = Color(0xFFF43F5E);

  /// Dark base background
  static const Color darkBase = Color(0xFF1E293B);

  /// Neutral background (darkest)
  static const Color neutralBackground = Color(0xFF0F172A);

  /// Neutral surface (cards, panels)
  static const Color neutralSurface = Color(0xFF1E293B);

  /// Text primary color
  static const Color textPrimary = Color(0xFFE2E8F0);

  /// Text secondary color
  static const Color textSecondary = Color(0xFF94A3B8);

  /// Border color
  static const Color borderColor = Color(0xFF334155);

  /// Success color
  static const Color successColor = Color(0xFF10B981);

  /// Warning color
  static const Color warningColor = Color(0xFFF59E0B);

  /// Error color
  static const Color errorColor = Color(0xFFEF4444);

  // ========================================
  // ACCENT COLOR OPTIONS
  // ========================================
  static const Map<String, Color> accentColors = {
    'purple': Color(0xFFA78BFA),
    'pink': Color(0xFFF43F5E),
    'cyan': Color(0xFF22D3EE),
    'lime': Color(0xFF84CC16),
  };

  // ========================================
  // TYPOGRAPHY
  // ========================================
  static const double fontSizeH1 = 28.0;
  static const double fontSizeH2 = 22.0;
  static const double fontSizeH3 = 18.0;
  static const double fontSizeBody = 16.0;
  static const double fontSizeLabel = 14.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeTiny = 11.0;

  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightRegular = FontWeight.w400;

  // ========================================
  // SPACING (8px Grid System)
  // ========================================
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2xl = 48.0;

  // ========================================
  // BORDER RADIUS
  // ========================================
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusRound = 999.0;

  // ========================================
  // ANIMATION DURATIONS
  // ========================================
  static const Duration animationFast = Duration(milliseconds: 100);
  static const Duration animationNormal = Duration(milliseconds: 200);
  static const Duration animationSlow = Duration(milliseconds: 300);
  static const Duration animationTyping = Duration(milliseconds: 600);

  // ========================================
  // LAYOUT DIMENSIONS
  // ========================================
  static const double bottomNavHeight = 56.0;
  static const double inputFieldHeight = 56.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double iconSizeLarge = 32.0;

  /// Minimum safe touch target size
  static const double minTouchTarget = 48.0;

  /// Maximum message bubble width (percentage)
  static const double maxMessageWidth = 0.75;

  // ========================================
  // ASSISTANT MODES
  // ========================================
  static const String modeProductivity = 'productivity';
  static const String modeLearning = 'learning';
  static const String modeCasual = 'casual';

  static const List<String> assistantModes = [
    modeProductivity,
    modeLearning,
    modeCasual,
  ];

  static const Map<String, String> modeEmojis = {
    modeProductivity: '🎯',
    modeLearning: '📚',
    modeCasual: '💬',
  };

  static const Map<String, String> modeDescriptions = {
    modeProductivity: 'Focused on tasks, goals, and actionable outcomes',
    modeLearning: 'Patient explanations and educational content',
    modeCasual: 'Friendly conversations and general chat',
  };

  // ========================================
  // GEMINI API CONFIGURATION
  // ========================================
  static const String geminiModel = 'gemini-2.0-flash-exp';
  static const int maxTokens = 1000;
  static const double temperature = 0.7;
  static const int apiTimeoutSeconds = 30;

  /// Rate limit: 15 requests per minute (free tier)
  static const int rateLimitPerMinute = 15;

  // ========================================
  // SYSTEM PROMPTS (Per Assistant Mode)
  // ========================================
  static const String promptProductivity = '''
You are a focused productivity assistant. Your responses should be:
- Concise and action-oriented
- Focused on goals, tasks, and deliverables
- Provide clear next steps
- Help users prioritize and organize
- Use bullet points for clarity
Keep responses under 200 words unless more detail is specifically requested.
''';

  static const String promptLearning = '''
You are a patient educational assistant. Your responses should be:
- Break down complex topics into simple concepts
- Ask clarifying questions to understand the user's level
- Provide examples and analogies
- Build understanding progressively
- Encourage questions and exploration
Be thorough but avoid overwhelming the user. Use a friendly, encouraging tone.
''';

  static const String promptCasual = '''
You are a friendly, conversational assistant. Your responses should be:
- Natural and personable
- Encouraging dialogue and exploration
- Share interesting perspectives
- Use a lighter, more playful tone
- Feel like chatting with a knowledgeable friend
Keep the conversation flowing naturally. Be helpful but not overly formal.
''';

  // ========================================
  // VOICE SETTINGS
  // ========================================
  static const double defaultVoiceSpeed = 1.0;
  static const double minVoiceSpeed = 0.5;
  static const double maxVoiceSpeed = 2.0;

  /// Auto-stop recording after silence (milliseconds)
  static const int silenceThresholdMs = 2000;

  /// Maximum recording duration (milliseconds)
  static const int maxRecordingMs = 60000; // 1 minute

  // ========================================
  // DATABASE
  // ========================================
  static const String dbName = 'echoai.db';
  static const int dbVersion = 1;

  /// Maximum conversations to load at once
  static const int conversationPageSize = 50;

  /// Maximum messages to load per conversation
  static const int messagePageSize = 100;

  // ========================================
  // VALIDATION
  // ========================================
  static const int minPasswordLength = 8;
  static const int maxMessageLength = 5000;
  static const int maxConversationTitleLength = 100;

  // ========================================
  // UI TEXT
  // ========================================
  static const String emptyConversationsMessage = 'No conversations yet';
  static const String emptyConversationsHint = 'Start your first chat!';
  static const String emptyMessagesHint = 'Type something...';
  static const String typingIndicator = 'AI is typing...';
  static const String loadingMessage = 'Loading...';
  static const String errorGeneric = 'Something went wrong';
  static const String errorNetwork = 'Network error. Check your connection.';
  static const String errorTimeout = 'Request timed out. Try again.';
  static const String successCopied = '✓ Copied to clipboard!';

  // ========================================
  // ROUTES
  // ========================================
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routePasswordReset = '/password-reset';
  static const String routeChat = '/chat';
  static const String routeHistory = '/history';
  static const String routeSettings = '/settings';

  // ========================================
  // SHARED PREFERENCES KEYS
  // ========================================
  static const String keyAssistantMode = 'assistant_mode';
  static const String keyAccentColor = 'accent_color';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyVoiceSpeed = 'voice_speed';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLastOpenedChat = 'last_opened_chat';
  static const String keyFirstLaunch = 'first_launch';

  // ========================================
  // ERROR MESSAGES
  // ========================================
  static const String errorInvalidEmail = 'Please enter a valid email address';
  static const String errorPasswordTooShort =
      'Password must be at least 8 characters';
  static const String errorPasswordsDoNotMatch = 'Passwords do not match';
  static const String errorEmailAlreadyInUse =
      'This email is already registered';
  static const String errorUserNotFound = 'No account found with this email';
  static const String errorWrongPassword = 'Incorrect password';
  static const String errorWeakPassword =
      'Password is too weak. Use a mix of letters, numbers, and symbols';
  static const String errorNetworkRequest = 'Network error. Please try again.';
  static const String errorTooManyRequests =
      'Too many attempts. Please try again later.';

  // ========================================
  // SUCCESS MESSAGES
  // ========================================
  static const String successAccountCreated = 'Account created successfully!';
  static const String successPasswordReset =
      'Password reset email sent. Check your inbox.';
  static const String successLogout = 'Logged out successfully';
  static const String successMessageSent = 'Message sent';
  static const String successConversationDeleted = 'Conversation deleted';

  // ========================================
  // CONFIRMATION MESSAGES
  // ========================================
  static const String confirmDeleteConversation =
      'This conversation will be permanently deleted. This cannot be undone.';
  static const String confirmDeleteAllConversations =
      'All conversations will be permanently deleted. This cannot be undone.';
  static const String confirmDeleteAccount =
      'Your account and all data will be permanently deleted. This cannot be undone.';
  static const String confirmLogout = 'Are you sure you want to log out?';

  // ========================================
  // HELPER METHODS
  // ========================================

  /// Get accent color from string name
  static Color getAccentColor(String colorName) {
    return accentColors[colorName] ?? primaryPurple;
  }

  /// Get system prompt for assistant mode
  static String getSystemPrompt(String mode) {
    switch (mode) {
      case modeProductivity:
        return promptProductivity;
      case modeLearning:
        return promptLearning;
      case modeCasual:
        return promptCasual;
      default:
        return promptProductivity;
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password strength
  static bool isValidPassword(String password) {
    return password.length >= minPasswordLength;
  }

  /// Format timestamp to readable string
  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
