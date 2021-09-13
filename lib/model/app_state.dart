import 'goal.dart';

class AppState {
  List<Goal> _currentlyDisplayedGoals = [];
  String title = "";
  List<String> titleStack = [];
  List<List<Goal>> goalsStack = [[]];
  bool testMode = false;

  AppState();

  Map<String, dynamic> toJson() => {
    'title': title,
    'currentlyDisplayedGoals' : _currentlyDisplayedGoals,
    'titleStack' : titleStack,
    'goalsStack' : goalsStack
  };

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    AppState appState = new AppState();
    appState.title = jsonMap["title"];
    var list = jsonMap['currentlyDisplayedGoals'] as List;
    appState._currentlyDisplayedGoals = list.map((i) => Goal.fromJson(i)).toList();

    list = jsonMap['titleStack'] as List;
    appState.titleStack = list.map((e) => e as String).toList();

    list =  jsonMap['goalsStack'] as List;
    list.forEach((element) {
      List innerList = element as List;
      List<Goal> innerGoalList = innerList.map((e) => Goal.fromJson(e)).toList();
      appState.goalsStack.add(innerGoalList);
    });

    return appState;
  }

  static Future<AppState> defaultState() {
    AppState appState = new AppState();
    appState.title = "Learn Time Money TaskList";
    appState._currentlyDisplayedGoals = [new Goal("Welcome to TMT","",0,0)];
    appState.titleStack = [];
    appState.goalsStack = [];
    return Future.value(appState);
  }

  @override
  String toString() {
    return 'AppState{\ncurrentlyDisplayedGoals: $_currentlyDisplayedGoals, \ntitle: $title, \ntitleStack: $titleStack, \ngoalsStack: $goalsStack}';
  }

  void moveUp(Goal goal) {
    if (this._currentlyDisplayedGoals.contains(goal) && isAtRootGoal() == false) {
      goal.levelDeep -= 1;
      this.goalsStack.last.add(goal);
      this._currentlyDisplayedGoals.remove(goal);
    }
  }

  isAtRootGoal() {  // When we are at the root we want certain operations to not work such as moving a goal up.
    if (this.goalsStack.length == 1) return true;
    return false;
  }

  void openGoal(Goal goal) {  // TODO create test
    this.titleStack.add(this.title);
    this.title = goal.title;
    this.goalsStack.add(this._currentlyDisplayedGoals);
    this._currentlyDisplayedGoals = goal.goals;
  }

  void backUp() {
    this.title = this.titleStack.last;
    this._currentlyDisplayedGoals = this.goalsStack.last;
    this.goalsStack.removeLast();
    this.titleStack.removeLast();
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

}
