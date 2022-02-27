import 'package:tmt_flutter/model/move_goal_directive.dart';

import 'goal.dart';

class AppState {
  List<Goal> _goalStack = [];

  String userId;

  AppState(this.userId);

  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'goalStack' : _goalStack
  };

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    var userId = jsonMap['userId'];
    if (userId == null) userId = "demo";
    AppState appState = new AppState(userId);
    var list = jsonMap['goalStack'] as List;
    appState._goalStack = list.map((i) => Goal.fromJson(i)).toList();
    return appState;
  }

  static String getRootTitle() {
    return "Projects";
  }

  static Goal _getRootGoal() {
    Goal rootGoal = new Goal(getRootTitle(),"",0,0);
    return rootGoal;
  }

  static AppState defaultAppState() {
    AppState appState = new AppState("demo");
    appState._goalStack.add(_getRootGoal());
    appState._goalStack.first.addSubGoal(new Goal("Welcome to TMT","",0,0));
    return appState;
  }

  @override
  String toString() {
    return 'AppState{'
        '\ncurrentlyDisplayedGoals: $getCurrentlyDisplayedGoals(), '
        '\ntitle: $getTitle(), '
        '\ngoalStack: $_goalStack}';
  }

  Goal? getGrandParentGoal() {
    if (!isAtRoot()) {
      return _goalStack[_goalStack.length - 2];
    }
  }

  bool isAtRoot() {  // When we are at the root we want certain operations to not work such as moving a goal up.
    if (this._goalStack.length == 1) return true;
    return false;
  }

  void openGoal(Goal goal) {
    this._goalStack.add(goal);
  }

  void backUp() {
    if (!isAtRoot()) {
      this._goalStack.removeLast();
    }
  }

  void move(MoveGoal moveGoal) {
    if (moveGoal.getGoalToMoveTo() == null) {
      if (isAtRoot()) {
        throw Exception("Can't move up when at the root");
      }
      moveGoal.goalToMoveTo = getGrandParentGoal();
    }
    _moveGoal(moveGoal.getGoalToMove(), moveGoal.getGoalToMoveTo());
  }

  void _moveGoal(Goal goalToMove, Goal? goalToMoveTo) {
    if (goalToMove == goalToMoveTo) {
      throw Exception('Cant move a goal inside itself');
    }
    if (getCurrentlyDisplayedGoals().contains(goalToMove) && goalToMove != goalToMoveTo) {
      getCurrentlyDisplayedGoals().remove(goalToMove);
      goalToMoveTo!.addSubGoal(goalToMove);
    }
  }

  List<Goal> getCurrentlyDisplayedGoals() {  // includes deleted goals
    return _goalStack.last.getGoals();
  }

  List<Goal> getGoalsToDisplay() { // excludes deleted goals
    return getCurrentlyDisplayedGoals().where((element) => element.isDeleted == false).toList();
  }

  String getTitle() {
    if (_goalStack.isEmpty) {
      return "ROOT";
    }
    return this._goalStack.last.title;
  }

  Goal getCurrentGoal() {
    if (_goalStack.isEmpty) {
      return new Goal("ROOT","",0.0,0.0);
    }
    return this._goalStack.last;
  }

  bool isAppStateHealthy() {
    if (this._goalStack.length == 0) return false; // always need at least one goal, the root
    return true;
  }

  List<String> getBreadCrumbs() {
    return _goalStack.map((e) => e.title).toList();
  }

}
