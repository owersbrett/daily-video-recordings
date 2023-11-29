// Define your custom colors
import 'package:flutter/material.dart';

const Color amethyst = Color(0xFF9966CC); // A shade of amethyst
const Color lightAmethyst = Color(0xFFCC99FF); // A lighter shade of amethyst
const Color darkAmethyst = Color(0xFF663399); // A darker shade of amethyst

const Color opal = Color(0xFFA8C3BC); // A shade of opal
const Color lightOpal = Color(0xFFD3E0DB); // A lighter shade of opal
const Color darkOpal = Color(0xFF7A8C89); // A darker shade of opal



const Color sapphire = Color(0xFF0F52BA); // A shade of ruby
const Color lightSapphire = Color(0xFF4D7EBB); // A lighter shade of ruby
const Color darkSapphire = Color(0xFF0A3A6B); // A darker shade of ruby

const Color ruby = Color(0xFF9B111E); // A shade of ruby
const Color lightRuby = Color(0xFFC9404A); // A lighter shade of ruby
const Color darkRuby = Color(0xFF700D16); // A darker shade of ruby

const Color emerald = Color(0xFF50C878); // A shade of emerald
const Color lightEmerald = Color(0xFF76D7A4); // A lighter shade of emerald
const Color darkEmerald = Color(0xFF32965D); // A darker shade of emerald

const Color gold = Color(0xFFD4AF37); // A shade of gold
const Color lightGold = Color(0xFFE8C55F); // A lighter shade of gold
const Color darkGold = Color(0xFFA78B2C); // A darker shade of gold

const Color lightBackgroundColor = Color(0xff232A35);
const Color backgroundColor = Color(0xff232A35);
const Color darkBackgroundColor = Color(0xff232A35);
// Define the color scheme
const ColorScheme myColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.white, // Use ruby as the primary color
  outlineVariant: darkRuby, // Use a darker shade of ruby for the outline variant
  surfaceVariant: lightRuby,
  secondary: emerald, // Use emerald as the secondary color
  outline: darkEmerald,
  onSurfaceVariant: lightEmerald,
  surface: Colors.white,
  background: Colors.white,
  error: darkRuby,
  onPrimary: emerald, // Text color on top of the primary color
  onSecondary: darkEmerald, // Text color on top of the secondary color
  onSurface: lightEmerald, // Typically the text color for inputs, cards, etc.
  onBackground: Colors.black, // Typically the background color for pages or cards
  onError: Colors.white, // Text color on top of the error color
);

final ThemeData theme = ThemeData(
  tabBarTheme: TabBarTheme(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black.withOpacity(.5),
      dividerColor: Colors.white,
      overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
      indicatorColor: emerald),
  // This is the theme of your application.
  //
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.black,
    selectionColor: Colors.black.withOpacity(.3),
    selectionHandleColor: Colors.black,
  ),

  appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
  progressIndicatorTheme:
      ProgressIndicatorThemeData(color: emerald, refreshBackgroundColor: emerald.withOpacity(.3), linearTrackColor: emerald.withOpacity(.3)),
  dropdownMenuTheme: const DropdownMenuThemeData(textStyle: TextStyle(color: Colors.white)),
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
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
