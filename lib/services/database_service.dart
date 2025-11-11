import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/message.dart';
import '../models/conversation.dart';
import '../models/settings.dart';
import '../utils/result.dart';
import '../utils/constants.dart';

/// Local database service using SQLite
class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Database instance
  Database? _database;

  // ========================================
  // DATABASE INITIALIZATION
  // ========================================

  /// Get database instance (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    // Messages table
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        conversation_id TEXT NOT NULL,
        text TEXT NOT NULL,
        is_user_message INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        is_streaming INTEGER NOT NULL DEFAULT 0,
        reactions TEXT,
        error_message TEXT,
        tokens_used INTEGER DEFAULT 0,
        FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for messages
    await db.execute('''
      CREATE INDEX idx_messages_conversation
      ON messages(conversation_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_messages_timestamp
      ON messages(timestamp DESC)
    ''');

    // Conversations table
    await db.execute('''
      CREATE TABLE conversations (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        last_updated_at INTEGER NOT NULL,
        assistant_mode TEXT NOT NULL,
        message_count INTEGER DEFAULT 0
      )
    ''');

    // Create indexes for conversations
    await db.execute('''
      CREATE INDEX idx_conversations_updated
      ON conversations(last_updated_at DESC)
    ''');

    await db.execute('''
      CREATE INDEX idx_conversations_created
      ON conversations(created_at DESC)
    ''');

    // Settings table (single row)
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        assistant_mode TEXT NOT NULL,
        notifications_enabled INTEGER NOT NULL,
        accent_color TEXT NOT NULL,
        sound_enabled INTEGER DEFAULT 1,
        voice_speed REAL DEFAULT 1.0,
        theme_mode TEXT DEFAULT 'dark'
      )
    ''');

    // Insert default settings
    await db.insert('settings', Settings.defaultSettings().toMap()..['id'] = 1);
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here when schema changes
    // For MVP, no migrations needed
  }

  // ========================================
  // MESSAGE OPERATIONS
  // ========================================

  /// Save a message
  Future<Result<void>> saveMessage(Message message) async {
    try {
      final db = await database;
      await db.insert(
        'messages',
        message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to save message: ${e.toString()}');
    }
  }

  /// Get all messages for a conversation
  Future<Result<List<Message>>> getMessages(String conversationId) async {
    try {
      final db = await database;
      final maps = await db.query(
        'messages',
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
        orderBy: 'timestamp ASC',
      );

      final messages = maps.map((map) => Message.fromMap(map)).toList();
      return Result.success(messages);
    } catch (e) {
      return Result.error('Failed to load messages: ${e.toString()}');
    }
  }

  /// Update a message
  Future<Result<void>> updateMessage(Message message) async {
    try {
      final db = await database;
      await db.update(
        'messages',
        message.toMap(),
        where: 'id = ?',
        whereArgs: [message.id],
      );
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to update message: ${e.toString()}');
    }
  }

  /// Delete a message
  Future<Result<void>> deleteMessage(String messageId) async {
    try {
      final db = await database;
      await db.delete('messages', where: 'id = ?', whereArgs: [messageId]);
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to delete message: ${e.toString()}');
    }
  }

  // ========================================
  // CONVERSATION OPERATIONS
  // ========================================

  /// Save a conversation
  Future<Result<void>> saveConversation(Conversation conversation) async {
    try {
      final db = await database;

      // Save conversation metadata
      await db.insert(
        'conversations',
        conversation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Save all messages
      for (final message in conversation.messages) {
        await db.insert(
          'messages',
          message.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to save conversation: ${e.toString()}');
    }
  }

  /// Get all conversations (without messages)
  Future<Result<List<Conversation>>> getAllConversations({int? limit}) async {
    try {
      final db = await database;
      final maps = await db.query(
        'conversations',
        orderBy: 'last_updated_at DESC',
        limit: limit ?? AppConstants.conversationPageSize,
      );

      final conversations = maps
          .map((map) => Conversation.fromMap(map))
          .toList();
      return Result.success(conversations);
    } catch (e) {
      return Result.error('Failed to load conversations: ${e.toString()}');
    }
  }

  /// Get a single conversation with all messages
  Future<Result<Conversation>> getConversation(String conversationId) async {
    try {
      final db = await database;

      // Get conversation metadata
      final conversationMaps = await db.query(
        'conversations',
        where: 'id = ?',
        whereArgs: [conversationId],
      );

      if (conversationMaps.isEmpty) {
        return Result.error('Conversation not found');
      }

      // Get all messages
      final messageMaps = await db.query(
        'messages',
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
        orderBy: 'timestamp ASC',
      );

      final messages = messageMaps.map((map) => Message.fromMap(map)).toList();
      final conversation = Conversation.fromMap(
        conversationMaps.first,
      ).copyWith(messages: messages);

      return Result.success(conversation);
    } catch (e) {
      return Result.error('Failed to load conversation: ${e.toString()}');
    }
  }

  /// Update conversation metadata
  Future<Result<void>> updateConversation(Conversation conversation) async {
    try {
      final db = await database;
      await db.update(
        'conversations',
        conversation.toMap(),
        where: 'id = ?',
        whereArgs: [conversation.id],
      );
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to update conversation: ${e.toString()}');
    }
  }

  /// Delete a conversation and all its messages
  Future<Result<void>> deleteConversation(String conversationId) async {
    try {
      final db = await database;

      // Delete messages first (foreign key will cascade, but explicit is better)
      await db.delete(
        'messages',
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
      );

      // Delete conversation
      await db.delete(
        'conversations',
        where: 'id = ?',
        whereArgs: [conversationId],
      );

      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to delete conversation: ${e.toString()}');
    }
  }

  /// Delete all conversations and messages
  Future<Result<void>> deleteAllConversations() async {
    try {
      final db = await database;

      // Delete all messages
      await db.delete('messages');

      // Delete all conversations
      await db.delete('conversations');

      return Result.success(null);
    } catch (e) {
      return Result.error(
        'Failed to delete all conversations: ${e.toString()}',
      );
    }
  }

  /// Search conversations by text content
  Future<Result<List<Conversation>>> searchConversations(String query) async {
    try {
      final db = await database;

      // Search in conversation titles
      final titleMatches = await db.query(
        'conversations',
        where: 'title LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'last_updated_at DESC',
      );

      // Search in message text
      final messageMatches = await db.rawQuery(
        '''
        SELECT DISTINCT c.*
        FROM conversations c
        INNER JOIN messages m ON c.id = m.conversation_id
        WHERE m.text LIKE ?
        ORDER BY c.last_updated_at DESC
      ''',
        ['%$query%'],
      );

      // Combine results and remove duplicates
      final allMaps = [...titleMatches, ...messageMatches];
      final uniqueIds = <String>{};
      final uniqueMaps = <Map<String, dynamic>>[];

      for (final map in allMaps) {
        final id = map['id'] as String;
        if (!uniqueIds.contains(id)) {
          uniqueIds.add(id);
          uniqueMaps.add(map);
        }
      }

      final conversations = uniqueMaps
          .map((map) => Conversation.fromMap(map))
          .toList();
      return Result.success(conversations);
    } catch (e) {
      return Result.error('Failed to search conversations: ${e.toString()}');
    }
  }

  // ========================================
  // SETTINGS OPERATIONS
  // ========================================

  /// Get user settings
  Future<Result<Settings>> getSettings() async {
    try {
      final db = await database;
      final maps = await db.query('settings', where: 'id = 1');

      if (maps.isEmpty) {
        // Return default settings if none exist
        return Result.success(Settings.defaultSettings());
      }

      final settings = Settings.fromMap(maps.first);
      return Result.success(settings);
    } catch (e) {
      return Result.error('Failed to load settings: ${e.toString()}');
    }
  }

  /// Save user settings
  Future<Result<void>> saveSettings(Settings settings) async {
    try {
      final db = await database;
      await db.update('settings', settings.toMap(), where: 'id = 1');
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to save settings: ${e.toString()}');
    }
  }

  // ========================================
  // UTILITY METHODS
  // ========================================

  /// Get conversation count
  Future<Result<int>> getConversationCount() async {
    try {
      final db = await database;
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM conversations'),
      );
      return Result.success(count ?? 0);
    } catch (e) {
      return Result.error('Failed to count conversations: ${e.toString()}');
    }
  }

  /// Get total message count
  Future<Result<int>> getTotalMessageCount() async {
    try {
      final db = await database;
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM messages'),
      );
      return Result.success(count ?? 0);
    } catch (e) {
      return Result.error('Failed to count messages: ${e.toString()}');
    }
  }

  /// Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Delete database (for testing or reset)
  Future<Result<void>> deleteDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, AppConstants.dbName);
      await databaseFactory.deleteDatabase(path);
      _database = null;
      return Result.success(null);
    } catch (e) {
      return Result.error('Failed to delete database: ${e.toString()}');
    }
  }
}
