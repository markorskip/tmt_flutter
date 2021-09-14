import 'goal.dart';

class AppState {
  List<Goal> _currentlyDisplayedGoals = [];
  List<String> _titleStack = [];
  List<List<Goal>> _goalsStack = [[]];
  bool testMode = false;

  AppState();

  Map<String, dynamic> toJson() => {
    'currentlyDisplayedGoals' : _currentlyDisplayedGoals,
    'titleStack' : _titleStack,
    'goalsStack' : _goalsStack
  };

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    AppState appState = new AppState();
    var list = jsonMap['currentlyDisplayedGoals'] as List;
    appState._currentlyDisplayedGoals = list.map((i) => Goal.fromJson(i)).toList();

    list = jsonMap['titleStack'] as List;
    appState._titleStack = list.map((e) => e as String).toList();

    list =  jsonMap['goalsStack'] as List;
    list.forEach((element) {
      List innerList = element as List;
      List<Goal> innerGoalList = innerList.map((e) => Goal.fromJson(e)).toList();
      appState._goalsStack.add(innerGoalList);
    });

    return appState;
  }

  static AppState defaultAppState() {
    AppState appState = new AppState();
    appState._currentlyDisplayedGoals = [new Goal("Welcome to TMT","",0,0)];
    appState._titleStack = ["Learn Time Money TaskList"];
    appState._goalsStack = [];
    return appState;
  }

  @override
  String toString() {
    return 'AppState{\ncurrentlyDisplayedGoals: $_currentlyDisplayedGoals, \ntitle: $getTitle(), \ntitleStack: $_titleStack, \ngoalsStack: $_goalsStack}';
  }

  void moveUp(Goal goal) {
    if (this._currentlyDisplayedGoals.contains(goal) && isAtRootGoal() == false) {
      goal.levelDeep -= 1;
      this._goalsStack.last.add(goal);
      this._currentlyDisplayedGoals.remove(goal);
    }
  }

  isAtRootGoal() {  // When we are at the root we want certain operations to not work such as moving a goal up.
    if (this._goalsStack.length == 1) return true;
    return false;
  }

  void openGoal(Goal goal) {  // TODO create test
    this._titleStack.add(goal.title);
    this._goalsStack.add(this._currentlyDisplayedGoals);
    this._currentlyDisplayedGoals = goal.goals;
  }

  void backUp() {
    this._currentlyDisplayedGoals = this._goalsStack.last;
    this._goalsStack.removeLast();
    this._titleStack.removeLast();
  }

  void moveGoal(Goal goalToMove, Goal goalToMoveTo) {
    if (_currentlyDisplayedGoals.contains(goalToMove) && _currentlyDisplayedGoals.contains(goalToMoveTo) && goalToMove != goalToMoveTo) {
     _currentlyDisplayedGoals.remove(goalToMove);
     goalToMoveTo.addSubGoal(goalToMove);
    }
  }

  getCurrentlyDisplayedGoals() {
    return this._currentlyDisplayedGoals;
  }

  void setCurrentlyDisplayedGoals(List<Goal> list) {
    if (testMode) {
      this._currentlyDisplayedGoals = list;
    } else {
      throw new Exception('Not allowed to set the currently displayed goals outside of testing');
    }
  }

  getGoalsToDisplay() {
    return getCurrentlyDisplayedGoals().where((element) => element.isDeleted == false).toList();
  }

  String getTitle() {
    if (_titleStack.isEmpty) {
      return "TMT";
    }
    return this._titleStack.last;
  }

}
