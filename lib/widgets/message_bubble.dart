import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/message.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onTap;
  final Function(String emoji)? onReaction;
  final VoidCallback? onSpeak;

  const MessageBubble({
    super.key,
    required this.message,
    this.onTap,
    this.onReaction,
    this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceMd,
        vertical: AppConstants.spaceSm,
      ),
      child: Column(
        crossAxisAlignment: message.isUserMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Message bubble
          GestureDetector(
            onTap: onTap,
            onLongPress: () => _showMessageOptions(context),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: context.screenWidth * AppConstants.maxMessageWidth,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMd,
                vertical: AppConstants.spaceSm + 2,
              ),
              decoration: BoxDecoration(
                gradient: message.isUserMessage
                    ? LinearGradient(
                        colors: [
                          AppConstants.primaryPurple,
                          AppConstants.primaryPurple.lighten(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: message.isUserMessage
                    ? null
                    : AppConstants.neutralSurface,
                border: message.isUserMessage
                    ? null
                    : Border.all(
                        color: AppConstants.accentCyan.withValues(alpha: 0.3),
                        width: 1,
                      ),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      color: message.isUserMessage
                          ? AppConstants.neutralBackground
                          : AppConstants.textPrimary,
                      height: 1.5,
                    ),
                  ),

                  // Streaming indicator
                  if (message.isStreaming)
                    Padding(
                      padding: const EdgeInsets.only(top: AppConstants.spaceSm),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                message.isUserMessage
                                    ? AppConstants.neutralBackground
                                    : AppConstants.accentCyan,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.spaceSm),
                          Text(
                            'AI is typing...',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: message.isUserMessage
                                  ? AppConstants.neutralBackground.withValues(
                                      alpha: 0.7,
                                    )
                                  : AppConstants.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Error message
                  if (message.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: AppConstants.spaceSm),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 14,
                            color: AppConstants.errorColor,
                          ),
                          const SizedBox(width: AppConstants.spaceXs),
                          Flexible(
                            child: Text(
                              message.errorMessage ?? 'Error',
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                color: AppConstants.errorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Quick action buttons
          // Quick action buttons (only for AI messages)
          if (!message.isUserMessage)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.spaceSm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppConstants.spaceSm,
                children: [
                  // Reaction button
                  InkWell(
                    onTap: () => _showReactionPicker(context),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppConstants.radiusSmall),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(AppConstants.spaceXs),
                      child: Icon(
                        Icons.add_reaction_outlined,
                        size: 18,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ),

                  // Text-to-speech button
                  if (onSpeak != null)
                    InkWell(
                      onTap: onSpeak,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppConstants.radiusSmall),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(AppConstants.spaceXs),
                        child: Icon(
                          Icons.volume_up_outlined,
                          size: 18,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ),

                  // More options button
                  InkWell(
                    onTap: () => _showMessageOptions(context),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppConstants.radiusSmall),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(AppConstants.spaceXs),
                      child: Icon(
                        Icons.more_horiz,
                        size: 18,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Reactions display
          if (message.hasReactions)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.spaceXs),
              child: Wrap(
                spacing: AppConstants.spaceXs,
                children: message.reactions
                    .map((emoji) => _buildReactionChip(emoji))
                    .toList(),
              ),
            ),

          // Timestamp
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.spaceXs),
            child: Text(
              message.timestamp.toTimeString(),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeTiny,
                color: AppConstants.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionChip(String emoji) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceSm,
        vertical: AppConstants.spaceXs,
      ),
      decoration: BoxDecoration(
        color: AppConstants.neutralSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(
          color: AppConstants.accentCyan.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 14)),
    );
  }

  void _showReactionPicker(BuildContext context) {
    final reactionEmojis = ['👍', '👎', '❤️', '🔥', '🎉', '😂', '😮', '😢'];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.neutralSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceMd,
            vertical: AppConstants.spaceMd,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add a reaction',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeH3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spaceMd),
              Wrap(
                spacing: AppConstants.spaceMd,
                runSpacing: AppConstants.spaceMd,
                children: reactionEmojis
                    .map(
                      (emoji) => InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          onReaction?.call(emoji);
                        },
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSmall,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(AppConstants.spaceMd),
                          decoration: BoxDecoration(
                            color: message.reactions.contains(emoji)
                                ? AppConstants.accentCyan.withValues(alpha: 0.2)
                                : Colors.transparent,
                            border: Border.all(
                              color: message.reactions.contains(emoji)
                                  ? AppConstants.accentCyan
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusSmall,
                            ),
                          ),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.neutralSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppConstants.spaceSm),

            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppConstants.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: AppConstants.spaceMd),

            // Copy option
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.text));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppConstants.successCopied),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),

            // Speak option (for AI messages)
            if (!message.isUserMessage && onSpeak != null)
              ListTile(
                leading: const Icon(Icons.volume_up_outlined),
                title: const Text('Read Aloud'),
                onTap: () {
                  Navigator.pop(context);
                  onSpeak?.call();
                },
              ),

            // Reactions
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spaceMd,
                vertical: AppConstants.spaceSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'React',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['👍', '👎', '❤️', '🔥', '🎉']
                        .map(
                          (emoji) => InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              onReaction?.call(emoji);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(
                                AppConstants.spaceSm,
                              ),
                              decoration: BoxDecoration(
                                color: message.reactions.contains(emoji)
                                    ? AppConstants.accentCyan.withValues(
                                        alpha: 0.2,
                                      )
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusSmall,
                                ),
                              ),
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spaceSm),
          ],
        ),
      ),
    );
  }
}
