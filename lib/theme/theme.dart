// Define your custom colors
import 'package:flutter/material.dart';

const Color sapphire = Color(0xFF0F52BA); // A shade of ruby
const Color sapphireLight = Color(0xFF4D7EBB); // A lighter shade of ruby
const Color sapphireDark = Color(0xFF0A3A6B); // A darker shade of ruby

const Color ruby = Color(0xFF9B111E); // A shade of ruby
const Color rubyLight = Color(0xFFC9404A); // A lighter shade of ruby
const Color rubyDark = Color(0xFF700D16); // A darker shade of ruby

const Color emerald = Color(0xFF50C878); // A shade of emerald
const Color emeraldLight = Color(0xFF76D7A4); // A lighter shade of emerald
const Color emeraldDark = Color(0xFF32965D); // A darker shade of emerald

const Color gold = Color(0xFFD4AF37); // A shade of gold
const Color goldLight = Color(0xFFE8C55F); // A lighter shade of gold
const Color goldDark = Color(0xFFA78B2C); // A darker shade of gold
// Define the color scheme
const ColorScheme myColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.white, // Use ruby as the primary color
  outlineVariant:
      rubyDark, // Use a darker shade of ruby for the outline variant
  surfaceVariant: rubyLight,
  secondary: emerald, // Use emerald as the secondary color
  outline: emeraldDark,
  onSurfaceVariant: emeraldLight,
  surface: Colors.white,
  background: Colors.white,
  error: rubyDark,
  onPrimary: gold, // Text color on top of the primary color
  onSecondary: goldLight, // Text color on top of the secondary color
  onSurface: goldDark, // Typically the text color for inputs, cards, etc.
  onBackground:
      Colors.black, // Typically the background color for pages or cards
  onError: Colors.white, // Text color on top of the error color
);

final ThemeData theme = ThemeData(
  // This is the theme of your application.
  //
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white
  ),
  dropdownMenuTheme:
      const DropdownMenuThemeData(textStyle: TextStyle(color: Colors.white)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  colorScheme: myColorScheme,
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle:
        TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    focusedBorder: OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide(color: Colors.black, width: 3),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide(color: Colors.black, width: 2),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  ),
  useMaterial3: true,
);
