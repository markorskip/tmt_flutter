import 'package:flutter/material.dart';

import 'package:tmt_flutter/goal_list_screen.dart';
import 'package:tmt_flutter/goal_storage.dart';



void main() {
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: GoalListScreen(GoalStorage()),
    );
  }
}
