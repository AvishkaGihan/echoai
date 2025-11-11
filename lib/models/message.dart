import 'package:uuid/uuid.dart';

/// Represents a single message in a conversation
/// Can be from user or AI, with optional reactions and metadata
class Message {
  /// Unique identifier for this message
  final String id;

  /// ID of the conversation this message belongs to
  final String conversationId;

  /// The actual message content/text
  final String text;

  /// True if sent by user, false if sent by AI
  final bool isUserMessage;

  /// When this message was created
  final DateTime timestamp;

  /// True while AI response is still streaming in
  final bool isStreaming;

  /// List of emoji reactions (e.g., ['👍', '❤️'])
  final List<String> reactions;

  /// Error message if something went wrong (transcription, API, etc.)
  final String? errorMessage;

  /// Number of tokens used by this message (for rate limiting)
  final int tokensUsed;

  const Message({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.isUserMessage,
    required this.timestamp,
    this.isStreaming = false,
    this.reactions = const [],
    this.errorMessage,
    this.tokensUsed = 0,
  });

  /// Create a new user message
  factory Message.user({required String conversationId, required String text}) {
    return Message(
      id: const Uuid().v4(),
      conversationId: conversationId,
      text: text,
      isUserMessage: true,
      timestamp: DateTime.now(),
      isStreaming: false,
    );
  }

  /// Create a new AI message (initially empty and streaming)
  factory Message.ai({required String conversationId, String text = ''}) {
    return Message(
      id: const Uuid().v4(),
      conversationId: conversationId,
      text: text,
      isUserMessage: false,
      timestamp: DateTime.now(),
      isStreaming: true,
    );
  }

  /// Create a copy with updated fields
  Message copyWith({
    String? id,
    String? conversationId,
    String? text,
    bool? isUserMessage,
    DateTime? timestamp,
    bool? isStreaming,
    List<String>? reactions,
    String? errorMessage,
    int? tokensUsed,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      timestamp: timestamp ?? this.timestamp,
      isStreaming: isStreaming ?? this.isStreaming,
      reactions: reactions ?? this.reactions,
      errorMessage: errorMessage ?? this.errorMessage,
      tokensUsed: tokensUsed ?? this.tokensUsed,
    );
  }

  /// Convert to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'text': text,
      'is_user_message': isUserMessage ? 1 : 0,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'is_streaming': isStreaming ? 1 : 0,
      'reactions': reactions.join(','), // Store as comma-separated string
      'error_message': errorMessage,
      'tokens_used': tokensUsed,
    };
  }

  /// Create from Map (SQLite query result)
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      conversationId: map['conversation_id'] as String,
      text: map['text'] as String,
      isUserMessage: (map['is_user_message'] as int) == 1,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      isStreaming: (map['is_streaming'] as int) == 1,
      reactions: (map['reactions'] as String).isEmpty
          ? []
          : (map['reactions'] as String).split(','),
      errorMessage: map['error_message'] as String?,
      tokensUsed: map['tokens_used'] as int? ?? 0,
    );
  }

  /// Check if message has an error
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  /// Check if message has reactions
  bool get hasReactions => reactions.isNotEmpty;

  /// Add a reaction to this message
  Message addReaction(String emoji) {
    if (reactions.contains(emoji)) {
      return this; // Already has this reaction
    }
    return copyWith(reactions: [...reactions, emoji]);
  }

  /// Remove a reaction from this message
  Message removeReaction(String emoji) {
    return copyWith(reactions: reactions.where((r) => r != emoji).toList());
  }

  @override
  String toString() {
    return 'Message(id: $id, conversationId: $conversationId, '
        'isUser: $isUserMessage, text: ${text.substring(0, text.length > 50 ? 50 : text.length)}..., '
        'timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
