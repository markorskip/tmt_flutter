import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/move_goal.dart';

class MoveGoalDialog extends StatefulWidget {

  final Goal goalToEdit;

  //final List<Goal> siblingGoals;

  MoveGoalDialog(
      this.goalToEdit); // chose a sibling goals, can move inside this to move down


  @override
  State<StatefulWidget> createState() => _MoveGoalDialogState();
}

class _MoveGoalDialogState extends State<MoveGoalDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Move Goal'),
      content: ListView(
        children: [
          //if (widget.siblingGoals.isNotEmpty) { TODO implement this logic
          // Container(
          //   child: DropdownButton<String>(
          //     //value: _chosenValue,
          //     //elevation: 5,
          //     style: TextStyle(color: Colors.black),
          //
          //     items: widget.siblingGoals.map<DropdownMenuItem<String>>((
          //         Goal sibling) {
          //       return DropdownMenuItem<String>(
          //         value: sibling.title,
          //         child: Text(sibling.title),
          //       );
          //     }).toList(),
          //     hint: Text(
          //       "Move into this goal",
          //       style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 12,
          //           fontWeight: FontWeight.w600),
          //     ),
          //   ),
          // ),
        ],
      ),
      actions: <Widget>[

        TextButton(
          child: Text('Move up'),
          onPressed: () {
            moveUp();
          },
        ),
      ],
    );
  }


  void moveUp() {
    final MoveGoal moveGoal = new MoveGoal();
    moveGoal.moveUp = true;
    Navigator.of(context).pop(moveGoal);
  }

}


