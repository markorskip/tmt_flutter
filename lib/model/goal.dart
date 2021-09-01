import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class Goal {
  String title;
  String? description;
  double costInDollars = 0.0;
  int timeInHours = 0;
  bool complete = false;
  bool isDeleted = false;
  int levelDeep = 0;  // start at 0
  List<Goal> goals = [];

  Goal(this.title, this.description, this.costInDollars, this.timeInHours) {
    this.levelDeep = 0;
    this.isDeleted = false;
    this.complete = false;
  }

  factory Goal.fromString(String title) {
    return new Goal(title, "",0,0);
  }

  getEstimatedTime() {
    if (getActiveGoals().length == 0) return timeInHours;
    num sum = 0;
    getActiveGoals().forEach((element) {sum += element.getEstimatedTime(); });
    return sum;
  }

  getEstimatedCost() {
    if (getActiveGoals().length == 0) return costInDollars;
    num sum = 0;
    getActiveGoals().forEach((element) {sum += element.getEstimatedCost(); });
    return sum;
  }

  getPercentageCompleteCost() {
    if (getActiveGoals().length == 0 && !complete) return 0.0;
    if (getActiveGoals().length == 0 && complete) return 1.0;
    num totalCost = 0;
    num completedCost = 0;
    getActiveGoals().forEach((element) {totalCost += element.getEstimatedCost(); });
    getActiveGoals()
        .where((element) => element.complete == false)
        .forEach((element) {
      completedCost += element.getEstimatedCost() * element.getPercentageCompleteCost();
    });
    getActiveGoals().where((element) => element.complete == true).forEach((element) {completedCost += element.getEstimatedCost(); });

    if (completedCost == 0) return 0.0;
    return roundDouble(completedCost/totalCost, 2);
  }

  getPercentageCompleteTime() {
    if (getActiveGoals().length == 0 && !complete) return 0.0;
    if (getActiveGoals().length == 0 && complete) return 1.0;
    num totalTime = 0;
    num completedTime = 0;
    getActiveGoals().forEach((element) {totalTime += element.getEstimatedTime(); });
    getActiveGoals()
        .where((element) => element.complete == false)
        .forEach((element) {
          completedTime += element.getEstimatedTime() * element.getPercentageCompleteTime();
        });
    getActiveGoals().where((element) => element.complete == true).forEach((element) {completedTime += element.getEstimatedTime(); });


    if (completedTime == 0) return 0.0;
    return roundDouble(completedTime/totalTime, 2);
  }

  double roundDouble(double value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String getSubTitle() {
    return "Time: " +  getEstimatedTime().toString() + " hrs \nCost: \$" + getEstimatedCost().toString();
  }

  RichText getSubTitleRichText() {
    return new RichText(
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          new TextSpan(text: "Time: " +  getEstimatedTime().toString() + " hours \n", style: new TextStyle(color: Colors.blue)),
          new TextSpan(text: "Cost: \$" +  getEstimatedCost().toString().split('.').first, style: new TextStyle(color: Colors.green)),
        ],
      ),
    );
  }

  delete() {
    this.isDeleted = true;
  }

  restore() {
    this.isDeleted = false;
  }

  addSubGoal(Goal goal) {
    goal.levelDeep = this.levelDeep + 1;
    this.goals.add(goal);
  }

  void update(Goal editedGoal) {
    this.title = editedGoal.title;
    this.description = editedGoal.description;
    this.timeInHours = editedGoal.timeInHours;
    this.costInDollars = editedGoal.costInDollars;
    this.complete = editedGoal.complete;

  }

  getActiveGoals() {
    return goals.where((element) => element.isDeleted == false).toList();
  }

  @override
  String toString() {
    return 'Goal{title: $title, description: $description, costInDollars: $costInDollars, timeInHours: $timeInHours, complete: $complete, isDeleted: $isDeleted, levelDeep: $levelDeep, goals: $goals}';
  }

  // TODO separate UI logic from calculation/model logic

  String getPercentageCompleteTimeFormatted() {
    return (getPercentageCompleteTime() * 100).toString().split('.').first + "%";
  }

  String getPercentageCompleteCostFormatted() {
    return (getPercentageCompleteCost() * 100).toString().split('.').first + "%";
  }


  factory Goal.fromJson(Map<String, dynamic> jsonMap) {
    Goal result = new Goal(jsonMap["title"], jsonMap["description"],jsonMap["costInDollars"],jsonMap["timeInHours"]);
    result.complete = jsonMap['complete'];
    result.isDeleted = jsonMap['isDeleted'];
    result.levelDeep = jsonMap['levelDeep'];
    var list = jsonMap['goals'] as List;
    result.goals = list.map((i) => Goal.fromJson(i)).toList();
    return result;
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'costInDollars':costInDollars,
    'timeInHours':timeInHours,
    'complete':complete,
    'isDeleted':isDeleted,
    'levelDeep':levelDeep,
    'goals': goals
  };
}
