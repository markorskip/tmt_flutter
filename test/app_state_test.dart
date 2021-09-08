

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/goal_list/goal_screen.dart';
import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/goal_storage.dart';

void main() {

  _generateGoal(String title) {
    return new Goal(title, "",0,0);
  }

  _createTestAppState() {
    AppState appState = new AppState();
    appState.currentlyDisplayedGoals = [_generateGoal("Goal 1"), _generateGoal("Goal 2")];
    return appState;
  }

  test('moving a goal up', () {
    AppState appState = _createTestAppState();
    Goal goal = _generateGoal("Goal 1");
    int length = appState.currentlyDisplayedGoals.length;
    appState.moveUp(goal);

    expect(appState.currentlyDisplayedGoals.length, length - 1); // if goal is moved up, the current displayed goals has one less
  });

}
