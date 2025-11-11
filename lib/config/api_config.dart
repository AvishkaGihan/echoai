/// API configuration and endpoints
class ApiConfig {
  ApiConfig._();

  // ========================================
  // GEMINI API CONFIGURATION
  // ========================================

  /// Gemini model to use
  static const String geminiModel = 'gemini-2.0-flash-exp';

  /// Maximum tokens for response
  static const int maxTokens = 1000;

  /// Temperature for response creativity (0.0 - 1.0)
  /// Lower = more deterministic, Higher = more creative
  static const double temperature = 0.7;

  /// Top-p nucleus sampling (0.0 - 1.0)
  /// Controls diversity of response
  static const double topP = 0.95;

  /// Top-k sampling
  /// Limits vocabulary to top k tokens
  static const int topK = 40;

  // ========================================
  // RATE LIMITING
  // ========================================

  /// Firebase AI Logic free tier: 15 requests per minute
  static const int rateLimitRequestsPerMinute = 15;

  /// Cooldown period between requests (milliseconds)
  static const int requestCooldownMs = 4000; // 4 seconds = 15 req/min

  /// Maximum concurrent requests
  static const int maxConcurrentRequests = 1;

  // ========================================
  // TIMEOUTS
  // ========================================

  /// API call timeout (milliseconds)
  static const int apiTimeoutMs = 30000; // 30 seconds

  /// Connection timeout (milliseconds)
  static const int connectionTimeoutMs = 10000; // 10 seconds

  /// Stream read timeout (milliseconds)
  static const int streamTimeoutMs = 60000; // 1 minute

  // ========================================
  // RETRY CONFIGURATION
  // ========================================

  /// Maximum retry attempts for failed requests
  static const int maxRetries = 3;

  /// Initial retry delay (milliseconds)
  static const int retryDelayMs = 1000; // 1 second

  /// Backoff multiplier for retries
  static const double retryBackoffMultiplier = 2.0;

  // ========================================
  // STREAMING CONFIGURATION
  // ========================================

  /// Whether to enable streaming responses
  static const bool enableStreaming = true;

  /// Buffer size for streaming chunks (characters)
  static const int streamBufferSize = 10;

  /// Delay between streaming chunks (milliseconds)
  /// Makes typing effect more visible
  static const int streamChunkDelayMs = 30;

  // ========================================
  // CONTENT SAFETY
  // ========================================

  /// Safety settings for Gemini API
  /// Categories: HARASSMENT, HATE_SPEECH, SEXUALLY_EXPLICIT, DANGEROUS_CONTENT
  /// Thresholds: BLOCK_NONE, BLOCK_LOW_AND_ABOVE, BLOCK_MEDIUM_AND_ABOVE, BLOCK_HIGH_AND_ABOVE
  static const Map<String, String> safetySetting = {
    'HARM_CATEGORY_HARASSMENT': 'BLOCK_MEDIUM_AND_ABOVE',
    'HARM_CATEGORY_HATE_SPEECH': 'BLOCK_MEDIUM_AND_ABOVE',
    'HARM_CATEGORY_SEXUALLY_EXPLICIT': 'BLOCK_MEDIUM_AND_ABOVE',
    'HARM_CATEGORY_DANGEROUS_CONTENT': 'BLOCK_MEDIUM_AND_ABOVE',
  };

  // ========================================
  // FIREBASE CONFIGURATION
  // ========================================

  /// Firebase Auth timeout (milliseconds)
  static const int authTimeoutMs = 15000; // 15 seconds

  /// Firebase Auth session refresh interval (milliseconds)
  static const int sessionRefreshMs = 3600000; // 1 hour

  // ========================================
  // VOICE CONFIGURATION
  // ========================================

  /// Speech-to-text language
  static const String speechLanguage = 'en-US';

  /// Alternative languages for speech recognition
  static const List<String> speechLanguageAlternatives = [
    'en-US',
    'en-GB',
    'en-AU',
  ];

  /// Minimum confidence threshold for speech recognition
  static const double speechMinConfidence = 0.7;

  // ========================================
  // CACHING
  // ========================================

  /// Enable response caching (future feature)
  static const bool enableCaching = false;

  /// Cache expiration time (milliseconds)
  static const int cacheExpirationMs = 3600000; // 1 hour

  /// Maximum cache size (bytes)
  static const int maxCacheSize = 10485760; // 10 MB

  // ========================================
  // HELPER METHODS
  // ========================================

  /// Calculate exponential backoff delay for retries
  static int getRetryDelay(int attemptNumber) {
    return (retryDelayMs * pow(retryBackoffMultiplier, attemptNumber)).toInt();
  }

  /// Check if rate limit should throttle request
  /// Returns milliseconds to wait before next request
  static int getRateLimitDelay(DateTime lastRequestTime) {
    final now = DateTime.now();
    final timeSinceLastRequest = now.difference(lastRequestTime).inMilliseconds;

    if (timeSinceLastRequest < requestCooldownMs) {
      return requestCooldownMs - timeSinceLastRequest;
    }

    return 0; // No delay needed
  }

  /// Validate API configuration
  static bool validateConfig() {
    if (temperature < 0.0 || temperature > 1.0) {
      throw ArgumentError('Temperature must be between 0.0 and 1.0');
    }

    if (topP < 0.0 || topP > 1.0) {
      throw ArgumentError('Top-p must be between 0.0 and 1.0');
    }

    if (topK < 1) {
      throw ArgumentError('Top-k must be at least 1');
    }

    if (maxTokens < 1) {
      throw ArgumentError('Max tokens must be at least 1');
    }

    return true;
  }
}

/// Power function for exponential backoff calculation
int pow(double base, int exponent) {
  if (exponent == 0) return 1;
  int result = 1;
  for (int i = 0; i < exponent; i++) {
    result = (result * base).toInt();
  }
  return result;
}
