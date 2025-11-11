import 'package:uuid/uuid.dart';
import 'message.dart';

/// Represents a full conversation with messages and metadata
class Conversation {
  /// Unique identifier for this conversation
  final String id;

  /// Auto-generated title from first user message
  final String title;

  /// All messages in this conversation (chronological order)
  final List<Message> messages;

  /// When this conversation was created
  final DateTime createdAt;

  /// Last time a message was added to this conversation
  final DateTime lastUpdatedAt;

  /// Assistant mode used for this conversation
  /// One of: "productivity", "learning", "casual"
  final String assistantMode;

  /// Cached message count for performance
  final int messageCount;

  const Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.assistantMode,
    required this.messageCount,
  });

  /// Create a new empty conversation
  factory Conversation.create({
    required String assistantMode,
    String title = 'New Conversation',
  }) {
    final now = DateTime.now();
    return Conversation(
      id: const Uuid().v4(),
      title: title,
      messages: [],
      createdAt: now,
      lastUpdatedAt: now,
      assistantMode: assistantMode,
      messageCount: 0,
    );
  }

  /// Create a copy with updated fields
  Conversation copyWith({
    String? id,
    String? title,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    String? assistantMode,
    int? messageCount,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      assistantMode: assistantMode ?? this.assistantMode,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  /// Convert to Map for SQLite storage (without messages)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.millisecondsSinceEpoch,
      'last_updated_at': lastUpdatedAt.millisecondsSinceEpoch,
      'assistant_mode': assistantMode,
      'message_count': messageCount,
    };
  }

  /// Create from Map (SQLite query result)
  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      title: map['title'] as String,
      messages: [], // Messages loaded separately
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      lastUpdatedAt: DateTime.fromMillisecondsSinceEpoch(
        map['last_updated_at'] as int,
      ),
      assistantMode: map['assistant_mode'] as String,
      messageCount: map['message_count'] as int,
    );
  }

  /// Add a message to this conversation
  Conversation addMessage(Message message) {
    final updatedMessages = [...messages, message];
    return copyWith(
      messages: updatedMessages,
      lastUpdatedAt: DateTime.now(),
      messageCount: updatedMessages.length,
    );
  }

  /// Update an existing message (useful for streaming updates)
  Conversation updateMessage(String messageId, Message updatedMessage) {
    final updatedMessages = messages.map((m) {
      return m.id == messageId ? updatedMessage : m;
    }).toList();

    return copyWith(messages: updatedMessages, lastUpdatedAt: DateTime.now());
  }

  /// Remove a message from this conversation
  Conversation removeMessage(String messageId) {
    final updatedMessages = messages.where((m) => m.id != messageId).toList();
    return copyWith(
      messages: updatedMessages,
      lastUpdatedAt: DateTime.now(),
      messageCount: updatedMessages.length,
    );
  }

  /// Generate a title from the first user message
  Conversation generateTitle() {
    if (messages.isEmpty) return this;

    final firstUserMessage = messages.firstWhere(
      (m) => m.isUserMessage,
      orElse: () => messages.first,
    );

    // Take first 50 characters or until first newline
    String generatedTitle = firstUserMessage.text
        .split('\n')
        .first
        .trim()
        .substring(
          0,
          firstUserMessage.text.length > 50 ? 50 : firstUserMessage.text.length,
        );

    // Add ellipsis if truncated
    if (firstUserMessage.text.length > 50) {
      generatedTitle += '...';
    }

    return copyWith(title: generatedTitle);
  }

  /// Get the last message in this conversation
  Message? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  /// Get only user messages
  List<Message> get userMessages {
    return messages.where((m) => m.isUserMessage).toList();
  }

  /// Get only AI messages
  List<Message> get aiMessages {
    return messages.where((m) => !m.isUserMessage).toList();
  }

  /// Check if conversation has any messages
  bool get isEmpty => messages.isEmpty;

  /// Check if conversation has messages
  bool get isNotEmpty => messages.isNotEmpty;

  /// Get a preview of the last message (for conversation list)
  String get preview {
    if (messages.isEmpty) return 'No messages yet';
    final lastMsg = messages.last;
    final previewText = lastMsg.text.split('\n').first.trim();
    return previewText.length > 60
        ? '${previewText.substring(0, 60)}...'
        : previewText;
  }

  /// Get time ago string for last update
  String get lastUpdatedAgo {
    final now = DateTime.now();
    final difference = now.difference(lastUpdatedAt);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  @override
  String toString() {
    return 'Conversation(id: $id, title: $title, '
        'messageCount: $messageCount, mode: $assistantMode, '
        'lastUpdated: $lastUpdatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
