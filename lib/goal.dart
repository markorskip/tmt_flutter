import 'dart:math';

import 'package:flutter/material.dart';

class Goal {
  String title;
  String description;
  double costInDollars;
  int timeInHours;
  bool complete;
  bool isDeleted;
  int levelDeep = 0;  // start at 0

  List<Goal> goals = [];

  Goal(this.title, this.description, this.costInDollars, this.timeInHours) {
    this.levelDeep = 0;
    this.isDeleted = false;
    this.complete = false;
  }

  getEstimatedTime() {
    if (goals.length == 0) return timeInHours;
    num sum = 0;
    goals.forEach((element) {sum += element.getEstimatedTime(); });
    return sum;
  }

  getEstimatedCost() {
    if (goals.length == 0) return costInDollars;
    num sum = 0;
    goals.forEach((element) {sum += element.getEstimatedCost(); });
    return sum;
  }

  getPercentageCompleteCost() {
    if (goals.length == 0 && !complete) return 0.0;
    if (goals.length == 0 && complete) return 1.0;
    num totalCost = 0;
    num completedCost = 0;
    goals.forEach((element) {totalCost += element.getEstimatedCost(); });
    goals.where((element) => element.complete == true).forEach((element) {completedCost += element.getEstimatedCost(); });
    return roundDouble(completedCost/totalCost, 2);
  }

  getPercentageCompleteTime() {
    if (goals.length == 0 && !complete) return 0.0;
    if (goals.length == 0 && complete) return 1.0;
    num totalTime = 0;
    num completedTime = 0;
    goals.forEach((element) {totalTime += element.getEstimatedTime(); });
    goals.where((element) => element.complete == true).forEach((element) {completedTime += element.getEstimatedTime(); });
    return roundDouble(completedTime/totalTime, 2);
  }

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String getSubTitle() {
    return "Time: " +  getEstimatedTime().toString() + " hrs. Cost: \$" + getEstimatedCost().toString()
    + "\n # of Subtasks: " + this.goals.length.toString();
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

  @override
  String toString() {
    return 'Goal{title: $title, description: $description, costInDollars: $costInDollars, timeInHours: $timeInHours, complete: $complete, isDeleted: $isDeleted, levelDeep: $levelDeep, goals: $goals}';
  }
}
