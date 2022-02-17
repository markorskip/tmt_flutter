import 'package:tmt_flutter/model/display_util.dart';
import 'package:tmt_flutter/model/goal.dart';

class Formatter {

  static String removeDecimals(num) {
    return num.toString().split(".")[0];
  }

  static String getTimeCompletedProgressText(Goal goal) {
    int hoursCompleted = goal.getTimeCompletedHrs().round();
    int hoursTotal = goal.getTimeTotal().round();
    String result =hoursCompleted.toString() + " / " + hoursTotal.toString() + " hours";
    if (result == "0 / 0 hours") return "";
    return result;
  }

  static String getMoneyCompletedProgressText(Goal goal) {
    int dollarsSpent = goal.getCompletedCostDollars().round();
    int totalDollars = goal.getTotalCost().round();
    String text = DisplayUtil.dollarsFormatter(dollarsSpent) + " / " + DisplayUtil.dollarsFormatter(totalDollars);
    if (text == "\$0 / \$0") { text = ""; }
    return text;
  }

  static String getTasksCompletedProgressText(Goal goal) {
    int numOfTasksComplete = goal.getTasksComplete();
    int tasksTotal = goal.getTasksTotalCount();
    return numOfTasksComplete.toString() + " / " + tasksTotal.toString() + " tasks";
  }

}