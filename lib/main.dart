import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/firebase_options.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for MVP)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppConstants.neutralSurface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const EchoAIApp());
}

class EchoAIApp extends StatelessWidget {
  const EchoAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Wrap with MultiProvider when providers are implemented
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (_) => AuthProvider()),
    //     ChangeNotifierProvider(create: (_) => ChatProvider()),
    //     ChangeNotifierProvider(create: (_) => HistoryProvider()),
    //     ChangeNotifierProvider(create: (_) => SettingsProvider()),
    //     ChangeNotifierProvider(create: (_) => VoiceProvider()),
    //   ],
    //   child: const _AppContent(),
    // );

    return const _AppContent();
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    // TODO: Get accent color from SettingsProvider
    // final settings = context.watch<SettingsProvider>().settings;
    // final accentColor = AppConstants.getAccentColor(settings.accentColor);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.getDarkTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.dark, // Always dark for MVP
      // Routes (to be implemented)
      initialRoute: AppConstants.routeSplash,
      routes: {
        AppConstants.routeSplash: (context) => const SplashScreen(),
        // AppConstants.routeLogin: (context) => const LoginScreen(),
        // AppConstants.routeSignup: (context) => const SignupScreen(),
        // AppConstants.routePasswordReset: (context) => const PasswordResetScreen(),
        // AppConstants.routeChat: (context) => const ChatScreen(),
        // AppConstants.routeHistory: (context) => const HistoryScreen(),
        // AppConstants.routeSettings: (context) => const SettingsScreen(),
      },

      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const ErrorScreen(message: 'Page not found'),
        );
      },
    );
  }
}

/// Splash screen shown on app launch
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // TODO: Check authentication status
    // TODO: Load user settings
    // TODO: Initialize services

    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // TODO: Navigate based on auth status
      // If authenticated: go to Chat
      // If not authenticated: go to Login

      // For now, show setup complete screen
      // Navigator.of(context).pushReplacementNamed(AppConstants.routeLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.neutralBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo (placeholder)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppConstants.primaryPurple, AppConstants.accentCyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 60,
                color: AppConstants.neutralBackground,
              ),
            ),

            const SizedBox(height: AppConstants.spaceLg),

            // App name
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: AppConstants.fontSizeH1,
                fontWeight: AppConstants.fontWeightBold,
                color: AppConstants.textPrimary,
              ),
            ),

            const SizedBox(height: AppConstants.spaceSm),

            // Tagline
            const Text(
              'Your AI-powered assistant',
              style: TextStyle(
                fontSize: AppConstants.fontSizeBody,
                color: AppConstants.textSecondary,
              ),
            ),

            const SizedBox(height: AppConstants.spaceXl),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.accentCyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen for unknown routes
class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.neutralBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.errorColor,
            ),

            const SizedBox(height: AppConstants.spaceLg),

            Text(
              message,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeH3,
                color: AppConstants.textPrimary,
              ),
            ),

            const SizedBox(height: AppConstants.spaceXl),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushReplacementNamed(AppConstants.routeSplash);
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
