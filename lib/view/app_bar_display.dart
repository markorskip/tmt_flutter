
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          color: Theme.of(context).colorScheme.surface,
          fontSize: 15
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
              child:
                Table(
                    children: [
                      TableRow(
                          children: [
                            Text(""),
                            Text("Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text("Money", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                          ]),
                    TableRow(
                      children: [
                        Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(goal.getTotalTimeFormatted().toString() + " hours"),
                        Text("\$" + goal.getTotalCostFormatted())
                        ]),
                  TableRow(
                      children: [
                        Text("Completed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(" hours"),
                        Text("test")
                      ])
                ])
      ));
    }

    String description = "Time in hours:" + goal.timeInHours.toString();
    return Text(description);
  }
}