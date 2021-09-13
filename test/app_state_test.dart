

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
    appState.testMode = true;
    appState.setCurrentlyDisplayedGoals([_generateGoal("remodel home"), _generateGoal("landscaping")]);
    return appState;
  }

  test('moving a goal up when at the root', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    Goal goal = appState.getCurrentlyDisplayedGoals().first; // Pick first goal to move up
    int length = appState.getCurrentlyDisplayedGoals().length;
    appState.moveUp(goal);
    expect(appState.isAtRootGoal(),true);
    expect(appState.getCurrentlyDisplayedGoals().length, length); // if we are in the root of the application, don't move up
  });

  test('moving a goal up when not at the root', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    int parentLength = appState.getCurrentlyDisplayedGoals().length;
    appState.openGoal(appState.getCurrentlyDisplayedGoals().first);
    Goal goalToMove = appState.getCurrentlyDisplayedGoals().first; // Pick a second level goal
    int length = appState.getCurrentlyDisplayedGoals().length;
    int depth = goalToMove.levelDeep;
    appState.moveUp(goalToMove);
    expect(appState.isAtRootGoal(),false);
    expect(appState.getCurrentlyDisplayedGoals().length, length-1); // if we are in the root of the application, don't move up
    appState.backUp();
    expect(appState.getCurrentlyDisplayedGoals().length, parentLength + 1);
    expect(goalToMove.levelDeep, depth - 1);
  });

  test('moving a goal down', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    int lengthBeforeMove = appState.getCurrentlyDisplayedGoals().length;

    Goal goalToMove = appState.getCurrentlyDisplayedGoals().first; // Pick first goal to move up
    int depth = goalToMove.levelDeep;
    Goal goalToMoveTo = appState.getCurrentlyDisplayedGoals().last;
    int numberOfChildrenBeforeMove = goalToMoveTo.goals.length;
    appState.moveGoal(goalToMove, goalToMoveTo);

    expect(appState.getCurrentlyDisplayedGoals().length, lengthBeforeMove - 1);
    expect(goalToMoveTo.goals.length, numberOfChildrenBeforeMove + 1);
    expect(goalToMove.levelDeep, depth + 1);
  });

  test('moving a goal down when there are no siblings', () {
    AppState appState = _createTestAppStateWith2RootGoalsWith3ChildrenEach();
    int lengthBeforeMove = appState.getCurrentlyDisplayedGoals().length;

    Goal goalToMove = appState.getCurrentlyDisplayedGoals().first; // Pick first goal to move up
    Goal goalToMoveTo = appState.getCurrentlyDisplayedGoals().first;
    print(goalToMove);
    int numberOfChildrenBeforeMove = goalToMoveTo.goals.length;
    appState.moveGoal(goalToMove, goalToMoveTo);
    print(appState);
    expect(appState.getCurrentlyDisplayedGoals().length, lengthBeforeMove);
    expect(goalToMoveTo.getGoals().length, numberOfChildrenBeforeMove);
  });

}
