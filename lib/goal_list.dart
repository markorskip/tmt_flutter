import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tmt_flutter/goal.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalList extends StatelessWidget {
  final Function deleteHandler;
  final Function openSubGoalHandler;
  final Function toggleCompleteHandler;
  final Function editHandler;
  GoalList({@required this.goals, this.deleteHandler, this.openSubGoalHandler, this.toggleCompleteHandler, this.editHandler});

  final List<Goal> goals;

  Widget _buildItem(BuildContext context, int index) {
    final goal = goals[index];

    // https://www.fluttercampus.com/guide/68/how-to-make-slide-and-delete-item-list-flutter/
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Card(
        color: Colors.white,
        child: ListTile(
          leading: getIcon(goal),
          title: Text(goal.title),
          subtitle: Text(goal.getSubTitle()),
          isThreeLine: true,
          dense: true,
          onTap: () {
            openSubGoalHandler(goal);
          },
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blueAccent
          ),
          child: Icon(Icons.edit),
          onPressed: (){
            editHandler(goal); // TODO
          },
        ),
      ],
      secondaryActions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.redAccent
          ),
          child: Icon(Icons.delete),
          onPressed: (){
            deleteHandler(goal);
          },
        ),
      ],
    );

    // return ListTile(
    //   leading: getIcon(goal),
    //   title: Text(goal.title),
    //   subtitle: Text(goal.getSubTitle()),
    //   isThreeLine: true,
    //   dense: true,
    //   trailing: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     children: <Widget>[
    //       IconButton(
    //         icon: Icon(
    //           Icons.delete_outline,
    //           size: 20.0,
    //           color: Colors.brown[900],
    //         ),
    //         onPressed: (){
    //           deleteHandler(goal);
    //         },
    //       ),
    //     ],
    //   ),
    // onTap: () {
    //     openSubGoalHandler(goal);
    //   },
    // );
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
            toggleCompleteHandler(goal);
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
              toggleCompleteHandler(goal);
            }
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildItem,
      itemCount: goals.length,
    );
  }
}
