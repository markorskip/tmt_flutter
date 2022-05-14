import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/model_helpers/move_goal_directive.dart';

void main() {

  _generateGoal(String title) {
    Goal goal = Goal(title, null);
    goal.addSubGoal(Goal.empty());
    goal.addSubGoal(Goal.empty());
    goal.addSubGoal(Goal.empty());
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

  test('moving a goal up when at the root', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    Goal goal = appState.getCurrentlyDisplayedGoalsIncludingDeleted().first; // Pick first goal to move up
    MoveGoal moveGoal = new MoveGoal(goal);
    expect(()=> appState.move(moveGoal), throwsA(isA<Exception>())); // if we are in the root of the application, don't move up
  });

  test('moving a goal up when not at the root', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    int parentLength = appState.getCurrentlyDisplayedGoalsIncludingDeleted().length;
    appState.openGoal(appState.getCurrentlyDisplayedGoalsIncludingDeleted().first);
    Goal goalToMove = appState.getCurrentlyDisplayedGoalsIncludingDeleted().first; // Pick a second level goal
    int length = appState.getCurrentlyDisplayedGoalsIncludingDeleted().length;
    int depth = goalToMove.getLevelDeep();
    MoveGoal moveGoal = new MoveGoal(goalToMove);
    appState.move(moveGoal);
    expect(appState.isAtRoot(),false);
    expect(appState.getCurrentlyDisplayedGoalsIncludingDeleted().length, length-1);
    appState.navigateUp();
    expect(appState.getCurrentlyDisplayedGoalsIncludingDeleted().length, parentLength + 1);
    expect(goalToMove.getLevelDeep(), depth - 1);
  });

  test('moving a goal down', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    appState.openGoal(appState.getCurrentlyDisplayedGoalsIncludingDeleted().first);
    int lengthBeforeMove = appState.getCurrentlyDisplayedGoalsIncludingDeleted().length;

    Goal goalToMove = appState.getCurrentlyDisplayedGoalsIncludingDeleted().first; // Pick first goal to move up
    int depth = goalToMove.getLevelDeep();
    Goal goalToMoveTo = appState.getCurrentlyDisplayedGoalsIncludingDeleted().last;
    int numberOfChildrenBeforeMove = goalToMoveTo.goals.length;

    MoveGoal moveGoal = new MoveGoal(goalToMove);
    moveGoal.setGoalToMoveTo(goalToMoveTo);
    appState.move(moveGoal);
    expect(appState.getCurrentlyDisplayedGoalsIncludingDeleted().length, lengthBeforeMove - 1);
    expect(goalToMoveTo.goals.length, numberOfChildrenBeforeMove + 1);
    expect(goalToMove.getLevelDeep(), depth + 1);
  });

  test('moving a goal down when there are no siblings', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();

    Goal goalToMove = appState.getCurrentlyDisplayedGoalsIncludingDeleted().first; // Pick first goal to move up
    Goal goalToMoveTo = appState.getCurrentlyDisplayedGoalsIncludingDeleted().first;  // Pick the same goal - not allowed

    MoveGoal moveGoal = new MoveGoal(goalToMove);
    moveGoal.setGoalToMoveTo(goalToMoveTo);
    expect(()=> appState.move(moveGoal), throwsA(isA<Exception>()));
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

  test('populateParents', () {
    Goal parent = Goal.empty();
    Goal child = Goal.empty();
    parent.goals.add(child);
    AppState appState = AppState.withGoal("demo", [parent]);
    Goal result = appState.getCurrentGoal().getActiveGoals()[0];
    expect(result.getParent(), null);
    appState.populateParents();
    expect(result.getParent(), parent);
  });
}
