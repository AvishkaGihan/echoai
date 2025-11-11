import 'dart:async';
import 'package:flutter/foundation.dart';

import '../services/voice_service.dart';

/// Voice input/output state provider
class VoiceProvider extends ChangeNotifier {
  final VoiceService _voiceService = VoiceService();

  // State
  bool _isRecording = false;
  bool _isSpeaking = false;
  double _volumeLevel = 0.0;
  String? _error;
  String _recognizedText = '';
  StreamSubscription<double>? _volumeSubscription;

  // ========================================
  // GETTERS
  // ========================================

  /// Check if recording is active
  bool get isRecording => _isRecording;

  /// Check if TTS is speaking
  bool get isSpeaking => _isSpeaking;

  /// Current volume level (0.0 - 1.0)
  double get volumeLevel => _volumeLevel;

  /// Error message
  String? get error => _error;

  /// Last recognized text
  String get recognizedText => _recognizedText;

  // ========================================
  // VOICE INPUT
  // ========================================

  /// Start recording voice input
  Future<void> startRecording() async {
    _clearError();

    final result = await _voiceService.startRecording();

    result.when(
      success: (_) {
        _isRecording = true;
        _recognizedText = '';
        _startVolumeListener();
        notifyListeners();
      },
      error: (message) {
        _setError(message);
        _isRecording = false;
        notifyListeners();
      },
    );
  }

  /// Stop recording and return transcribed text
  Future<String?> stopRecording() async {
    if (!_isRecording) return null;

    final result = await _voiceService.stopRecording();

    String? transcribedText;

    result.when(
      success: (text) {
        _recognizedText = text;
        transcribedText = text;
        _clearError();
      },
      error: (message) {
        _setError(message);
        transcribedText = null;
      },
    );

    _isRecording = false;
    _volumeLevel = 0.0;
    _stopVolumeListener();
    notifyListeners();

    return transcribedText;
  }

  /// Cancel recording
  Future<void> cancelRecording() async {
    if (!_isRecording) return;

    final result = await _voiceService.cancelRecording();

    result.when(
      success: (_) {
        _recognizedText = '';
        _clearError();
      },
      error: (message) {
        _setError(message);
      },
    );

    _isRecording = false;
    _volumeLevel = 0.0;
    _stopVolumeListener();
    notifyListeners();
  }

  /// Toggle recording (start if not recording, stop if recording)
  Future<String?> toggleRecording() async {
    if (_isRecording) {
      return await stopRecording();
    } else {
      await startRecording();
      return null;
    }
  }

  // ========================================
  // VOICE OUTPUT
  // ========================================

  /// Speak text aloud
  Future<void> speak(String text, {double? speed}) async {
    if (text.isEmpty) return;

    _clearError();

    // Stop any current speech
    if (_isSpeaking) {
      await stopSpeaking();
    }

    final result = await _voiceService.speak(text, speed: speed ?? 1.0);

    result.when(
      success: (_) {
        _isSpeaking = true;
        notifyListeners();

        // Auto-update speaking state when complete
        // (VoiceService handles this via completion handler)
        _startSpeakingMonitor();
      },
      error: (message) {
        _setError(message);
        _isSpeaking = false;
        notifyListeners();
      },
    );
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    if (!_isSpeaking) return;

    final result = await _voiceService.stopSpeaking();

    result.when(
      success: (_) {
        _isSpeaking = false;
        notifyListeners();
      },
      error: (message) {
        _setError(message);
      },
    );
  }

  /// Pause speaking
  Future<void> pauseSpeaking() async {
    if (!_isSpeaking) return;

    final result = await _voiceService.pauseSpeaking();

    result.when(
      success: (_) {
        // Keep _isSpeaking true since it's paused, not stopped
        notifyListeners();
      },
      error: (message) {
        _setError(message);
      },
    );
  }

  /// Toggle speaking (stop if speaking, speak if not)
  Future<void> toggleSpeaking(String text, {double? speed}) async {
    if (_isSpeaking) {
      await stopSpeaking();
    } else {
      await speak(text, speed: speed);
    }
  }

  // ========================================
  // VOLUME MONITORING
  // ========================================

  /// Start listening to volume level changes
  void _startVolumeListener() {
    _volumeSubscription?.cancel();

    _volumeSubscription = _voiceService.volumeLevelStream.listen(
      (level) {
        _volumeLevel = level;
        notifyListeners();
      },
      onError: (error) {
        _setError('Volume monitoring error: $error');
      },
    );
  }

  /// Stop listening to volume level changes
  void _stopVolumeListener() {
    _volumeSubscription?.cancel();
    _volumeSubscription = null;
  }

  // ========================================
  // SPEAKING MONITOR
  // ========================================

  /// Monitor speaking state and update when complete
  void _startSpeakingMonitor() {
    // Check speaking state periodically
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isSpeaking || !_voiceService.isSpeaking) {
        _isSpeaking = false;
        notifyListeners();
        timer.cancel();
      }
    });
  }

  // ========================================
  // UTILITY METHODS
  // ========================================

  /// Clear recognized text
  void clearRecognizedText() {
    _recognizedText = '';
    notifyListeners();
  }

  /// Check if speech recognition is available
  Future<bool> checkSpeechRecognitionAvailable() async {
    return await _voiceService.isSpeechRecognitionAvailable();
  }

  /// Get available TTS voices
  Future<List<dynamic>?> getAvailableVoices() async {
    final result = await _voiceService.getAvailableVoices();

    return result.when(
      success: (voices) => voices,
      error: (message) {
        _setError(message);
        return null;
      },
    );
  }

  // ========================================
  // PRIVATE METHODS
  // ========================================

  /// Set error message
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _error = null;
  }

  // ========================================
  // DISPOSE
  // ========================================

  @override
  void dispose() {
    _stopVolumeListener();
    _voiceService.dispose();
    super.dispose();
  }
}
