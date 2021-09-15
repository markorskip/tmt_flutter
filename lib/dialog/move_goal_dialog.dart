import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/move_goal_directive.dart';

class MoveGoalDialog extends StatefulWidget {

  final Goal goalToMove;

  final List<Goal> siblingGoals;

  final Goal? grandParentGoal;

  MoveGoalDialog(this.goalToMove, this.siblingGoals, this.grandParentGoal); // chose a sibling goals, can move inside this to move down

  @override
  State<StatefulWidget> createState() => _MoveGoalDialogState();
}

class _MoveGoalDialogState extends State<MoveGoalDialog> {

  Goal? dropdownValue;

  List<Goal> getGoalsInDropDown() {
    List<Goal> list = [];
    if (widget.grandParentGoal != null) {
      list.add(widget.grandParentGoal!);
    }
    list.addAll(widget.siblingGoals);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Move Goal'),
      content: ListView(
        children: [
          Container(
            child: DropdownButton(
              icon: const Icon(Icons.arrow_drop_down),
              value: dropdownValue,
              items:
              getGoalsInDropDown().where((goal) => goal != widget.goalToMove).map<DropdownMenuItem<Goal>>((Goal goal) {
                return DropdownMenuItem<Goal>(
                  child: Text(getText(goal)),
                  value: goal,
                );
              }).toList(),
              onChanged: (Goal? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              hint: Text("Select a goal to move to"),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Move'),
          onPressed: () {
            move();
          },
        ),
      ],
    );
  }

  void move() {
    final MoveGoal moveGoal = new MoveGoal(widget.goalToMove);
    moveGoal.setGoalToMoveTo(dropdownValue);
    Navigator.of(context).pop(moveGoal);
  }

  String getText(Goal goal) {
    if (goal == widget.grandParentGoal) {
      return 'MOVE UP TO: ' + widget.grandParentGoal!.title;
    }
    return goal.title;
  }

}


