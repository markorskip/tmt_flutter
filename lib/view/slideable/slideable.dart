import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/calc/goal_calculator.dart';

import 'leading_metric_display_for_slideable.dart';

class GoalSlideable extends StatefulWidget {

  final Function deleteHandler;
  final Function openSubGoalHandler;
  final Function toggleCompleteHandler;
  final Function editHandler;
  final Function moveHandler;
  final List<Goal> goals;

  GoalSlideable(
      this.goals,
      this.deleteHandler,
      this.openSubGoalHandler,
      this.toggleCompleteHandler,
      this.editHandler,
      this.moveHandler);

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
              text: "Time: " +  GoalCalc(goal).getTimeTotal().toString() + " hours \n",
              style: TextStyle(color: Theme.of(context).colorScheme.primary)
          ),
          new TextSpan(text: "Cost: \$" +  GoalCalc(goal).getCostTotal().toString().toString().split('.').first,
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


