// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tmt_flutter/main.dart';
import 'package:tmt_flutter/goal.dart';
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
    //expect(result.title, "title");
  });


}


