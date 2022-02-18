import 'dart:math';

import 'package:collection/collection.dart';
import 'edit_goal_directive.dart';

class Goal {
  String title;
  String description;
  double costInDollars;
  double timeInHours;
  bool _complete = false;
  bool isDeleted = false;
  int levelDeep = 0;  // start at 0 // TODO Can this be calculated instead of stored?
  List<Goal> goals = []; // children
  late int id = getUniqueID();

  Goal(this.title, this.description, this.costInDollars, this.timeInHours) {
    this.levelDeep = 0;
    this.isDeleted = false;
  }

  factory Goal.fromString(String title) {
    return new Goal(title, "",0,0);
  }

  bool isLeaf() {
    if (getActiveGoals().length == 0) return true;
    return false;
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

}
