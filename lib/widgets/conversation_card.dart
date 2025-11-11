import 'package:flutter/material.dart';

import '../models/conversation.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class ConversationCard extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ConversationCard({
    super.key,
    required this.conversation,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppConstants.spaceLg),
        color: AppConstants.errorColor,
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Conversation?'),
            content: const Text(AppConstants.confirmDeleteConversation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.errorColor,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        onDelete?.call();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMd,
          vertical: AppConstants.spaceSm,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Mode emoji
                    Text(
                      AppConstants.modeEmojis[conversation.assistantMode] ??
                          '🤖',
                      style: const TextStyle(fontSize: 20),
                    ),

                    const SizedBox(width: AppConstants.spaceSm),

                    // Title
                    Expanded(
                      child: Text(
                        conversation.title,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Delete button
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: AppConstants.textSecondary,
                        onPressed: onDelete,
                      ),
                  ],
                ),

                const SizedBox(height: AppConstants.spaceSm),

                // Preview
                Text(
                  conversation.preview,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppConstants.spaceSm),

                // Metadata row
                Row(
                  children: [
                    // Message count
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 14,
                      color: AppConstants.textSecondary,
                    ),
                    const SizedBox(width: AppConstants.spaceXs),
                    Text(
                      '${conversation.messageCount} messages',
                      style: context.textTheme.bodySmall,
                    ),

                    const Spacer(),

                    // Time ago
                    Text(
                      conversation.lastUpdatedAgo,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
