
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:tmt_flutter/view/bottom/bottom_nav_bar.dart';
import 'package:tmt_flutter/view/bottom/breadcrumbs.dart';
import 'package:tmt_flutter/view/dialog/edit_goal_dialog.dart';
import 'package:tmt_flutter/view/dialog/move_goal_dialog.dart';

import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/repository/app_state_repository.dart';
import 'package:tmt_flutter/model/model_helpers/move_goal_directive.dart';
import '../model/model_helpers/edit_goal_directive.dart';
import 'dialog/new_goal_dialog.dart';
import 'header/app_bar_display.dart';
import 'slideable/slideable_tasks.dart';

class GoalScreen extends StatefulWidget {
  GoalScreen(this.appStateRepository);

  final AppStateRepository appStateRepository;

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {

  late AppState appState;

  Future<AppState> getAppState() async {
    return await widget.appStateRepository.readAppState(getUserId());
  }

  @override
  void initState() {
    super.initState();
    widget.appStateRepository.readAppState(getUserId()).then((value) => this.appState = value);
  }

  _addGoal() async {
    //TODO consider instead of a dialog it slide over to another page - gives user the full screen
    final goal = await showDialog<Goal>(
      context: context,
      builder: (BuildContext context) {
        return NewGoalDialog(appState.getCurrentGoal());
      },
    );

    if (goal != null) {
      setState(() {
        appState.getCurrentlyDisplayedGoalsIncludingDeleted().add(goal);
        _save();
      });

    }
  }

  _editGoal(Goal goal) async {
    EditGoal? editedGoal = await showDialog<EditGoal>(
      context: context,
      builder: (BuildContext context) {
        return EditGoalDialog(goal);
      },
    );
    if (editedGoal != null) {
      setState(() {
        goal.editGoal(editedGoal);
        _save();
      }); // Update changes on screen=
    }
  }

  moveGoal(Goal goalToMove) async {
    MoveGoal? moveGoal = await showDialog<MoveGoal>(
      context: context,
      builder: (BuildContext context) {
        return MoveGoalDialog(goalToMove, appState.getGoalsToDisplay(), appState.getGrandParentGoal());
      },
    );

    if (moveGoal != null) {
    setState(() {
      appState.move(moveGoal);
      if (appState.getGoalsToDisplay().length == 0) {
        _navigateUp();
      }
      _save();
    });
  }
  }

  _deleteGoal(Goal goal) {
    setState(() {
      goal.delete();
      _save();
    });
  }

  _toggleComplete(Goal goal) {
    setState(() {
      goal.toggleComplete();
      _save();
    });
  }

  _openGoal(Goal goal) {
    setState(() {
      appState.openGoal(goal);
    });
  }

  _toggleExpandOnGoal(Goal goal) {
    setState(() {
      appState.toggleExpandOnGoal(goal);
    });
  }

  _navigateUp({int levels: 1}) {
    if (!appState.isAtRoot()) {
      setState(() {
        appState.navigateUp(levels: levels);
      });
    }
  }

  bool expandToggle = false;

  _save() {
    widget.appStateRepository.writeAppState(appState);
  }

  List<Goal> goalsToDisplay() {
    return appState.getGoalsToDisplay();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      child:
          FutureBuilder<AppState>(
          future: getAppState(),
            builder: (context, AsyncSnapshot<AppState> snapshot) {
              if (snapshot.hasData) {
                //this.appState = snapshot.data!;
                return getScaffold();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return CircularProgressIndicator(); // By default, show a loading spinner
              }
            }
        ),
    );
  }

  Scaffold getScaffold() {
    return Scaffold(
      appBar: buildAppBar(context, appState.getTitle(), appState.getCurrentGoal()),
      body: SlideableTasks(
          goalsToDisplay(),
          _deleteGoal,
          _openGoal,
          _toggleExpandOnGoal,
          _toggleComplete,
          _editGoal,
          moveGoal,
          context),
        bottomSheet: TMTBreadCrumbs(appState.getBreadCrumbs()),
        bottomNavigationBar: CustomBottomNavbar(
          addGoalHandler: _addGoal,
          navigateUpHandler: _navigateUp,
          saveHandler: _save,
          isAtRoot: appState.isAtRoot(),
        )
    );
  }

  AppBar buildAppBar(BuildContext context, String title, Goal currentGoal) {
    return AppBar(
        title: Text(title),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(130),
            child: AppBarDisplay(context: context, goal: currentGoal)
        )
    );
  }

  String getUserId() {
    // TODO implement from authentication
    return "demo";
  }
}

