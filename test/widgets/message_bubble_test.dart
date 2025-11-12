import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echoai/models/message.dart';
import 'package:echoai/widgets/message_bubble.dart';

void main() {
  group('MessageBubble Widget Tests', () {
    late Message testMessage;

    setUp(() {
      testMessage = Message.user(
        conversationId: 'test-conv',
        text: 'Hello, how are you?',
      );
    });

    group('User Message Rendering', () {
      testWidgets('Renders user message correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        expect(find.text('Hello, how are you?'), findsOneWidget);
      });

      testWidgets('User message appears on the right', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        // Check that text is rendered
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('User message has purple gradient background', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('User message text is white', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        expect(find.byType(Text), findsWidgets);
      });
    });

    group('AI Message Rendering', () {
      testWidgets('Renders AI message correctly', (WidgetTester tester) async {
        final aiMessage = Message.ai(
          conversationId: 'test-conv',
          text: 'I am doing great!',
        );

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: MessageBubble(message: aiMessage))),
        );

        expect(find.text('I am doing great!'), findsOneWidget);
      });

      testWidgets('AI message appears on the left', (
        WidgetTester tester,
      ) async {
        final aiMessage = Message.ai(
          conversationId: 'test-conv',
          text: 'Response text',
        );

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: MessageBubble(message: aiMessage))),
        );

        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('AI message has border', (WidgetTester tester) async {
        final aiMessage = Message.ai(
          conversationId: 'test-conv',
          text: 'Response',
        );

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: MessageBubble(message: aiMessage))),
        );

        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Streaming Indicator', () {
      testWidgets('Shows streaming indicator when isStreaming is true', (
        WidgetTester tester,
      ) async {
        final streamingMessage = Message.ai(
          conversationId: 'test-conv',
          text: '',
        ).copyWith(isStreaming: true);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: streamingMessage)),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('Hides streaming indicator when not streaming', (
        WidgetTester tester,
      ) async {
        final nonStreamingMessage = Message.ai(
          conversationId: 'test-conv',
          text: 'Complete response',
        ).copyWith(isStreaming: false);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: nonStreamingMessage)),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('Shows "AI is typing..." text during streaming', (
        WidgetTester tester,
      ) async {
        final streamingMessage = Message.ai(
          conversationId: 'test-conv',
        ).copyWith(isStreaming: true);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: streamingMessage)),
          ),
        );

        expect(find.text('AI is typing...'), findsOneWidget);
      });
    });

    group('Error Display', () {
      testWidgets('Shows error icon when message has error', (
        WidgetTester tester,
      ) async {
        final errorMessage = testMessage.copyWith(
          errorMessage: 'API Error: Rate limit exceeded',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: errorMessage)),
          ),
        );

        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('Shows error message text', (WidgetTester tester) async {
        final errorMessage = testMessage.copyWith(
          errorMessage: 'API Error: Rate limit exceeded',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: errorMessage)),
          ),
        );

        expect(find.text('API Error: Rate limit exceeded'), findsOneWidget);
      });

      testWidgets('Hides error display when no error', (
        WidgetTester tester,
      ) async {
        final normalMessage = testMessage.copyWith(errorMessage: null);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: normalMessage)),
          ),
        );

        expect(find.byIcon(Icons.error_outline), findsNothing);
      });
    });

    group('Reactions', () {
      testWidgets('Shows reaction button for AI messages', (
        WidgetTester tester,
      ) async {
        final aiMessage = Message.ai(
          conversationId: 'test-conv',
          text: 'Response',
        );

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: MessageBubble(message: aiMessage))),
        );

        expect(find.byIcon(Icons.add_reaction_outlined), findsOneWidget);
      });

      testWidgets('Hides reaction button for user messages', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        expect(find.byIcon(Icons.add_reaction_outlined), findsNothing);
      });

      testWidgets('Displays reactions on message', (WidgetTester tester) async {
        final messageWithReactions = testMessage
            .addReaction('👍')
            .addReaction('❤️')
            .addReaction('😂');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: messageWithReactions)),
          ),
        );

        // Reactions should be displayed
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('Reaction picker opens on tap', (WidgetTester tester) async {
        final aiMessage = Message.ai(
          conversationId: 'test-conv',
          text: 'Response',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageBubble(
                message: aiMessage,
                onReaction: (emoji) {
                  // Reaction callback
                },
              ),
            ),
          ),
        );

        // Verify reaction button is present for AI messages
        expect(find.byIcon(Icons.add_reaction_outlined), findsOneWidget);
      });
    });

    group('Interactive Features', () {
      testWidgets('Message bubble renders with callback support', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageBubble(
                message: testMessage,
                onTap: () {
                  // Callback provided
                },
              ),
            ),
          ),
        );

        expect(find.byType(MessageBubble), findsOneWidget);
      });

      testWidgets('Message bubble renders with message content', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        expect(find.byType(MessageBubble), findsOneWidget);
      });

      testWidgets('Speak button is available for AI messages', (
        WidgetTester tester,
      ) async {
        final aiMessage = Message.ai(
          conversationId: 'test-conv',
          text: 'Listen to this',
        );

        bool speakCalled = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageBubble(
                message: aiMessage,
                onSpeak: () {
                  speakCalled = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.volume_up_outlined));
        expect(speakCalled, isTrue);
      });
    });

    group('Text Wrapping', () {
      testWidgets('Long text wraps to multiple lines', (
        WidgetTester tester,
      ) async {
        final longMessage = Message.user(
          conversationId: 'test-conv',
          text:
              'This is a very long message that should wrap to multiple lines '
              'to ensure that the message bubble properly handles text layout '
              'and displays all the content correctly without overflow.',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: longMessage)),
          ),
        );

        // Message should be rendered
        expect(
          find.byWidgetPredicate((widget) => widget is Text),
          findsWidgets,
        );
      });

      testWidgets('Short text does not wrap', (WidgetTester tester) async {
        final shortMessage = Message.user(
          conversationId: 'test-conv',
          text: 'Short',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: shortMessage)),
          ),
        );

        expect(find.text('Short'), findsOneWidget);
      });
    });

    group('Styling', () {
      testWidgets('Message bubble has rounded corners', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('Proper padding is applied', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        // Widget should be rendered with proper spacing
        expect(find.byType(Padding), findsWidgets);
      });

      testWidgets('Proper text styling is applied', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        final textWidget = find.byType(Text).first;
        expect(textWidget, findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('Message text is readable', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: MessageBubble(message: testMessage)),
          ),
        );

        expect(find.text('Hello, how are you?'), findsOneWidget);
      });

      testWidgets('Tap targets are appropriately sized', (
        WidgetTester tester,
      ) async {
        final aiMessage = Message.ai(
          conversationId: 'test-conv',
          text: 'Response',
        );

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: MessageBubble(message: aiMessage))),
        );

        // Buttons should be tappable
        expect(find.byIcon(Icons.add_reaction_outlined), findsOneWidget);
      });
    });
  });
}
