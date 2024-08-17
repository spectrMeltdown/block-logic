import 'package:flutter/material.dart';

class AppTheme {
  TextStyle textStyle = const TextStyle(
    color: Colors.white,
  );

  /// Make the same text theme for both system dark/light theme
  TextTheme textTheme() => TextTheme(
        displayLarge: textStyle,
        displayMedium: textStyle,
        displaySmall: textStyle,
        headlineLarge: textStyle,
        headlineMedium: textStyle,
        headlineSmall: textStyle,
        titleLarge: textStyle,
        titleMedium: textStyle,
        titleSmall: textStyle,
        bodyLarge: textStyle,
        bodyMedium: textStyle,
        bodySmall: textStyle,
        labelLarge: textStyle,
        labelMedium: textStyle,
        labelSmall: textStyle,
      );

  /// Make the same app theme for system dark or light theme
  ThemeData theme() => ThemeData(
        fontFamily: 'Play',
        textTheme: textTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade400),
        scaffoldBackgroundColor: Colors.transparent,
        tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
        inputDecorationTheme: const InputDecorationTheme(
            prefixIconColor: Colors.white, suffixIconColor: Colors.white),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.blueGrey.shade900,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.blueGrey.shade900,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      );
}
