import 'dart:math';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'edit_goal_directive.dart';

class Goal {
  String title;
  String? description;
  double costInDollars = 0.0;
  double timeInHours = 0;
  bool complete = false;
  bool isDeleted = false;
  int levelDeep = 0;  // start at 0
  List<Goal> goals = []; // children
  late int id = getUniqueID();

  Goal(this.title, this.description, this.costInDollars, this.timeInHours) {
    this.levelDeep = 0;
    this.isDeleted = false;
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

  double getPercentageCompleteCost() {
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

    if (totalCost == 0) return 1.0;
    if (completedCost == 0) return 0.0;
    return roundDouble(completedCost/totalCost, 2);
  }

  double getPercentageCompleteTime() {
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

    if (totalTime == 0) return 1.0;
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

  void editGoal(EditGoal editedGoal) {
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

  String getPercentageCompleteTimeFormatted() {
    return (getPercentageCompleteTime() * 100).toString().split('.').first + "%";
  }

  String getPercentageCompleteCostFormatted() {
    return (getPercentageCompleteCost() * 100).toString().split('.').first + "%";
  }


  factory Goal.fromJson(Map<String, dynamic> jsonMap) {
    double costInDollars = jsonMap["costInDollars"];

    var timeInHours = jsonMap["timeInHours"];
    if (timeInHours.runtimeType == int) {
      timeInHours = timeInHours.toDouble();
    }
    Goal result = new Goal(jsonMap["title"], jsonMap["description"],costInDollars,timeInHours);
    result.id = jsonMap['id'];
    result.complete = jsonMap['complete'];
    result.isDeleted = jsonMap['isDeleted'];
    result.levelDeep = jsonMap['levelDeep'];
    var list = jsonMap['goals'] as List;
    result.goals = list.map((i) => Goal.fromJson(i)).toList();
    return result;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'costInDollars':costInDollars,
    'timeInHours':timeInHours,
    'complete':complete,
    'isDeleted':isDeleted,
    'levelDeep':levelDeep,
    'goals': goals
  };

  Function deepEq = const DeepCollectionEquality().equals;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Goal &&
          id == other.id &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          costInDollars == other.costInDollars &&
          timeInHours == other.timeInHours &&
          complete == other.complete &&
          isDeleted == other.isDeleted &&
          levelDeep == other.levelDeep &&
          deepEq(goals, other.goals);

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      costInDollars.hashCode ^
      timeInHours.hashCode ^
      complete.hashCode ^
      isDeleted.hashCode ^
      levelDeep.hashCode ^
      goals.hashCode;

  List<Goal> getGoals() {
    return this.goals;
  }

  void toggleComplete() {
    complete = !complete;
  }

  bool isCompletable() {
    return this.goals.where((goal) => goal.isDeleted == false).length < 1;
  }

  int getUniqueID() {
    return Random().nextInt(999999);
  }
}
