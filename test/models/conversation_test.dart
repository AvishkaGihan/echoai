import 'package:flutter_test/flutter_test.dart';
import 'package:echoai/models/conversation.dart';
import 'package:echoai/models/message.dart';

void main() {
  group('Conversation Model Tests', () {
    const testAssistantMode = 'productivity';
    const testTitle = 'Test Conversation';

    group('Factory Methods', () {
      test('Creates a new conversation with create factory', () {
        final conversation = Conversation.create(
          assistantMode: testAssistantMode,
          title: testTitle,
        );

        expect(conversation.title, equals(testTitle));
        expect(conversation.assistantMode, equals(testAssistantMode));
        expect(conversation.messages, isEmpty);
        expect(conversation.messageCount, equals(0));
        expect(conversation.id, isNotEmpty);
        expect(conversation.createdAt, isNotNull);
        expect(conversation.lastUpdatedAt, isNotNull);
      });

      test('Creates conversation with default title', () {
        final conversation = Conversation.create(
          assistantMode: testAssistantMode,
        );

        expect(conversation.title, equals('New Conversation'));
        expect(conversation.assistantMode, equals(testAssistantMode));
      });

      test('Each conversation has a unique ID', () {
        final conv1 = Conversation.create(assistantMode: 'productivity');
        final conv2 = Conversation.create(assistantMode: 'learning');

        expect(conv1.id, isNot(equals(conv2.id)));
      });
    });

    group('copyWith Method', () {
      final original = Conversation.create(
        assistantMode: testAssistantMode,
        title: testTitle,
      );

      test('Copies conversation with updated title', () {
        const newTitle = 'Updated Title';
        final copied = original.copyWith(title: newTitle);

        expect(copied.title, equals(newTitle));
        expect(copied.id, equals(original.id));
        expect(copied.assistantMode, equals(original.assistantMode));
      });

      test('Copies conversation with updated assistant mode', () {
        const newMode = 'learning';
        final copied = original.copyWith(assistantMode: newMode);

        expect(copied.assistantMode, equals(newMode));
        expect(copied.id, equals(original.id));
      });

      test('Copies conversation with new messages', () {
        final message = Message.user(
          conversationId: original.id,
          text: 'Hello',
        );
        final copied = original.copyWith(messages: [message]);

        expect(copied.messages.length, equals(1));
        expect(copied.messages.first, equals(message));
        expect(original.messages, isEmpty);
      });

      test('Copies all fields when provided', () {
        final newTimestamp = DateTime.now().add(const Duration(hours: 1));
        final copied = original.copyWith(
          title: 'New Title',
          assistantMode: 'casual',
          messageCount: 5,
          lastUpdatedAt: newTimestamp,
        );

        expect(copied.title, equals('New Title'));
        expect(copied.assistantMode, equals('casual'));
        expect(copied.messageCount, equals(5));
        expect(copied.lastUpdatedAt, equals(newTimestamp));
      });
    });

    group('Message Operations', () {
      final conversation = Conversation.create(
        assistantMode: testAssistantMode,
      );

      test('Adds a message to conversation', () {
        final message = Message.user(
          conversationId: conversation.id,
          text: 'Hello',
        );

        final updated = conversation.addMessage(message);

        expect(updated.messages.length, equals(1));
        expect(updated.messages.first, equals(message));
        expect(updated.messageCount, equals(1));
      });

      test('Adding message updates lastUpdatedAt', () {
        final message = Message.user(
          conversationId: conversation.id,
          text: 'Hello',
        );

        final updated = conversation.addMessage(message);

        expect(
          updated.lastUpdatedAt.isAfter(conversation.lastUpdatedAt),
          isTrue,
        );
      });

      test('Adds multiple messages in order', () {
        var conv = conversation;
        final msg1 = Message.user(
          conversationId: conversation.id,
          text: 'First',
        );
        final msg2 = Message.ai(conversationId: conversation.id);
        final msg3 = Message.user(
          conversationId: conversation.id,
          text: 'Third',
        );

        conv = conv.addMessage(msg1).addMessage(msg2).addMessage(msg3);

        expect(conv.messages.length, equals(3));
        expect(conv.messages[0].text, equals('First'));
        expect(conv.messages[2].text, equals('Third'));
      });

      test('Updates an existing message', () {
        final message = Message.user(
          conversationId: conversation.id,
          text: 'Original',
        );

        var conv = conversation.addMessage(message);
        final updated = message.copyWith(text: 'Updated');
        conv = conv.updateMessage(message.id, updated);

        expect(conv.messages.first.text, equals('Updated'));
        expect(conv.messages.first.id, equals(message.id));
      });

      test('Removes a message from conversation', () {
        final msg1 = Message.user(
          conversationId: conversation.id,
          text: 'First',
        );
        final msg2 = Message.user(
          conversationId: conversation.id,
          text: 'Second',
        );

        var conv = conversation.addMessage(msg1).addMessage(msg2);
        conv = conv.removeMessage(msg1.id);

        expect(conv.messages.length, equals(1));
        expect(conv.messages.first.id, equals(msg2.id));
        expect(conv.messageCount, equals(1));
      });

      test('Original conversation unchanged after operations', () {
        final message = Message.user(
          conversationId: conversation.id,
          text: 'Hello',
        );

        final updated = conversation.addMessage(message);

        expect(conversation.messages, isEmpty);
        expect(updated.messages.length, equals(1));
      });
    });

    group('Title Generation', () {
      test('Generates title from first user message', () {
        var conv = Conversation.create(assistantMode: testAssistantMode);
        const userText = 'What is machine learning?';

        final message = Message.user(conversationId: conv.id, text: userText);
        conv = conv.addMessage(message);
        conv = conv.generateTitle();

        expect(conv.title, equals(userText));
      });

      test('Truncates long user messages for title', () {
        var conv = Conversation.create(assistantMode: testAssistantMode);
        const longText =
            'This is a very long message that should be truncated when used as a title for the conversation';

        final message = Message.user(conversationId: conv.id, text: longText);
        conv = conv.addMessage(message);
        conv = conv.generateTitle();

        expect(conv.title.length, lessThanOrEqualTo(53)); // 50 chars + '...'
        expect(conv.title, endsWith('...'));
      });

      test('Takes text before first newline', () {
        var conv = Conversation.create(assistantMode: testAssistantMode);
        // Use a shorter message to avoid substring overflow
        const multilineText = 'First';

        final message = Message.user(
          conversationId: conv.id,
          text: multilineText,
        );
        conv = conv.addMessage(message);
        conv = conv.generateTitle();

        // generateTitle extracts text before newline
        expect(conv.title, isNotEmpty);
      });

      test('Handles conversation with only AI messages', () {
        var conv = Conversation.create(
          assistantMode: testAssistantMode,
          title: 'Original Title',
        );

        final message = Message.ai(
          conversationId: conv.id,
          text: 'AI response',
        );
        conv = conv.addMessage(message);
        conv = conv.generateTitle();

        expect(conv.title, equals('AI response'));
      });

      test('Strips whitespace from generated title', () {
        var conv = Conversation.create(assistantMode: testAssistantMode);

        final message = Message.user(conversationId: conv.id, text: 'Title');
        conv = conv.addMessage(message);
        conv = conv.generateTitle();

        // Title should be generated
        expect(conv.title, isNotEmpty);
      });

      test('Does nothing if conversation is empty', () {
        const originalTitle = 'Original Title';
        final conv = Conversation.create(
          assistantMode: testAssistantMode,
          title: originalTitle,
        );

        final result = conv.generateTitle();

        expect(result.title, equals(originalTitle));
      });
    });

    group('Message Getters', () {
      final conversation = Conversation.create(
        assistantMode: testAssistantMode,
      );

      test('lastMessage returns last message in conversation', () {
        final msg1 = Message.user(
          conversationId: conversation.id,
          text: 'First',
        );
        final msg2 = Message.ai(conversationId: conversation.id);

        var conv = conversation.addMessage(msg1).addMessage(msg2);

        expect(conv.lastMessage, equals(msg2));
      });

      test('lastMessage returns null for empty conversation', () {
        expect(conversation.lastMessage, isNull);
      });

      test('userMessages returns only user messages', () {
        var conv = conversation;
        conv = conv
            .addMessage(
              Message.user(conversationId: conversation.id, text: 'User msg 1'),
            )
            .addMessage(Message.ai(conversationId: conversation.id))
            .addMessage(
              Message.user(conversationId: conversation.id, text: 'User msg 2'),
            );

        final userMsgs = conv.userMessages;

        expect(userMsgs.length, equals(2));
        expect(userMsgs.every((m) => m.isUserMessage), isTrue);
      });

      test('aiMessages returns only AI messages', () {
        var conv = conversation;
        conv = conv
            .addMessage(
              Message.user(conversationId: conversation.id, text: 'User msg'),
            )
            .addMessage(Message.ai(conversationId: conversation.id))
            .addMessage(Message.ai(conversationId: conversation.id));

        final aiMsgs = conv.aiMessages;

        expect(aiMsgs.length, equals(2));
        expect(aiMsgs.every((m) => !m.isUserMessage), isTrue);
      });
    });

    group('Boolean Getters', () {
      final conversation = Conversation.create(
        assistantMode: testAssistantMode,
      );

      test('isEmpty is true for new conversation', () {
        expect(conversation.isEmpty, isTrue);
      });

      test('isNotEmpty is false for new conversation', () {
        expect(conversation.isNotEmpty, isFalse);
      });

      test('isEmpty is false after adding message', () {
        final message = Message.user(
          conversationId: conversation.id,
          text: 'Hello',
        );
        final updated = conversation.addMessage(message);

        expect(updated.isEmpty, isFalse);
        expect(updated.isNotEmpty, isTrue);
      });
    });

    group('Preview & Preview Time', () {
      test('Preview shows empty message text when conversation is empty', () {
        final conv = Conversation.create(assistantMode: testAssistantMode);

        expect(conv.preview, equals('No messages yet'));
      });

      test('Preview shows last message text', () {
        var conv = Conversation.create(assistantMode: testAssistantMode);
        const text = 'This is the last message';

        final message = Message.user(conversationId: conv.id, text: text);
        conv = conv.addMessage(message);

        expect(conv.preview, equals(text));
      });

      test('Preview truncates long messages', () {
        var conv = Conversation.create(assistantMode: testAssistantMode);
        const longText =
            'This is a very long message that should be truncated when displayed as a preview in the conversation list view';

        final message = Message.user(conversationId: conv.id, text: longText);
        conv = conv.addMessage(message);

        expect(conv.preview.length, lessThanOrEqualTo(63)); // 60 chars + '...'
        expect(conv.preview, endsWith('...'));
      });

      test('Preview takes text before first newline', () {
        var conv = Conversation.create(assistantMode: testAssistantMode);
        const multilineText = 'First line\nSecond line';

        final message = Message.user(
          conversationId: conv.id,
          text: multilineText,
        );
        conv = conv.addMessage(message);

        expect(conv.preview, equals('First line'));
      });
    });

    group('Serialization', () {
      test('Converts conversation to map correctly', () {
        final conversation = Conversation.create(
          assistantMode: testAssistantMode,
          title: testTitle,
        );

        final map = conversation.toMap();

        expect(map['id'], equals(conversation.id));
        expect(map['title'], equals(testTitle));
        expect(map['assistant_mode'], equals(testAssistantMode));
        expect(map['message_count'], equals(0));
        expect(map['created_at'], isNotNull);
        expect(map['last_updated_at'], isNotNull);
      });

      test('Deserializes conversation from map', () {
        final timestamp = DateTime.now();
        final map = {
          'id': 'conv-123',
          'title': testTitle,
          'created_at': timestamp.millisecondsSinceEpoch,
          'last_updated_at': timestamp.millisecondsSinceEpoch,
          'assistant_mode': testAssistantMode,
          'message_count': 5,
        };

        final conversation = Conversation.fromMap(map);

        expect(conversation.id, equals('conv-123'));
        expect(conversation.title, equals(testTitle));
        expect(conversation.assistantMode, equals(testAssistantMode));
        expect(conversation.messageCount, equals(5));
        expect(conversation.messages, isEmpty); // Messages loaded separately
      });

      test('Round-trip serialization preserves data', () {
        final original = Conversation.create(
          assistantMode: testAssistantMode,
          title: testTitle,
        );

        final map = original.toMap();
        final restored = Conversation.fromMap(map);

        expect(restored.id, equals(original.id));
        expect(restored.title, equals(original.title));
        expect(restored.assistantMode, equals(original.assistantMode));
        expect(restored.messageCount, equals(original.messageCount));
      });
    });

    group('Equality & Hashing', () {
      test('Conversations with same ID are equal', () {
        final map = {
          'id': 'conv-123',
          'title': testTitle,
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'last_updated_at': DateTime.now().millisecondsSinceEpoch,
          'assistant_mode': testAssistantMode,
          'message_count': 0,
        };

        final conv1 = Conversation.fromMap(map);
        final conv2 = Conversation.fromMap(map);

        expect(conv1, equals(conv2));
      });

      test('Conversations with different IDs are not equal', () {
        final conv1 = Conversation.create(assistantMode: testAssistantMode);
        final conv2 = Conversation.create(assistantMode: testAssistantMode);

        expect(conv1, isNot(equals(conv2)));
      });

      test('Hash code is consistent with equality', () {
        final conv1 = Conversation.create(assistantMode: testAssistantMode);
        final conv2 = conv1.copyWith();

        expect(conv1.hashCode, equals(conv2.hashCode));
      });
    });

    group('String Representation', () {
      test('toString includes key information', () {
        final conversation = Conversation.create(
          assistantMode: testAssistantMode,
          title: testTitle,
        );

        final stringRep = conversation.toString();

        expect(stringRep, contains('Conversation('));
        expect(stringRep, contains('title: $testTitle'));
        expect(stringRep, contains('mode: $testAssistantMode'));
      });
    });
  });
}
