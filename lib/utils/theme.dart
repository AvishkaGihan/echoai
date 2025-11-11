import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

/// App theme configuration - Dark mode native
class AppTheme {
  AppTheme._();

  /// Get dark theme with specified accent color
  static ThemeData getDarkTheme({Color? accentColor}) {
    final accent = accentColor ?? AppConstants.primaryPurple;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // ========================================
      // COLOR SCHEME
      // ========================================
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: AppConstants.accentCyan,
        tertiary: AppConstants.accentPink,
        surface: AppConstants.neutralSurface,
        error: AppConstants.errorColor,
        onPrimary: AppConstants.neutralBackground,
        onSecondary: AppConstants.neutralBackground,
        onSurface: AppConstants.textPrimary,
        onError: Colors.white,
        outline: AppConstants.borderColor,
      ),

      // ========================================
      // SCAFFOLD
      // ========================================
      scaffoldBackgroundColor: AppConstants.neutralBackground,

      // ========================================
      // APP BAR
      // ========================================
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.neutralSurface,
        foregroundColor: AppConstants.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontSize: AppConstants.fontSizeH3,
          fontWeight: AppConstants.fontWeightBold,
          color: AppConstants.textPrimary,
        ),
      ),

      // ========================================
      // BOTTOM NAVIGATION BAR
      // ========================================
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.neutralSurface,
        selectedItemColor: AppConstants.accentCyan,
        unselectedItemColor: AppConstants.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontSizeTiny,
          fontWeight: AppConstants.fontWeightSemibold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontSizeTiny,
          fontWeight: AppConstants.fontWeightRegular,
        ),
      ),

      // ========================================
      // CARD
      // ========================================
      cardTheme: CardThemeData(
        color: AppConstants.neutralSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          side: const BorderSide(color: AppConstants.borderColor, width: 1),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMd,
          vertical: AppConstants.spaceSm,
        ),
      ),

      // ========================================
      // INPUT DECORATION
      // ========================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.neutralSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(
            color: AppConstants.borderColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: BorderSide(
            color: AppConstants.borderColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(
            color: AppConstants.accentCyan,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(
            color: AppConstants.errorColor,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(
            color: AppConstants.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceMd,
          vertical: AppConstants.spaceSm,
        ),
        hintStyle: const TextStyle(
          color: AppConstants.textSecondary,
          fontSize: AppConstants.fontSizeBody,
        ),
        labelStyle: const TextStyle(
          color: AppConstants.textSecondary,
          fontSize: AppConstants.fontSizeLabel,
        ),
        errorStyle: const TextStyle(
          color: AppConstants.errorColor,
          fontSize: AppConstants.fontSizeSmall,
        ),
      ),

      // ========================================
      // ELEVATED BUTTON
      // ========================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: AppConstants.neutralBackground,
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.buttonHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceLg,
            vertical: AppConstants.spaceSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeLabel,
            fontWeight: AppConstants.fontWeightSemibold,
          ),
        ),
      ),

      // ========================================
      // OUTLINED BUTTON
      // ========================================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.accentCyan,
          side: const BorderSide(color: AppConstants.accentCyan, width: 2),
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.buttonHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceLg,
            vertical: AppConstants.spaceSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeLabel,
            fontWeight: AppConstants.fontWeightSemibold,
          ),
        ),
      ),

      // ========================================
      // TEXT BUTTON
      // ========================================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.accentCyan,
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.buttonHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceMd,
            vertical: AppConstants.spaceSm,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeLabel,
            fontWeight: AppConstants.fontWeightSemibold,
          ),
        ),
      ),

      // ========================================
      // ICON BUTTON
      // ========================================
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppConstants.textPrimary,
          minimumSize: const Size(
            AppConstants.minTouchTarget,
            AppConstants.minTouchTarget,
          ),
        ),
      ),

      // ========================================
      // FLOATING ACTION BUTTON
      // ========================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: AppConstants.neutralBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),

      // ========================================
      // DIALOG
      // ========================================
      dialogTheme: DialogThemeData(
        backgroundColor: AppConstants.neutralSurface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        titleTextStyle: const TextStyle(
          fontSize: AppConstants.fontSizeH3,
          fontWeight: AppConstants.fontWeightBold,
          color: AppConstants.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: AppConstants.fontSizeBody,
          color: AppConstants.textPrimary,
        ),
      ),

      // ========================================
      // SNACKBAR
      // ========================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppConstants.neutralSurface,
        contentTextStyle: const TextStyle(
          fontSize: AppConstants.fontSizeBody,
          color: AppConstants.textPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        ),
        elevation: 4,
      ),

      // ========================================
      // DIVIDER
      // ========================================
      dividerTheme: const DividerThemeData(
        color: AppConstants.borderColor,
        thickness: 1,
        space: 1,
      ),

      // ========================================
      // TYPOGRAPHY
      // ========================================
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontSizeH1,
          fontWeight: AppConstants.fontWeightBold,
          color: AppConstants.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: AppConstants.fontSizeH2,
          fontWeight: AppConstants.fontWeightBold,
          color: AppConstants.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: AppConstants.fontSizeH3,
          fontWeight: AppConstants.fontWeightSemibold,
          color: AppConstants.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontWeight: AppConstants.fontWeightRegular,
          color: AppConstants.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeBody,
          fontWeight: AppConstants.fontWeightRegular,
          color: AppConstants.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: AppConstants.fontWeightRegular,
          color: AppConstants.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: AppConstants.fontSizeLabel,
          fontWeight: AppConstants.fontWeightSemibold,
          color: AppConstants.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: AppConstants.fontWeightRegular,
          color: AppConstants.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: AppConstants.fontSizeTiny,
          fontWeight: AppConstants.fontWeightRegular,
          color: AppConstants.textSecondary,
        ),
      ),

      // ========================================
      // ICON THEME
      // ========================================
      iconTheme: const IconThemeData(
        color: AppConstants.textPrimary,
        size: AppConstants.iconSize,
      ),
    );
  }

  /// Get theme based on accent color name
  static ThemeData getThemeByColorName(String colorName) {
    return getDarkTheme(accentColor: AppConstants.getAccentColor(colorName));
  }
}
