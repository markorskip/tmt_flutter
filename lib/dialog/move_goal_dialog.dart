import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/move_goal_directive.dart';

class MoveGoalDialog extends StatefulWidget {

  final Goal goalToMove;

  final List<Goal> siblingGoals;

  MoveGoalDialog(this.goalToMove, this.siblingGoals); // chose a sibling goals, can move inside this to move down

  @override
  State<StatefulWidget> createState() => _MoveGoalDialogState();
}

class _MoveGoalDialogState extends State<MoveGoalDialog> {

  Goal? dropdownValue;

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
              items: widget.siblingGoals.where((goal) => goal != widget.goalToMove).map<DropdownMenuItem<Goal>>((Goal goal) {
                return DropdownMenuItem<Goal>(
                  child: Text(goal.title),
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
          child: Text('Move Down'),
          onPressed: () {
            moveDown();
          },
        ),
        TextButton(
          child: Text('Move up'),
          onPressed: () {
            moveUp();
          },
        ),
      ],
    );
  }

  void moveDown() {
    final MoveGoal moveGoal = new MoveGoal(widget.goalToMove);
    moveGoal.setMoveUp(false);
    moveGoal.setGoalToMoveTo(dropdownValue);
    Navigator.of(context).pop(moveGoal);
  }

  void moveUp() {
    final MoveGoal moveGoal = new MoveGoal(widget.goalToMove);
    moveGoal.setMoveUp(true);
    Navigator.of(context).pop(moveGoal);
  }



}


