// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/calc/goal_calculator.dart';

void main() {

  test('List should be modified by reference', () {
    List<Goal> list1 = [];
    list1.add(Goal("goal1",0,0));
    List<Goal> list2 = [];
    list2 = list1;
    list2.add(Goal("goal2",1,1));

    expect(list1.length,2);
  });

  getEmptyGoal () => new Goal("test",0,0);

  test('Should not throw infinity error', () {
    Goal goal = new Goal("test",0,0);
    goal.addSubGoal(getEmptyGoal());
    goal.addSubGoal(getEmptyGoal());
    expect(GoalCalc(goal).getCostPercentageComplete(),1.0);
  });

  test('Test encoding and decodings JSON', () {
    Goal goal = getEmptyGoal();
    goal.addSubGoal(getEmptyGoal());
    String jsonString = json.encode(goal);
    Map<String, dynamic> map = json.decode(jsonString);
    Goal result  = Goal.fromJson(map);
    expect(result.title, "title");
  });

  test('Test encoding and decodings JSON appState', () {
    AppState appState = AppState.defaultAppState();
    String appStateString = json.encode(appState);
    Map<String, dynamic> jsonDecoded = json.decode(appStateString);
    AppState newAppState = AppState.fromJson(jsonDecoded);
    expect(newAppState.getTitle(), AppState.getRootTitle());
  });

  test('Test calculations for multiple levels of goals', () {
    Goal parent = Goal.fromString("parent");
    Goal child1 = getEmptyGoal();
    Goal grandChildGoal = Goal("grandchild",50,110);
    Goal grandChildGoal2 = Goal("grandchild",50,110);
    grandChildGoal2.setComplete(true);
    child1.addSubGoal(grandChildGoal);
    child1.addSubGoal(grandChildGoal2);

    Goal child2 = getEmptyGoal();
    Goal grandChildGoal3 = Goal("grandchild",50,110);
    grandChildGoal3.setComplete(true);
    Goal grandChildGoal4 = Goal("grandchild",75,120);
    child1.addSubGoal(grandChildGoal3);
    child1.addSubGoal(grandChildGoal4);

    parent.addSubGoal(child1);
    parent.addSubGoal(child2);

    expect(GoalCalc(parent).getTimeTotal(),450);
    expect(GoalCalc(parent).getTimePercentageComplete(),.49);
    expect(GoalCalc(parent).getCostTotal(),225.0);
    expect(GoalCalc(parent).getCostPercentageComplete(),.44);

  });

  test('Test total tasks and total tasks complete is accurate', () {
    Goal parent = Goal.fromString("parent");
    Goal child1 = getEmptyGoal();
    Goal grandChildGoal = Goal("grandchild",50,110);
    Goal grandChildGoal2 = Goal("grandchild",50,110);
    grandChildGoal2.setComplete(true);
    child1.addSubGoal(grandChildGoal);
    child1.addSubGoal(grandChildGoal2);
    parent.addSubGoal(child1);
    expect(GoalCalc(parent).getTasksTotal(),2);
    expect(GoalCalc(parent).getTasksComplete(),1);
  });

}


