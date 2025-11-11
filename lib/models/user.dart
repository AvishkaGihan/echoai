/// Represents a user account in the app
class User {
  /// Firebase UID (unique identifier)
  final String uid;

  /// User's email address
  final String email;

  /// Optional display name
  final String? displayName;

  /// When the account was created
  final DateTime createdAt;

  /// Profile photo URL (optional, for Google Sign-In)
  final String? photoUrl;

  /// Whether email is verified
  final bool isEmailVerified;

  const User({
    required this.uid,
    required this.email,
    this.displayName,
    required this.createdAt,
    this.photoUrl,
    this.isEmailVerified = false,
  });

  /// Create a copy with updated fields
  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    DateTime? createdAt,
    String? photoUrl,
    bool? isEmailVerified,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  /// Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'display_name': displayName,
      'created_at': createdAt.millisecondsSinceEpoch,
      'photo_url': photoUrl,
      'is_email_verified': isEmailVerified ? 1 : 0,
    };
  }

  /// Create from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['display_name'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      photoUrl: map['photo_url'] as String?,
      isEmailVerified: (map['is_email_verified'] as int?) == 1,
    );
  }

  /// Create from Firebase User
  factory User.fromFirebaseUser(dynamic firebaseUser) {
    return User(
      uid: firebaseUser.uid as String,
      email: firebaseUser.email as String,
      displayName: firebaseUser.displayName as String?,
      createdAt: firebaseUser.metadata?.creationTime ?? DateTime.now(),
      photoUrl: firebaseUser.photoURL as String?,
      isEmailVerified: firebaseUser.emailVerified as bool? ?? false,
    );
  }

  /// Get display name or email if no display name
  String get displayIdentifier => displayName ?? email.split('@').first;

  /// Get initials for avatar (first letter of display name or email)
  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final parts = displayName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
