# EchoAI - Complete Setup Guide

This guide will walk you through setting up EchoAI for development from scratch.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Flutter Installation](#flutter-installation)
3. [Project Setup](#project-setup)
4. [Firebase Configuration](#firebase-configuration)
5. [Platform Setup](#platform-setup)
6. [Running the App](#running-the-app)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

- **Operating System:** macOS (for iOS), Windows, or Linux
- **RAM:** Minimum 8GB (16GB recommended)
- **Disk Space:** 10GB free space
- **Git:** For version control
- **Code Editor:** VS Code or Android Studio

### Online Accounts

- GitHub account (for cloning repository)
- Firebase account (free tier is sufficient)
- Google Cloud account (for Firebase AI access)

---

## Flutter Installation

### macOS

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Flutter
brew install --cask flutter

# Add Flutter to PATH
echo 'export PATH="$PATH:/usr/local/Caskroom/flutter/latest/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
flutter doctor
```

### Windows

1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract to `C:\src\flutter`
3. Add to PATH:
   - Search "Environment Variables"
   - Edit "Path" variable
   - Add `C:\src\flutter\bin`
4. Verify: `flutter doctor`

### Linux

```bash
# Download Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz

# Extract
tar xf flutter_linux_3.24.0-stable.tar.xz

# Add to PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verify
flutter doctor
```

### Install Development Tools

**Android Studio:**

```bash
# Download from https://developer.android.com/studio
# Install with Android SDK, SDK Command-line Tools, SDK Build-Tools
```

**Xcode (macOS only):**

```bash
# Install from Mac App Store
xcode-select --install
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Install CocoaPods
sudo gem install cocoapods
```

**VS Code (Optional):**

```bash
# Download from https://code.visualstudio.com/
# Install Flutter and Dart extensions
```

---

## Project Setup

# Clone repository

```bash
# Create workspace directory
mkdir ~/development
cd ~/development

# Clone repository
git clone https://github.com/AvishkaGihan/echoai.git
cd echoai
```

### 2. Install Dependencies

```bash
# Get Flutter packages
flutter pub get

# Verify no issues
flutter doctor -v
```

### 3. Install Firebase Tools

```bash
# Install Node.js (if not installed)
# macOS
brew install node

# Windows - Download from nodejs.org
# Linux
sudo apt install nodejs npm

# Install Firebase CLI
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Add to PATH (if needed)
export PATH="$PATH":"$HOME/.pub-cache/bin"  # macOS/Linux
# Windows: Add %USERPROFILE%\AppData\Local\Pub\Cache\bin to PATH
```

---

## Firebase Configuration

### 2. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Name: `echoai-app-a0800` (or your choice)
4. Disable Google Analytics (optional for development)
5. Click "Create Project"

### 2. Enable Authentication

1. In Firebase Console, go to **Build** > **Authentication**
2. Click "Get Started"
3. Enable **Email/Password** provider
4. Enable **Google** sign-in provider
   - Add support email
   - Save

### 3. Enable Firebase AI (Gemini)

1. Go to **Build** > **AI (Gemini)**
2. Click "Get Started"
3. Select pricing tier (Spark - Free is fine for development)
4. The Firebase AI API will be automatically enabled
5. Wait for setup to complete (~2 minutes)

### 4. Configure Flutter App

```bash
# Login to Firebase
firebase login

# Configure FlutterFire
flutterfire configure

# Select options:
# - Select your Firebase project (echoai-dev)
# - Select platforms: android, ios, web (use spacebar)
# - Confirm to create apps
```

This will:

- Create `lib/config/firebase_options.dart`
- Download `google-services.json` (Android)
- Download `GoogleService-Info.plist` (iOS)
- Register your apps in Firebase

### 5. Verify Firebase Setup

```bash
# Check generated file exists
ls lib/config/firebase_options.dart

# For Android
ls android/app/google-services.json

# For iOS (macOS only)
ls ios/Runner/GoogleService-Info.plist
```

---

## Platform Setup

### Android Configuration

**1. Update AndroidManifest.xml**

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.echoai">

    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>

    <!-- For text-to-speech -->
    <queries>
        <intent>
            <action android:name="android.intent.action.TTS_SERVICE" />
        </intent>
    </queries>

    <application
        android:label="EchoAI"
        android:icon="@mipmap/ic_launcher">
        <!-- ... rest of configuration ... -->
    </application>
</manifest>
```

**2. Update build.gradle**

Edit `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34  // Use latest

    defaultConfig {
        applicationId "com.example.echoai"
        minSdkVersion 21  // For Firebase AI
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    // ... rest of configuration ...
}
```

**3. Test Android Setup**

```bash
# List available devices
flutter devices

# Run on Android
flutter run
```

### iOS Configuration (macOS only)

**1. Update Info.plist**

Edit `ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Existing keys... -->

    <!-- Microphone permission -->
    <key>NSMicrophoneUsageDescription</key>
    <string>EchoAI needs microphone access to enable voice input for conversations.</string>

    <!-- Speech recognition permission -->
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>EchoAI uses speech recognition to convert your voice to text.</string>

    <!-- Bundle identifier -->
    <key>CFBundleIdentifier</key>
    <string>com.example.echoai</string>
</dict>
```

**2. Update Podfile**

Edit `ios/Podfile`:

```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '14.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

# ... rest of configuration ...
```

**3. Install CocoaPods Dependencies**

```bash
cd ios
pod install
cd ..
```

**4. Test iOS Setup**

```bash
# Open iOS Simulator
open -a Simulator

# Run on iOS
flutter run
```

---

## Running the App

### Development Mode

```bash
# Run on default device
flutter run

# Run on specific device
flutter devices  # List devices
flutter run -d <device-id>

# Run with hot reload enabled (default)
flutter run --debug
```

### Release Mode

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release

# Output locations:
# Android APK: build/app/outputs/flutter-apk/app-release.apk
# Android Bundle: build/app/outputs/bundle/release/app-release.aab
# iOS: build/ios/iphoneos/Runner.app
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/auth_service_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Troubleshooting

### Common Issues

#### 1. Flutter Doctor Warnings

```bash
# Android licenses not accepted
flutter doctor --android-licenses

# Command line tools missing
# Download from Android Studio > SDK Manager > SDK Tools

# iOS CocoaPods issues
cd ios
pod repo update
pod install
cd ..
```

#### 2. Firebase Configuration Issues

```bash
# File not found error
flutterfire configure  # Re-run configuration

# Check firebase_options.dart exists
ls lib/config/firebase_options.dart

# Verify Firebase project ID in firebase_options.dart
```

#### 3. Build Failures

```bash
# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# For iOS
cd ios && pod install && cd ..

# Rebuild
flutter run
```

#### 4. Voice Features Not Working

**Android:**

- Check microphone permission in device settings
- Verify RECORD_AUDIO permission in AndroidManifest.xml
- Test on physical device (emulator may not support)

**iOS:**

- Check microphone permission in device settings
- Verify NSMicrophoneUsageDescription in Info.plist
- Grant permission when prompted

#### 5. API Rate Limiting

If you see "Too many requests" errors:

- Wait 1 minute (rate limit: 15 requests/minute)
- Check API quota in Firebase Console
- Consider upgrading to Blaze plan for higher limits

### Debug Mode

```bash
# Enable verbose logging
flutter run -v

# Check device logs
# Android
adb logcat

# iOS
xcrun simctl spawn booted log stream --predicate 'processImagePath endswith "Runner"'
```

### Environment Verification

```bash
# Check Flutter installation
flutter doctor -v

# Check Dart version
dart --version

# Check Firebase tools
firebase --version
flutterfire --version

# Check dependencies
flutter pub outdated
```

---

## Development Workflow

### Recommended Setup

1. **IDE:** VS Code with Flutter/Dart extensions
2. **Device:** Physical device for voice testing
3. **Emulator:** For quick UI testing
4. **Hot Reload:** Enabled by default in debug mode

### Code Quality Tools

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Check for outdated dependencies
flutter pub outdated

# Update dependencies
flutter pub upgrade
```

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "feat: add my feature"

# Push to fork
git push origin feature/my-feature

# Create pull request on GitHub
```

---

## Next Steps

1. ✅ Review [Architecture Documentation](architecture.md)
2. ✅ Read [Contributing Guidelines](../CONTRIBUTING.md)
3. ✅ Check [Code Style Guidelines](../CONTRIBUTING.md#code-style-guidelines)
4. ✅ Start coding!

---

### Support

Need help?

- 📖 Check [Documentation](../README.md)
- 🐛 Report issues on [GitHub](https://github.com/AvishkaGihan/echoai/issues)
- 💬 Ask in [Discussions](https://github.com/AvishkaGihan/echoai/discussions)
- 📧 Email: support@echoai.com

---

**Happy Coding! 🚀**
