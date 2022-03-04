import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../calc/goal_calculator.dart';
import '../../model/goal.dart';
import 'slideable.dart';

class buildGoalLeadingDisplay extends StatelessWidget {
  const buildGoalLeadingDisplay({
    Key? key,
    required this.widget,
    required this.goal,
  }) : super(key: key);

  final GoalSlideable widget;
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    if (!goal.isCompletable()) {
      GC gc = GoalCalc(goal);
      return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.timer,
              //color: Colors.blueAccent,
              size: 15.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            new CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 5.0,
              percent: GoalCalc(goal).getTimePercentageComplete(),
              center: new Text(gc.getPercentageCompleteTimeFormatted(),
                style:
                new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
              ),
              progressColor: Theme.of(context).colorScheme.primary,
              animation: true,
            ),
            Icon(
              Icons.attach_money,
              //color: Colors.green,
              size: 15.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            new CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 5.0,
              percent: GoalCalc(goal).getCostPercentageComplete(),
              center: new Text(gc.getPercentageCompleteCostFormatted(),
                style:
                new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
              ),
              progressColor: Theme.of(context).colorScheme.primaryVariant,
              animation: true,
            ),
          ]);
    }
    if (goal.isComplete() == false) {
      return IconButton(
          icon: Icon(
            Icons.radio_button_unchecked,
            // color: Colors.blue,
            size: 24.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          onPressed: () {
            widget.toggleCompleteHandler(goal);
          }
      );
    }
    return IconButton(
        icon: Icon(
          Icons.radio_button_checked,
          // color: Colors.blue,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ),
        onPressed: () {
          widget.toggleCompleteHandler(goal);
        }
    );
  }
}