import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static const TextTheme _lightTextTheme = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 16,
      color: kNeutral900,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: kNeutral900,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: kNeutral900,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: kNeutral900,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "Noir Pro",
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white, // Colors.grey[50],
        elevation: 2.0,
        titleTextStyle: _lightTextTheme.headlineMedium,
      ),
      primaryColor: kPrimaryColor,
      textTheme: _lightTextTheme,
      // textSelectionTheme: const TextSelectionThemeData(
      //   cursorColor: kPrimaryColor,
      // ),
      // inputDecorationTheme: InputDecorationTheme(
      //   isDense: false,
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8.0),
      //     borderSide: const BorderSide(
      //       color: kNeutral100,
      //     ),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8.0),
      //     borderSide: const BorderSide(
      //       color: kNeutral100,
      //     ),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8.0),
      //     borderSide: const BorderSide(
      //       color: kPrimaryColor,
      //     ),
      //   ),
      //   disabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8.0),
      //     borderSide: const BorderSide(
      //       color: kNeutral50,
      //     ),
      //   ),
      //   focusedErrorBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: const BorderSide(color: kError500Color, width: 1.0),
      //   ),
      //   focusColor: kPrimaryColor,
      // ),
    );
  }
}
