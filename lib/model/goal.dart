import 'dart:math';

import 'package:collection/collection.dart';
import 'package:tmt_flutter/util/formatter.dart';
import 'edit_goal_directive.dart';

class Goal {
  String title;
  String description;
  double costInDollars;
  double timeInHours;
  bool _complete = false;
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

  num getTimeTotal() {
    if (getActiveGoals().length == 0) return timeInHours;
    num sum = 0;
    getActiveGoals().forEach((element) {sum += element.getTimeTotal(); });
    return sum;
  }

  num getCostTotal() {
    if (isLeaf()) return costInDollars;
    num sum = 0;
    getActiveGoals().forEach((element) {sum += element.getCostTotal(); });
    return sum;
  }

  double getCostPercentageComplete() {
    if (getCostTotal() == 0) return 1.0;
    double result = getCostCompletedDollars() / getCostTotal();
    return Formatter.roundDouble(result,2);
  }

  num getCostCompletedDollars() {
    if (isLeaf() && isComplete()) return costInDollars;

    double completedDollars = 0;
    getActiveGoals().forEach((goal) {
      completedDollars += goal.getCostCompletedDollars();
    });
    return completedDollars;
  }

  double getTimePercentageComplete() {
    if (getTimeTotal() == 0) {
      return getTasksComplete() / getTasksTotalCount();
    }
    return Formatter.roundDouble((getTimeCompletedHrs() / getTimeTotal()),2);
  }

  bool isLeaf() {
    if (getActiveGoals().length == 0) return true;
    return false;
  }

  double getTimeCompletedHrs() {
    if (isLeaf() && _complete) return timeInHours;
    double completedHrs = 0;
    getActiveGoals().forEach((goal) {
      completedHrs += goal.getTimeCompletedHrs();
    });
    return completedHrs;
  }

  delete() {
    this.isDeleted = true;
  }

  restore() {
    this.isDeleted = false;
  }

  addSubGoal(Goal goal) { //TODO can this be calculated?
    goal.levelDeep = this.levelDeep + 1;
    this.goals.add(goal);
  }

  void editGoal(EditGoal editedGoal) { // TODO can this be done with a Partial?
    this.title = editedGoal.title;
    this.description = editedGoal.description;
    this.timeInHours = editedGoal.timeInHours;
    this.costInDollars = editedGoal.costInDollars;
    this._complete = editedGoal.complete;
  }

  List<Goal> getActiveGoals() {
    return goals.where((element) => element.isDeleted == false).toList();
  }

  @override
  String toString() {
    return 'Goal{title: $title, description: $description, costInDollars: $costInDollars, timeInHours: $timeInHours, complete: $_complete, isDeleted: $isDeleted, levelDeep: $levelDeep, goals: $goals}';
  }

  factory Goal.fromJson(Map<String, dynamic> jsonMap) {
    double costInDollars = jsonMap["costInDollars"];

    var timeInHours = jsonMap["timeInHours"];
    if (timeInHours.runtimeType == int) {
      timeInHours = timeInHours.toDouble();
    }
    Goal result = new Goal(jsonMap["title"], jsonMap["description"],costInDollars,timeInHours);
    result.id = jsonMap['id'];
    result._complete = jsonMap['complete'];
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
    'complete':_complete,
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
          _complete == other._complete &&
          isDeleted == other.isDeleted &&
          levelDeep == other.levelDeep &&
          deepEq(goals, other.goals);

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      costInDollars.hashCode ^
      timeInHours.hashCode ^
      _complete.hashCode ^
      isDeleted.hashCode ^
      levelDeep.hashCode ^
      goals.hashCode;

  List<Goal> getGoals() {
    return this.goals;
  }

  void toggleComplete() {
    _complete = !_complete;
  }

  bool isCompletable() {
    return this.goals.where((goal) => goal.isDeleted == false).length < 1;
  }

  int getUniqueID() {
    return Random().nextInt(999999);
  }

  int _getTasksCompleteRecursive() {
    if (isLeaf()) {
      if (isComplete()) return 1;
      return 0;
    }
    int result = 0;
    getActiveGoals().forEach((goal) {
      result += goal._getTasksCompleteRecursive();
    });
    if (isComplete()) result += 1;
    return result;
  }

  int getTasksComplete() {
    if (isLeaf()) {
      if (isComplete()) return 1;
      return 0;
    }
    int result = 0;
    getActiveGoals().forEach((goal) {
      result += goal._getTasksCompleteRecursive();
    });
    return result;
  }

  int getTasksTotalCount() {
    if (isLeaf()) return 0;
    int result = 0;
    getActiveGoals().forEach((g) {
      result += g.getTasksTotalCount();
    });
    result += getActiveGoals().length;
    return result;
  }

  double getPercentageCompleteTasks() {
    return getTasksComplete() / getTasksTotalCount();
  }

  void setComplete(bool bool) {
    this._complete = bool;
  }

  bool isComplete() {
    if (isLeaf()) return _complete;
    int numberOfActiveGoals = getActiveGoals().length;

    int numberCompleted = 0;
    getActiveGoals().forEach((g) {
      if (g.isComplete()) numberCompleted++;
    });
    if (numberCompleted == numberOfActiveGoals) return true;
    return false;
  }

  double getPercentageCompleteLeafs() {
    if (isLeaf()) {
      if (isComplete()) return 1.0;
      return 0.0;
    }
    return getLeafsComplete()/getLeafTotalCount();
  }

  int getLeafTotalCount() {
    if (isLeaf()) return 1;
    int result = 0;
    getActiveGoals().forEach((goal) {
      result += goal.getLeafTotalCount();
    });
    return result;
  }

  int getLeafsComplete() {
    if (isLeaf() && isComplete()) return 1;
    int result = 0;
    getActiveGoals().forEach((goal) {
      result += goal.getLeafsComplete();
    });
    return result;
  }


}
