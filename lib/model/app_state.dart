import 'goal.dart';

class AppState {
  List<Goal> currentlyDisplayedGoals = [];
  String title = "";
  List<String> titleStack = [];
  List<List<Goal>> goalsStack = [[]];

  AppState();

  Map<String, dynamic> toJson() => {
    'title': title,
    'currentlyDisplayedGoals' : currentlyDisplayedGoals,
    'titleStack' : titleStack,
    'goalsStack' : goalsStack
  };

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    AppState appState = new AppState();
    appState.title = jsonMap["title"];
    var list = jsonMap['currentlyDisplayedGoals'] as List;
    appState.currentlyDisplayedGoals = list.map((i) => Goal.fromJson(i)).toList();

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
    appState.currentlyDisplayedGoals = [new Goal("Welcome to TMT","",0,0)];
    appState.titleStack = [];
    appState.goalsStack = [];
    return Future.value(appState);
  }

  @override
  String toString() {
    return 'AppState{\ncurrentlyDisplayedGoals: $currentlyDisplayedGoals, \ntitle: $title, \ntitleStack: $titleStack, \ngoalsStack: $goalsStack}';
  }

  void moveUp(Goal goal) {
    if (this.currentlyDisplayedGoals.contains(goal) && isAtRootGoal() == false) {
      this.goalsStack.last.add(goal);
      this.currentlyDisplayedGoals.remove(goal);
    }
  }

  isAtRootGoal() {  // When we are at the root we want certain operations to not work such as moving a goal up.
    if (this.goalsStack.length == 1) return true;
    return false;
  }

  void openGoal(Goal goal) {  // TODO create test
    this.titleStack.add(this.title);
    this.title = goal.title;
    this.goalsStack.add(this.currentlyDisplayedGoals);
    this.currentlyDisplayedGoals = goal.goals;
  }

  void backUp() {
    this.title = this.titleStack.last;
    this.currentlyDisplayedGoals = this.goalsStack.last;
    this.goalsStack.removeLast();
    this.titleStack.removeLast();
  }

}
