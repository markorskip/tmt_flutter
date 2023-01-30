import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/model_helpers/move_goal_directive.dart';

void main() {

  _generateGoal(String title) {
    Goal goal = Goal(title, null);
    goal.addSubGoal(Goal.createEmptyGoal());
    goal.addSubGoal(Goal.createEmptyGoal());
    goal.addSubGoal(Goal.createEmptyGoal());
    return goal;
  }

  _createTestAppStateWith2RootGoalsWith3ChildrenEach() {
    AppState appState = AppState.defaultAppState();
    appState.getCurrentlyDisplayedGoalsIncludingDeleted().first.addSubGoal(_generateGoal("remodel home"));
    appState.getCurrentlyDisplayedGoalsIncludingDeleted().first.addSubGoal(_generateGoal("landscaping"));
    return appState;
  }

  test('test opening a goal changes state', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    int appStateLength = appState.getCurrentlyDisplayedGoalsIncludingDeleted().length;
    Goal goal = appState.getCurrentlyDisplayedGoalsIncludingDeleted().first; // Pick first goal to move up
    appState.openGoal(goal);
    expect(appState.getCurrentlyDisplayedGoalsIncludingDeleted().length,isNot(appStateLength));
  });

  test('isAtRoot works', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    expect(appState.isAtRoot(), true);
    expect(appState.getCurrentlyDisplayedGoalsIncludingDeleted().first.title,"Welcome to TMT");
    appState.openGoal(appState.getCurrentlyDisplayedGoalsIncludingDeleted().first);
    expect(appState.isAtRoot(), false);
  });

  test('Breadcrumbs', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    appState.openGoal(appState.getCurrentlyDisplayedGoalsIncludingDeleted().first);
    appState.openGoal(appState.getCurrentlyDisplayedGoalsIncludingDeleted().first);
    List<String> crumbs = appState.getBreadCrumbs();
    expect(crumbs, ['Projects', 'Welcome to TMT', 'remodel home']);
  });
}
