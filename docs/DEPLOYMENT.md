# EchoAI Deployment Guide

Complete guide for deploying EchoAI to production environments.

## 📋 Table of Contents

1. [Pre-Deployment Checklist](#pre-deployment-checklist)
2. [Android Deployment](#android-deployment)
3. [iOS Deployment](#ios-deployment)
4. [Firebase Production Setup](#firebase-production-setup)
5. [App Store Submission](#app-store-submission)
6. [Post-Deployment](#post-deployment)

---

## Pre-Deployment Checklist

### Code Quality

- [ ] All tests passing (`flutter test`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] Code properly formatted (`dart format`)
- [ ] Coverage > 70% (optional but recommended)
- [ ] No hardcoded secrets or API keys
- [ ] Error handling comprehensive
- [ ] Loading states implemented
- [ ] Edge cases handled

### App Configuration

- [ ] App name finalized
- [ ] App icon created (1024x1024 PNG)
- [ ] Splash screen designed
- [ ] Version number set in `pubspec.yaml`
- [ ] Package name/Bundle ID unique
- [ ] Privacy policy URL ready
- [ ] Terms of service URL ready

### Firebase Setup

- [ ] Production Firebase project created
- [ ] Authentication configured
- [ ] Vertex AI enabled
- [ ] Rate limits configured
- [ ] Security rules reviewed
- [ ] Monitoring enabled

### Legal & Compliance

- [ ] Privacy policy written
- [ ] Terms of service written
- [ ] GDPR compliance (if applicable)
- [ ] COPPA compliance (if targeting children)
- [ ] App Store guidelines reviewed

---

## Android Deployment

### 1. Generate Keystore

**Create a keystore for signing:**

```bash
keytool -genkey -v -keystore ~/echoai-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias echoai-key-alias
```

**Secure the keystore:**

```bash
# Move to secure location
mv ~/echoai-release-key.jks ~/secure-keys/

# Never commit to Git!
# Add to .gitignore
echo "*.jks" >> .gitignore
```

### 2. Configure Signing

**Create `android/key.properties`:**

```properties
storePassword=example_keystore_password
keyPassword=example_key_password
keyAlias=echoai-key-alias
storeFile=/Users/yourname/secure-keys/echoai-release-key.jks
```

**Update `android/app/build.gradle`:**

```gradle
// Add before android block
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### 3. Update App Details

**Edit `android/app/src/main/AndroidManifest.xml`:**

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.avishkagihan.echoai">

    <application
        android:label="EchoAI"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- ... -->
    </application>
</manifest>
```

**Update `android/app/build.gradle`:**

```gradle
android {
    defaultConfig {
        applicationId "com.avishkagihan.echoai"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

### 4. Build Release APK/Bundle

```bash
# Clean build
flutter clean
flutter pub get

# Build APK (for direct distribution)
flutter build apk --release

# Build App Bundle (for Play Store - recommended)
flutter build appbundle --release

# Output locations:
# APK: build/app/outputs/flutter-apk/app-release.apk
# Bundle: build/app/outputs/bundle/release/app-release.aab
```

### 5. Test Release Build

```bash
# Install APK on device
adb install build/app/outputs/flutter-apk/app-release.apk

# Test thoroughly:
# - All features work
# - No debug UI
# - Performance is good
# - Voice features work
# - Firebase connection works
```

### 6. Google Play Store Submission

1. **Create Developer Account**

   - Go to [Google Play Console](https://play.google.com/console)
   - Pay $25 registration fee
   - Complete account setup

2. **Create App**

   - Click "Create App"
   - Fill in app details
   - Select language and type

3. **Store Listing**

   - App name: EchoAI
   - Short description (80 chars)
   - Full description (4000 chars)
   - Screenshots (at least 2)
   - Feature graphic (1024x500)
   - App icon (512x512)
   - Category: Productivity / Tools

4. **Content Rating**

   - Complete questionnaire
   - Get rating certificate

5. **Pricing & Distribution**

   - Select countries
   - Set price (Free for MVP)
   - Accept terms

6. **Upload App Bundle**
   - Go to Production > Releases
   - Create new release
   - Upload `app-release.aab`
   - Add release notes
   - Review and rollout

---

## iOS Deployment

### 1. Apple Developer Account

- Enroll in [Apple Developer Program](https://developer.apple.com) ($99/year)
- Complete account verification
- Accept agreements

### 2. Configure Xcode Project

**Update `ios/Runner/Info.plist`:**

```xml
<dict>
    <key>CFBundleDisplayName</key>
    <string>EchoAI</string>

    <key>CFBundleIdentifier</key>
    <string>com.yourcompany.echoai</string>

    <key>CFBundleVersion</key>
    <string>1</string>

    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>

    <!-- Existing permissions... -->
</dict>
```

**Open in Xcode:**

```bash
open ios/Runner.xcworkspace
```

**In Xcode:**

1. Select Runner target
2. General tab:
   - Bundle Identifier: `com.yourcompany.echoai`
   - Version: `1.0.0`
   - Build: `1`
3. Signing & Capabilities:
   - Check "Automatically manage signing"
   - Select your team
   - Ensure provisioning profile created

### 3. Create App Store Connect App

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click "My Apps" > "+" > "New App"
3. Fill in:
   - Platform: iOS
   - Name: EchoAI
   - Primary Language: English
   - Bundle ID: com.yourcompany.echoai
   - SKU: echoai-1-0-0

### 4. Build Archive

```bash
# Clean and get dependencies
flutter clean
flutter pub get
cd ios
pod install
cd ..

# Build release
flutter build ios --release

# Or build archive in Xcode
open ios/Runner.xcworkspace
# Product > Archive
```

### 5. Upload to App Store

**Via Xcode:**

1. Window > Organizer
2. Select archive
3. Click "Distribute App"
4. Choose "App Store Connect"
5. Upload
6. Wait for processing (~10-30 minutes)

**Via Command Line:**

```bash
# Install tools
brew install fastlane

# Create Fastfile (one-time setup)
cd ios
fastlane init

# Upload
fastlane upload_to_app_store
```

### 6. App Store Submission

1. **App Information**

   - Name, subtitle, category
   - Privacy policy URL
   - Copyright

2. **Pricing & Availability**

   - Select countries
   - Set price (Free)

3. **App Privacy**

   - Complete privacy questionnaire
   - Explain data collection

4. **Version Information**

   - Screenshots (required sizes)
   - App preview video (optional)
   - Promotional text
   - Description
   - Keywords
   - Support URL
   - Marketing URL

5. **Build**

   - Select uploaded build
   - Add "What's New" text

6. **Submit for Review**
   - Answer questions
   - Submit

---

## Firebase Production Setup

### 1. Create Production Project

```bash
# Login
firebase login

# Create project
firebase projects:create echoai-prod

# Set as default
firebase use echoai-prod
```

### 2. Configure Services

**Authentication:**

```bash
# Enable providers in Firebase Console
# - Email/Password
# - Google Sign-In
```

**Vertex AI:**

```bash
# Enable in Firebase Console
# Set appropriate rate limits for production
```

**Security Rules:**

```javascript
// Firestore rules (if using)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 3. Update App Configuration

```bash
# Configure for production
flutterfire configure --project=echoai-prod

# Commit new firebase_options.dart
git add lib/firebase_options.dart
git commit -m "chore: update firebase config for production"
```

### 4. Set Up Monitoring

**In Firebase Console:**

1. Enable Crashlytics
2. Enable Performance Monitoring
3. Set up alerts for:
   - Error rate spikes
   - API quota warnings
   - Performance degradation

---

## App Store Submission

### Common Rejection Reasons

**1. Incomplete Information**

- Missing privacy policy
- Incomplete app description
- Missing screenshots

**2. Broken Functionality**

- App crashes on launch
- Core features don't work
- Login issues

**3. Privacy Issues**

- Not explaining data usage
- Missing required permissions descriptions
- Privacy policy doesn't match app behavior

**4. Design Issues**

- App looks like a test app
- UI doesn't follow platform guidelines
- Poor user experience

### Review Timeline

- **Google Play:** 1-3 days typically
- **Apple App Store:** 1-2 days for first review, 24-48 hours for updates

### Tips for Approval

1. **Test Thoroughly**

   - No crashes
   - All features work
   - Good performance

2. **Provide Details**

   - Clear app description
   - Demo video/screenshots
   - Test account if needed

3. **Follow Guidelines**

   - [Google Play Policies](https://play.google.com/about/developer-content-policy/)
   - [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

4. **Be Responsive**
   - Check status daily
   - Respond to rejections quickly
   - Provide requested information

---

## Post-Deployment

### Monitoring

**Set Up Analytics:**

```dart
// Add to main.dart (if using)
import 'package:firebase_analytics/firebase_analytics.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// Track screen views
analytics.setCurrentScreen(screenName: 'ChatScreen');

// Track events
analytics.logEvent(
  name: 'message_sent',
  parameters: {'mode': 'text'},
);
```

**Monitor Key Metrics:**

- Daily Active Users (DAU)
- Crash-free users rate
- API error rate
- Average session duration
- Message send success rate

### User Feedback

**Collect Feedback:**

- Enable in-app rating prompts
- Monitor app store reviews
- Set up support email
- Create feedback form

**Respond to Reviews:**

- Reply to negative reviews
- Thank users for positive feedback
- Address common issues

### Updates

**Regular Updates:**

```bash
# Increment version
# pubspec.yaml: version: 1.0.1+2

# Build and deploy
flutter build appbundle --release  # Android
flutter build ios --release        # iOS

# Upload to stores
```

**Release Notes Template:**

```
Version 1.0.1
- Bug fixes and improvements
- Enhanced voice recognition
- Performance optimizations

Version 1.1.0
- New: Conversation folders
- New: Export to PDF
- Improved: Chat search
- Fixed: Voice recording on iOS 17
```

### Maintenance

**Weekly:**

- Check crash reports
- Monitor API usage
- Review user feedback
- Update dependencies (if needed)

**Monthly:**

- Analyze user metrics
- Plan new features
- Security audit
- Performance review

### Scaling Considerations

**When to Upgrade:**

- > 1000 DAU: Consider paid Firebase plan
- > 10000 DAU: Optimize API calls
- > 100000 DAU: Dedicated infrastructure

**Cost Management:**

- Monitor Firebase usage
- Implement caching
- Optimize API calls
- Use Cloud Functions for heavy processing

---

## Rollback Plan

If issues arise post-deployment:

### Android

```bash
# Roll back in Play Console
# Production > Releases > Previous release > Re-activate
```

### iOS

```bash
# Remove app from sale (temporary)
# App Store Connect > App > Pricing and Availability
# Uncheck all countries

# Submit hotfix
# Expedited review available for critical bugs
```

### Firebase

```bash
# Revert to previous config
firebase use echoai-dev
flutterfire configure
```

---

## Checklist Summary

### Pre-Launch

- [ ] All tests passing
- [ ] App store accounts created
- [ ] Signing keys generated
- [ ] Firebase production configured
- [ ] Privacy policy published
- [ ] Screenshots prepared
- [ ] App descriptions written

### Launch Day

- [ ] Final build tested
- [ ] Uploaded to stores
- [ ] Submitted for review
- [ ] Monitoring enabled
- [ ] Support email ready

### Post-Launch

- [ ] Monitor crash reports daily
- [ ] Respond to reviews within 24h
- [ ] Track key metrics
- [ ] Plan updates
- [ ] Collect user feedback

---

## Resources

- [Flutter Deployment Docs](https://flutter.dev/docs/deployment)
- [Firebase Console](https://console.firebase.google.com)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)

---

**Good luck with your launch! 🚀**
