import 'goal.dart';

class AppState {
  List<Goal> _goalStack = [];
  AppState();

  Map<String, dynamic> toJson() => {
    'goalStack' : _goalStack
  };

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    AppState appState = new AppState();
    var list = jsonMap['goalStack'] as List;
    appState._goalStack = list.map((i) => Goal.fromJson(i)).toList();
    return appState;
  }

  static String getRootTitle() {
    return "TMT";
  }

  static Goal _getRootGoal() {
    Goal rootGoal = new Goal(getRootTitle(),"root never should be displayed",0,0);
    rootGoal.complete = false;
    return rootGoal;
  }
  static AppState defaultAppState() {
    AppState appState = new AppState();
    appState._goalStack.add(_getRootGoal());
    appState._goalStack.first.addSubGoal(new Goal("Welcome to TMT","",0,0));
    return appState;
  }

  @override
  String toString() {
    return 'AppState{\ncurrentlyDisplayedGoals: $getCurrentlyDisplayedGoals(), \ntitle: $getTitle(), \ngoalStack: $_goalStack}';
  }

  void moveUp(Goal goal) {
    if (this.getCurrentlyDisplayedGoals().contains(goal) && isAtRoot() == false) {
      goal.levelDeep -= 1;
      _getGrandParentGoal().addSubGoal(goal);
      this.getCurrentlyDisplayedGoals().remove(goal);
    }
  }
  Goal _getGrandParentGoal() {
    return _goalStack[_goalStack.length-2];
  }

  isAtRoot() {  // When we are at the root we want certain operations to not work such as moving a goal up.
    if (this._goalStack.length == 1) return true;
    return false;
  }

  void openGoal(Goal goal) {  // TODO create test
    this._goalStack.add(goal);
  }

  void backUp() {
    if (!isAtRoot()) {
      this._goalStack.removeLast();
    }
  }

  void moveGoal(Goal goalToMove, Goal goalToMoveTo) {
    if (goalToMove == goalToMoveTo) {
      throw Exception('Cant move a goal inside itself');
    }
    if (getCurrentlyDisplayedGoals().contains(goalToMove) && getCurrentlyDisplayedGoals().contains(goalToMoveTo) && goalToMove != goalToMoveTo) {
      getCurrentlyDisplayedGoals().remove(goalToMove);
      goalToMoveTo.addSubGoal(goalToMove);
    }
  }

  List<Goal> getCurrentlyDisplayedGoals() {  // includes deleted goals
    return _goalStack.last.getGoals();
  }

  getGoalsToDisplay() { // excludes deleted goals
    return getCurrentlyDisplayedGoals().where((element) => element.isDeleted == false).toList();
  }

  String getTitle() {
    if (_goalStack.isEmpty) {
      return "ROOT";
    }
    return this._goalStack.last.title;
  }

}
