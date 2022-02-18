import 'dart:math';

import 'package:intl/intl.dart';
import 'package:tmt_flutter/model/goal.dart';

class Formatter {

  static String removeDecimals(num) {
    return num.toString().split(".")[0];
  }

  static String dollarsFormatter(num amount) {
    return NumberFormat.simpleCurrency(decimalDigits: 0).format(amount);
  }

  static String getTimeCompletedProgressText(Goal goal) {
    int hoursCompleted = goal.getTimeCompletedHrs().round();
    int hoursTotal = goal.getTimeTotal().round();
    String result =hoursCompleted.toString() + " / " + hoursTotal.toString() + " hours";
    if (result == "0 / 0 hours") return "";
    return result;
  }

  static String getMoneyCompletedProgressText(Goal goal) {
    int dollarsSpent = goal.getCostCompletedDollars().round();
    int totalDollars = goal.getCostTotal().round();
    String text = dollarsFormatter(dollarsSpent) + " / " + dollarsFormatter(totalDollars);
    if (text == "\$0 / \$0") { text = "No Cost"; }
    return text;
  }

  static String getTasksCompletedProgressText(Goal goal) {
    int numOfTasksComplete = goal.getTasksComplete();
    int tasksTotal = goal.getTasksTotalCount();
    return numOfTasksComplete.toString() + " / " + tasksTotal.toString() + " tasks";
  }

  static String getLeafsCompletedProgressText(Goal goal) {
    int numOfLeafsComplete = goal.getLeafsComplete();
    int leafsTotal = goal.getLeafTotalCount();
    return numOfLeafsComplete.toString() + " / " + leafsTotal.toString() + " tasks";
  }

  static double roundDouble(double value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  static String getPercentageCompleteTimeFormatted(Goal goal) {
    return (goal.getTimePercentageComplete() * 100).toString().split('.').first + "%";
  }

  static String getPercentageCompleteCostFormatted(Goal goal) {
    return (goal.getCostPercentageComplete() * 100).toString().split('.').first + "%";
  }
}