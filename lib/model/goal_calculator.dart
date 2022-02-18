import 'package:flutter/cupertino.dart';
import 'package:tmt_flutter/util/formatter.dart';

import 'goal.dart';

class GoalCalculation {
  double costInDollars;
  double timeInHours;
  double tasks;

  GoalCalculation({this.costInDollars = 0, this.timeInHours = 0, this.tasks = 0});
}

// Goal Calculator
class GoalCalc {
  GoalCalculation getTMTCompleted(Goal goal) {
    if (goal.isLeaf() && goal.isComplete()) {
      return new GoalCalculation(costInDollars: goal.costInDollars, timeInHours: goal.timeInHours, tasks: 1);}

    GoalCalculation calc = new GoalCalculation();

    goal.getActiveGoals().forEach((goal) {
      calc.costInDollars += GoalCalc().getTMTCompleted(goal).costInDollars;
      calc.timeInHours += GoalCalc().getTMTCompleted(goal).timeInHours;
      calc.tasks += GoalCalc().getTMTCompleted(goal).tasks;
    });

    return calc;
  }


  GoalCalculation getTMTTotal(Goal goal) {
    if (goal.isLeaf()) {
      return new GoalCalculation(costInDollars: goal.costInDollars, timeInHours: goal.timeInHours, tasks: 1);
    }

    GoalCalculation calc = new GoalCalculation();

    goal.getActiveGoals().forEach((goal) {
      calc.costInDollars += GoalCalc().getTMTTotal(goal).costInDollars;
      calc.timeInHours += GoalCalc().getTMTTotal(goal).timeInHours;
      calc.tasks += GoalCalc().getTMTTotal(goal).tasks;
    });

    return calc;
  }

  GoalCalculation getTMTPercentageComplete(Goal goal) {
    GoalCalculation tmtTotal = getTMTTotal(goal);
    GoalCalculation tmtComplete = getTMTCompleted(goal);

    double moneyResult;
    if (tmtTotal.costInDollars == 0.0) moneyResult = 1.0;
    else moneyResult = tmtComplete.costInDollars/tmtTotal.costInDollars;

    double timeResult;
    if (tmtTotal.timeInHours == 0) timeResult = tmtComplete.tasks / tmtTotal.tasks;
    else timeResult = tmtComplete.timeInHours/tmtTotal.timeInHours;

    GoalCalculation calc = new GoalCalculation();
    calc.costInDollars = Formatter.roundDouble(moneyResult,2);
    calc.timeInHours = Formatter.roundDouble(timeResult,2);
    calc.tasks = Formatter.roundDouble(tmtComplete.tasks/tmtTotal.tasks,2);

    return calc;
  }
}