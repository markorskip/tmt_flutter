import 'package:flutter/material.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:getwidget/getwidget.dart';

enum MetricType {
TIME, MONEY, TASKS
}

class AppBarDisplay extends StatelessWidget {
  const AppBarDisplay({
    Key? key,
    required this.context,
    required this.goal,
  }) : super(key: key);

  final BuildContext context;
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    if (!goal.isCompletable()) {return buildAppBarDashBoard(context);}
    return buildAppBarTaskSummary();
  }

  DefaultTextStyle buildAppBarTaskSummary() {
    return DefaultTextStyle(
    style: TextStyle(
          color: Colors.white,
          fontSize: 20
      ), child: Column(
    children:[
      Text(goal.description),
      Text("Time: " + goal.getTotalTimeFormatted()),
      Text("Cost: " + goal.getTotalCostFormatted()),
    ]),
  );
  }

  DefaultTextStyle buildAppBarDashBoard(BuildContext context) {
    // https://docs.getwidget.dev/gf-progress-bar/
    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).colorScheme.surface,
        fontSize: 15
      ),
      child: Padding(
        padding: EdgeInsets.all(6),
          child:
                Column(
                  children: [
                    Text("Time"),
                    buildGfProgressBar(goal, MetricType.TIME),
                    Text("Cost"),
                    buildGfProgressBar(goal, MetricType.MONEY),
                    // Padding(
                    //     padding: EdgeInsets.all(5),
                    //     child: ClipRRect(
                    //       borderRadius: BorderRadius.circular(4),
                    //       child: LinearProgressIndicator(
                    //           minHeight: 15,
                    //           color: Theme.of(context).colorScheme.primaryVariant,
                    //           backgroundColor: Colors.white,
                    //           value: goal.getPercentageCompleteCost()
                    //       ),
                    //     )),
                    Text("Tasks"),
                    buildGfProgressBar(goal, MetricType.TASKS)
                    // Padding(
                    //     padding: EdgeInsets.all(5),
                    //     child: ClipRRect(
                    //       borderRadius: BorderRadius.circular(4),
                    //       child: LinearProgressIndicator(
                    //           minHeight: 15,
                    //           color: Theme.of(context).colorScheme.secondaryVariant,
                    //           backgroundColor: Colors.white,
                    //           value: goal.getTotalTasksComplete() / goal.getTotalTasks()
                    //       ),
                    //     ))],
                ]),
        )
      );
  }

  GFProgressBar buildGfProgressBar(Goal goal, MetricType metricType) {
    double percentageComplete;
    String displayText;
    Color progressColor;
    switch(metricType) {
      case MetricType.TIME: {
        percentageComplete = goal.getPercentageCompleteTime();
        progressColor = GFColors.INFO;
        displayText = goal.getTimeCompletedProgressText();
      }
      break;
      case MetricType.MONEY: {
        percentageComplete = goal.getPercentageCompleteCost();
        progressColor = Theme.of(context).colorScheme.primaryVariant;
        displayText = goal.getMoneyCompletedProgressText();
      }
      break;
      case MetricType.TASKS: {
        percentageComplete = goal.getPercentageCompleteTasks();
        progressColor = Theme.of(context).colorScheme.onSurface;
        displayText = goal.getTasksCompletedProgressText();
      }
    }
     // MONEY color: Theme.of(context).colorScheme.primaryVariant
    return GFProgressBar(
      percentage: percentageComplete,
      lineHeight: 20,
      alignment: MainAxisAlignment.spaceBetween,
      child: Text(displayText, textAlign: TextAlign.end,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      backgroundColor: Colors.black26,
      progressBarColor: progressColor,
    );
  }
}