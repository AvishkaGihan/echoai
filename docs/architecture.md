# EchoAI Architecture Document

**Author:** Winston (Architect Agent)
**Date:** November 12, 2025
**Version:** 1.0
**Status:** ✅ Decision Locked - Ready for Implementation

---

## Executive Summary

EchoAI uses a **simple, clean MVVM architecture with Provider state management**. All decisions favor speed of implementation and portfolio polish over unnecessary complexity. The app runs entirely on-device with direct Gemini API integration—no backend server required.

**Core Philosophy:** Boring, proven technology that works flawlessly. Flutter, Firebase Auth, SQLite, Gemini API. All decisions finalized to prevent AI agent conflicts during implementation.

---

## Project Initialization

Start with Flutter's official project generator:

```bash
flutter create echoai
cd echoai
flutter pub add \
  firebase_core:^4.2.1 \
  firebase_auth:^6.1.2 \
  firebase_ai:^3.5.0 \
  provider:^6.1.5+1 \
  sqflite:^2.4.2 \
  speech_to_text:^7.3.0 \
  flutter_tts:^4.2.3 \
  google_sign_in:^7.2.0 \
  intl:^0.20.2 \
  uuid:^4.5.2 \
  path_provider:^2.1.5 \
  path:^1.9.0
```

This is the **first implementation story**—establishes base architecture with Firebase CLI configuration.

---

## Technology Stack

| Component            | Technology                | Version | Why                                                       |
| -------------------- | ------------------------- | ------- | --------------------------------------------------------- |
| **Framework**        | Flutter                   | 3.9+    | Native iOS/Android, single codebase, Material Design 3    |
| **AI API**           | Firebase AI Logic         | 3.5.0+  | Official Gemini SDK, streaming support, token management  |
| **Authentication**   | Firebase Auth             | 6.1.2+  | Email/password + Google Sign-In, free tier, secure        |
| **Database**         | SQLite                    | 2.4.2+  | Local on-device storage, fast queries, zero cloud costs   |
| **Voice Input**      | speech_to_text            | 7.3.0+  | Cross-platform, accurate transcription, silence detection |
| **Voice Output**     | flutter_tts               | 4.2.3+  | Natural voices, adjustable speed, both platforms          |
| **State Management** | Provider                  | 6.1.5+  | Lightweight, proven, easy to test, clear data flow        |
| **OAuth**            | google_sign_in            | 7.2.0+  | Google authentication, integrated with Firebase           |
| **Utilities**        | intl, uuid, path_provider | Latest  | Localization, unique IDs, app directories                 |

**Decision:** All packages are stable, well-maintained, and current as of November 2025.

---

## Project Structure

```
echoai/
├── .github/
├── docs/                       # Design & architecture documentation
│   ├── PRD.md
│   ├── architecture.md         # (this file)
│   ├── ux-design-specification.md
│   ├── DEPLOYMENT.md
│   ├── PROJECT_STRUCTURE.md
│   ├── SETUP.md
│   ├── CHANGELOG.md
│   ├── CONTRIBUTING.md
│   ├── LICENSE
│   └── SECURITY.md
│
├── lib/
│   ├── main.dart              # App entry point, Firebase init, theme setup
│   │
│   ├── models/                # Data structures (immutable classes)
│   │   ├── message.dart       # Message {id, text, timestamp, reactions, etc}
│   │   ├── conversation.dart  # Conversation {id, title, messages, mode}
│   │   ├── user.dart          # User {uid, email, displayName}
│   │   └── settings.dart      # Settings {assistantMode, theme, colors}
│   │
│   ├── screens/               # Full-page UI layouts
│   │   ├── splash_screen.dart
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   └── password_reset_screen.dart
│   │   ├── chat_screen.dart
│   │   ├── history_screen.dart
│   │   └── settings_screen.dart
│   │
│   ├── widgets/               # Reusable UI components
│   │   ├── message_bubble.dart       # Message display with reactions
│   │   ├── message_input.dart        # Text input + voice button
│   │   ├── bottom_nav.dart           # Navigation tabs
│   │   ├── typing_indicator.dart     # Loading animation
│   │   ├── conversation_card.dart    # History list item
│   │   ├── theme_toggle.dart         # Settings component
│   │   └── mode_selector.dart        # Assistant mode picker
│   │
│   ├── services/              # Business logic & external integrations
│   │   ├── auth_service.dart        # Firebase Authentication
│   │   ├── gemini_service.dart      # Gemini API + streaming responses
│   │   ├── database_service.dart    # SQLite chat persistence
│   │   ├── voice_service.dart       # Speech-to-text & text-to-speech
│   │   └── notification_service.dart # Push notifications (future)
│   │
│   ├── providers/             # State management (Provider pattern)
│   │   ├── auth_provider.dart       # User login/signup state
│   │   ├── chat_provider.dart       # Current conversation, messages
│   │   ├── history_provider.dart    # Chat list, search
│   │   ├── settings_provider.dart   # Theme, assistant mode, prefs
│   │   └── voice_provider.dart      # Recording/playback state
│   │
│   ├── utils/                 # Helpers and constants
│   │   ├── constants.dart     # Colors, strings, API endpoints, timeouts
│   │   ├── theme.dart         # Dark theme definition (Material 3)
│   │   └── extensions.dart    # String, DateTime, List extensions
│   │
│   └── config/                # Configuration files
│       ├── firebase_options.dart  # Generated by Firebase CLI
│       └── api_config.dart        # API endpoints, rate limits
│
├── test/                      # Unit & widget tests (mirrors lib/)
│   ├── models/
│   │   ├── message_test.dart
│   │   └── conversation_test.dart
│   ├── services/
│   │   ├── gemini_service_test.dart
│   │   └── database_service_test.dart
│   ├── providers/
│   │   ├── chat_provider_test.dart
│   │   └── settings_provider_test.dart
│   └── widgets/
│       ├── message_bubble_test.dart
│       └── message_input_test.dart
│
├── android/                  # Android-specific configuration
│   ├── app/
│   │   ├── build.gradle.kts
│   │   ├── google-services.json
│   │   └── src/main/AndroidManifest.xml  # Permissions: INTERNET, RECORD_AUDIO
│   └── gradle.properties
│
├── ios/                      # iOS-specific configuration
│   └── Runner/Info.plist     # Permissions: NSMicrophoneUsageDescription
│
├── linux/                    # Linux-specific configuration
├── macos/                    # macOS-specific configuration
├── web/                      # Web-specific configuration
├── windows/                  # Windows-specific configuration
│
├── pubspec.yaml             # Dependencies and build config
├── analysis_options.yaml    # Dart lint rules
├── firebase.json            # Firebase configuration
└── README.md                # Setup and development guide

```

**Structure Rationale:**

- ✅ **By layer, not by feature** - Clear separation of concerns (UI, state, logic, data)
- ✅ **Models are dumb** - Just data classes, no logic
- ✅ **Services handle all external concerns** - API, database, auth, device features
- ✅ **Providers manage state** - Single source of truth per feature
- ✅ **Screens compose widgets and connect to providers** - UI is presentation-only
- ✅ **Tests mirror source structure** - Easy to navigate

---

## Architecture Pattern: MVVM with Provider

```
User Interaction (Screens/Widgets)
              ↓ (calls)
      [Provider State]  ← Notifies listeners when data changes
              ↓ (calls)
   [Service Layer]      ← Firebase, Gemini, SQLite, device APIs
              ↓ (returns)
    [Models/Data]       ← Immutable data structures
```

### Layer Responsibilities

| Layer               | Responsibility                                 | Example                                                           |
| ------------------- | ---------------------------------------------- | ----------------------------------------------------------------- |
| **Screens/Widgets** | UI layout, user input handling                 | `ChatScreen` renders message list, text input, buttons            |
| **Providers**       | State management, business logic orchestration | `ChatProvider.sendMessage()` saves message, calls API, updates UI |
| **Services**        | External integrations, data access             | `GeminiService.getResponse()` calls Gemini API with streaming     |
| **Models**          | Data structures, serialization                 | `Message` class with `toMap()`/`fromMap()` for SQLite             |

### Data Flow Examples

**User sends a text message:**

```
1. ChatScreen: User types "Hello" and taps Send button
2. ChatScreen calls: chatProvider.sendMessage("Hello")
3. ChatProvider: Creates Message object, adds to local list, notifies UI
4. ChatProvider: Calls databaseService.saveMessage(message)
5. ChatProvider: Calls geminiService.getResponse(allMessages, assistantMode)
6. GeminiService: Opens streaming connection to Gemini API
7. GeminiService: Emits tokens as they arrive (word by word)
8. ChatProvider: Receives tokens, updates AI message in real-time
9. ChatScreen: Rebuilds automatically showing new text appearing
10. When complete: ChatProvider calls databaseService.saveMessage(aiResponse)
```

**User records voice message:**

```
1. ChatScreen: User taps microphone button
2. VoiceProvider: Calls voiceService.startRecording()
3. VoiceService: Requests microphone permission, starts recording
4. ChatScreen: Shows waveform animation while recording
5. VoiceService: Detects silence (2 seconds), stops automatically
6. VoiceProvider: Calls geminiService.transcribe(audioData)
7. GeminiService: Sends audio to Gemini API for transcription
8. ChatProvider: Receives transcribed text
9. ChatProvider: Sends text as message (same flow as above)
```

**User views chat history:**

```
1. HistoryScreen: Mounts, calls historyProvider.loadConversations()
2. HistoryProvider: Calls databaseService.getAllConversations()
3. DatabaseService: Queries SQLite, returns sorted list
4. HistoryProvider: Stores in state, notifies listeners
5. HistoryScreen: Rebuilds showing conversation cards
6. User taps a conversation
7. ChatProvider: Loads that conversation's messages
8. ChatScreen: Displays full message history
9. User can continue the conversation from where they left off
```

---

## Data Models

All models are **immutable data classes** with serialization support for SQLite.

### Message

```dart
class Message {
  final String id;                    // Unique ID (UUID)
  final String conversationId;        // Foreign key to conversation
  final String text;                  // Message content
  final bool isUserMessage;           // true = user, false = AI
  final DateTime timestamp;           // When sent
  final bool isStreaming;             // true while response is arriving
  final List<String> reactions;       // ['👍', '❤️', etc]
  final String? errorMessage;         // if transcription/API failed
  final int tokensUsed;               // For future rate limiting

  Message({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.isUserMessage,
    required this.timestamp,
    this.isStreaming = false,
    this.reactions = const [],
    this.errorMessage,
    this.tokensUsed = 0,
  });

  // Serialization for SQLite
  Map<String, dynamic> toMap() => { ... };
  factory Message.fromMap(Map<String, dynamic> map) => ...;
}
```

### Conversation

```dart
class Conversation {
  final String id;                    // Unique ID (UUID)
  final String title;                 // Auto-generated from first user message
  final List<Message> messages;       // Full message history
  final DateTime createdAt;           // Conversation start date
  final DateTime lastUpdatedAt;       // Last message date
  final String assistantMode;         // "productivity" | "learning" | "casual"
  final int messageCount;             // Cached for UI display

  Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.assistantMode,
    required this.messageCount,
  });

  Map<String, dynamic> toMap() => { ... };
  factory Conversation.fromMap(Map<String, dynamic> map) => ...;
}
```

### User

```dart
class User {
  final String uid;                   // Firebase UID
  final String email;                 // Email address
  final String? displayName;          // Optional display name
  final DateTime createdAt;           // Account creation date

  User({
    required this.uid,
    required this.email,
    this.displayName,
    required this.createdAt,
  });
}
```

### Settings

```dart
class Settings {
  final String assistantMode;         // "productivity" | "learning" | "casual"
  final bool notificationsEnabled;    // Push notifications on/off
  final String accentColor;           // "purple" | "pink" | "cyan" | "lime"
  final bool soundEnabled;            // Text-to-speech on/off

  Settings({
    required this.assistantMode,
    required this.notificationsEnabled,
    required this.accentColor,
    this.soundEnabled = true,
  });

  Map<String, dynamic> toMap() => { ... };
  factory Settings.fromMap(Map<String, dynamic> map) => ...;
}
```

---

## Services Layer (External Integration)

Each service is a **singleton** responsible for one domain.

### AuthService

**Responsibility:** Firebase Authentication (login, signup, password reset, token management)

```dart
class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal() {
    // Initialize Firebase Auth listener
    _firebaseAuth.authStateChanges().listen((user) {
      _authStateController.add(user);
    });
  }

  // Public interface
  Future<User?> signUpWithEmail(String email, String password);
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> deleteAccount();

  Stream<User?> get authStateStream => _authStateController.stream;
  User? get currentUser => _getCurrentUser();
}
```

### GeminiService

**Responsibility:** Gemini API integration with streaming responses

```dart
class GeminiService {
  static final GeminiService _instance = GeminiService._internal();

  factory GeminiService() => _instance;

  // System prompts for each assistant mode
  static const PROMPTS = {
    'productivity': 'You are a focused productivity assistant...',
    'learning': 'You are a patient educational assistant...',
    'casual': 'You are a friendly, conversational assistant...',
  };

  // Public interface
  Stream<String> getResponseStream({
    required List<Message> conversationHistory,
    required String userMessage,
    required String assistantMode,
  });

  Future<String> transcribeAudio(Uint8List audioData);
}
```

### DatabaseService

**Responsibility:** SQLite local storage for messages and conversations

```dart
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  // Table: messages (id, conversation_id, text, is_user, timestamp, streaming, error)
  // Table: conversations (id, title, created_at, last_updated_at, mode, message_count)
  // Table: settings (assistant_mode, notifications_enabled, accent_color, sound_enabled)

  // Public interface
  Future<void> saveMessage(Message message);
  Future<void> saveConversation(Conversation conversation);
  Future<List<Message>> getMessages(String conversationId);
  Future<List<Conversation>> getAllConversations({int limit = 50});
  Future<void> deleteConversation(String conversationId);
  Future<void> deleteAllConversations();
  Future<void> searchConversations(String query);
}
```

### VoiceService

**Responsibility:** Voice-to-text (transcription) and text-to-speech (playback)

```dart
class VoiceService {
  static final VoiceService _instance = VoiceService._internal();

  factory VoiceService() => _instance;

  // Voice Input
  Future<void> startRecording();
  Future<String> stopRecording();  // Returns transcribed text
  Future<void> cancelRecording();

  Stream<double> get volumeLevelStream;  // For waveform animation

  // Voice Output
  Future<void> speak(String text, {double speed = 1.0});
  Future<void> stopSpeaking();
  Future<void> pauseSpeaking();

  bool get isRecording;
  bool get isSpeaking;
}
```

---

## Providers (State Management)

Each provider manages one feature's state using the **Provider pattern**.

### ChatProvider

```dart
class ChatProvider extends ChangeNotifier {
  // State
  Conversation? _currentConversation;
  List<Message> get messages => _currentConversation?.messages ?? [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Business logic
  Future<void> startNewConversation() async { ... }

  Future<void> sendMessage(String text) async {
    // 1. Create user message
    // 2. Add to current conversation
    // 3. Save to database
    // 4. notifyListeners()
    // 5. Call Gemini API with streaming
    // 6. Build AI response in real-time
    // 7. Save to database
  }

  Future<void> loadConversation(String conversationId) async { ... }

  void addReaction(String messageId, String emoji) async { ... }

  void copyMessage(String messageId) { ... }
}
```

### HistoryProvider

```dart
class HistoryProvider extends ChangeNotifier {
  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;

  List<Conversation> _filteredResults = [];
  List<Conversation> get filteredResults => _filteredResults;

  Future<void> loadConversations() async { ... }

  Future<void> searchConversations(String query) async { ... }

  Future<void> deleteConversation(String id) async { ... }

  Future<void> deleteAllConversations() async { ... }
}
```

### SettingsProvider

```dart
class SettingsProvider extends ChangeNotifier {
  Settings _settings = Settings.defaultSettings();
  Settings get settings => _settings;

  void setAssistantMode(String mode) async {
    _settings = Settings(
      assistantMode: mode,
      notificationsEnabled: _settings.notificationsEnabled,
      accentColor: _settings.accentColor,
    );
    await _saveToDatabase();
    notifyListeners();
  }

  void setAccentColor(String color) async { ... }

  void toggleNotifications() async { ... }
}
```

### AuthProvider

```dart
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // Listen to auth state changes
    authService.authStateStream.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password) async { ... }

  Future<void> signIn(String email, String password) async { ... }

  Future<void> signInWithGoogle() async { ... }

  Future<void> signOut() async { ... }
}
```

### VoiceProvider

```dart
class VoiceProvider extends ChangeNotifier {
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  double _volumeLevel = 0.0;
  double get volumeLevel => _volumeLevel;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  Future<void> startRecording() async { ... }

  Future<String> stopRecording() async { ... }

  Future<void> speak(String text) async { ... }
}
```

---

## Naming Conventions

**Purpose:** Ensure all AI agents write code with consistent naming, preventing conflicts.

### Dart Classes & Files

| Type          | Pattern                                             | Example                                |
| ------------- | --------------------------------------------------- | -------------------------------------- |
| **Screens**   | `XxxScreen` (class), `xxx_screen.dart` (file)       | `ChatScreen`, `chat_screen.dart`       |
| **Widgets**   | `XxxWidget` (class), `xxx_widget.dart` or just name | `MessageBubble`, `message_bubble.dart` |
| **Services**  | `XxxService` (class), `xxx_service.dart` (file)     | `AuthService`, `auth_service.dart`     |
| **Providers** | `XxxProvider` (class), `xxx_provider.dart` (file)   | `ChatProvider`, `chat_provider.dart`   |
| **Models**    | `Xxx` singular (class), `xxx.dart` (file)           | `Message`, `message.dart`              |

### Variables & Functions

| Type                 | Pattern                       | Example                                                     |
| -------------------- | ----------------------------- | ----------------------------------------------------------- |
| **Local variables**  | `camelCase`                   | `currentMessage`, `isLoading`, `userMessages`               |
| **Private methods**  | `_methodName`                 | `_parseResponse()`, `_validateInput()`                      |
| **Constants**        | `UPPER_SNAKE_CASE`            | `MAX_MESSAGE_LENGTH`, `API_TIMEOUT_MS`, `DEFAULT_PAGE_SIZE` |
| **Getters**          | `camelCase` (no `get` prefix) | `isLoading`, `currentUser`, `messages`                      |
| **Database columns** | `snake_case`                  | `user_id`, `is_user_message`, `created_at`                  |

### API/Database Naming

| Entity            | Naming                 | Example                                      |
| ----------------- | ---------------------- | -------------------------------------------- |
| **API endpoints** | `/api/v1/resource`     | `/api/v1/messages`, `/api/v1/conversations`  |
| **DB tables**     | `snake_case` lowercase | `messages`, `conversations`, `user_settings` |
| **DB columns**    | `snake_case` lowercase | `user_id`, `is_user_message`, `created_at`   |
| **Foreign keys**  | `{table}_id`           | `user_id`, `conversation_id`                 |

---

## Error Handling Pattern

All services return **Result<T>** to handle success/failure uniformly.

```dart
/// Result type: Either success with data or failure with error message
sealed class Result<T> {
  const Result();

  factory Result.success(T data) => Success(data);
  factory Result.error(String message) => Error(message);

  R when<R>({
    required R Function(T data) success,
    required R Function(String message) error,
  });
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Error<T> extends Result<T> {
  final String message;
  const Error(this.message);
}
```

**Usage in services:**

```dart
Future<Result<String>> getResponse(List<Message> messages) async {
  try {
    final response = await _geminiApi.generateContent(...);
    return Result.success(response);
  } on SocketException {
    return Result.error('Network error. Check your connection.');
  } on TimeoutException {
    return Result.error('Request timed out. Try again.');
  } on Exception catch (e) {
    return Result.error('Error: ${e.toString()}');
  }
}
```

**Usage in providers/screens:**

```dart
final result = await geminiService.getResponse(messages);
result.when(
  success: (response) {
    updateMessage(response);
    notifyListeners();
  },
  error: (message) {
    _error = message;
    notifyListeners();
  },
);
```

---

## Database Schema

### Tables

#### messages

```sql
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  text TEXT NOT NULL,
  is_user_message INTEGER NOT NULL,        -- 1 = true, 0 = false
  timestamp INTEGER NOT NULL,              -- Unix milliseconds
  is_streaming INTEGER NOT NULL,
  reactions TEXT,                          -- JSON array: ["👍", "❤️"]
  error_message TEXT,
  tokens_used INTEGER DEFAULT 0,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id)
);

CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_messages_timestamp ON messages(timestamp DESC);
```

#### conversations

```sql
CREATE TABLE conversations (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  created_at INTEGER NOT NULL,            -- Unix milliseconds
  last_updated_at INTEGER NOT NULL,
  assistant_mode TEXT NOT NULL,            -- "productivity", "learning", "casual"
  message_count INTEGER DEFAULT 0
);

CREATE INDEX idx_conversations_created ON conversations(created_at DESC);
CREATE INDEX idx_conversations_updated ON conversations(last_updated_at DESC);
```

#### settings

```sql
CREATE TABLE settings (
  id INTEGER PRIMARY KEY CHECK (id = 1),  -- Single row table
  assistant_mode TEXT NOT NULL,
  notifications_enabled INTEGER NOT NULL,  -- 1 = true, 0 = false
  accent_color TEXT NOT NULL,              -- "purple", "pink", "cyan", "lime"
  sound_enabled INTEGER DEFAULT 1
);
```

---

## API Contracts

### Gemini Streaming API

**Request:**

```dart
GenerateContentRequest {
  String model = "gemini-2.5-flash";
  List<Content> contents;  // Conversation history
  String systemPrompt;     // Assistant mode personality
  int temperature = 0.7;   // Creativity level
}
```

**Response (Streaming):**

```
// Tokens arrive incrementally
chunk 1: "I"
chunk 2: " can"
chunk 3: " help"
...
// Stop token received, stream closes
```

### Firebase Authentication

**Email/Password:**

```
POST /accounts:signUp
  email: String
  password: String (min 8 chars)
  returnSecureToken: true
→ idToken, refreshToken, uid
```

**Google Sign-In:**

```
// Handled by google_sign_in package
// Returns: GoogleSignInAccount with idToken
// Exchange for Firebase idToken
```

---

## Cross-Cutting Consistency Rules

**These patterns apply across ALL features to prevent AI agent conflicts:**

### 1. **Async Operations Pattern**

All async operations follow this pattern:

```dart
Future<void> doSomething() async {
  try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Actual work
    final result = await _service.doWork();

    _isLoading = false;
    notifyListeners();
  } on SpecificException catch (e) {
    _isLoading = false;
    _error = e.message;
    notifyListeners();
  } catch (e) {
    _isLoading = false;
    _error = 'Something went wrong';
    notifyListeners();
  }
}
```

### 2. **State Update Pattern**

Always notify listeners **after** updating state:

```dart
void updateSetting(String key, dynamic value) {
  _settings[key] = value;
  _saveToDB();  // Fire and forget OK
  notifyListeners();  // Notify immediately
}
```

### 3. **Database Operations**

All DB queries go through `DatabaseService`, which handles opening/closing connections:

```dart
// GOOD: Centralized DB access
Future<List<Message>> getMessages(String conversationId) async {
  final result = await databaseService.getMessages(conversationId);
  return result;
}

// BAD: Scattered DB access
final db = await openDatabase(...);
final rows = await db.query('messages');
```

### 4. **Error Messages**

User-facing error messages are **friendly and actionable**:

```dart
// GOOD
"No internet connection. Check WiFi and try again."

// BAD
"SocketException: Connection refused"
"NullPointerException at line 342"
```

### 5. **Timestamps**

All timestamps are stored as **Unix milliseconds** in database:

```dart
final timestamp = DateTime.now().millisecondsSinceEpoch;
// NOT: DateTime.now().toString()
```

### 6. **Unique IDs**

All IDs use **UUID v4**:

```dart
final id = const Uuid().v4();
// NOT: Random numbers, sequential IDs, or timestamp-based
```

### 7. **Testing**

Test files mirror source structure:

```
lib/services/gemini_service.dart
test/services/gemini_service_test.dart

lib/providers/chat_provider.dart
test/providers/chat_provider_test.dart
```

---

## Development Environment Setup

### Requirements

- **Flutter:** 3.24 or later
- **Dart:** 3.5 or later
- **Android Studio** or **VS Code** with Flutter extension
- **Xcode:** 15+ (for iOS development)
- **Firebase CLI:** For Firebase configuration

### Initial Setup

```bash
# Clone project
git clone <repo>
cd echoai

# Install dependencies
flutter pub get

# Setup Firebase (interactive)
flutterfire configure

# Generate Firebase options
dart run build_runner build

# Run on emulator or device
flutter run
```

### Code Quality

```bash
# Format code
dart format lib test

# Lint
dart analyze

# Run tests
flutter test

# Check coverage (optional)
flutter test --coverage
```

---

## Epic to Architecture Mapping

| Epic                            | Architectural Components                          | Key Decisions                                          |
| ------------------------------- | ------------------------------------------------- | ------------------------------------------------------ |
| **Authentication & Onboarding** | AuthService, AuthProvider, Login/SignUp screens   | Firebase Auth, email/password + Google OAuth           |
| **Chat Interface**              | ChatProvider, ChatScreen, MessageBubble widget    | Streaming responses, real-time UI updates              |
| **Voice Capabilities**          | VoiceService, VoiceProvider, Message input widget | speech_to_text + flutter_tts packages                  |
| **Assistant Modes**             | SettingsProvider, GeminiService system prompts    | Three hardcoded prompts, user selection                |
| **Chat History**                | DatabaseService, HistoryProvider, History screen  | SQLite local storage, conversation cards               |
| **Settings & Customization**    | SettingsProvider, Settings screen, Theme utils    | Dark mode only (v1), accent color selector             |
| **Persistence**                 | DatabaseService, SQLite schema                    | All conversations saved locally, none deleted on crash |

---

## Security Architecture

### Authentication

- ✅ Firebase Auth handles token management
- ✅ Tokens stored securely by Firebase
- ✅ Tokens refresh automatically
- ✅ Logout clears all local state

### Data Privacy

- ✅ All chat history stays on device (never uploaded to cloud)
- ✅ No telemetry or analytics
- ✅ No user tracking
- ✅ Gemini API calls are logged by Google (standard)

### API Key Management

- ✅ Gemini API credentials handled by Firebase (no exposure)
- ✅ Firebase project-specific credentials
- ✅ No hardcoded secrets in app binary
- ✅ API keys never visible in client logs

---

## Performance Targets

| Metric                      | Target                          | Approach                                                      |
| --------------------------- | ------------------------------- | ------------------------------------------------------------- |
| **Gemini response latency** | <2 seconds average              | Streaming shows tokens immediately, reduces perceived latency |
| **Chat history load**       | <1 second for 100+ messages     | Pagination + virtual scrolling if needed                      |
| **Search**                  | <500ms across all conversations | Indexed SQLite queries, limited result set                    |
| **App startup**             | <3 seconds cold, <1 second warm | Lazy loading, minimal initialization work                     |
| **Voice transcription**     | <500ms after stop               | speech_to_text package optimized                              |
| **UI frame rate**           | 60 FPS                          | Flutter optimized, avoid jank in message animations           |

---

## Deployment Architecture

### Development

- Local development on emulator/simulator
- GitHub for version control
- Firebase free Spark tier for backend

### Portfolio Demo

- Build release APK (Android) + IPA (iOS) via GitHub Actions or manually
- Demonstrate on physical device at interviews
- Firebase rate limit: 15 requests/minute (sufficient for demo)

### Future (If Productizing)

- Move to Firebase Blaze plan (pay-as-you-go)
- Add Firestore for cloud sync
- Implement cloud backup of conversations

---

## What's NOT in This Architecture (Intentional Simplicity)

❌ **No backend server** - Direct Gemini API calls via Firebase is sufficient for portfolio scope
❌ **No cloud sync** - Local storage only in v1 (added in growth phase)
❌ **No analytics/telemetry** - User privacy is a feature, not a trade-off
❌ **No complex state management** - Provider is simpler than Redux/Riverpod for this scope
❌ **No image generation** - Gemini text-only for v1 (future feature)
❌ **No conversation sharing** - Personal assistant only in v1
❌ **No offline mode** - Requires internet for Gemini (reasonable for v1)

**Why?** These choices _accelerate_ implementation and _maximize_ polish. You ship a flawless MVP in 6 weeks rather than a mediocre feature-complete app in 12.

---

## Key Architectural Decisions (Summary Table)

| Decision               | Choice                              | Reasoning                             | Blocks               | Status    |
| ---------------------- | ----------------------------------- | ------------------------------------- | -------------------- | --------- |
| **State Management**   | Provider                            | Simple, official, proven              | All features         | ✅ Locked |
| **Database**           | SQLite (local)                      | No backend needed, full privacy       | History, persistence | ✅ Locked |
| **Gemini Integration** | Direct Firebase API                 | Free tier, official SDK, streaming    | Chat responses       | ✅ Locked |
| **Authentication**     | Firebase Auth                       | Free, secure, Google Sign-In built-in | All features         | ✅ Locked |
| **Voice I/O**          | speech_to_text + flutter_tts        | Best cross-platform support           | Voice features       | ✅ Locked |
| **Project Structure**  | By layer (screens/widgets/services) | Clear separation, easy scaling        | All development      | ✅ Locked |
| **Error Handling**     | Result<T> sealed class              | Uniform error propagation             | All services         | ✅ Locked |
| **Testing**            | Unit + widget tests                 | Prove correctness, catch regressions  | Quality gate         | ✅ Locked |

---

## Next Steps

1. ✅ **Architecture locked** - Ready for implementation
2. 📝 **First task:** Run `flutter create echoai` and add dependencies
3. 🔥 **Firebase setup:** Configure Gemini API credentials
4. 🏗️ **Week 1 starts:** Authentication screens and navigation structure

**The architecture is complete and ready to guide implementation.** AI agents will follow this document to ensure consistency throughout the 6-week development cycle.

---

**Document Status:** ✅ Decision Locked - Approved for implementation
**Last Updated:** November 10, 2025
**Architect:** Winston
**Project:** EchoAI (Portfolio Showcase)
