import 'package:flutter/material.dart';

import 'package:tmt_flutter/goal_list.dart';
import 'package:tmt_flutter/goal.dart';
import 'new_goal_dialog.dart';

class GoalListScreen extends StatefulWidget {

  @override
  _GoalListScreenState createState() => _GoalListScreenState();

}

class _GoalListScreenState extends State<GoalListScreen> {
  Goal rootGoal = new Goal("root goal", "never show to user",0,0);
  List<Goal> currentlyDisplayedGoals = [new Goal("root goal", "never show to user",0,0)];
  String title = "Time Money Task List";

  _addGoal() async {
    final goal = await showDialog<Goal>(
      context: context,
      builder: (BuildContext context) {
        return NewGoalDialog();
      },
    );

    if (goal != null) {
      setState(() {
        currentlyDisplayedGoals.add(goal);
      });
    }
  }

  _addSubGoal(Goal goal) async {
    final subgoal = await showDialog<Goal>(
      context: context,
      builder: (BuildContext context) {
        return NewGoalDialog();
      },
    );

    if (goal != null) {
      setState(() {
        goal.addSubGoal(subgoal);
      });
    }
  }

  _showHelpDialog() async {  // TODO fix this - it's not working
      return new AlertDialog(
        title: new Text("My Super title"),
        content: new Text("Hello World"),
      );
  }

  _deleteGoal(Goal goal) {
    setState(() {
      goal.delete();
    });
  }

  _openGoal(Goal goal) {
    if (goal.goals.length > 0) {
      setState(() {
        titleStack.add(this.title);
        this.title = goal.title;
        goalsStack.add(this.currentlyDisplayedGoals);
        this.currentlyDisplayedGoals = goal.goals;
      });
    }
  }

  _backUp() {
    setState(() {
      this.title = titleStack.last;
      this.currentlyDisplayedGoals = goalsStack.last;
      goalsStack.removeLast();
      titleStack.removeLast();
    });
  }

  List<String> titleStack = [];
  List<List<Goal>> goalsStack = [];

  goalsToDisplay() {
    return currentlyDisplayedGoals.where((element) => element.isDeleted == false).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GoalList(
        goals: goalsToDisplay(),
        deleteHandler: _deleteGoal,
        addSubGoalHandler: _addSubGoal,
        openSubGoalHandler: _openGoal
      ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              showBackButton(),
              Spacer(),
              //IconButton(icon: Icon(Icons.search), onPressed: () {}),
              //IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
        ),
        floatingActionButton:
        FloatingActionButton(child: Icon(Icons.add), onPressed: _addGoal),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
  }

  showBackButton() {
    if (goalsStack.isNotEmpty) {
      return IconButton(icon: Icon(Icons.arrow_back), onPressed: _backUp);
    }
     return IconButton(icon: Icon(Icons.info), onPressed: _showHelpDialog);
  }
}
