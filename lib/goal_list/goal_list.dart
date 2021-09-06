import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tmt_flutter/model/goal.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalList extends StatefulWidget {

  final Function deleteHandler;
  final Function openSubGoalHandler;
  final Function toggleCompleteHandler;
  final Function editHandler;
  final Function moveHandler;
  final List<Goal> goals;

  GoalList(this.goals, this.deleteHandler, this.openSubGoalHandler, this.toggleCompleteHandler, this.editHandler, this.moveHandler);

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
          subtitle: goal.getSubTitleRichText(),
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
        ),
        IconSlideAction(
          caption: 'Move',
          color: Colors.greenAccent,
          icon: Icons.folder,
          onTap: () => widget.moveHandler(goal),
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
          Icon(
            Icons.timer,
            color: Colors.blueAccent,
            size: 15.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          new CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 5.0,
            percent: goal.getPercentageCompleteTime(),
            center: new Text(goal.getPercentageCompleteTimeFormatted(),
              style:
              new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
            ),
          progressColor: Colors.blue,
            animation: true,
        ),
          Icon(
            Icons.attach_money,
            color: Colors.green,
            size: 15.0,
            semanticLabel: 'Text to announce in accessibility modes',
          ),
          new CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 5.0,
            percent: goal.getPercentageCompleteCost(),
            center: new Text(goal.getPercentageCompleteCostFormatted(),
            style:
            new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
          ),
          progressColor: Colors.green,
            animation: true,
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
