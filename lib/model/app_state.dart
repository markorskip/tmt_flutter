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
    return 'AppState{currentlyDisplayedGoals: $currentlyDisplayedGoals, title: $title, titleStack: $titleStack, goalsStack: $goalsStack}';
  }

  void moveUp(Goal goal) {
    if (this.currentlyDisplayedGoals.contains(goal)) {
      this.goalsStack.last.add(goal);
      this.currentlyDisplayedGoals.remove(goal);
    }
  }


}
