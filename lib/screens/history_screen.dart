import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/conversation_card.dart';
import '../widgets/bottom_nav.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Defer loading to after build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadConversations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    final historyProvider = context.read<HistoryProvider>();
    await historyProvider.loadConversations();
  }

  Future<void> _handleSearch(String query) async {
    final historyProvider = context.read<HistoryProvider>();
    if (query.trim().isEmpty) {
      historyProvider.clearSearch();
    } else {
      await historyProvider.searchConversations(query);
    }
  }

  Future<void> _handleConversationTap(String conversationId) async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.loadConversation(conversationId);

    if (mounted) {
      context.navigateTo(AppConstants.routeChat);
    }
  }

  Future<void> _handleDeleteConversation(String conversationId) async {
    final confirmed = await _showDeleteConfirmation();

    if (confirmed && mounted) {
      final historyProvider = context.read<HistoryProvider>();
      final success = await historyProvider.deleteConversation(conversationId);

      if (mounted) {
        if (success) {
          context.showSuccess(AppConstants.successConversationDeleted);
        } else if (historyProvider.error != null) {
          context.showError(historyProvider.error!);
        }
      }
    }
  }

  Future<void> _handleDeleteAll() async {
    final confirmed = await _showDeleteAllConfirmation();

    if (confirmed && mounted) {
      final historyProvider = context.read<HistoryProvider>();
      final success = await historyProvider.deleteAllConversations();

      if (mounted) {
        if (success) {
          context.showSuccess('All conversations deleted');
        } else if (historyProvider.error != null) {
          context.showError(historyProvider.error!);
        }
      }
    }
  }

  Future<bool> _showDeleteConfirmation() async {
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
        ) ??
        false;
  }

  Future<bool> _showDeleteAllConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete All Conversations?'),
            content: const Text(AppConstants.confirmDeleteAllConversations),
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
                child: const Text('Delete All'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        actions: [
          Consumer<HistoryProvider>(
            builder: (context, historyProvider, child) {
              if (!historyProvider.hasConversations) {
                return const SizedBox.shrink();
              }

              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'delete_all') {
                    _handleDeleteAll();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete_all',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: AppConstants.errorColor,
                        ),
                        SizedBox(width: AppConstants.spaceSm),
                        Text('Delete All'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.spaceMd),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _handleSearch('');
                        },
                      )
                    : null,
              ),
              onChanged: _handleSearch,
            ),
          ),

          // Conversations list
          Expanded(
            child: Consumer<HistoryProvider>(
              builder: (context, historyProvider, child) {
                if (historyProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final conversations = historyProvider.filteredConversations;

                if (conversations.isEmpty) {
                  return _buildEmptyState(historyProvider.isSearching);
                }

                return RefreshIndicator(
                  onRefresh: _loadConversations,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.spaceMd,
                    ),
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];

                      return ConversationCard(
                        conversation: conversation,
                        onTap: () => _handleConversationTap(conversation.id),
                        onDelete: () =>
                            _handleDeleteConversation(conversation.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.history,
              size: 80,
              color: AppConstants.textSecondary.withValues(alpha: 0.5),
            ),

            const SizedBox(height: AppConstants.spaceLg),

            Text(
              isSearching
                  ? 'No matches found'
                  : AppConstants.emptyConversationsMessage,
              style: context.textTheme.displaySmall,
            ),

            const SizedBox(height: AppConstants.spaceSm),

            Text(
              isSearching
                  ? 'Try a different search term'
                  : AppConstants.emptyConversationsHint,
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),

            if (!isSearching) ...[
              const SizedBox(height: AppConstants.spaceXl),

              ElevatedButton.icon(
                onPressed: () {
                  context.navigateTo(AppConstants.routeChat);
                },
                icon: const Icon(Icons.add),
                label: const Text('Start New Chat'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
