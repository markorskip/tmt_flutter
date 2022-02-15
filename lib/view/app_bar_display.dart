
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tmt_flutter/model/goal.dart';

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
    if (!goal.isCompletable()) {
      var color = Theme.of(context).colorScheme.primaryVariant;

      return DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(

              children: <Widget>[
                Column (
                  children: [
                    Text("Total:"),
                    Text("Hours Needed: " + goal.getTotalTime().toString()),
                    Text("Dollars Needed: " + goal.getTotalCost().toString())
                  ],
                ),
                Column (
                  children: [
                    Text("Completed:"),
                    Text("Hours Needed: " + goal.timeInHours.toString()),
                    Text("Dollars Needed: " + goal.costInDollars.toString())
                  ],
                ),
                //goal.getSubTitleRichText(),
                //Spacer(),

                // Icon(
                //   Icons.timer,
                //   color: color,
                //   size: 15.0,
                //   semanticLabel: 'Text to announce in acrcessibility modes',r
                // ),
                // new CircularPercentIndicator(
                //   radius: 40.0,
                //   lineWidth: 5.0,
                //   percent: goal.getPercentageCompleteTime(),
                //   center: new Text(goal.getPercentageCompleteTimeFormatted(),
                //     style:
                //     new TextStyle(fontWeight: FontWeight.normal,
                //         fontSize: 10.0,
                //         color: color),
                //   ),
                //   progressColor: color,
                //   animation: true,
                // ),
                // Text("Cost Completed:"),
                // Icon(
                //   Icons.attach_money,
                //   color: color,
                //   size: 15.0,
                //   semanticLabel: 'Text to announce in accessibility modes',
                // ),
                // new CircularPercentIndicator(
                //   radius: 40.0,
                //   lineWidth: 5.0,
                //   percent: goal.getPercentageCompleteCost(),
                //   center: new Text(goal.getPercentageCompleteCostFormatted(),
                //     style:
                //     new TextStyle(fontWeight: FontWeight.normal,
                //         fontSize: 10.0,
                //         color: color),
                //   ),
                //   progressColor: color,
                //   animation: true,
                // ),
              ])
      ));
    }

    String description = "Time in hours:" + goal.timeInHours.toString();
    return Text(description);
  }
}