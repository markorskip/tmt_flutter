import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../model/goal.dart';

abstract class GC {

  double getTimeComplete();
  double getTimeTotal();
  double getTimePercentageComplete();

  double getCostComplete();
  double getCostTotal();
  double getCostPercentageComplete();

  double getTasksComplete();
  double getTasksTotal();
  double getTasksPercentageComplete();

  String getTimeCompletedProgressText();
  String getMoneyCompletedProgressText();
  String getLeafsCompletedProgressText();

  String getPercentageCompleteTimeFormatted();
  String getPercentageCompleteCostFormatted();
}

class _Accumulator {

  double totalCost = 0;
  double totalTime = 0;
  double totalTasks = 0;
  double completedCost = 0;
  double completedTime = 0;
  double completedTasks = 0;

  _Accumulator();

  _Accumulator.fromSingleGoal(this.totalCost, this.totalTime, this.totalTasks, bool complete):
        completedCost = complete ? totalCost : 0,
        completedTime = complete ? totalTime : 0,
        completedTasks = complete ? totalTasks : 0;

  combine(_Accumulator acc) {
    totalCost += acc.totalCost;
    totalTime += acc.totalTime;
    totalTasks += acc.totalTasks;
    completedCost += acc.completedCost;
    completedTime += acc.completedTime;
    completedTasks += acc.completedTasks;
  }
}

class GoalCalc extends GC{

  _Accumulator _calculations;

  GoalCalc(Goal goal) :
    _calculations = _getAll(goal);

  static _Accumulator _getAll(Goal goal) {
    _Accumulator acc = _Accumulator();
    if (goal.isLeaf()) {
      return _Accumulator.fromSingleGoal(goal.money, goal.time, 1, goal.isComplete());
    }

    goal.getActiveGoals().forEach((goal) {
      acc.combine(GoalCalc._getAll(goal));
    });
    return acc;
  }

  @override
  double getCostComplete() {
    return _calculations.completedCost;
  }

  @override
  double getCostPercentageComplete() {
    double moneyResult;
    if (_calculations.totalCost <= 0.0) moneyResult = 1.0;
    else moneyResult = _calculations.completedCost/_calculations.totalCost;
    return cleanPercentage(roundDouble(moneyResult,2));
  }

  @override
  double getCostTotal() {
    return _calculations.totalCost;
  }

  @override
  double getTasksComplete() {
    return _calculations.completedTasks;
  }

  @override
  double getTasksPercentageComplete() {
    return cleanPercentage(roundDouble(_calculations.completedTasks/_calculations.totalTasks,2));
  }

  @override
  double getTasksTotal() {
    return _calculations.totalTasks;
  }

  @override
  double getTimeComplete() {
    return _calculations.completedTime;
  }

  @override
  double getTimePercentageComplete() {
    double timeResult;
    if (_calculations.totalTime == 0) timeResult = _calculations.completedTasks / _calculations.totalTasks;
    else timeResult = _calculations.completedTime/_calculations.totalTime;
    return cleanPercentage(roundDouble(timeResult,2));
  }

  @override
  double getTimeTotal() {
    return _calculations.totalTime;
  }

  static String dollarsFormatter(num amount) {
    return NumberFormat.simpleCurrency(decimalDigits: 0).format(amount);
  }

  static double roundDouble(double value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String getTimeCompletedProgressText() {
    int hoursCompleted = _calculations.completedTime.round();
    int hoursTotal = _calculations.totalTime.round();
    String result = hoursCompleted.toString() + " / " + hoursTotal.toString() + " hours";
    if (result == "0 / 0 hours") return "";
    return result;
  }

  String getMoneyCompletedProgressText() {
    int dollarsSpent = _calculations.completedCost.round();
    int totalDollars = _calculations.totalCost.round();
    String text = dollarsFormatter(dollarsSpent) + " / " + dollarsFormatter(totalDollars);
    if (text == "\$0 / \$0") { text = "No Cost"; }
    return text;
  }

  String getLeafsCompletedProgressText() {
    int numOfLeafsComplete = _calculations.completedTasks.round();
    int leafsTotal = _calculations.totalTasks.round();
    return numOfLeafsComplete.toString() + " / " + leafsTotal.toString() + " tasks";
  }

  static String removeDecimals(num) {
    return num.toString().split(".")[0];
  }

  String getPercentageCompleteTimeFormatted() {
    return (getTimePercentageComplete()* 100).toString().split('.').first + "%";
  }

  String getPercentageCompleteCostFormatted() {
    return (getCostPercentageComplete() * 100).toString().split('.').first + "%";
  }

  double cleanPercentage(double percentage) {
      if (percentage > 1.0) return 1.0;
      if (percentage < 0.0) return 0.0;
      return percentage;
  }
}