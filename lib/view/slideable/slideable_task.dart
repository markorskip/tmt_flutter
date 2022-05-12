import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/calc/goal_calculator.dart';

import 'leading_metric_display_for_slideable.dart';

class SlideableTask extends StatelessWidget {

  final Function deleteHandler;
  final Function openSubGoalHandler;
  final Function toggleExpandOnGoalHandler;
  final Function toggleCompleteHandler;
  final Function editHandler;
  final Function moveHandler;
  final List<Goal> tasks;
  final BuildContext context;

  SlideableTask(
      this.tasks,
      this.deleteHandler,
      this.openSubGoalHandler,
      this.toggleExpandOnGoalHandler,
      this.toggleCompleteHandler,
      this.editHandler,
      this.moveHandler,
      this.context);

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
    final goal = tasks[index];

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        child: ListTile(
          leading: buildGoalLeadingDisplay(widget: this, goal: goal),
          trailing: goal.getActiveGoals().length > 0 ? TrailingWidget(goal) : Spacer(),
          //textColor: Theme.of(context).primaryColor,
          title: Text(goal.title),
          subtitle: getSubTitleRichText(goal),
          isThreeLine: true,
          tileColor: goal.getBackgroundColor(),
          dense: true,
          onTap: () {
            openSubGoalHandler(goal);
          },
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Theme.of(context).primaryColor,
          icon: Icons.edit,
          onTap: () => editHandler(goal),
        ),
        IconSlideAction(
        caption: 'Move',
        color: Theme.of(context).secondaryHeaderColor,
        icon: Icons.folder,
        onTap: () => moveHandler(goal),
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Theme.of(context).secondaryHeaderColor,
          icon: Icons.delete,
          foregroundColor: Colors.white,
          onTap: () => deleteHandler(goal),
        ),
      ],
    );
  }

  IconButton TrailingWidget(Goal goal) {
    return IconButton(
            icon: Icon(
              goal.expanded ? Icons.expand : Icons.compress,
              // color: Colors.blue,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            onPressed: () {
              this.toggleExpandOnGoalHandler(goal);
            }
        );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildItem,
      itemCount: tasks.length,
    );
  }
}


