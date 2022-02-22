import 'package:flutter/cupertino.dart';
import 'package:tmt_flutter/util/formatter.dart';

import 'goal.dart';

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

class _GoalCalculation {
  double costInDollars;
  double timeInHours;
  double tasks;

  _GoalCalculation({this.costInDollars = 0, this.timeInHours = 0, this.tasks = 0});
}

// Goal Calculator
class GoalCalc extends GC{

  Goal goal;
  _GoalCalculation _completed;
  _GoalCalculation _total;
  _GoalCalculation _percentage;

  GoalCalc(this.goal) :
    _completed = _getTMTCompleted(goal),
    _total = _getTMTTotal(goal),
    _percentage = _getTMTPercentageComplete(goal);


  static _GoalCalculation _getTMTCompleted(Goal goal) {
    if (goal.isLeaf() && goal.isComplete()) {
      return new _GoalCalculation(costInDollars: goal.costInDollars, timeInHours: goal.timeInHours, tasks: 1);}

    _GoalCalculation calc = new _GoalCalculation();

    goal.getActiveGoals().forEach((goal) {
      calc.costInDollars += GoalCalc._getTMTCompleted(goal).costInDollars;
      calc.timeInHours += GoalCalc._getTMTCompleted(goal).timeInHours;
      calc.tasks += GoalCalc._getTMTCompleted(goal).tasks;
    });

    return calc;
  }


  static _GoalCalculation _getTMTTotal(Goal goal) {
    if (goal.isLeaf()) {
      return new _GoalCalculation(costInDollars: goal.costInDollars, timeInHours: goal.timeInHours, tasks: 1);
    }

    _GoalCalculation calc = new _GoalCalculation();

    goal.getActiveGoals().forEach((goal) {
      calc.costInDollars += GoalCalc._getTMTTotal(goal).costInDollars;
      calc.timeInHours += GoalCalc._getTMTTotal(goal).timeInHours;
      calc.tasks += GoalCalc._getTMTTotal(goal).tasks;
    });

    return calc;
  }

  static _GoalCalculation _getTMTPercentageComplete(Goal goal) {
    _GoalCalculation tmtTotal = _getTMTTotal(goal);
    _GoalCalculation tmtComplete = _getTMTCompleted(goal);

    double moneyResult;
    if (tmtTotal.costInDollars == 0.0) moneyResult = 1.0;
    else moneyResult = tmtComplete.costInDollars/tmtTotal.costInDollars;

    double timeResult;
    if (tmtTotal.timeInHours == 0) timeResult = tmtComplete.tasks / tmtTotal.tasks;
    else timeResult = tmtComplete.timeInHours/tmtTotal.timeInHours;

    _GoalCalculation calc = new _GoalCalculation();
    calc.costInDollars = Formatter.roundDouble(moneyResult,2);
    calc.timeInHours = Formatter.roundDouble(timeResult,2);
    calc.tasks = Formatter.roundDouble(tmtComplete.tasks/tmtTotal.tasks,2);

    return calc;
  }

  @override
  double getCostComplete() {
    return _completed.costInDollars;
  }

  @override
  double getCostPercentageComplete() {
    return _percentage.costInDollars;
  }

  @override
  double getCostTotal() {
    return _total.costInDollars;
  }

  @override
  double getTasksComplete() {
    return _completed.tasks;
  }

  @override
  double getTasksPercentageComplete() {
    return _percentage.tasks;
  }

  @override
  double getTasksTotal() {
    return _total.tasks;
  }

  @override
  double getTimeComplete() {
    return _completed.timeInHours;
  }

  @override
  double getTimePercentageComplete() {
    return _percentage.timeInHours;
  }

  @override
  double getTimeTotal() {
    return _total.timeInHours;
  }
}