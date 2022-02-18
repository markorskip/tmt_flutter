import 'package:tmt_flutter/util/formatter.dart';

import 'goal.dart';
enum TMT {
  TIME, MONEY, TASK
}
class GoalCalc {

  Map<TMT, double> getTMTCompleted(Goal goal) {
    if (goal.isLeaf() && goal.isComplete()) {
      return {
        TMT.MONEY: goal.costInDollars,
        TMT.TIME: goal.timeInHours,
        TMT.TASK: 1.0
      };
    }

    Map<TMT, double> tmt = {
      TMT.MONEY: 0.0,
      TMT.TIME: 0.0,
      TMT.TASK: 0.0
    };

    goal.getActiveGoals().forEach((goal) {
      tmt[TMT.MONEY] = tmt[TMT.MONEY]! + GoalCalc().getTMTCompleted(goal)[TMT.MONEY]!;
      tmt[TMT.TIME] = tmt[TMT.TIME]! + GoalCalc().getTMTCompleted(goal)[TMT.TIME]!;
      tmt[TMT.TASK] = tmt[TMT.TASK]! + GoalCalc().getTMTCompleted(goal)[TMT.TASK]!;
    });

    return tmt;
  }

  Map<TMT, double> getTMTTotal(Goal goal) {
    if (goal.isLeaf()) return {
        TMT.MONEY: goal.costInDollars,
        TMT.TIME: goal.timeInHours,
        TMT.TASK: 1
      };

    Map<TMT, double> tmt = {
      TMT.MONEY: 0.0,
      TMT.TIME: 0.0,
      TMT.TASK: 0.0
    };

    goal.getActiveGoals().forEach((goal) {
      tmt[TMT.MONEY] = tmt[TMT.MONEY]! + GoalCalc().getTMTTotal(goal)[TMT.MONEY]!;
      tmt[TMT.TIME] = tmt[TMT.TIME]! + GoalCalc().getTMTTotal(goal)[TMT.TIME]!;
      tmt[TMT.TASK] = tmt[TMT.TASK]! + GoalCalc().getTMTTotal(goal)[TMT.TASK]!;
    });

    return tmt;
  }

  Map<TMT, double> getTMTPercentageComplete(Goal goal) {
    var tmtTotal = getTMTTotal(goal);
    var tmtComplete = getTMTCompleted(goal);

    var moneyResult;
    if (tmtTotal[TMT.MONEY] == 0) moneyResult = 1.0;
    else moneyResult = tmtComplete[TMT.MONEY]!/tmtTotal[TMT.MONEY]!;

    Map<TMT, double> tmt = {
      TMT.MONEY: Formatter.roundDouble(moneyResult,2),
      TMT.TIME: Formatter.roundDouble(tmtComplete[TMT.TIME]!/tmtTotal[TMT.TIME]!,2),
      TMT.TASK: Formatter.roundDouble(tmtComplete[TMT.TASK]!/tmtTotal[TMT.TASK]!,2)
    };
    return tmt;
  }
}