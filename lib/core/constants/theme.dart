import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F0F1E),
      primaryColor: const Color(0xFF6B4EFF),
      secondaryContainer: const Color(0xFF1A1A2E),

      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          // Headlines
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
          ),
          // Body text
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFFCCCCCC),
            height: 1.6,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFAAAAAA),
          ),
          // Labels
          labelSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF888888),
          ),
        ),
      ),

      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6B4EFF),
        secondary: Color(0xFFFF6B9D),
        tertiary: Color(0xFF4ECDC4),
        surface: Color(0xFF1A1A2E),
        surfaceContainerHighest: Color(0xFF2A2A3E),
        onSurface: Color(0xFFFFFFFF),
        onPrimary: Color(0xFFFFFFFF),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B4EFF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF6B4EFF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: Color(0xFF888888)),
      ),

      iconTheme: const IconThemeData(
        color: Color(0xFFCCCCCC),
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF0F0F1E),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFCCCCCC)),
      ),

      cardTheme: CardTheme(
        color: const Color(0xFF1A1A2E),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      dividerColor: const Color(0xFF2A2A3E),
    );
  }
}

// Color Palette - Addictive & Premium
class AppColors {
  static const primary = Color(0xFF6B4EFF); // Purple - premium feel
  static const secondary = Color(0xFFFF6B9D); // Pink - emotional engagement
  static const accent = Color(0xFF4ECDC4); // Teal - interactive elements

  static const bgDark = Color(0xFF0F0F1E); // Deep dark - focus on content
  static const bgSecondary = Color(0xFF1A1A2E);
  static const bgTertiary = Color(0xFF2A2A3E);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFCCCCCC);
  static const textTertiary = Color(0xFFAAAAAA);
  static const textDisabled = Color(0xFF888888);

  // Gradient for premium feel
  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6B4EFF), Color(0xFF8E7CFF)],
  );

  static const gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB1)],
  );
}

// Spacing - Clean, predictable
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

// Border Radius - Friendly, modern
class AppRadius {
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
  static const xl = 24.0;
}
