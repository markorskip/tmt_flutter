import 'dart:math';

import 'package:intl/intl.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/goal_calculator.dart';

class Formatter {

  static String removeDecimals(num) {
    return num.toString().split(".")[0];
  }

  static String dollarsFormatter(num amount) {
    return NumberFormat.simpleCurrency(decimalDigits: 0).format(amount);
  }

  static String getTimeCompletedProgressText(Goal goal) {
    int hoursCompleted = GoalCalc().getTMTCompleted(goal).timeInHours.round();
    int hoursTotal = GoalCalc().getTMTTotal(goal).timeInHours.round();
    String result =hoursCompleted.toString() + " / " + hoursTotal.toString() + " hours";
    if (result == "0 / 0 hours") return "";
    return result;
  }

  static String getMoneyCompletedProgressText(Goal goal) {
    int dollarsSpent = GoalCalc().getTMTCompleted(goal).costInDollars.round();
    int totalDollars = GoalCalc().getTMTTotal(goal).costInDollars.round();
    String text = dollarsFormatter(dollarsSpent) + " / " + dollarsFormatter(totalDollars);
    if (text == "\$0 / \$0") { text = "No Cost"; }
    return text;
  }

  static String getLeafsCompletedProgressText(Goal goal) {
    int numOfLeafsComplete = GoalCalc().getTMTCompleted(goal).tasks.round();
    int leafsTotal = GoalCalc().getTMTTotal(goal).tasks.round();
    return numOfLeafsComplete.toString() + " / " + leafsTotal.toString() + " tasks";
  }

  static double roundDouble(double value, int places){
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  static String getPercentageCompleteTimeFormatted(Goal goal) {
    return (GoalCalc().getTMTPercentageComplete(goal).timeInHours * 100).toString().split('.').first + "%";
  }

  static String getPercentageCompleteCostFormatted(Goal goal) {
    return (GoalCalc().getTMTPercentageComplete(goal).costInDollars * 100).toString().split('.').first + "%";
  }
}