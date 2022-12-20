import 'package:flutter/material.dart';

// Theme colors: Item 8 from this url: https://www.envato.com/blog/color-scheme-trends-in-mobile-app-design/
const blue = Color(0xff0a5688);
const white = Color(0xffffffff);
const yellow = Color(0xfff9d162);
const orange = Color(0xfff3954f);
const lightGreen = Color(0xff6bc6a5);

const customColorScheme = ColorScheme(
  primary: blue,
  primaryVariant: lightGreen,
  secondary: blue,
  secondaryVariant: orange,
  surface: yellow,
  background: white,
  error: orange,
  onPrimary: white,
  onSecondary: white,
  onSurface: orange,
  onBackground: orange,
  onError: orange,
  brightness: Brightness.light,
);