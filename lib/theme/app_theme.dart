import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Playful palette inspired by Charmi's rounded, kawaii habit UI.
class MzajColors {
  static const navy = Color(0xFF24368F);
  static const lime = Color(0xFFC6EC5A);
  static const pink = Color(0xFFF7A8C4);
  static const sky = Color(0xFF9ED4F0);
  static const yellow = Color(0xFFF4E35A);
  static const paleYellow = Color(0xFFFFF6C9);
  static const mintBlue = Color(0xFFC9EEF0);
  static const softPink = Color(0xFFF5B1D8);
  static const lavender = Color(0xFFB7BDF6);
  static const black = Color(0xFF111111);
  static const white = Color(0xFFFFFFFF);
  static const muted = Color(0xFF8A8A8A);
}

class NeoStyle {
  static const radius = 32.0;

  static BoxDecoration card({
    required Color color,
    double radius = radius,
    bool shadow = false,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: shadow
          ? [
              BoxShadow(
                color: MzajColors.black.withValues(alpha: 0.06),
                offset: const Offset(0, 8),
                blurRadius: 16,
              ),
            ]
          : null,
    );
  }

  static BoxDecoration pill({required Color color}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(999),
    );
  }
}

class MzajTheme {
  static ThemeData get neo {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: MzajColors.mintBlue,
      colorScheme: const ColorScheme.light(
        primary: MzajColors.navy,
        onPrimary: MzajColors.white,
        secondary: MzajColors.lime,
        onSecondary: MzajColors.navy,
        surface: MzajColors.white,
        onSurface: MzajColors.black,
      ),
    );

    return base.copyWith(
      primaryColor: MzajColors.navy,
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.nunito(
          fontSize: 40,
          fontWeight: FontWeight.w900,
          color: MzajColors.lime,
          height: 1.05,
          letterSpacing: -0.6,
        ),
        displayMedium: GoogleFonts.nunito(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: MzajColors.navy,
          height: 1.1,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: MzajColors.navy,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: MzajColors.navy,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: MzajColors.navy,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: MzajColors.navy.withValues(alpha: 0.74),
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          color: MzajColors.navy,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: MzajColors.navy),
        foregroundColor: MzajColors.navy,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: MzajColors.navy,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MzajColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: MzajColors.navy, width: 2),
        ),
        hintStyle: GoogleFonts.nunito(
          color: MzajColors.navy.withValues(alpha: 0.5),
          fontWeight: FontWeight.w700,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: MzajColors.navy,
        contentTextStyle: GoogleFonts.nunito(color: MzajColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MzajColors.navy,
          foregroundColor: MzajColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
