# Contributing to EchoAI

Thank you for your interest in contributing to EchoAI! This document provides guidelines and instructions for contributing.

## 🤝 Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Examples of behavior that contributes to creating a positive environment include:**

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Examples of unacceptable behavior include:**

- The use of sexualized language or imagery
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without explicit permission
- Other conduct which could reasonably be considered inappropriate in a professional setting

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have:

- Flutter SDK 3.24 or higher installed
- Dart SDK 3.5 or higher
- Git for version control
- A code editor (VS Code or Android Studio recommended)
- Firebase account for testing

### Setting Up Your Development Environment

1. **Fork the Repository**

   ```bash
   # Click the 'Fork' button on GitHub
   ```

2. **Clone Your Fork**

   ```bash
   git clone https://github.com/YOUR_USERNAME/echoai.git
   cd echoai
   ```

3. **Add Upstream Remote**

   ```bash
   git remote add upstream https://github.com/AvishkaGihan/echoai.git
   ```

4. **Install Dependencies**

   ```bash
   flutter pub get
   ```

5. **Configure Firebase**

   ```bash
   flutterfire configure
   ```

6. **Run the App**
   ```bash
   flutter run
   ```

## 📝 How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

**When submitting a bug report, include:**

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Device/OS information
- Flutter and Dart versions (`flutter doctor -v`)

**Example:**

```markdown
**Title:** Chat screen crashes when sending voice message

**Description:**
The app crashes when attempting to send a voice message after recording.

**Steps to Reproduce:**

1. Open chat screen
2. Tap microphone button
3. Record a voice message
4. Release microphone button
5. App crashes

**Expected Behavior:**
Voice message should be transcribed and sent.

**Actual Behavior:**
App crashes with null pointer exception.

**Device Info:**

- Device: iPhone 14 Pro
- OS: iOS 17.0
- Flutter: 3.24.0
- Dart: 3.5.0

**Screenshots:**
[Attach error screenshot]
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues.

**When suggesting an enhancement, include:**

- A clear and descriptive title
- Detailed description of the proposed feature
- Why this enhancement would be useful
- Possible implementation approach (optional)
- Mockups or examples (if applicable)

### Pull Requests

1. **Create a Feature Branch**

   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Make Your Changes**

   - Follow the code style guidelines below
   - Write tests for new features
   - Update documentation as needed

3. **Commit Your Changes**

   ```bash
   git add .
   git commit -m "feat: add amazing feature"
   ```

4. **Push to Your Fork**

   ```bash
   git push origin feature/amazing-feature
   ```

5. **Create Pull Request**
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Select your branch
   - Fill out the PR template

### Commit Message Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**

```bash
feat(chat): add message reactions
fix(voice): resolve recording crash on iOS
docs(readme): update installation instructions
style(theme): adjust button padding
refactor(services): simplify database queries
test(auth): add login flow tests
chore(deps): update firebase dependencies
```

## 💻 Code Style Guidelines

### Dart/Flutter Style

Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines:

**File Naming:**

```dart
// Good
user_profile_screen.dart
message_service.dart

// Bad
UserProfileScreen.dart
MessageService.dart
```

**Class Naming:**

```dart
// Good
class UserProfileScreen extends StatefulWidget { }
class MessageService { }

// Bad
class userProfileScreen extends StatefulWidget { }
class messageService { }
```

**Formatting:**

- Use 2 spaces for indentation
- Maximum line length: 80 characters
- Always use trailing commas for better diffs

```dart
// Good
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    child: Text('Hello'),
  );
}

// Bad
Widget build(BuildContext context) {
  return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text('Hello'));
}
```

**Documentation:**

```dart
/// Sends a message to the AI assistant.
///
/// The [text] parameter contains the user's message.
/// Returns a [Future] that completes when the message is sent.
///
/// Throws [NetworkException] if there's no internet connection.
Future<void> sendMessage(String text) async {
  // Implementation
}
```

### Project Structure

Place files in the correct directories:

```
lib/
├── models/           # Data classes only
├── screens/          # Full-page widgets
├── widgets/          # Reusable UI components
├── services/         # Business logic, API calls
├── providers/        # State management
├── utils/            # Helper functions, constants
└── config/           # Configuration files
```

### Testing Guidelines

**Write tests for:**

- All service methods
- Provider state changes
- Critical business logic
- UI components with complex behavior

**Test file naming:**

```
lib/services/auth_service.dart
test/services/auth_service_test.dart
```

**Example test:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:echoai/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('signIn with valid credentials succeeds', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      final result = await authService.signIn(
        email: email,
        password: password,
      );

      // Assert
      expect(result.isSuccess, true);
    });
  });
}
```

## 🧪 Testing Your Changes

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/auth_service_test.dart

# Run with coverage
flutter test --coverage
```

### Manual Testing Checklist

Before submitting a PR, test on:

- [ ] Android device/emulator
- [ ] iOS device/simulator (if possible)
- [ ] Different screen sizes
- [ ] Dark mode
- [ ] Voice features work
- [ ] Offline behavior
- [ ] Performance (no jank, smooth scrolling)

## 📚 Documentation

### Updating Documentation

When making changes, update:

- Code comments (if changing functionality)
- README.md (if changing setup or features)
- Architecture docs (if changing structure)
- API documentation (if changing interfaces)

### Writing Good Documentation

**Do:**

````dart
/// Loads all conversations from the database.
///
/// Returns a [Result] containing the list of [Conversation] objects
/// sorted by last updated date (most recent first).
///
/// Example:
/// ```dart
/// final result = await databaseService.getAllConversations();
/// result.when(
///   success: (conversations) => print('Found ${conversations.length}'),
///   error: (message) => print('Error: $message'),
/// );
/// ```
Future<Result<List<Conversation>>> getAllConversations();
````

**Don't:**

```dart
// Gets conversations
Future<Result<List<Conversation>>> getAllConversations();
```

## 🔍 Code Review Process

### What Reviewers Look For

1. **Code Quality**

   - Follows style guidelines
   - No unnecessary complexity
   - Proper error handling
   - Adequate test coverage

2. **Functionality**

   - Solves the stated problem
   - Doesn't introduce bugs
   - Handles edge cases

3. **Performance**

   - No memory leaks
   - Efficient algorithms
   - Smooth UI (60 FPS)

4. **Documentation**
   - Clear comments
   - Updated docs
   - Helpful commit messages

### Responding to Feedback

- Be open to suggestions
- Ask questions if unclear
- Make requested changes promptly
- Thank reviewers for their time

## 🎯 Priority Areas

We especially welcome contributions in:

1. **Testing** - Increase test coverage
2. **Accessibility** - Improve screen reader support
3. **Performance** - Optimize slow operations
4. **Documentation** - Clarify unclear sections
5. **Bug Fixes** - Resolve open issues

## 📞 Getting Help

If you need help:

1. Check the [documentation](docs/)
2. Search existing [issues](https://github.com/AvishkaGihan/echoai/issues)
3. Ask in [discussions](https://github.com/AvishkaGihan/echoai/discussions)
4. Reach out to maintainers

## 🏆 Recognition

Contributors will be:

- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Given credit in commit messages

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to EchoAI! 🚀**
