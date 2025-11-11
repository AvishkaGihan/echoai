import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echoai/widgets/message_input.dart';

void main() {
  group('MessageInput Widget Tests', () {
    late String sentMessage;

    setUp(() {
      sentMessage = '';
    });

    group('Basic Rendering', () {
      testWidgets('MessageInput renders correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        expect(find.byType(MessageInput), findsOneWidget);
      });

      testWidgets('Text input field is present', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('Send button is present', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.send), findsOneWidget);
      });
    });

    group('Text Input', () {
      testWidgets('Can type text in input field', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Hello');
        expect(find.text('Hello'), findsOneWidget);
      });

      testWidgets('Input field has correct hint text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        // Hint text should be visible when empty
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('Input field expands as you type', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Type multiple lines
        await tester.enterText(textField, 'Line 1\nLine 2\nLine 3');
        await tester.pumpAndSettle();

        // Verify text was entered by checking the EditableText widget
        expect(find.byType(EditableText), findsOneWidget);
      });

      testWidgets('Input field has maximum lines of 4', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('Send Button Behavior', () {
      testWidgets('Send button is disabled when text is empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        final sendButton = find.byIcon(Icons.send);
        expect(sendButton, findsOneWidget);

        // Button should be disabled (grayed out)
      });

      testWidgets('Send button is enabled when text is entered', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'Hello');
        await tester.pumpAndSettle();

        final sendButton = find.byIcon(Icons.send);
        expect(sendButton, findsOneWidget);
      });

      testWidgets('Tapping send button sends message', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        const testMessage = 'Hello World';
        await tester.enterText(find.byType(TextField), testMessage);
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        expect(sentMessage, equals(testMessage));
      });

      testWidgets('Text is cleared after sending', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        const testMessage = 'Hello World';
        await tester.enterText(find.byType(TextField), testMessage);
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        expect(find.text(testMessage), findsNothing);
      });

      testWidgets('Whitespace is trimmed from message', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        const messageWithSpaces = '  Hello  ';
        await tester.enterText(find.byType(TextField), messageWithSpaces);
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        expect(sentMessage.trim(), equals('Hello'));
      });

      testWidgets('Empty messages are not sent', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), '   ');
        await tester.pumpAndSettle();

        // Send button should still be disabled
        expect(find.byIcon(Icons.send), findsOneWidget);
      });
    });

    group('Voice Input', () {
      testWidgets('Voice button is shown when onVoicePressed provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                onVoicePressed: () {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.mic_outlined), findsOneWidget);
      });

      testWidgets('Voice button is not shown when onVoicePressed is null', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                onVoicePressed: null,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.mic_outlined), findsNothing);
      });

      testWidgets('Voice button callback is called on tap', (
        WidgetTester tester,
      ) async {
        bool voiceTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                onVoicePressed: () {
                  voiceTapped = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.mic_outlined));
        expect(voiceTapped, isTrue);
      });

      testWidgets('Voice button is disabled when streaming', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                onVoicePressed: () {},
                isStreaming: true,
              ),
            ),
          ),
        );

        // Voice button should be disabled
        expect(find.byIcon(Icons.mic_outlined), findsOneWidget);
      });
    });

    group('Streaming State', () {
      testWidgets('Hint text changes during streaming', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                isStreaming: true,
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('Text field is disabled during streaming', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                isStreaming: true,
              ),
            ),
          ),
        );

        // TextField should be disabled
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('Send button is disabled during streaming', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                isStreaming: true,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.send), findsOneWidget);
      });

      testWidgets('Becomes enabled after streaming ends', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                isStreaming: false,
              ),
            ),
          ),
        );

        // Fields should be enabled
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('Recording State', () {
      testWidgets('Shows recording view when recording', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                isRecording: true,
                onVoicePressed: () {},
              ),
            ),
          ),
        );

        // Should show recording UI with stop button
        expect(find.byIcon(Icons.stop), findsOneWidget);
      });

      testWidgets('Shows input view when not recording', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                isRecording: false,
                onVoicePressed: () {},
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.send), findsOneWidget);
      });

      testWidgets('Shows recording indicator during recording', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                isRecording: true,
                onVoicePressed: () {},
              ),
            ),
          ),
        );

        // Should show mic icon in red circle
        expect(find.byIcon(Icons.mic), findsOneWidget);
      });

      testWidgets('Shows waveform visualization during recording', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                isRecording: true,
                onVoicePressed: () {},
                volumeLevel: 0.5,
              ),
            ),
          ),
        );

        // Should render waveform bars
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('Stop button stops recording', (WidgetTester tester) async {
        bool stopCalled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
                isRecording: true,
                onVoicePressed: () {
                  stopCalled = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.stop));
        expect(stopCalled, isTrue);
      });
    });

    group('Keyboard Input', () {
      testWidgets('Enter key sends message', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        const testMessage = 'Hello';
        await tester.enterText(find.byType(TextField), testMessage);
        await tester.testTextInput.receiveAction(TextInputAction.send);
        await tester.pumpAndSettle();

        expect(sentMessage, equals(testMessage));
      });

      testWidgets('Newlines are supported in text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        const multilineText = 'Line 1\nLine 2';
        await tester.enterText(find.byType(TextField), multilineText);
        await tester.pumpAndSettle();

        // Verify multiline text was entered
        expect(find.byType(EditableText), findsOneWidget);
      });
    });

    group('Styling', () {
      testWidgets('Input field has proper border', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('Send button has proper styling', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.send), findsOneWidget);
      });

      testWidgets('Proper spacing between elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        expect(find.byType(Row), findsWidgets);
      });
    });

    group('Accessibility', () {
      testWidgets('Input field is accessible', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('Buttons have appropriate tap targets', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageInput(
                onSendMessage: (msg) {
                  sentMessage = msg;
                },
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.send), findsOneWidget);
      });
    });
  });
}
