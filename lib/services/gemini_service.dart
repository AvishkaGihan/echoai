import 'dart:async';
import 'package:firebase_ai/firebase_ai.dart';

import '../models/message.dart';
import '../utils/result.dart';
import '../utils/constants.dart';
import '../config/api_config.dart';

/// Gemini AI service using Firebase AI Logic
class GeminiService {
  // Singleton pattern
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  // Rate limiting
  DateTime? _lastRequestTime;

  // ========================================
  // INITIALIZATION
  // ========================================

  /// Initialize Gemini model
  GenerativeModel _getModel(String assistantMode) {
    // Get system prompt based on mode
    final systemPrompt = AppConstants.getSystemPrompt(assistantMode);

    return FirebaseAI.googleAI().generativeModel(
      model: ApiConfig.geminiModel,
      generationConfig: GenerationConfig(
        temperature: ApiConfig.temperature,
        topK: ApiConfig.topK,
        topP: ApiConfig.topP,
        maxOutputTokens: ApiConfig.maxTokens,
      ),
      systemInstruction: Content.text(systemPrompt),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium, null),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium, null),
        SafetySetting(
          HarmCategory.sexuallyExplicit,
          HarmBlockThreshold.medium,
          null,
        ),
        SafetySetting(
          HarmCategory.dangerousContent,
          HarmBlockThreshold.medium,
          null,
        ),
      ],
    );
  }

  // ========================================
  // STREAMING RESPONSE
  // ========================================

  /// Get streaming response from Gemini
  Stream<String> getResponseStream({
    required List<Message> conversationHistory,
    required String userMessage,
    required String assistantMode,
  }) async* {
    try {
      // Check rate limit
      await _checkRateLimit();

      // Get model with current assistant mode
      final model = _getModel(assistantMode);

      // Build conversation history for context
      final history = _buildConversationHistory(conversationHistory);

      // Start chat session with history
      final chat = model.startChat(history: history);

      // Send message and stream response
      final response = chat.sendMessageStream(Content.text(userMessage));

      // Update last request time
      _lastRequestTime = DateTime.now();

      // Stream tokens as they arrive
      await for (final chunk in response) {
        final text = chunk.text;
        if (text != null && text.isNotEmpty) {
          yield text;
        }
      }
    } on TimeoutException {
      yield '[Error: Request timed out. Please try again.]';
    } catch (e) {
      yield '[Error: ${_mapError(e)}]';
    }
  }

  /// Get complete response (non-streaming)
  Future<Result<String>> getResponse({
    required List<Message> conversationHistory,
    required String userMessage,
    required String assistantMode,
  }) async {
    try {
      // Check rate limit
      await _checkRateLimit();

      // Get model with current assistant mode
      final model = _getModel(assistantMode);

      // Build conversation history
      final history = _buildConversationHistory(conversationHistory);

      // Start chat session
      final chat = model.startChat(history: history);

      // Send message and get response
      final response = await chat
          .sendMessage(Content.text(userMessage))
          .timeout(const Duration(milliseconds: ApiConfig.apiTimeoutMs));

      // Update last request time
      _lastRequestTime = DateTime.now();

      // Extract text from response
      final text = response.text;
      if (text == null || text.isEmpty) {
        return Result.error('Empty response from AI');
      }

      return Result.success(text);
    } on TimeoutException {
      return Result.error('Request timed out. Please try again.');
    } catch (e) {
      return Result.error(_mapError(e));
    }
  }

  // ========================================
  // TRANSCRIPTION (Future Feature)
  // ========================================

  /// Transcribe audio to text using Gemini
  /// Note: This requires Gemini Pro with multimodal support
  Future<Result<String>> transcribeAudio(List<int> audioData) async {
    try {
      // Check rate limit
      await _checkRateLimit();

      // TODO: Implement audio transcription when Firebase AI Logic supports it
      // For now, return error
      return Result.error(
        'Audio transcription not yet supported. Use speech_to_text package.',
      );

      // Future implementation:
      // final model = _getModel('productivity');
      // final content = Content.multi([
      //   DataPart('audio/wav', Uint8List.fromList(audioData)),
      //   TextPart('Transcribe this audio to text.'),
      // ]);
      // final response = await model.generateContent([content]);
      // return Result.success(response.text ?? '');
    } catch (e) {
      return Result.error('Failed to transcribe audio: ${e.toString()}');
    }
  }

  // ========================================
  // HELPER METHODS
  // ========================================

  /// Build conversation history for Gemini API
  List<Content> _buildConversationHistory(List<Message> messages) {
    // Only include recent messages to stay within token limits
    // Take last 10 message pairs (20 messages total)
    final recentMessages = messages.length > 20
        ? messages.sublist(messages.length - 20)
        : messages;

    final history = <Content>[];

    for (final message in recentMessages) {
      // Skip streaming messages and error messages
      if (message.isStreaming || message.hasError) continue;

      // Add to history
      history.add(
        Content(message.isUserMessage ? 'user' : 'model', [
          TextPart(message.text),
        ]),
      );
    }

    return history;
  }

  /// Check and enforce rate limiting
  Future<void> _checkRateLimit() async {
    if (_lastRequestTime == null) return;

    final delay = ApiConfig.getRateLimitDelay(_lastRequestTime!);

    if (delay > 0) {
      // Wait for rate limit cooldown
      await Future.delayed(Duration(milliseconds: delay));
    }
  }

  /// Map errors to user-friendly messages
  String _mapError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network error. Check your connection and try again.';
    }

    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    if (errorString.contains('quota') || errorString.contains('limit')) {
      return 'Rate limit reached. Please wait a moment and try again.';
    }

    if (errorString.contains('api key') || errorString.contains('auth')) {
      return 'Authentication error. Please check your setup.';
    }

    if (errorString.contains('safety') || errorString.contains('blocked')) {
      return 'Response blocked by safety filters. Please rephrase your message.';
    }

    // Generic error
    return 'Something went wrong. Please try again.';
  }

  // ========================================
  // TESTING & DEBUG
  // ========================================

  /// Test connection to Gemini API
  Future<Result<bool>> testConnection() async {
    try {
      final model = _getModel('casual');
      final response = await model
          .generateContent([
            Content.text('Hello! Please respond with just "OK".'),
          ])
          .timeout(const Duration(milliseconds: ApiConfig.apiTimeoutMs));

      if (response.text != null && response.text!.isNotEmpty) {
        return Result.success(true);
      }

      return Result.error('Empty response from API');
    } catch (e) {
      return Result.error('Connection test failed: ${_mapError(e)}');
    }
  }

  /// Get remaining rate limit info
  int getRemainingRequests() {
    if (_lastRequestTime == null) {
      return ApiConfig.rateLimitRequestsPerMinute;
    }

    final now = DateTime.now();
    final elapsedMs = now.difference(_lastRequestTime!).inMilliseconds;
    final windowMs = 60000; // 1 minute

    if (elapsedMs >= windowMs) {
      return ApiConfig.rateLimitRequestsPerMinute;
    }

    // Calculate based on cooldown period
    final requestsMade = (windowMs / ApiConfig.requestCooldownMs).floor();
    final remaining = ApiConfig.rateLimitRequestsPerMinute - requestsMade;

    return remaining > 0 ? remaining : 0;
  }
}
