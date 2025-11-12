# EchoAI - Complete Project Structure

This document provides a comprehensive overview of the EchoAI project structure.

## 📁 Repository Structure

```
echoai/
├── .github/                          # GitHub configuration
│   ├── workflows/
│   │   └── ci.yml                   # CI/CD pipeline
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md            # Bug report template
│   │   └── feature_request.md       # Feature request template
│   └── pull_request_template.md     # PR template
│
├── android/                          # Android native code
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml  # App permissions & config
│   │   │   ├── kotlin/              # Kotlin code (if any)
│   │   │   └── res/                 # Android resources
│   │   ├── build.gradle.kts         # App-level Gradle config (Kotlin DSL)
│   │   └── google-services.json     # Firebase config (generated)
│   ├── gradle/                      # Gradle wrapper
│   ├── build.gradle.kts             # Project-level Gradle config (Kotlin DSL)
│   └── settings.gradle.kts          # Gradle settings (Kotlin DSL)
│
├── assets/                           # Static assets
│   ├── logo.png                     # App logo
│   └── splash_screen.png            # Splash screen
│
├── build/                            # Build artifacts (generated)
├── docs/                             # Documentation
│   ├── PRD.md                       # Product Requirements Document
│   ├── architecture.md              # Architecture Document
│   ├── ux-design-specification.md   # UX Design Specification
│   ├── SETUP.md                     # Setup Guide
│   ├── DEPLOYMENT.md                # Deployment Guide
│   └── PROJECT_STRUCTURE.md         # This file
│
├── ios/                              # iOS native code
│   ├── Flutter/                     # Flutter configuration
│   │   ├── Debug.xcconfig           # Debug configuration
│   │   ├── Release.xcconfig         # Release configuration
│   │   └── Generated.xcconfig       # Generated configuration
│   ├── Runner/
│   │   ├── Info.plist               # iOS app configuration
│   │   ├── AppDelegate.swift        # iOS app delegate
│   │   └── GeneratedPluginRegistrant.h/.m # Plugin registry
│   ├── Runner.xcodeproj/            # Xcode project
│   ├── Runner.xcworkspace/          # Xcode workspace
│   └── RunnerTests/                 # iOS tests
│
├── lib/                              # Main application code
│   ├── config/                      # Configuration files
│   │   ├── api_config.dart          # API configuration
│   │   └── firebase_options.dart    # Firebase config (generated)
│   │
│   ├── models/                      # Data models
│   │   ├── message.dart             # Message model
│   │   ├── conversation.dart        # Conversation model
│   │   ├── user.dart                # User model
│   │   └── settings.dart            # Settings model
│   │
│   ├── providers/                   # State management
│   │   ├── auth_provider.dart       # Authentication state
│   │   ├── chat_provider.dart       # Chat state
│   │   ├── history_provider.dart    # History state
│   │   ├── settings_provider.dart   # Settings state
│   │   └── voice_provider.dart      # Voice state
│   │
│   ├── screens/                     # Full-page screens
│   │   ├── auth/
│   │   │   ├── login_screen.dart    # Login screen
│   │   │   ├── signup_screen.dart   # Signup screen
│   │   │   └── password_reset_screen.dart
│   │   ├── chat_screen.dart         # Main chat screen
│   │   ├── history_screen.dart      # Chat history screen
│   │   └── settings_screen.dart     # Settings screen
│   │
│   ├── services/                    # Business logic & APIs
│   │   ├── auth_service.dart        # Firebase Authentication
│   │   ├── database_service.dart    # SQLite operations
│   │   ├── gemini_service.dart      # Gemini AI API
│   │   └── voice_service.dart       # Voice I/O
│   │
│   ├── utils/                       # Utilities & helpers
│   │   ├── constants.dart           # App constants
│   │   ├── extensions.dart          # Dart extensions
│   │   ├── logger.dart              # Logging utilities
│   │   ├── result.dart              # Result type
│   │   └── theme.dart               # App theme
│   │
│   ├── widgets/                     # Reusable UI components
│   │   ├── bottom_nav.dart          # Bottom navigation
│   │   ├── conversation_card.dart   # Conversation list item
│   │   ├── message_bubble.dart      # Message display
│   │   └── message_input.dart       # Message input field
│   │
│   └── main.dart                    # App entry point
│
├── linux/                            # Linux native code
├── macos/                            # macOS native code
├── test/                             # Tests
│   ├── models/
│   │   ├── message_test.dart
│   │   └── conversation_test.dart
│   ├── providers/
│   │   ├── chat_provider_test.dart
│   │   ├── chat_provider_test.mocks.dart
│   │   ├── settings_provider_test.dart
│   │   └── settings_provider_test.mocks.dart
│   ├── services/
│   │   ├── auth_service_test.dart
│   │   ├── database_service_test.dart
│   │   └── gemini_service_test.dart
│   └── widgets/
│       ├── message_bubble_test.dart
│       └── message_input_test.dart
│
├── web/                              # Web build files
├── windows/                          # Windows native code
├── .dart_tool/                       # Dart tools (generated)
├── .flutter-plugins-dependencies     # Flutter plugins (generated)
├── .gitignore                        # Git ignore rules
├── .metadata                         # Flutter metadata
├── analysis_options.yaml             # Dart analyzer config
├── CHANGELOG.md                      # Version history
├── CONTRIBUTING.md                   # Contribution guidelines
├── echoai.iml                        # IntelliJ IDEA module file
├── firebase.json                     # Firebase configuration
├── LICENSE                           # MIT License
├── pubspec.lock                      # Dependency lock file (generated)
├── pubspec.yaml                      # Dependencies & metadata
├── README.md                         # Project overview
└── SECURITY.md                       # Security policy
```

---

## 📦 Key Files Explained

### Root Configuration Files

#### `pubspec.yaml`

- **Purpose:** Defines project metadata and dependencies
- **Key Sections:**
  - `name`: Project name
  - `description`: Project description
  - `version`: App version (0.1.0)
  - `environment`: SDK constraints
  - `dependencies`: Production dependencies
  - `dev_dependencies`: Development dependencies
  - `flutter`: Asset configuration

#### `analysis_options.yaml`

- **Purpose:** Dart analyzer configuration
- **Includes:** Linting rules, code style preferences

#### `.gitignore`

- **Purpose:** Files to exclude from version control
- **Excludes:**
  - Build artifacts
  - IDE files
  - Firebase config files
  - API keys

---

## 🏗️ Architecture Layers

### 1. Presentation Layer (`lib/screens/` & `lib/widgets/`)

**Screens:**

- Full-page UI components
- Handle user interactions
- Connect to providers
- No business logic

**Widgets:**

- Reusable UI components
- Stateless when possible
- Accept callbacks for interactions
- Styled with theme

**Example:**

```dart
// Screen uses Widget
ChatScreen → MessageInput
           → MessageBubble
           → BottomNav
```

### 2. State Management Layer (`lib/providers/`)

**Providers:**

- Manage app state
- Notify listeners on changes
- Coordinate between services
- No UI code

**Data Flow:**

```
User Action → Provider → Service → Provider → UI Update
```

**Example:**

```dart
ChatProvider:
  - sendMessage() → GeminiService → Database → notifyListeners()
```

### 3. Business Logic Layer (`lib/services/`)

**Services:**

- Handle external integrations
- Implement business rules
- Return Result types
- No state management

**Responsibilities:**

- `AuthService`: Firebase Auth operations
- `GeminiService`: AI API calls
- `DatabaseService`: SQLite operations
- `VoiceService`: Speech I/O

### 4. Data Layer (`lib/models/`)

**Models:**

- Immutable data classes
- Serialization methods
- No business logic
- Type-safe

**Example:**

```dart
Message → toMap() → SQLite
SQLite → fromMap() → Message
```

### 5. Configuration Layer (`lib/config/` & `lib/utils/`)

**Config:**

- API settings
- Firebase options
- Environment variables

**Utils:**

- Constants
- Extensions
- Helper functions
- Result type

---

## 🔄 Data Flow

### Example: Sending a Message

```
1. User types message in MessageInput
   ↓
2. MessageInput calls onSendMessage callback
   ↓
3. ChatScreen calls chatProvider.sendMessage()
   ↓
4. ChatProvider:
   - Creates Message object
   - Adds to conversation
   - Saves to DatabaseService
   - Calls GeminiService.getResponseStream()
   ↓
5. GeminiService:
   - Sends request to Gemini API
   - Streams response back
   ↓
6. ChatProvider:
   - Updates message with streamed text
   - Calls notifyListeners()
   ↓
7. ChatScreen rebuilds
   ↓
8. MessageBubble displays updated text
```

---

## 📱 Platform-Specific Code

### Android (`android/`)

**Key Files:**

- `AndroidManifest.xml`: Permissions, app metadata
- `build.gradle`: Build configuration, dependencies
- `google-services.json`: Firebase configuration

**Permissions Required:**

- `INTERNET`: Network access
- `RECORD_AUDIO`: Voice input

### iOS (`ios/`)

**Key Files:**

- `Info.plist`: App metadata, permissions
- `AppDelegate.swift`: iOS app delegate
- `GeneratedPluginRegistrant.h/.m`: Plugin registry
- `Runner.xcworkspace`: Xcode workspace (use this, not .xcodeproj)
- `Runner.xcodeproj`: Xcode project configuration

**Permission Descriptions:**

- `NSMicrophoneUsageDescription`: Microphone access
- `NSSpeechRecognitionUsageDescription`: Speech recognition

---

## 🧪 Testing Structure

### Test Organization

Tests mirror source structure:

```
lib/services/auth_service.dart
test/services/auth_service_test.dart
```

### Test Types

1. **Unit Tests** (`test/services/`, `test/models/`)

   - Test individual functions
   - Mock external dependencies
   - Fast execution

2. **Widget Tests** (`test/widgets/`)

   - Test UI components
   - Verify interactions
   - Check rendering

3. **Integration Tests** (planned)
   - Test complete workflows
   - Use real dependencies
   - Slower but comprehensive

---

## 📊 Dependencies Overview

### Production Dependencies

```yaml
firebase_core: ^4.2.1 # Firebase initialization
firebase_auth: ^6.1.2 # Authentication
firebase_ai: ^3.5.0 # Gemini AI
provider: ^6.1.5+1 # State management
sqflite: ^2.4.2 # Local database
speech_to_text: ^7.3.0 # Voice input
flutter_tts: ^4.2.3 # Voice output
google_sign_in: ^7.2.0 # Google OAuth
uuid: ^4.5.2 # Unique IDs
intl: ^0.20.2 # Internationalization
path_provider: ^2.1.5 # File paths
```

### Dev Dependencies

```yaml
flutter_test: sdk # Testing framework
flutter_lints: ^5.0.0 # Linting rules
build_runner: ^2.4.0 # Code generation (if needed)
```

---

## 🎨 Design System

### Theme (`lib/utils/theme.dart`)

**Colors:**

- Primary: Purple (#A78BFA)
- Accent: Cyan (#22D3EE)
- Background: Dark (#0F172A, #1E293B)
- Text: Light (#E2E8F0)

**Typography:**

- H1: 28px Bold
- Body: 16px Regular
- Small: 12px Regular

**Spacing:**

- 8px grid system
- xs: 4px, sm: 8px, md: 16px, lg: 24px, xl: 32px

### Components

All widgets follow Material Design 3 guidelines with custom theming.

---

## 🔒 Security Considerations

### What's Excluded from Git

```gitignore
# API Keys & Secrets
google-services.json
GoogleService-Info.plist
firebase_options.dart
*.jks
*.keystore
.env

# Build Artifacts
build/
*.apk
*.aab
*.ipa
```

### Secure Data Storage

- **SQLite**: Local conversations (encrypted in future)
- **Firebase Auth**: Tokens managed by Firebase
- **Keychain/KeyStore**: Sensitive data (platform-specific)

---

## 📈 Scalability

### Current Architecture Supports

- **Users:** Up to 10,000 DAU comfortably
- **Messages:** Unlimited (local storage)
- **API Calls:** 15 req/min (Firebase free tier)

### When to Scale

- **> 1000 DAU:** Upgrade to Firebase Blaze plan
- **> 10000 DAU:** Add caching layer
- **> 100000 DAU:** Consider backend service

### Migration Path

1. Add Cloud Firestore for sync
2. Implement Cloud Functions
3. Add caching with Redis
4. Consider microservices

---

## 🛠️ Development Workflow

### Local Development

```bash
# 1. Create feature branch
git checkout -b feature/my-feature

# 2. Make changes
# Edit files...

# 3. Format & analyze
dart format .
flutter analyze

# 4. Run tests
flutter test

# 5. Commit & push
git add .
git commit -m "feat: add my feature"
git push origin feature/my-feature
```

### Code Review Process

1. Create pull request
2. Automated CI checks run
3. Manual code review
4. Address feedback
5. Merge to main
6. Deploy to production

---

## 📚 Documentation

### Required Documentation

- [x] README.md - Project overview
- [x] CONTRIBUTING.md - How to contribute
- [x] CHANGELOG.md - Version history
- [x] LICENSE - MIT License
- [x] SECURITY.md - Security policy
- [x] docs/PRD.md - Product requirements
- [x] docs/architecture.md - Technical architecture
- [x] docs/ux-design-specification.md - Design specs
- [x] docs/SETUP.md - Setup guide
- [x] docs/DEPLOYMENT.md - Deployment guide
- [x] docs/PROJECT_STRUCTURE.md - This file

### Code Documentation

- All public APIs documented with DartDoc
- Complex logic explained with comments
- README in each major directory

---

## 🚀 Quick Start Commands

```bash
# Setup
flutter pub get
flutterfire configure

# Development
flutter run

# Testing
flutter test

# Build
flutter build apk --release
flutter build ios --release

# Deploy
# See docs/DEPLOYMENT.md
```

---

## 📞 Support

Need help navigating the project?

- 📖 Read the documentation in `docs/`
- 🐛 Report issues on GitHub
- 💬 Ask in Discussions
- 📧 Email: support@echoai.example.com

---

**Last Updated:** November 13, 2025
**Version:** 0.1.0
