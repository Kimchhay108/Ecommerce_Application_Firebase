import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF8E6CEE);
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Color(0xFFF4F4F4);
  static const Color textPrimaryColor = Color(0xFF272727);
  static const Color textSecondaryColor = Color(0x7F272727);
  static const Color borderCardColor = Color(0xFFE2E2E2);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor,
        surface: surfaceColor,
        error: Colors.redAccent,
      ),
      textTheme: GoogleFonts.gabaritoTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: textPrimaryColor,
        displayColor: textPrimaryColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimaryColor),
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: const CardTheme(
        color: surfaceColor,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
