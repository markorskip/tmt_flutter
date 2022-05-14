import 'package:flutter/material.dart';

import 'package:tmt_flutter/view/main_screen.dart';
import 'package:tmt_flutter/repository/app_state_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  //SystemChrome.setEnabledSystemUIOverlays([]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Theme colors: Item 8 from this url: https://www.envato.com/blog/color-scheme-trends-in-mobile-app-design/
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
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
              bodyText2: TextStyle(
              color: blue
              ),
          headline6: TextStyle(fontSize: 25.0),
          subtitle1: TextStyle(fontSize: 20.0),
        ),
      ),
      home: GoalScreen(FirestoreStorage()),
      //home: GoalScreen(LocalGoalStorage()),
    );
  }
}
