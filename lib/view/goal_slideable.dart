import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tmt_flutter/model/goal.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalSlideable extends StatefulWidget {

  final Function deleteHandler;
  final Function openSubGoalHandler;
  final Function toggleCompleteHandler;
  final Function editHandler;
  final Function moveHandler;
  final List<Goal> goals;

  GoalSlideable(this.goals, this.deleteHandler, this.openSubGoalHandler, this.toggleCompleteHandler, this.editHandler, this.moveHandler);

  @override
  _GoalSlideableState createState() => _GoalSlideableState();
}

class _GoalSlideableState extends State<GoalSlideable> {

  RichText getSubTitleRichText(Goal goal) {
    return new RichText(
      text: new TextSpan(
        style: new TextStyle(
          fontSize: 14.0,
        ),
        children: <TextSpan>[
          new TextSpan(
              text: "Time: " +  goal.getTimeTotal().toString() + " hours \n",
              style: TextStyle(color: Theme.of(context).colorScheme.primary)
          ),
          new TextSpan(text: "Cost: \$" +  goal.getCostTotal().toString().split('.').first,
              style: TextStyle(color: Theme.of(context).colorScheme.primaryVariant)),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final goal = widget.goals[index];

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: ListTile(
          leading: buildGoalLeadingDisplay(widget: widget, goal: goal),
          //textColor: Theme.of(context).primaryColor,
          title: Text(goal.title),
          subtitle: getSubTitleRichText(goal),
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
          color: Theme.of(context).primaryColor,
          icon: Icons.edit,
          onTap: () => widget.editHandler(goal),
        ),
        IconSlideAction(
        caption: 'Move',
        color: Theme.of(context).secondaryHeaderColor,
        icon: Icons.folder,
        onTap: () => widget.moveHandler(goal),
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Theme.of(context).secondaryHeaderColor,
          icon: Icons.delete,
          foregroundColor: Colors.white,
          onTap: () => widget.deleteHandler(goal),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildItem,
      itemCount: widget.goals.length,
    );
  }
}

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
            percent: goal.getTimePercentageComplete(),
            center: new Text(goal.getPercentageCompleteTimeFormatted(),
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
            percent: goal.getCostPercentageComplete(),
            center: new Text(goal.getPercentageCompleteCostFormatted(),
            style:
            new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
          ),
          progressColor: Theme.of(context).colorScheme.primaryVariant,
            animation: true,
          ),
          ]);
    }
    if (goal.complete == false) {
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
    //if (goal.complete == true) {
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
    //}
  }
}
