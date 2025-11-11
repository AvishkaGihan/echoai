import 'package:flutter/material.dart';
import 'constants.dart';

/// Extensions for String class
extension StringExtensions on String {
  /// Capitalize first letter of string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Check if string is valid email
  bool get isValidEmail {
    return AppConstants.isValidEmail(this);
  }

  /// Check if string is valid password
  bool get isValidPassword {
    return AppConstants.isValidPassword(this);
  }

  /// Truncate string to max length with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Remove extra whitespace
  String removeExtraSpaces() {
    return replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Convert string to title case
  String toTitleCase() {
    return split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  /// Check if string contains only whitespace
  bool get isBlank {
    return trim().isEmpty;
  }

  /// Check if string is not blank
  bool get isNotBlank {
    return !isBlank;
  }

  /// Convert markdown-style bold to Flutter TextSpan
  /// **bold text** -> bold TextSpan
  List<TextSpan> toTextSpans({TextStyle? baseStyle}) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    var lastIndex = 0;

    for (final match in regex.allMatches(this)) {
      // Add text before match
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(text: substring(lastIndex, match.start), style: baseStyle),
        );
      }

      // Add bold text
      spans.add(
        TextSpan(
          text: match.group(1),
          style:
              baseStyle?.copyWith(fontWeight: FontWeight.bold) ??
              const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < length) {
      spans.add(TextSpan(text: substring(lastIndex), style: baseStyle));
    }

    return spans;
  }
}

/// Extensions for DateTime class
extension DateTimeExtensions on DateTime {
  /// Format as "2h ago", "3d ago", etc.
  String toRelativeTime() {
    return AppConstants.formatTimestamp(this);
  }

  /// Format as "Nov 10, 2025"
  String toShortDate() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[month - 1]} $day, $year';
  }

  /// Format as "2:34 PM"
  String toTimeString() {
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final period = hour >= 12 ? 'PM' : 'AM';
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour12:$minute $period';
  }

  /// Format as "Nov 10, 2025 at 2:34 PM"
  String toFullDateTime() {
    return '${toShortDate()} at ${toTimeString()}';
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is within last 7 days
  bool get isWithinWeek {
    final now = DateTime.now();
    return now.difference(this).inDays < 7;
  }

  /// Get friendly date string ("Today", "Yesterday", or date)
  String toFriendlyDate() {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    return toShortDate();
  }
}

/// Extensions for List class
extension ListExtensions<T> on List<T> {
  /// Check if list is not empty
  bool get isNotEmpty => length > 0;

  /// Get first element or null if empty
  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  /// Get last element or null if empty
  T? get lastOrNull {
    return isEmpty ? null : last;
  }

  /// Safely get element at index or return null
  T? safeGet(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Split list into chunks of specified size
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}

/// Extensions for BuildContext
extension ContextExtensions on BuildContext {
  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  /// Get safe area padding
  EdgeInsets get safeArea => MediaQuery.of(this).padding;

  /// Show snackbar with message
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? AppConstants.errorColor
            : AppConstants.neutralSurface,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show success snackbar
  void showSuccess(String message) {
    showSnackBar('✓ $message', isError: false);
  }

  /// Show error snackbar
  void showError(String message) {
    showSnackBar('⚠ $message', isError: true);
  }

  /// Show loading dialog
  void showLoadingDialog() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    Navigator.of(this).pop();
  }

  /// Navigate to named route
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Navigate and replace current route
  Future<T?> navigateReplace<T>(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed<T, void>(routeName, arguments: arguments);
  }

  /// Navigate and clear stack
  Future<T?> navigateClearStack<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back
  void goBack<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Check if can go back
  bool get canGoBack => Navigator.of(this).canPop();
}

/// Extensions for Color class
extension ColorExtensions on Color {
  /// Get lighter version of color
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Get darker version of color
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Convert to hex string
  String toHex({bool includeAlpha = false}) {
    if (includeAlpha) {
      return '#${((a * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
              '${((r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
              '${((g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
              '${((b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
    }
    return '#${((r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
            '${((g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
            '${((b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }
}

/// Extensions for Duration class
extension DurationExtensions on Duration {
  /// Format as "2:34" (minutes:seconds)
  String toMMSS() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Format as "2h 34m"
  String toHumanReadable() {
    if (inHours > 0) {
      final hours = inHours;
      final minutes = inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    } else if (inMinutes > 0) {
      final minutes = inMinutes;
      final seconds = inSeconds.remainder(60);
      return '${minutes}m ${seconds}s';
    } else {
      return '${inSeconds}s';
    }
  }
}
