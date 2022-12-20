import 'package:flutter/material.dart';
import 'package:tmt_flutter/view/formatting/color_scheme.dart';

import 'package:tmt_flutter/view/goal_screen.dart';
import 'package:tmt_flutter/repository/app_state_repository.dart';

Future<void> main() async {
  //SystemChrome.setEnabledSystemUIOverlays([]);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Money Tasklist',
      theme: getThemeData(),
      home: GoalScreen(AppStateRepository(LocalStorage())),
    );
  }

  ThemeData getThemeData() {
    return ThemeData(
      //brightness: Brightness.dark,
      brightness: Brightness.light,
      colorScheme: customColorScheme,
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
    );
  }
}
