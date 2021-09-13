

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/goal_list/goal_screen.dart';
import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/goal_storage.dart';

void main() {

  _generateGoal(String title) {
    Goal goal = new Goal(title, "",0,0);
    goal.addSubGoal(new Goal("child 1 of $title","",0,0));
    goal.addSubGoal(new Goal("child 2 of $title","",0,0));
    goal.addSubGoal(new Goal("child 3 of $title","",0,0));
    return goal;
  }

  _createTestAppStateWith2RootGoalsWith3ChildrenEach() {
    AppState appState = new AppState();
    appState.currentlyDisplayedGoals = [_generateGoal("remodel home"), _generateGoal("landscaping")];
    return appState;
  }

  test('moving a goal up when at the root', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    Goal goal = appState.currentlyDisplayedGoals.first; // Pick first goal to move up
    int length = appState.currentlyDisplayedGoals.length;
    appState.moveUp(goal);
    expect(appState.isAtRootGoal(),true);
    expect(appState.currentlyDisplayedGoals.length, length); // if we are in the root of the application, don't move up
  });

  test('moving a goal up when not at the root', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    int parentLength = appState.currentlyDisplayedGoals.length;
    appState.openGoal(appState.currentlyDisplayedGoals.first);
    Goal goal = appState.currentlyDisplayedGoals.first; // Pick a second level goal
    int length = appState.currentlyDisplayedGoals.length;
    appState.moveUp(goal);
    expect(appState.isAtRootGoal(),false);
    expect(appState.currentlyDisplayedGoals.length, length-1); // if we are in the root of the application, don't move up
    appState.backUp();
    expect(appState.currentlyDisplayedGoals.length, parentLength + 1);
  });

  test('moving a goal down', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    int lengthBeforeMove = appState.currentlyDisplayedGoals.length;

    Goal goalToMove = appState.currentlyDisplayedGoals.first; // Pick first goal to move up
    Goal goalToMoveTo = appState.currentlyDisplayedGoals.last;
    int numberOfChildrenBeforeMove = goalToMoveTo.goals.length;
    appState.moveGoal(goalToMove, goalToMoveTo);

    expect(appState.currentlyDisplayedGoals.length, lengthBeforeMove - 1);
    expect(goalToMoveTo.goals.length, numberOfChildrenBeforeMove + 1);
  });

  test('moving a goal down when there are no siblings', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    int lengthBeforeMove = appState.currentlyDisplayedGoals.length;

    Goal goalToMove = appState.currentlyDisplayedGoals.first; // Pick first goal to move up
    Goal goalToMoveTo = appState.currentlyDisplayedGoals.first;
    print(goalToMove);
    int numberOfChildrenBeforeMove = goalToMoveTo.goals.length;
    appState.moveGoal(goalToMove, goalToMoveTo);
    print(appState);
    expect(appState.currentlyDisplayedGoals.length, lengthBeforeMove);
    expect(goalToMoveTo.goals.length, numberOfChildrenBeforeMove);
  });

}
