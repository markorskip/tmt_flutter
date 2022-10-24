import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/calc/goal_calculator.dart';

import 'leading_metric_display_for_slideable.dart';

class SlideableTasks extends StatelessWidget {

  final Function deleteHandler;
  final Function openSubGoalHandler;
  final Function toggleExpandOnGoalHandler;
  final Function toggleCompleteHandler;
  final Function editHandler;
  final List<Goal> tasks;
  final BuildContext context;

  SlideableTasks(
      this.tasks,
      this.deleteHandler,
      this.openSubGoalHandler,
      this.toggleExpandOnGoalHandler,
      this.toggleCompleteHandler,
      this.editHandler,
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
          trailing: TrailingWidget(goal),
          //textColor: Theme.of(context).primaryColor,
          title: Text(goal.title),
          subtitle: getSubTitleRichText(goal),
          isThreeLine: true,
          tileColor: getTileColor(goal),
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
        )
        //,  Disabling MOVE for first release TODO find a better way to do this
        // IconSlideAction(
        // caption: 'Move',
        // color: Theme.of(context).secondaryHeaderColor,
        // icon: Icons.folder,
        // onTap: () => moveHandler(goal),
        // )
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

  Widget TrailingWidget(Goal goal) {
    if (goal.getActiveGoals().length < 1) return SizedBox.shrink();
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

  Color getTileColor(Goal goal) {
    // This lumps the colors of the parent with the children
    int depth = goal.expanded ? goal.ident + 1 : goal.ident;

    switch(depth) {
      case 0:
        return Colors.white;
      case 1:
        return Colors.black12;
      case 2:
        return Colors.white10;
      case 3:
        return Colors.black12;
      default:
        return Colors.white10;
    }
  }
}


