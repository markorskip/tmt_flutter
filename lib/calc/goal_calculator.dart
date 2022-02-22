import 'package:flutter/cupertino.dart';
import 'package:tmt_flutter/util/formatter.dart';

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
      if (goal.isComplete()) {
        return _Accumulator.fromSingleGoal(goal.costInDollars, goal.timeInHours, 1, true);
      }
      return _Accumulator.fromSingleGoal(goal.costInDollars, goal.timeInHours, 1, false);
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
    if (_calculations.totalCost == 0.0) moneyResult = 1.0;
    else moneyResult = _calculations.completedCost/_calculations.totalCost;
    return Formatter.roundDouble(moneyResult,2);
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
    return Formatter.roundDouble(_calculations.completedTasks/_calculations.totalTasks,2);
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
    return Formatter.roundDouble(timeResult,2);
  }

  @override
  double getTimeTotal() {
    return _calculations.totalTime;
  }
}