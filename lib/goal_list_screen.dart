import 'package:flutter/material.dart';
import 'package:tmt_flutter/edit_goal_dialog.dart';

import 'package:tmt_flutter/goal_list.dart';
import 'package:tmt_flutter/goal.dart';
import 'new_goal_dialog.dart';

class GoalListScreen extends StatefulWidget {

  @override
  _GoalListScreenState createState() => _GoalListScreenState();

}

class _GoalListScreenState extends State<GoalListScreen> {


  List<Goal> currentlyDisplayedGoals = [];
  String title;
  @override
  void initState() {
    //adding item to list, you can add using json from network
    Goal houseUpgrades = new Goal("House Upgrades", "Improvements to make the house better",0,0);
    houseUpgrades.addSubGoal(new Goal("Paint interior","Professional Qoute",6000,5));
    Goal replaceCarpet = new Goal("Replace Carpet","Professional Quote",3500,5);
    replaceCarpet.complete = true;
    houseUpgrades.addSubGoal(replaceCarpet);

    currentlyDisplayedGoals.add(houseUpgrades);
    title = "TMT";
    super.initState();
  }

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

  _editGoal(Goal goal) async {
    Goal editedGoal = await showDialog<Goal>(
      context: context,
      builder: (BuildContext context) {
        return EditGoalDialog(goalToEdit: goal);
      },
    );

    if (editedGoal != null) {
      setState(() {
        print(editedGoal);
        print(goal);
        goal.update(editedGoal);
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

  _toggleComplete(Goal goal) {
    setState(() {
      goal.complete = !goal.complete;
    });
  }

  _openGoal(Goal goal) {
    setState(() {
      titleStack.add(this.title);
      this.title = goal.title;
      goalsStack.add(this.currentlyDisplayedGoals);
      this.currentlyDisplayedGoals = goal.goals;
    });
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
        openSubGoalHandler: _openGoal,
        toggleCompleteHandler: _toggleComplete,
        editHandler: _editGoal,
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
