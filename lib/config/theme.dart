import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF6A4053); // Dark Plum
  static const Color secondary = Color(0xFF99868C); // Muted Plum
  static const Color tertiary = Color(0xFFC4ACAC);
  static const Color neutralBg = Color(0xFFFDF4F5); // Light Cream
  static const Color neutralSurface = Color(0xFFFFFFFF); // Surface White
  static const Color neutralText = Color(0xFF6A4053); // Same as primary
  
  // Semantic Colors
  static const Color success = Color(0xFF22C55E);
  static const Color pending = Color(0xFFEAB308);
  static const Color unavailable = Color(0xFFFCA5A5);
  static const Color link = Color(0xFF06B6D4);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: neutralBg,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: neutralSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primary,
        error: unavailable,
      ),
      textTheme: GoogleFonts.figtreeTextTheme().apply(
        bodyColor: primary,
        displayColor: primary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: neutralBg,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(color: primary),
        hintStyle: TextStyle(color: secondary.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: const Color(0xFF2C1923), // Very Dark Plum (no-black rule)
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFDF4F5), // Light Cream for primary elements in dark mode
        secondary: secondary,
        surface: Color(0xFF3B232F), // Slightly lighter dark plum for surfaces
        onPrimary: Color(0xFF2C1923),
        onSecondary: Colors.white,
        onSurface: Color(0xFFFDF4F5),
        error: unavailable,
      ),
      textTheme: GoogleFonts.figtreeTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: const Color(0xFFFDF4F5),
        displayColor: const Color(0xFFFDF4F5),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2C1923),
        foregroundColor: Color(0xFFFDF4F5),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFFDF4F5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFDF4F5),
          foregroundColor: const Color(0xFF2C1923),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(color: Color(0xFFFDF4F5)),
        hintStyle: TextStyle(color: secondary.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFDF4F5), width: 2),
        ),
      ),
      useMaterial3: true,
    );
  }
}

