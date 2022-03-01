import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/components/tabs/gf_tabbar.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:tmt_flutter/view/dialog/edit_goal_dialog.dart';
import 'package:tmt_flutter/view/dialog/move_goal_dialog.dart';

import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/goal_storage.dart';
import 'package:tmt_flutter/model/move_goal_directive.dart';
import '../model/edit_goal_directive.dart';
import 'dialog/new_goal_dialog.dart';
import 'app_bar_display.dart';
import 'slideable.dart';

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
      goal.editGoal(editedGoal);
    }
    setState(() {}); // Update changes on screen=
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

  _navigateUp() {
    if (!appState.isAtRoot()) {
      setState(() {
        appState.navigateUp();
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
      appBar: buildAppBar(),
      body: GoalSlideable(
          goalsToDisplay(), _deleteGoal, _openGoal, _toggleComplete, _editGoal,
          moveGoal),
        bottomSheet: getBreadCrumbs(),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  AppBar buildAppBar() {
    Goal currentGoal = appState.getCurrentGoal();
    return AppBar(
        title: Text(appState.getTitle()),
        bottom: PreferredSize(
            preferredSize: currentGoal.isCompletable() ? Size.fromHeight(70) : Size.fromHeight(130),
            child: AppBarDisplay(context: context, goal: appState.getCurrentGoal())
        )
    );
  }

  Widget getBreadCrumbs() {
    List<String> breadCrumbs = appState.getBreadCrumbs();
    if (breadCrumbs.length > 1) {
      if (breadCrumbs.length > 3) breadCrumbs = breadCrumbs.sublist(breadCrumbs.length - 3, breadCrumbs.length);
      List<BreadCrumbItem> items = breadCrumbs.map(
              (e) => BreadCrumbItem(
                    content: Text(e),
                    //onTap: _navigateUp() // TODO implement link back
      )).toList();
      return BreadCrumb(
        items: items,
        divider: Icon(Icons.chevron_right),
        overflow: WrapOverflow(
          keepLastDivider: false,
          direction: Axis.horizontal,
        ),
      );
    }
    return Container(width: 0.0, height: 0.0);
  }

  String getUserId() {
    // TODO implement from authentication
    return "demo";
  }

  BottomAppBar getBottomNavigationBar() {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.primary,

      child: Row(
        children: [
          Spacer(),
          GFButton(
            onPressed: _navigateUp,
            text: "Navigate Up",
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white
            ),
            type: GFButtonType.outline,
            color: Colors.white
          ),
          Spacer(),
          GFButton(
            onPressed: _addGoal,
            text: "Create New Task",
            icon: Icon(Icons.add, color: Colors.white),
            type: GFButtonType.outline,
              color: Colors.white
          ),
          Spacer(),
          GFButton(
            onPressed: _save,
            text: "Save",
            icon: Icon(Icons.save, color: Colors.white),
            type: GFButtonType.outline,
              color: Colors.white
          ),
          Spacer(),
          //IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
    );
  }

  Widget showBackButton() {
    if (!appState.isAtRoot()) {
      return IconButton(
          icon: Icon(Icons.arrow_upward),
          onPressed: _navigateUp,
          );
    }
    return IconButton(icon: Icon(Icons.info), color: Colors.white, onPressed: _basicEasyDialog);
  }

  // Easy Dialog using title and description
  void _basicEasyDialog() {
    EasyDialog(
        title: Text(
          "Time Money Tasklist",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        description: Text(
          "1. Create goals and subgoals \n2. Save to not lose work",
          textScaleFactor: 1.1,
          textAlign: TextAlign.center,
        )).show(context);
  }

}
