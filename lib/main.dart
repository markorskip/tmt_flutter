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
    print(context);
    return MaterialApp(
      title: 'Todo List',
      home: GoalScreen(GoalStorage()), // TODO implement spinner while goal storage loads
    );
  }
}
