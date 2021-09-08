// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal_storage.dart';

import 'package:tmt_flutter/main.dart';
import 'package:tmt_flutter/model/goal.dart';
// @dart=2.9
void main() {

  test('List should be modified by reference', () {
    List<Goal> list1 = [];
    list1.add(new Goal("goal1","desc",0,0));
    List<Goal> list2 = [];
    list2 = list1;
    list2.add(new Goal("goal2","desc",1,1));
    print(list1);
    print(list2);

    expect(list1.length,2);
  });

  test('Should not throw infinity error', () {
    Goal goal = new Goal("test","",0,0);
    goal.addSubGoal(new Goal("test2","",0,0));
    goal.addSubGoal(new Goal("test3","",0,0));
    expect(goal.getPercentageCompleteCost(),0.0);
    expect(goal.getPercentageCompleteCost(),0.0);
  });

  test('Test serialization process for sub goal', () {
    Goal goal = new Goal("test","test",0,0);
    goal.isDeleted = true;
    Goal subGoal = new Goal("test","test1",0,0);
    subGoal.addSubGoal(new Goal("third deep","",0,0));
    goal.addSubGoal(subGoal);

    Map<String, dynamic> json = goal.toJson();
    Goal result = Goal.fromJson(json);
    expect(result.isDeleted,true);
    expect(result.goals.first.goals.length,1);
  });

  test('Test encoding and decodings JSON', () {
    Goal goal = new Goal("title","description",0,0);
    goal.goals.add(new Goal("test sub goal","test",0,0));
    String jsonString = json.encode(goal);
    print(jsonString);
    Map<String, dynamic> map = json.decode(jsonString);
    print(map);
    Goal result  = Goal.fromJson(map);
    expect(result.title, "title");
  });

  test('Test encoding and decodings JSON appState', () {
    AppState appState = new AppState();
    appState.title = "title";
    appState.titleStack = ["Test","Testing"];
    appState.goalsStack = [[new Goal("test goal stack","",0,0)]];
    appState.currentlyDisplayedGoals = [new Goal("Currently displayed goals","",0,0)];

    String appStateString = json.encode(appState);

    Map<String, dynamic> jsonDecoded = json.decode(appStateString);
    AppState newAppState = AppState.fromJson(jsonDecoded);
    expect(newAppState.title, "title");
  });

  test('Test calculations for multiple levels of goals', () {
    Goal parent = Goal.fromString("parent");
    Goal child1 = new Goal("child goal","",0,0);
    Goal grandChildGoal = new Goal("grandchild","",50,110);
    Goal grandChildGoal2 = new Goal("grandchild","",50,110);
    grandChildGoal2.complete = true;
    child1.addSubGoal(grandChildGoal);
    child1.addSubGoal(grandChildGoal2);

    Goal child2 = new Goal("child goal","",0,0);
    Goal grandChildGoal3 = new Goal("grandchild","",50,110);
    grandChildGoal3.complete = true;
    Goal grandChildGoal4 = new Goal("grandchild","",75,120);
    child1.addSubGoal(grandChildGoal3);
    child1.addSubGoal(grandChildGoal4);
    print(child1.getPercentageCompleteTime());

    parent.addSubGoal(child1);
    parent.addSubGoal(child2);

    print(parent.getEstimatedTime());
    print(parent.getEstimatedCost());
    print(parent.getPercentageCompleteTime());
    print(parent.getPercentageCompleteCost());

    expect(parent.getEstimatedTime(),450);
    expect(parent.getPercentageCompleteTime(),.49);
    expect(parent.getEstimatedCost(),225.0);
    expect(parent.getPercentageCompleteCost(),.44);

  });


}


