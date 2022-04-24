import 'package:flutter/material.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';

enum AppTheme { baseDark, baseLight, light }

final appThemeData = {
  AppTheme.light: ThemeData(
    colorScheme: ColorScheme(
      // The color displayed most frequently
      // across your app’s screens and components
      primary: ColorPerseus.blue,
      // A color that's clearly legible when drawn on primary
      onPrimary: Colors.white,
      // A darker version of the primary color
      primaryContainer: Colors.blue,

      // An accent color that, when used sparingly,
      // calls attention to parts of your app
      secondary: ColorPerseus.pink,
      // A color that's clearly legible when drawn on secondary
      onSecondary: Colors.white,
      // A darker version of the secondary color (Used for warnings)
      secondaryContainer: Colors.blue,

      // A color that typically appears behind scrollable content
      background: Colors.blue,
      // A color that's clearly legible when drawn on background
      onBackground: Colors.black,

      // The background color for widgets like Card
      surface: Colors.white,
      // A color that's clearly legible when drawn on surface
      onSurface: Colors.blue,

      // The color to use for input validation errors, e.g.
      // for InputDecoration.errorText.
      error: Colors.red,
      // A color that's clearly legible when drawn on error
      onError: Colors.white,

      // The overall brightness of this color scheme
      brightness: Brightness.light,
    ),
  ),
};
