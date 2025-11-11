import 'package:flutter_test/flutter_test.dart';
import 'package:echoai/models/message.dart';

void main() {
  group('Message Model Tests', () {
    const testConversationId = 'conv-123';
    const testText = 'Hello, how are you?';

    group('Constructor & Factory Methods', () {
      test('Creates a user message with user factory', () {
        final message = Message.user(
          conversationId: testConversationId,
          text: testText,
        );

        expect(message.conversationId, equals(testConversationId));
        expect(message.text, equals(testText));
        expect(message.isUserMessage, isTrue);
        expect(message.isStreaming, isFalse);
        expect(message.reactions, isEmpty);
        expect(message.errorMessage, isNull);
        expect(message.id, isNotEmpty);
        expect(message.timestamp, isNotNull);
      });

      test('Creates an AI message with ai factory', () {
        final message = Message.ai(conversationId: testConversationId);

        expect(message.conversationId, equals(testConversationId));
        expect(message.text, isEmpty);
        expect(message.isUserMessage, isFalse);
        expect(message.isStreaming, isTrue);
        expect(message.reactions, isEmpty);
        expect(message.id, isNotEmpty);
        expect(message.timestamp, isNotNull);
      });

      test('Creates an AI message with initial text', () {
        const initialText = 'Response...';
        final message = Message.ai(
          conversationId: testConversationId,
          text: initialText,
        );

        expect(message.text, equals(initialText));
        expect(message.isStreaming, isTrue);
      });

      test('Each message has a unique ID', () {
        final message1 = Message.user(
          conversationId: testConversationId,
          text: 'First message',
        );
        final message2 = Message.user(
          conversationId: testConversationId,
          text: 'Second message',
        );

        expect(message1.id, isNot(equals(message2.id)));
      });
    });

    group('copyWith Method', () {
      final originalMessage = Message.user(
        conversationId: testConversationId,
        text: testText,
      );

      test('Copies message with updated text', () {
        const newText = 'Updated text';
        final copied = originalMessage.copyWith(text: newText);

        expect(copied.text, equals(newText));
        expect(copied.id, equals(originalMessage.id));
        expect(copied.isUserMessage, equals(originalMessage.isUserMessage));
      });

      test('Copies message with updated streaming state', () {
        final copied = originalMessage.copyWith(isStreaming: true);

        expect(copied.isStreaming, isTrue);
        expect(copied.id, equals(originalMessage.id));
        expect(copied.text, equals(originalMessage.text));
      });

      test('Copies message with error message', () {
        const errorMsg = 'API Error: Rate limit exceeded';
        final copied = originalMessage.copyWith(errorMessage: errorMsg);

        expect(copied.errorMessage, equals(errorMsg));
        expect(copied.id, equals(originalMessage.id));
      });

      test('Copies all fields when provided', () {
        final newTimestamp = DateTime.now().add(const Duration(hours: 1));
        final copied = originalMessage.copyWith(
          text: 'New text',
          isStreaming: true,
          errorMessage: 'Error',
          tokensUsed: 150,
          timestamp: newTimestamp,
        );

        expect(copied.text, equals('New text'));
        expect(copied.isStreaming, isTrue);
        expect(copied.errorMessage, equals('Error'));
        expect(copied.tokensUsed, equals(150));
        expect(copied.timestamp, equals(newTimestamp));
      });

      test('Returns same message when no fields changed', () {
        final copied = originalMessage.copyWith();

        expect(copied.id, equals(originalMessage.id));
        expect(copied.text, equals(originalMessage.text));
        expect(copied.isUserMessage, equals(originalMessage.isUserMessage));
      });
    });

    group('Reactions', () {
      final message = Message.user(
        conversationId: testConversationId,
        text: testText,
      );

      test('Adds a reaction to message', () {
        const emoji = '👍';
        final messageWithReaction = message.addReaction(emoji);

        expect(messageWithReaction.reactions, contains(emoji));
        expect(messageWithReaction.reactions.length, equals(1));
        expect(message.reactions, isEmpty); // Original unchanged
      });

      test('Does not add duplicate reactions', () {
        const emoji = '👍';
        final withOne = message.addReaction(emoji);
        final withTwo = withOne.addReaction(emoji);

        expect(withTwo.reactions.length, equals(1));
        expect(withTwo.reactions, equals([emoji]));
      });

      test('Adds multiple different reactions', () {
        final msg = message
            .addReaction('👍')
            .addReaction('❤️')
            .addReaction('😂');

        expect(msg.reactions.length, equals(3));
        expect(msg.reactions, containsAll(['👍', '❤️', '😂']));
      });

      test('Removes a reaction from message', () {
        final withReactions = message.addReaction('👍').addReaction('❤️');
        final withoutOne = withReactions.removeReaction('👍');

        expect(withoutOne.reactions.length, equals(1));
        expect(withoutOne.reactions, equals(['❤️']));
        expect(withReactions.reactions.length, equals(2)); // Original unchanged
      });

      test('Removing non-existent reaction has no effect', () {
        final withReaction = message.addReaction('👍');
        final result = withReaction.removeReaction('❤️');

        expect(result.reactions, equals(['👍']));
      });

      test('hasReactions is correct', () {
        expect(message.hasReactions, isFalse);
        expect(message.addReaction('👍').hasReactions, isTrue);
      });
    });

    group('Serialization', () {
      test('Converts message to map correctly', () {
        final message = Message.user(
          conversationId: testConversationId,
          text: testText,
        );

        final map = message.toMap();

        expect(map['id'], equals(message.id));
        expect(map['conversation_id'], equals(testConversationId));
        expect(map['text'], equals(testText));
        expect(map['is_user_message'], equals(1));
        expect(map['is_streaming'], equals(0));
        expect(map['error_message'], isNull);
        expect(map['tokens_used'], equals(0));
      });

      test('Handles reactions in serialization', () {
        final message = Message.user(
          conversationId: testConversationId,
          text: testText,
        ).addReaction('👍').addReaction('❤️');

        final map = message.toMap();

        expect(map['reactions'], equals('👍,❤️'));
      });

      test('Deserializes message from map correctly', () {
        final timestamp = DateTime.now();
        final originalMap = {
          'id': 'msg-123',
          'conversation_id': testConversationId,
          'text': testText,
          'is_user_message': 1,
          'timestamp': timestamp.millisecondsSinceEpoch,
          'is_streaming': 0,
          'reactions': '👍,❤️',
          'error_message': null,
          'tokens_used': 50,
        };

        final message = Message.fromMap(originalMap);

        expect(message.id, equals('msg-123'));
        expect(message.conversationId, equals(testConversationId));
        expect(message.text, equals(testText));
        expect(message.isUserMessage, isTrue);
        expect(message.isStreaming, isFalse);
        expect(message.reactions, equals(['👍', '❤️']));
        expect(message.errorMessage, isNull);
        expect(message.tokensUsed, equals(50));
      });

      test('Round-trip serialization preserves data', () {
        final original = Message.user(
          conversationId: testConversationId,
          text: testText,
        ).addReaction('👍').copyWith(tokensUsed: 75);

        final map = original.toMap();
        final restored = Message.fromMap(map);

        expect(restored.id, equals(original.id));
        expect(restored.conversationId, equals(original.conversationId));
        expect(restored.text, equals(original.text));
        expect(restored.isUserMessage, equals(original.isUserMessage));
        expect(restored.reactions, equals(original.reactions));
        expect(restored.tokensUsed, equals(original.tokensUsed));
      });

      test('Handles empty reactions string in deserialization', () {
        final map = {
          'id': 'msg-123',
          'conversation_id': testConversationId,
          'text': testText,
          'is_user_message': 1,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'is_streaming': 0,
          'reactions': '',
          'error_message': null,
          'tokens_used': 0,
        };

        final message = Message.fromMap(map);

        expect(message.reactions, isEmpty);
      });
    });

    group('Error Handling', () {
      test('hasError is true when error message is present', () {
        final message = Message.ai(
          conversationId: testConversationId,
        ).copyWith(errorMessage: 'API Error');

        expect(message.hasError, isTrue);
      });

      test('hasError is false when error message is null', () {
        final message = Message.ai(conversationId: testConversationId);

        expect(message.hasError, isFalse);
      });

      test('hasError is false when error message is empty', () {
        final message = Message.ai(
          conversationId: testConversationId,
        ).copyWith(errorMessage: '');

        expect(message.hasError, isFalse);
      });
    });

    group('Equality & Hashing', () {
      test('Messages with same ID are equal', () {
        final map = {
          'id': 'msg-123',
          'conversation_id': testConversationId,
          'text': testText,
          'is_user_message': 1,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'is_streaming': 0,
          'reactions': '',
          'error_message': null,
          'tokens_used': 0,
        };

        final msg1 = Message.fromMap(map);
        final msg2 = Message.fromMap(map);

        expect(msg1, equals(msg2));
      });

      test('Messages with different IDs are not equal', () {
        final msg1 = Message.user(
          conversationId: testConversationId,
          text: 'Message 1',
        );
        final msg2 = Message.user(
          conversationId: testConversationId,
          text: 'Message 1',
        );

        expect(msg1, isNot(equals(msg2)));
      });

      test('Hash code is consistent with equality', () {
        final msg1 = Message.user(
          conversationId: testConversationId,
          text: 'Same message',
        );
        final msg2 = msg1.copyWith();

        expect(msg1.hashCode, equals(msg2.hashCode));
      });
    });

    group('String Representation', () {
      test('toString truncates long text', () {
        final longText = 'This is a very long message ' * 10;
        final message = Message.user(
          conversationId: testConversationId,
          text: longText,
        );

        final stringRep = message.toString();

        expect(stringRep, contains('isUser: true'));
        expect(stringRep, contains('...'));
      });

      test('toString includes key information', () {
        final message = Message.user(
          conversationId: testConversationId,
          text: testText,
        );

        final stringRep = message.toString();

        expect(stringRep, contains('Message('));
        expect(stringRep, contains('id:'));
        expect(stringRep, contains('isUser: true'));
      });
    });
  });
}
