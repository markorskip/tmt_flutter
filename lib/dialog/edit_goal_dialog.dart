import 'package:flutter/material.dart';

import 'package:tmt_flutter/model/goal.dart';

import '../model/edit_goal_directive.dart';

// TODO For the edit dialog, add complete on/off as well as notes for updates

class EditGoalDialog extends StatefulWidget {

  final Goal goalToEdit;

  EditGoalDialog(this.goalToEdit);

  @override
  _EditGoalDialogState createState() => _EditGoalDialogState();

}

class _EditGoalDialogState extends State<EditGoalDialog>{
  final titleController = new TextEditingController();
  final descriptionController = new TextEditingController();
  final moneyController = new TextEditingController();
  final timeController = new TextEditingController();

  double getMoneyValue() {
    final result = double.tryParse(moneyController.value.text);
    if (result == null) return 0;
    return result;
  }

  int getTimeValue() {
    final result = int.tryParse(timeController.value.text);
    if (result == null) return 0;
    return result;
  }


  @override
  Widget build(BuildContext context) {
    titleController.text = widget.goalToEdit.title;
    descriptionController.text = widget.goalToEdit.description!;
    moneyController.text = widget.goalToEdit.costInDollars.toString();
    timeController.text = widget.goalToEdit.timeInHours.toString();
    return AlertDialog(
      title: Text('Edit Goal'),
      content: ListView(
        children: [
          TextField(
          controller: titleController,
          autofocus: true,
         ),
          Text("Title"),
          TextField(
            controller: descriptionController,
            autofocus: true,
          ),
          Text("Description (optional)"),

          TextField(
            controller: moneyController,
            autofocus: true,
          ),
          Text("Estimated cost (in dollars)"),
          TextField(
            controller: timeController,
            autofocus: true,
          ),
          Text("Estimated time to complete (in hours)"),
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
          child: Text('Save'),
          onPressed: () {
            editGoal();
          },
        ),
      ],
    );
  }

  void editGoal() {
    final editedGoal = new EditGoal(titleController.value.text,
        descriptionController.value.text,
        getMoneyValue(),
        getTimeValue());
    titleController.clear();
    descriptionController.clear();
    moneyController.clear();
    timeController.clear();
    Navigator.of(context).pop(editedGoal);
  }


}

