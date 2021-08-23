import 'package:flutter/material.dart';
import 'package:tmt_flutter/model.dart';

import 'package:tmt_flutter/goal_list.dart';

import 'new_goal_dialog.dart';

class GoalListScreen extends StatefulWidget {

  @override
  _GoalListScreenState createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  List<Goal> goals = [new Goal("Remodel Home","Paint and Carpets - Paying professionals",10000.0,25,0),
    new Goal("Remodel Home DIY","Paint and Carpet DIY",2500.0,200,0)
  ];

  _addRootGoal() async {
    final goal = await showDialog<Goal>(
      context: context,
      builder: (BuildContext context) {
        return NewGoalDialog();
      },
    );

    if (goal != null) {
      setState(() {
        goals.add(goal);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Time Money Task List')),
      body: GoalList(
        goals: goals
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addRootGoal,
      ),
    );
  }
}
