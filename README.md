# EchoAI - AI Personal Assistant

[![Flutter](https://img.shields.io/badge/Flutter-3.24%2B-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A beautiful, production-ready AI-powered personal assistant mobile app with voice and text interface, built with Flutter and Firebase.

## ✨ Features

### 🎯 Core Features

- **Dual Input Modes**: Text and voice input with seamless switching
- **Streaming AI Responses**: Real-time word-by-word AI responses
- **Persistent Chat History**: All conversations saved locally with SQLite
- **Assistant Modes**: Productivity, Learning, and Casual personalities
- **Voice Capabilities**: Speech-to-text and text-to-speech support
- **Message Reactions**: Quick feedback with emoji reactions
- **Dark Mode Native**: Beautiful dark theme optimized for extended use

### 🔐 Authentication

- Email/password authentication
- Google Sign-In integration
- Password reset flow
- Secure session management

### 🎨 Customization

- Multiple accent color options (Purple, Pink, Cyan, Lime)
- Adjustable voice speed for text-to-speech
- Configurable notifications
- Three assistant personality modes

## 🏗️ Architecture

EchoAI follows a clean **MVVM architecture** with **Provider state management**:

```
lib/
├── models/           # Data structures (Message, Conversation, User, Settings)
├── screens/          # Full-page UI layouts
│   ├── auth/        # Login, Signup, Password Reset
│   ├── chat_screen.dart
│   ├── history_screen.dart
│   └── settings_screen.dart
├── widgets/          # Reusable UI components
│   ├── message_bubble.dart
│   ├── message_input.dart
│   ├── conversation_card.dart
│   └── bottom_nav.dart
├── services/         # Business logic & external integrations
│   ├── auth_service.dart        # Firebase Auth
│   ├── gemini_service.dart      # Gemini AI API
│   ├── database_service.dart    # SQLite operations
│   └── voice_service.dart       # Speech-to-text & TTS
├── providers/        # State management (Provider pattern)
│   ├── auth_provider.dart
│   ├── chat_provider.dart
│   ├── history_provider.dart
│   ├── settings_provider.dart
│   └── voice_provider.dart
├── utils/            # Helpers and constants
│   ├── constants.dart
│   ├── theme.dart
│   ├── extensions.dart
│   └── result.dart
└── config/           # Configuration files
    ├── firebase_options.dart
    └── api_config.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.24 or higher
- Dart SDK 3.5 or higher
- Android Studio or VS Code with Flutter extension
- Xcode 15+ (for iOS development on macOS)
- Firebase account
- Node.js (for Firebase CLI)

### Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd echoai
```

2. **Install Flutter dependencies**

```bash
flutter pub get
```

3. **Install Firebase CLI and FlutterFire**

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

4. **Configure Firebase**

```bash
firebase login
flutterfire configure
```

This will:

- Create/select a Firebase project
- Register your app for iOS, Android, and Web
- Generate `lib/config/firebase_options.dart`
- Download configuration files

5. **Enable Firebase Services**

In [Firebase Console](https://console.firebase.google.com):

- Enable **Authentication** (Email/Password + Google Sign-In)
- Enable **Firebase AI** for Gemini API access

6. **Configure Platform-Specific Settings**

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>NSMicrophoneUsageDescription</key>
<string>EchoAI needs microphone access for voice input</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>EchoAI uses speech recognition for voice conversations</string>
```

7. **Run the app**

```bash
flutter run
```

## 📱 Usage

### Basic Workflow

1. **Sign Up / Sign In**

   - Create account with email/password or Google Sign-In
   - Session persists across app restarts

2. **Start Chatting**

   - Type message or tap microphone for voice input
   - Watch AI response stream in real-time
   - React to messages with emoji
   - Tap AI messages to hear them read aloud

3. **Browse History**

   - View all past conversations
   - Search by content
   - Delete individual or all conversations

4. **Customize Settings**
   - Switch assistant modes (Productivity/Learning/Casual)
   - Change accent color
   - Adjust voice speed
   - Toggle notifications

### Voice Features

**Voice Input:**

- Tap microphone icon to start recording
- Speak naturally
- Auto-stops after 2 seconds of silence
- Transcription appears in text field

**Text-to-Speech:**

- Tap any AI message to hear it read aloud
- Adjust speed in Settings (0.5x - 2.0x)
- Tap again to stop

### Assistant Modes

**🎯 Productivity Mode**

- Focused on tasks and goals
- Concise, action-oriented responses
- Emphasizes next steps

**📚 Learning Mode**

- Patient explanations
- Breaks down complex topics
- Educational focus

**💬 Casual Mode**

- Friendly conversations
- Lighter tone
- General chat

## 🧪 Testing

Run all tests:

```bash
flutter test
```

Run with coverage:

```bash
flutter test --coverage
```

## 🏭 Building for Production

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### iOS (requires macOS)

```bash
flutter build ios --release
```

## 🔧 Configuration

### API Configuration

Edit `lib/config/api_config.dart` to adjust:

- Gemini model settings (temperature, top-k, top-p)
- Rate limiting (default: 15 requests/minute)
- Timeouts
- Safety settings

### Theme Configuration

Edit `lib/utils/constants.dart` to modify:

- Color palette
- Typography scale
- Spacing system
- Animation durations

## 📊 Tech Stack

| Component            | Technology     | Version |
| -------------------- | -------------- | ------- |
| **Framework**        | Flutter        | 3.24+   |
| **Language**         | Dart           | 3.5+    |
| **AI API**           | Firebase AI    | 3.5.0+  |
| **Authentication**   | Firebase Auth  | 6.1.2+  |
| **Database**         | SQLite         | 2.4.2+  |
| **Voice Input**      | speech_to_text | 7.3.0+  |
| **Voice Output**     | flutter_tts    | 4.2.3+  |
| **State Management** | Provider       | 6.1.5+  |
| **OAuth**            | google_sign_in | 7.2.0+  |

## 🎨 Design System

### Colors (Futuristic Bold Theme)

```dart
Primary Purple:  #A78BFA
Accent Cyan:     #22D3EE
Accent Pink:     #F43F5E
Dark Base:       #1E293B
Background:      #0F172A
Text Primary:    #E2E8F0
Text Secondary:  #94A3B8
```

### Typography Scale

```dart
H1: 28px Bold
H2: 22px Bold
H3: 18px Semibold
Body: 16px Regular
Label: 14px Semibold
Small: 12px Regular
```

### Spacing System (8px Grid)

```dart
xs:  4px
sm:  8px
md:  16px
lg:  24px
xl:  32px
2xl: 48px
```

## 🐛 Troubleshooting

### Common Issues

**Flutter Doctor Issues:**

```bash
flutter doctor
flutter doctor --android-licenses
```

**Firebase Configuration Not Found:**

```bash
flutterfire configure
```

**Build Failures:**

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

**Voice Recognition Not Working:**

- Check microphone permissions in device settings
- Ensure `speech_to_text` package is properly configured
- Test on physical device (emulator may not support)

## 📖 Documentation

- [Product Requirements Document](docs/PRD.md)
- [Architecture Document](docs/architecture.md)
- [UX Design Specification](docs/ux-design-specification.md)

## 🤝 Contributing

This is a portfolio project, but feedback and suggestions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**

- Portfolio: [your-portfolio.com](https://your-portfolio.com)
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your Name](https://linkedin.com/in/yourprofile)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for backend infrastructure
- Google Gemini team for AI capabilities
- Material Design team for design guidelines

## 📈 Roadmap

### Version 1.1

- [ ] Cloud sync for conversations
- [ ] Export conversations to PDF
- [ ] Multi-language support
- [ ] Light theme option

### Version 2.0

- [ ] Image generation with Gemini
- [ ] Conversation sharing
- [ ] Advanced search filters
- [ ] Desktop versions (Windows, macOS, Linux)

### Version 3.0

- [ ] Collaborative conversations
- [ ] Advanced AI models selection
- [ ] Plugin system
- [ ] Web version

## 💬 Support

For issues and questions:

- Open an issue on GitHub
- Email: your.email@example.com

---

**Built with ❤️ using Flutter**
