import 'package:flutter/material.dart';

import 'package:tmt_flutter/goal_list/goal_screen.dart';
import 'package:tmt_flutter/model/goal_storage.dart';



void main() {
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    const blue = Color(0xff0a5688);
    const white = Color(0xffffffff);
    const yellow = Color(0xfff9d162);
    const orange = Color(0xfff3954f);
    const lightGreen = Color(0xff6bc6a5);

    const _customColorScheme = ColorScheme(
      primary: blue,
      primaryVariant: lightGreen,
      secondary: blue,
      secondaryVariant: orange,
      surface: white,
      background: white,
      error: orange,
      onPrimary: white,
      onSecondary: white,
      onSurface: blue,
      onBackground: orange,
      onError: orange,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        //brightness: Brightness.dark,
        brightness: Brightness.light,
        colorScheme: _customColorScheme,
        primaryColor: blue,
        secondaryHeaderColor: lightGreen,
        buttonColor: orange,
        // Define the default font family.
        fontFamily: 'Hind',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and rmore.
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 26.0),
          subtitle1: TextStyle(fontSize: 20.0),
        ),
      ),
      home: GoalScreen(GoalStorage()),
    );
  }
}
