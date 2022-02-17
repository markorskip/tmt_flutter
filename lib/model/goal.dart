import 'dart:math';
import 'package:collection/collection.dart';
import 'display_util.dart';
import 'edit_goal_directive.dart';

class Goal {
  String title;
  String description;
  double costInDollars;
  double timeInHours;
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

  String getTotalTimeFormatted() {
    return getTimeTotal().toString().split(".")[0];
  }

  String getTotalCostFormatted() {
    return getTotalCost().toString().split(".")[0];
  }
  
  num getTimeTotal() {
    if (getActiveGoals().length == 0) return timeInHours;
    num sum = 0;
    getActiveGoals().forEach((element) {sum += element.getTimeTotal(); });
    return sum;
  }

  num getTotalCost() {
    if (getActiveGoals().length == 0) return costInDollars;
    num sum = 0;
    getActiveGoals().forEach((element) {sum += element.getTotalCost(); });
    return sum;
  }

  num getCompletedCostPercentage() {
    num completedCost = 0;
    getActiveGoals()
        .where((element) => element.complete == false)
        .forEach((element) {
      completedCost += element.getTotalCost() * element.getPercentageCompleteCost();
    });
    getActiveGoals().where((element) => element.complete == true).forEach((element) {completedCost += element.getTotalCost(); });
    return completedCost;
  }

  num getCompletedCostDollars() {
    if (isLeaf() && complete) return costInDollars;
    double completedDollars = 0;
    getActiveGoals().forEach((goal) {
      completedDollars += goal.getCompletedCostDollars();
    });
    return completedDollars;
  }

  double getPercentageCompleteCost() {
    if (getActiveGoals().length == 0 && !complete) return 0.0;
    if (getActiveGoals().length == 0 && complete) return 1.0;
    num totalCost = getTotalCost();
    num completedCost = getCompletedCostPercentage();
    if (totalCost == 0) return 1.0;
    if (completedCost == 0) return 0.0;
    return roundDouble(completedCost/totalCost, 2);
  }

  double getTimeCompletedPercentage() {
    double completedTime = 0.0;
    getActiveGoals()  // TODO refactor with reducer pattern
        .where((element) => element.complete == false)
        .forEach((element) {
      completedTime += element.getTimeTotal() * element.getPercentageCompleteTime();
    });
    getActiveGoals().where((element) => element.complete == true).forEach((element) {completedTime += element.getTimeTotal(); });

    return completedTime;
  }

  bool isLeaf() {
    if (getActiveGoals().length == 0) {
      return true;
    }
    return false;
  }

  double getTimeCompletedHrs() {
    if (isLeaf() && complete) return timeInHours;
    double completedHrs = 0;
    getActiveGoals().forEach((goal) {
      completedHrs += goal.getTimeCompletedHrs();
    });
    return completedHrs;
  }

  double getPercentageCompleteTime() {
    if (getActiveGoals().length == 0 && !complete) return 0.0;
    if (getActiveGoals().length == 0 && complete) return 1.0;
    num totalTime = getTimeTotal();
    num completedTime = getTimeCompletedPercentage();

    if (totalTime == 0) {
      num tasksCompleted = 0;
      num totalTasks = getActiveGoals().length;
      getActiveGoals().forEach((goal) {  // TODO refactor with reduce / accumulator pattern
        if (goal.complete) tasksCompleted++;
      });
      if (tasksCompleted == 0) return 0.0;
      if (tasksCompleted == totalTasks) return 1.0;
      return roundDouble(tasksCompleted/totalTasks, 2);
    }
    if (completedTime == 0) return 0.0;
    return roundDouble(completedTime/totalTime, 2);
  }

  double roundDouble(double value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String getSubTitle() {
    return "Time: " +  getTimeTotal().toString() + " hrs \nCost: \$" + getTotalCost().toString();
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

  List<Goal> getActiveGoals() {
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

  String getCompletedTimeFormatted() {
    return getTimeCompletedPercentage().toString();
  }

  String getCompletedCostFormatted() {
    return getCompletedCostPercentage().toString();
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
  
  int getTotalLeafCount() {
    if (isLeaf()) return 1;
    int result = 0;
    getActiveGoals().forEach((goal) {
      result += goal.getTotalLeafCount();
    });
    return result;
  }


  int getTasksCompleteRecursive() {
    if (isLeaf()) {
      if (isComplete()) return 1;
      return 0;
    }
    int result = 0;
    getActiveGoals().forEach((goal) {
      result += goal.getTasksCompleteRecursive();
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
    int totalTasks = getTasksTotalCount();
    getActiveGoals().forEach((goal) {
      result += goal.getTasksCompleteRecursive();
    });

    return result;
  }


  double getPercentageCompleteTasks() {
    return getTasksComplete() / getTasksTotalCount();
  }

  String getTimeCompletedProgressText() {
    int hoursCompleted = getTimeCompletedHrs().round();
    int hoursTotal = getTimeTotal().round();
    String result =hoursCompleted.toString() + " / " + hoursTotal.toString() + " hours";
    if (result == "0 / 0 hours") return "";
    return result;
  }

  String getMoneyCompletedProgressText() {
    int dollarsSpent = getCompletedCostDollars().round();
    int totalDollars = getTotalCost().round();
    String text = DisplayUtil.dollarsFormatter(dollarsSpent) + " / " + DisplayUtil.dollarsFormatter(totalDollars);
    if (text == "\$0 / \$0") { text = ""; }
    return text;
  }

  String getTasksCompletedProgressText() {
    int numOfTasksComplete = getTasksComplete();
    int tasksTotal = getTasksTotalCount();
    return numOfTasksComplete.toString() + " / " + tasksTotal.toString() + " tasks";
  }

  void setComplete(bool bool) {
    this.complete = bool;
  }

  bool isComplete() {
    if (isLeaf()) return complete;
    int numberOfActiveGoals = getActiveGoals().length;

    int numberCompleted = 0;
    getActiveGoals().forEach((g) {
      if (g.isComplete()) numberCompleted++;
    });
    if (numberCompleted == numberOfActiveGoals) return true;
    return false;
  }
}
