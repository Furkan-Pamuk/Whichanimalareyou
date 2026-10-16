import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.softCream,
      cardColor: AppColors.surfaceLight,
      primaryColor: AppColors.jungleGreen,
      colorScheme: ColorScheme.light(
        primary: AppColors.jungleGreen,
        secondary: AppColors.vibrantAmber,
        surface: AppColors.surfaceLight,
        background: AppColors.offWhite,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: AppColors.textLightPrimary,
        onBackground: AppColors.textLightPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme.apply(
          bodyColor: AppColors.textLightPrimary,
          displayColor: AppColors.textLightPrimary,
        ),
      ).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 36,
          color: AppColors.textLightPrimary,
        ),
        displayMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 28,
          color: AppColors.textLightPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: AppColors.textLightPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.textLightPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.textLightSecondary,
        ),
        labelLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textLightPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warmCoral,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          elevation: 4,
          shadowColor: AppColors.warmCoral.withOpacity(0.4),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.jungleGreen,
          side: const BorderSide(color: AppColors.jungleGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.selected) ? AppColors.vibrantAmber : Colors.grey,
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.selected) ? AppColors.vibrantAmber.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepCharcoal,
      cardColor: AppColors.surfaceDark,
      primaryColor: AppColors.jungleGreen,
      colorScheme: ColorScheme.dark(
        primary: AppColors.jungleGreen,
        secondary: AppColors.vibrantAmber,
        surface: AppColors.surfaceDark,
        background: AppColors.deepCharcoal,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: AppColors.textDarkPrimary,
        onBackground: AppColors.textDarkPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme.apply(
          bodyColor: AppColors.textDarkPrimary,
          displayColor: AppColors.textDarkPrimary,
        ),
      ).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 36,
          color: AppColors.textDarkPrimary,
        ),
        displayMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 28,
          color: AppColors.textDarkPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: AppColors.textDarkPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.textDarkPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.textDarkSecondary,
        ),
        labelLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textDarkPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warmCoral,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          elevation: 4,
          shadowColor: AppColors.warmCoral.withOpacity(0.4),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.jungleGreen,
          side: const BorderSide(color: AppColors.jungleGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.selected) ? AppColors.vibrantAmber : Colors.grey,
        ),
        trackColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.selected) ? AppColors.vibrantAmber.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      useMaterial3: true,
    );
  }
}
