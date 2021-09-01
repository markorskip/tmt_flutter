import 'package:flutter/material.dart';
import 'package:tmt_flutter/edit_goal_dialog.dart';

import 'package:tmt_flutter/goal_list.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/goal_storage.dart';
import 'new_goal_dialog.dart';

class GoalListScreen extends StatefulWidget {
  GoalListScreen(this.goalStorage);

  final GoalStorage goalStorage;

  @override
  _GoalListScreenState createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  AppState appState = new AppState();

  @override
  void initState() {
    // TODO replace with local storage
    super.initState();
    widget.goalStorage.readAppState().then((storedState) {
      setState(() {
        appState.currentlyDisplayedGoals = storedState.currentlyDisplayedGoals;
        appState.title = storedState.title;
        appState.titleStack = storedState.titleStack;
        appState.goalsStack = storedState.goalsStack;
      });
    });
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
        appState.currentlyDisplayedGoals.add(goal);
      });
    }
  }

  _editGoal(Goal goal) async {
    Goal? editedGoal = await showDialog<Goal>(
      context: context,
      builder: (BuildContext context) {
        return EditGoalDialog(goal);
      },
    );

    if (editedGoal != null) {
      setState(() {
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
      appState.titleStack.add(appState.title);
      appState.title = goal.title;
      appState.goalsStack.add(appState.currentlyDisplayedGoals);
      //goal.goals.sort(); // TODO fix the sort to move completed on the bottom
      appState.currentlyDisplayedGoals = goal.goals;

    });
  }

  _backUp() {
    setState(() {
      appState.title = appState.titleStack.last;
      appState.currentlyDisplayedGoals = appState.goalsStack.last;
      appState.goalsStack.removeLast();
      appState.titleStack.removeLast();
    });
  }

  _save() {
    widget.goalStorage.writeAppState(appState);
  }

  goalsToDisplay() {
    return appState.currentlyDisplayedGoals.where((element) => element.isDeleted == false).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appState.title)),
      body: GoalList(goalsToDisplay(), _deleteGoal, _openGoal, _toggleComplete, _editGoal),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            showBackButton(),
            Spacer(),
            showSaveButton()
            //IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton:
      FloatingActionButton(child: Icon(Icons.add), onPressed: _addGoal),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  showSaveButton() {
    return IconButton(icon: Icon(Icons.save), onPressed: _save);
  }

  showBackButton() {
    if (appState.goalsStack.isNotEmpty) {
      return IconButton(icon: Icon(Icons.arrow_back), onPressed: _backUp);
    }
     return IconButton(icon: Icon(Icons.info), onPressed: _showHelpDialog);
  }
}
