import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFD52B1E);
  static const Color deepRed = Color(0xFFAB1F14);
  static const Color lightRed = Color(0xFFFF4D42);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F5F5);
  static const Color warmGrey = Color(0xFF8C8C8C);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color mediumGrey = Color(0xFF3D3D3D);
  static const Color cardBg = Color(0xFFFFF9F9);
  static const Color divider = Color(0xFFEDE0E0);
  static const Color success = Color(0xFF2D8A4E);
  static const Color warning = Color(0xFFE08C00);
  static const Color error = Color(0xFFD52B1E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        onPrimary: white,
        secondary: deepRed,
        surface: white,
        background: offWhite,
        error: error,
      ),
      fontFamily: 'Georgia',
      scaffoldBackgroundColor: offWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: darkGrey,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkGrey),
        titleTextStyle: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: darkGrey,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryRed,
          side: const BorderSide(color: primaryRed, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryRed,
          textStyle: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: divider, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: divider, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        labelStyle: const TextStyle(color: warmGrey, fontFamily: 'Georgia'),
        hintStyle: const TextStyle(color: warmGrey, fontFamily: 'Georgia'),
        errorStyle: const TextStyle(color: error, fontFamily: 'Georgia'),
      ),
      cardTheme: CardTheme(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: divider, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryRed,
        unselectedItemColor: warmGrey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 12,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: darkGrey,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: darkGrey,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: darkGrey,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: darkGrey,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: darkGrey,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: darkGrey,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: mediumGrey,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: mediumGrey,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: warmGrey,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: darkGrey,
        ),
      ),
    );
  }
}

class AppColors {
  static const Color primaryRed = AppTheme.primaryRed;
  static const Color deepRed = AppTheme.deepRed;
  static const Color lightRed = AppTheme.lightRed;
  static const Color white = AppTheme.white;
  static const Color offWhite = AppTheme.offWhite;
  static const Color warmGrey = AppTheme.warmGrey;
  static const Color darkGrey = AppTheme.darkGrey;
  static const Color mediumGrey = AppTheme.mediumGrey;
  static const Color cardBg = AppTheme.cardBg;
  static const Color divider = AppTheme.divider;
  static const Color success = AppTheme.success;
  static const Color warning = AppTheme.warning;
  static const Color error = AppTheme.error;
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;
  static const double full = 100;
}
