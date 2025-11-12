import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import '../utils/result.dart';
import '../utils/constants.dart';
import '../config/api_config.dart';

/// Voice input and output service
class VoiceService {
  // Singleton pattern
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal() {
    _initializeTTS();
  }

  // Speech-to-text instance
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  // Text-to-speech instance
  final FlutterTts _flutterTts = FlutterTts();

  // Voice level stream controller
  final StreamController<double> _volumeLevelController =
      StreamController<double>.broadcast();

  // State tracking
  bool _isRecording = false;
  bool _isSpeaking = false;
  bool _isInitialized = false;
  String _recognizedText = '';

  // Silence detection
  Timer? _silenceTimer;
  DateTime? _lastSoundTime;

  // ========================================
  // PUBLIC API - VOICE INPUT
  // ========================================

  /// Check if recording is active
  bool get isRecording => _isRecording;

  /// Stream of volume levels during recording
  Stream<double> get volumeLevelStream => _volumeLevelController.stream;

  /// Initialize speech recognition
  Future<Result<void>> initializeSpeechRecognition() async {
    try {
      if (_isInitialized) {
        return Result.success(null);
      }

      final available = await _speechToText.initialize(
        onError: (error) {
          _handleSpeechError(error.errorMsg);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _stopRecording();
          }
        },
      );

      if (!available) {
        return Result.error('Speech recognition not available on this device');
      }

      _isInitialized = true;
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to initialize speech recognition: $e');
    }
  }

  /// Start recording voice input
  Future<Result<void>> startRecording() async {
    try {
      // Initialize if needed
      if (!_isInitialized) {
        final initResult = await initializeSpeechRecognition();
        if (initResult.isError) {
          return initResult;
        }
      }

      // Check if already recording
      if (_isRecording) {
        return Result.error('Already recording');
      }

      // Reset state
      _recognizedText = '';
      _lastSoundTime = DateTime.now();

      // Start listening
      final started = await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(milliseconds: ApiConfig.maxRecordingMs),
        pauseFor: const Duration(milliseconds: ApiConfig.silenceThresholdMs),
        listenOptions: stt.SpeechListenOptions(partialResults: true),
        localeId: ApiConfig.speechLanguage,
        onSoundLevelChange: _onSoundLevelChange,
      );

      if (!started) {
        return Result.error('Failed to start recording');
      }

      _isRecording = true;

      // Start silence detection timer
      _startSilenceDetection();

      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to start recording: $e');
    }
  }

  /// Stop recording and return transcribed text
  Future<Result<String>> stopRecording() async {
    try {
      if (!_isRecording) {
        return Result.error('Not currently recording');
      }

      await _speechToText.stop();
      _stopRecording();

      if (_recognizedText.isEmpty) {
        return Result.error('No speech detected');
      }

      return Result.success(_recognizedText);
    } catch (e) {
      return Result.error('Failed to stop recording: $e');
    }
  }

  /// Cancel recording
  Future<Result<void>> cancelRecording() async {
    try {
      if (!_isRecording) {
        return Result.success(null);
      }

      await _speechToText.cancel();
      _stopRecording();
      _recognizedText = '';

      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to cancel recording: $e');
    }
  }

  // ========================================
  // PUBLIC API - VOICE OUTPUT
  // ========================================

  /// Check if TTS is speaking
  bool get isSpeaking => _isSpeaking;

  /// Speak text aloud
  Future<Result<void>> speak(String text, {double speed = 1.0}) async {
    try {
      if (_isSpeaking) {
        await stopSpeaking();
      }

      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(speed);
      await _flutterTts.setPitch(1.0);

      _isSpeaking = true;
      await _flutterTts.speak(text);

      return Result.success(null);
    } catch (e) {
      _isSpeaking = false;
      return Result.error('Failed to speak text: $e');
    }
  }

  /// Stop speaking
  Future<Result<void>> stopSpeaking() async {
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to stop speaking: $e');
    }
  }

  /// Pause speaking
  Future<Result<void>> pauseSpeaking() async {
    try {
      await _flutterTts.pause();
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to pause speaking: $e');
    }
  }

  /// Set TTS language
  Future<Result<void>> setLanguage(String language) async {
    try {
      await _flutterTts.setLanguage(language);
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to set language: $e');
    }
  }

  /// Get available TTS voices
  Future<Result<List<dynamic>>> getAvailableVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      return Result.success(voices);
    } catch (e) {
      return Result.error('Failed to get voices: $e');
    }
  }

  // ========================================
  // PRIVATE METHODS - VOICE INPUT
  // ========================================

  /// Handle speech recognition results
  void _onSpeechResult(dynamic result) {
    _recognizedText = result.recognizedWords ?? '';
    _lastSoundTime = DateTime.now();

    // Reset silence timer since we got new words
    _silenceTimer?.cancel();
    _startSilenceDetection();
  }

  /// Handle sound level changes
  void _onSoundLevelChange(double level) {
    // Normalize level to 0.0 - 1.0 range
    final normalizedLevel = (level + 20) / 20; // Assuming -20 to 0 dB range
    final clampedLevel = normalizedLevel.clamp(0.0, 1.0);

    _volumeLevelController.add(clampedLevel);

    // Update last sound time if level is significant
    if (clampedLevel > 0.1) {
      _lastSoundTime = DateTime.now();
    }
  }

  /// Start silence detection timer
  void _startSilenceDetection() {
    _silenceTimer?.cancel();

    _silenceTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_lastSoundTime == null) return;

      final silenceDuration =
          DateTime.now().difference(_lastSoundTime!).inMilliseconds;

      if (silenceDuration >= ApiConfig.silenceThresholdMs) {
        // Auto-stop on silence
        stopRecording();
        timer.cancel();
      }
    });
  }

  /// Stop recording and cleanup
  void _stopRecording() {
    _isRecording = false;
    _silenceTimer?.cancel();
    _volumeLevelController.add(0.0);
  }

  /// Handle speech recognition errors
  void _handleSpeechError(String error) {
    if (_isRecording) {
      _stopRecording();
    }
  }

  // ========================================
  // PRIVATE METHODS - VOICE OUTPUT
  // ========================================

  /// Initialize text-to-speech
  Future<void> _initializeTTS() async {
    // Set completion handler
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    // Set error handler
    _flutterTts.setErrorHandler((message) {
      _isSpeaking = false;
    });

    // Set default language
    await _flutterTts.setLanguage(ApiConfig.speechLanguage);

    // Set default voice settings
    await _flutterTts.setSpeechRate(AppConstants.defaultVoiceSpeed);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  // ========================================
  // UTILITY METHODS
  // ========================================

  /// Check if speech recognition is available
  Future<bool> isSpeechRecognitionAvailable() async {
    return await _speechToText.initialize();
  }

  /// Get available languages for speech recognition
  Future<List<stt.LocaleName>> getAvailableLanguages() async {
    return await _speechToText.locales();
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _speechToText.cancel();
    await _flutterTts.stop();
    _silenceTimer?.cancel();
    await _volumeLevelController.close();
  }
}
