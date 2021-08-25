import 'package:flutter/material.dart';

import 'package:tmt_flutter/goal.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalList extends StatelessWidget {
  final Function deleteHandler;
  final Function openSubGoalHandler;
  GoalList({@required this.goals, this.deleteHandler, this.openSubGoalHandler});

  final List<Goal> goals;

  Widget _buildItem(BuildContext context, int index) {
    final goal = goals[index];

    return ListTile(
      leading: getIcon(goal),
      title: Text(goal.title),
      subtitle: Text(goal.getSubTitle()),
      isThreeLine: true,
      dense: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 20.0,
              color: Colors.brown[900],
            ),
            onPressed: (){
              deleteHandler(goal);
            },
          ),
        ],
      ),
    onTap: () {
        openSubGoalHandler(goal);
      },
    );
  }

  getIcon(Goal goal) {

    if (goal.goals.length > 0) {
      return new CircularPercentIndicator(
        radius: 45.0,
        lineWidth: 5.0,
        percent:1.0,
        center: new Text(
          "100%",
          style:
          new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
        ),
        progressColor: Colors.blue,
      );
    }
    return Icon(
      Icons.radio_button_off_rounded ,
      color: Colors.blue,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildItem,
      itemCount: goals.length,
    );
  }
}
