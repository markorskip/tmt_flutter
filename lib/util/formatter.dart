import 'dart:math';

import 'package:intl/intl.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/calc/goal_calculator.dart';


// TODO move all this to Goal Calc
class Formatter {

  static String removeDecimals(num) {
    return num.toString().split(".")[0];
  }

  static String dollarsFormatter(num amount) {
    return NumberFormat.simpleCurrency(decimalDigits: 0).format(amount);
  }

  static String getTimeCompletedProgressText(Goal goal) {
    GC gc = GoalCalc(goal);
    int hoursCompleted = gc.getTimeComplete().round();
    int hoursTotal = gc.getTimeComplete().round();
    String result =hoursCompleted.toString() + " / " + hoursTotal.toString() + " hours";
    if (result == "0 / 0 hours") return "";
    return result;
  }

  static String getMoneyCompletedProgressText(Goal goal) {
    GC gc = GoalCalc(goal);
    int dollarsSpent = gc.getCostComplete().round();
    int totalDollars = gc.getCostTotal().round();
    String text = dollarsFormatter(dollarsSpent) + " / " + dollarsFormatter(totalDollars);
    if (text == "\$0 / \$0") { text = "No Cost"; }
    return text;
  }

  static String getLeafsCompletedProgressText(Goal goal) {
    GC gc = GoalCalc(goal);
    int numOfLeafsComplete = gc.getTasksComplete().round();
    int leafsTotal = gc.getTasksTotal().round();
    return numOfLeafsComplete.toString() + " / " + leafsTotal.toString() + " tasks";
  }

  static double roundDouble(double value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  static String getPercentageCompleteTimeFormatted(Goal goal) {
    return (GoalCalc(goal).getTimePercentageComplete() * 100).toString().split('.').first + "%";
  }

  static String getPercentageCompleteCostFormatted(Goal goal) {
    return (GoalCalc(goal).getCostPercentageComplete() * 100).toString().split('.').first + "%";
  }
}