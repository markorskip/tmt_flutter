import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tmt_flutter/goal.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalList extends StatefulWidget {

  final Function deleteHandler;
  final Function openSubGoalHandler;
  final Function toggleCompleteHandler;
  final Function editHandler;
  final List<Goal> goals;

  GoalList({@required this.goals, this.deleteHandler, this.openSubGoalHandler, this.toggleCompleteHandler, this.editHandler});

  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {

  Widget _buildItem(BuildContext context, int index) {
    final goal = widget.goals[index];

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: getIcon(goal),
          title: Text(goal.title),
          subtitle: Text(goal.getSubTitle()),
          isThreeLine: true,
          dense: true,
          onTap: () {
            widget.openSubGoalHandler(goal);
          },
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blueAccent,
          icon: Icons.edit,
          onTap: () => widget.editHandler(goal),
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: () => widget.deleteHandler(goal),
        ),
      ],
    );
  }

  getIcon(Goal goal) {
    if (goal.goals.length > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new CircularPercentIndicator(
            radius: 35.0,
            lineWidth: 5.0,
            percent: goal.getPercentageCompleteTime(),
            center: new Text(
              (goal.getPercentageCompleteTime() * 100).toString() + "%",
              style:
              new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
            ),
          progressColor: Colors.blue,
        ),
          new CircularPercentIndicator(
            radius: 35.0,
            lineWidth: 5.0,
            percent: goal.getPercentageCompleteCost(),
            center: new Text(
            (goal.getPercentageCompleteCost() * 100).toString() + "%",
            style:
            new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
          ),
          progressColor: Colors.green,
          ),
          ]);
    }
    if (goal.complete == false) {
      return IconButton(
          icon: Icon(
            Icons.radio_button_unchecked,
            color: Colors.blue,
            size: 24.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          onPressed: () {
            widget.toggleCompleteHandler(goal);
          }
      );
    }
    if (goal.complete == true) {
      return IconButton(
            icon: Icon(
              Icons.radio_button_checked,
              color: Colors.blue,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            onPressed: () {
              widget.toggleCompleteHandler(goal);
            }
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildItem,
      itemCount: widget.goals.length,
    );
  }
}
