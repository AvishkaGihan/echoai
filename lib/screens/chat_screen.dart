import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/voice_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/bottom_nav.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    final chatProvider = context.read<ChatProvider>();

    // Start new conversation if none exists
    if (!chatProvider.hasActiveConversation) {
      await chatProvider.startNewConversation();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: AppConstants.animationNormal,
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _handleSendMessage(String text) async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.sendMessage(text);
    _scrollToBottom();
  }

  Future<void> _handleVoiceInput() async {
    final voiceProvider = context.read<VoiceProvider>();

    if (voiceProvider.isRecording) {
      // Stop recording and get text
      final transcribedText = await voiceProvider.stopRecording();

      if (transcribedText != null && transcribedText.isNotEmpty) {
        await _handleSendMessage(transcribedText);
      }
    } else {
      // Start recording
      await voiceProvider.startRecording();
    }
  }

  Future<void> _handleSpeak(String text) async {
    final voiceProvider = context.read<VoiceProvider>();
    final settings = context.read<SettingsProvider>().settings;

    if (settings.soundEnabled) {
      await voiceProvider.speak(text, speed: settings.voiceSpeed);
    } else {
      if (mounted) {
        context.showError('Text-to-speech is disabled in settings');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(settingsProvider.settings.assistantModeEmoji),
                const SizedBox(width: AppConstants.spaceSm),
                Text(settingsProvider.settings.assistantModeDisplayName),
              ],
            );
          },
        ),
        actions: [
          // New chat button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final chatProvider = context.read<ChatProvider>();
              await chatProvider.startNewConversation();
              if (mounted && context.mounted) {
                context.showSuccess('Started new conversation');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final messages = chatProvider.messages;

                if (messages.isEmpty) {
                  return _buildEmptyState();
                }

                // Scroll to bottom when new message arrives
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                    top: AppConstants.spaceMd,
                    bottom: AppConstants.spaceMd,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                    return MessageBubble(
                      message: message,
                      onReaction: (emoji) {
                        if (message.reactions.contains(emoji)) {
                          chatProvider.removeReaction(message.id, emoji);
                        } else {
                          chatProvider.addReaction(message.id, emoji);
                        }
                      },
                      onSpeak:
                          !message.isUserMessage
                              ? () => _handleSpeak(message.text)
                              : null,
                    );
                  },
                );
              },
            ),
          ),

          // Message input
          Consumer2<ChatProvider, VoiceProvider>(
            builder: (context, chatProvider, voiceProvider, child) {
              return MessageInput(
                onSendMessage: _handleSendMessage,
                onVoicePressed: _handleVoiceInput,
                isRecording: voiceProvider.isRecording,
                isStreaming: chatProvider.isStreaming,
                volumeLevel: voiceProvider.volumeLevel,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: AppConstants.textSecondary.withValues(alpha: 0.5),
            ),

            const SizedBox(height: AppConstants.spaceLg),

            Text('👋 Hello!', style: context.textTheme.displayMedium),

            const SizedBox(height: AppConstants.spaceSm),

            Text(
              'Ready to chat with AI?',
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),

            const SizedBox(height: AppConstants.spaceXl),

            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Try:',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spaceSm),
                    ...AppConstants.modeDescriptions.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.spaceSm,
                        ),
                        child: Row(
                          children: [
                            Text(
                              AppConstants.modeEmojis[entry.key] ?? '',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: AppConstants.spaceSm),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: context.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: AppConstants.spaceLg),

            Text(
              'Tap the mic to use voice!',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppConstants.accentCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
