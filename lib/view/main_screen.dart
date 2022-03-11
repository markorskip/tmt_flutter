import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/components/tabs/gf_tabbar.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:tmt_flutter/view/breadcrumbs.dart';
import 'package:tmt_flutter/view/dialog/edit_goal_dialog.dart';
import 'package:tmt_flutter/view/dialog/info_dialog.dart';
import 'package:tmt_flutter/view/dialog/move_goal_dialog.dart';

import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/goal_storage.dart';
import 'package:tmt_flutter/model/move_goal_directive.dart';
import '../model/edit_goal_directive.dart';
import 'dialog/new_goal_dialog.dart';
import 'app_bar_display.dart';
import 'slideable/slideable_task.dart';

class GoalScreen extends StatefulWidget {
  GoalScreen(this.readWriteAppState);

  final ReadWriteAppState readWriteAppState;

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {

  late AppState appState;

  Future<AppState> getAppState() async {
    return await widget.readWriteAppState.readAppState(getUserId());
  }

  @override
  void initState() {
    super.initState();
    widget.readWriteAppState.readAppState(getUserId()).then((value) => this.appState = value);
  }

  _addGoal() async {
    //TODO consider instead of a dialog it slide over to another page - gives user the full screen
    final goal = await showDialog<Goal>(
      context: context,
      builder: (BuildContext context) {
        return NewGoalDialog();
      },
    );

    if (goal != null) {
      setState(() {
        appState.getCurrentlyDisplayedGoals().add(goal);
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
    });
  }
  }

  _deleteGoal(Goal goal) {
    setState(() {
      goal.delete();
    });
  }

  _toggleComplete(Goal goal) {
    setState(() {
      goal.toggleComplete();
    });
  }

  _openGoal(Goal goal) {
    setState(() {
      appState.openGoal(goal);
    });
  }

  _navigateUp({int levels: 1}) {
    if (!appState.isAtRoot()) {
      setState(() {
        appState.navigateUp(levels: levels);
      });
    }
  }

  _save() {
    widget.readWriteAppState.writeAppState(appState);
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
      // TODO create an expanded view mode
      body: SlideableTask(
          goalsToDisplay(),
          //expandedView(),
          _deleteGoal,
          _openGoal,
          _toggleComplete,
          _editGoal,
          moveGoal,
          context),
        bottomSheet: TMTBreadCrumbs(appState.getBreadCrumbs()),
      bottomNavigationBar: getBottomNavigationBar(),
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
    return "liveDemo";
  }

  BottomAppBar getBottomNavigationBar() {
    var buttonColor = Colors.white;

    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,
      child: Row(
            children: [
              Spacer(),
              !appState.isAtRoot() ? GFButton(
                  onPressed: _navigateUp,
                  text: "Back",
                  icon: Icon(
                      Icons.arrow_back_ios,
                      color: appState.isAtRoot() ? Colors.grey : buttonColor
                  ),
                  type: GFButtonType.outline,
                  color:  appState.isAtRoot() ? Colors.grey : buttonColor,
              ): Container(height: 0, width: 0),
              !appState.isAtRoot() ? Spacer() : Container(height: 0, width: 0),
              GFButton(
                  onPressed: _addGoal,
                  text: "New Task",
                  icon: Icon(Icons.add, color: buttonColor),
                  type: GFButtonType.outline,
                  color: buttonColor,
              ),
              Spacer(),
              GFButton(
                  onPressed: _save,
                  text: "Save",
                  icon: Icon(Icons.save, color: buttonColor),
                  type: GFButtonType.outline,
                  color: buttonColor,
              ),
              Spacer(),
              GFButton(
                  onPressed: () => InfoDialog(),
                  text: "Info",
                  icon: Icon(Icons.info, color: buttonColor),
                  type: GFButtonType.outline,
                  color: buttonColor,
                  //shape: GFButtonShape.pills
              ),
              Spacer(),
              //IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
            ],
          )
    );
  }

  List<Goal> expandedView() {
    return appState.getExpandedView();
  }
}
