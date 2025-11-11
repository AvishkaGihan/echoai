import 'package:flutter/foundation.dart';

import '../models/conversation.dart';
import '../services/database_service.dart';

/// Chat history state provider
class HistoryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  // State
  List<Conversation> _conversations = [];
  List<Conversation> _filteredConversations = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // ========================================
  // GETTERS
  // ========================================

  /// All conversations
  List<Conversation> get conversations => _conversations;

  /// Filtered conversations (based on search)
  List<Conversation> get filteredConversations =>
      _searchQuery.isEmpty ? _conversations : _filteredConversations;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Error message
  String? get error => _error;

  /// Current search query
  String get searchQuery => _searchQuery;

  /// Check if has conversations
  bool get hasConversations => _conversations.isNotEmpty;

  /// Check if search is active
  bool get isSearching => _searchQuery.isNotEmpty;

  // ========================================
  // LOAD CONVERSATIONS
  // ========================================

  /// Load all conversations from database
  Future<void> loadConversations() async {
    _setLoading(true);
    _clearError();

    final result = await _databaseService.getAllConversations();

    result.when(
      success: (conversations) {
        _conversations = conversations;

        // Re-apply search filter if active
        if (_searchQuery.isNotEmpty) {
          _applySearchFilter();
        }

        _setLoading(false);
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
      },
    );
  }

  /// Refresh conversations
  Future<void> refreshConversations() async {
    await loadConversations();
  }

  // ========================================
  // SEARCH
  // ========================================

  /// Search conversations by query
  Future<void> searchConversations(String query) async {
    _searchQuery = query.trim();

    if (_searchQuery.isEmpty) {
      _filteredConversations = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    _clearError();

    final result = await _databaseService.searchConversations(_searchQuery);

    result.when(
      success: (conversations) {
        _filteredConversations = conversations;
        _setLoading(false);
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
      },
    );
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredConversations = [];
    notifyListeners();
  }

  /// Apply search filter to current conversations
  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredConversations = [];
      return;
    }

    final query = _searchQuery.toLowerCase();
    _filteredConversations = _conversations.where((conversation) {
      final title = conversation.title.toLowerCase();
      final preview = conversation.preview.toLowerCase();
      return title.contains(query) || preview.contains(query);
    }).toList();
  }

  // ========================================
  // DELETE OPERATIONS
  // ========================================

  /// Delete a specific conversation
  Future<bool> deleteConversation(String conversationId) async {
    _clearError();

    final result = await _databaseService.deleteConversation(conversationId);

    return result.when(
      success: (_) {
        // Remove from local list
        _conversations.removeWhere((c) => c.id == conversationId);
        _filteredConversations.removeWhere((c) => c.id == conversationId);
        notifyListeners();
        return true;
      },
      error: (message) {
        _setError(message);
        return false;
      },
    );
  }

  /// Delete all conversations
  Future<bool> deleteAllConversations() async {
    _setLoading(true);
    _clearError();

    final result = await _databaseService.deleteAllConversations();

    return result.when(
      success: (_) {
        _conversations = [];
        _filteredConversations = [];
        _setLoading(false);
        return true;
      },
      error: (message) {
        _setError(message);
        _setLoading(false);
        return false;
      },
    );
  }

  // ========================================
  // SORTING & FILTERING
  // ========================================

  /// Sort conversations by last updated (most recent first)
  void sortByRecent() {
    _conversations.sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
    notifyListeners();
  }

  /// Sort conversations by created date (newest first)
  void sortByCreated() {
    _conversations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  /// Sort conversations by title (alphabetically)
  void sortByTitle() {
    _conversations.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );
    notifyListeners();
  }

  /// Filter conversations by assistant mode
  List<Conversation> filterByMode(String mode) {
    return _conversations.where((c) => c.assistantMode == mode).toList();
  }

  /// Filter conversations by date range
  List<Conversation> filterByDateRange({
    required DateTime start,
    required DateTime end,
  }) {
    return _conversations.where((c) {
      return c.lastUpdatedAt.isAfter(start) && c.lastUpdatedAt.isBefore(end);
    }).toList();
  }

  // ========================================
  // STATISTICS
  // ========================================

  /// Get total message count across all conversations
  int getTotalMessageCount() {
    return _conversations.fold(0, (sum, c) => sum + c.messageCount);
  }

  /// Get conversations count by mode
  Map<String, int> getConversationsByMode() {
    final counts = <String, int>{'productivity': 0, 'learning': 0, 'casual': 0};

    for (final conversation in _conversations) {
      counts[conversation.assistantMode] =
          (counts[conversation.assistantMode] ?? 0) + 1;
    }

    return counts;
  }

  /// Get most recent conversation
  Conversation? getMostRecentConversation() {
    if (_conversations.isEmpty) return null;
    return _conversations.reduce(
      (a, b) => a.lastUpdatedAt.isAfter(b.lastUpdatedAt) ? a : b,
    );
  }

  // ========================================
  // PRIVATE METHODS
  // ========================================

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _error = null;
  }
}
