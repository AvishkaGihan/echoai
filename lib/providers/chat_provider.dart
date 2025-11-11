import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/message.dart';
import '../models/conversation.dart';
import '../services/database_service.dart';
import '../services/gemini_service.dart';

/// Chat state provider
class ChatProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final GeminiService _geminiService = GeminiService();

  // State
  Conversation? _currentConversation;
  bool _isLoading = false;
  bool _isStreaming = false;
  String? _error;
  String _assistantMode = 'productivity';

  // ========================================
  // GETTERS
  // ========================================

  /// Current conversation
  Conversation? get currentConversation => _currentConversation;

  /// Messages in current conversation
  List<Message> get messages => _currentConversation?.messages ?? [];

  /// Loading state
  bool get isLoading => _isLoading;

  /// Streaming state (AI is currently responding)
  bool get isStreaming => _isStreaming;

  /// Error message
  String? get error => _error;

  /// Current assistant mode
  String get assistantMode => _assistantMode;

  /// Check if there's an active conversation
  bool get hasActiveConversation => _currentConversation != null;

  // ========================================
  // CONVERSATION MANAGEMENT
  // ========================================

  /// Start a new conversation
  Future<void> startNewConversation() async {
    _currentConversation = Conversation.create(assistantMode: _assistantMode);
    _clearError();
    notifyListeners();
  }

  /// Load an existing conversation
  Future<void> loadConversation(String conversationId) async {
    _setLoading(true);
    _clearError();

    final result = await _databaseService.getConversation(conversationId);

    result.when(
      success: (conversation) {
        _currentConversation = conversation;
        _assistantMode = conversation.assistantMode;
        _setLoading(false);
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
      },
    );
  }

  /// Save current conversation
  Future<void> saveConversation() async {
    if (_currentConversation == null) return;

    final result = await _databaseService.saveConversation(
      _currentConversation!,
    );

    result.when(
      success: (_) {
        // Success - conversation saved
      },
      error: (message) {
        _setError(message);
      },
    );
  }

  /// Change assistant mode
  void setAssistantMode(String mode) {
    _assistantMode = mode;

    if (_currentConversation != null) {
      _currentConversation = _currentConversation!.copyWith(
        assistantMode: mode,
      );
    }

    notifyListeners();
  }

  // ========================================
  // MESSAGE OPERATIONS
  // ========================================

  /// Send a text message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Create conversation if needed
    if (_currentConversation == null) {
      await startNewConversation();
    }

    _clearError();

    // Create user message
    final userMessage = Message.user(
      conversationId: _currentConversation!.id,
      text: text.trim(),
    );

    // Add user message to conversation
    _currentConversation = _currentConversation!.addMessage(userMessage);
    notifyListeners();

    // Save user message to database
    await _databaseService.saveMessage(userMessage);

    // Generate title from first message
    if (_currentConversation!.messages.length == 1) {
      _currentConversation = _currentConversation!.generateTitle();
    }

    // Create AI message placeholder
    final aiMessage = Message.ai(conversationId: _currentConversation!.id);

    _currentConversation = _currentConversation!.addMessage(aiMessage);
    _isStreaming = true;
    notifyListeners();

    // Get AI response (streaming)
    await _getStreamingResponse(aiMessage);
  }

  /// Get streaming response from AI
  Future<void> _getStreamingResponse(Message aiMessage) async {
    final responseStream = _geminiService.getResponseStream(
      conversationHistory: messages,
      userMessage: messages.last.text,
      assistantMode: _assistantMode,
    );

    String accumulatedText = '';

    try {
      await for (final chunk in responseStream) {
        accumulatedText += chunk;

        // Update AI message with accumulated text
        final updatedMessage = aiMessage.copyWith(
          text: accumulatedText,
          isStreaming: true,
        );

        _currentConversation = _currentConversation!.updateMessage(
          aiMessage.id,
          updatedMessage,
        );

        notifyListeners();
      }

      // Mark as complete
      final finalMessage = aiMessage.copyWith(
        text: accumulatedText,
        isStreaming: false,
      );

      _currentConversation = _currentConversation!.updateMessage(
        aiMessage.id,
        finalMessage,
      );

      _isStreaming = false;
      notifyListeners();

      // Save AI message to database
      await _databaseService.saveMessage(finalMessage);

      // Save conversation metadata
      await saveConversation();
    } catch (e) {
      // Handle streaming error
      final errorMessage = aiMessage.copyWith(
        text: 'Failed to get response',
        isStreaming: false,
        errorMessage: e.toString(),
      );

      _currentConversation = _currentConversation!.updateMessage(
        aiMessage.id,
        errorMessage,
      );

      _isStreaming = false;
      _setError('Failed to get AI response');
    }
  }

  /// Retry failed message
  Future<void> retryMessage(String messageId) async {
    final message = messages.firstWhere((m) => m.id == messageId);

    if (message.isUserMessage) {
      // Retry by sending the same message again
      await sendMessage(message.text);
    } else {
      // Find previous user message and retry
      final messageIndex = messages.indexOf(message);
      if (messageIndex > 0) {
        final previousMessage = messages[messageIndex - 1];
        if (previousMessage.isUserMessage) {
          // Remove failed AI message
          _currentConversation = _currentConversation!.removeMessage(messageId);
          notifyListeners();

          // Send user message again
          await sendMessage(previousMessage.text);
        }
      }
    }
  }

  // ========================================
  // MESSAGE INTERACTIONS
  // ========================================

  /// Add reaction to message
  Future<void> addReaction(String messageId, String emoji) async {
    if (_currentConversation == null) return;

    final message = messages.firstWhere((m) => m.id == messageId);
    final updatedMessage = message.addReaction(emoji);

    _currentConversation = _currentConversation!.updateMessage(
      messageId,
      updatedMessage,
    );

    notifyListeners();

    // Save to database
    await _databaseService.updateMessage(updatedMessage);
  }

  /// Remove reaction from message
  Future<void> removeReaction(String messageId, String emoji) async {
    if (_currentConversation == null) return;

    final message = messages.firstWhere((m) => m.id == messageId);
    final updatedMessage = message.removeReaction(emoji);

    _currentConversation = _currentConversation!.updateMessage(
      messageId,
      updatedMessage,
    );

    notifyListeners();

    // Save to database
    await _databaseService.updateMessage(updatedMessage);
  }

  /// Copy message text to clipboard
  String getMessageText(String messageId) {
    final message = messages.firstWhere((m) => m.id == messageId);
    return message.text;
  }

  // ========================================
  // PRIVATE METHODS
  // ========================================

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

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
  // CLEANUP
  // ========================================

  /// Clear current conversation
  void clearConversation() {
    _currentConversation = null;
    _clearError();
    notifyListeners();
  }
}
