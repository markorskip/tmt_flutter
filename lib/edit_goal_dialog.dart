import 'package:flutter/material.dart';

import 'package:tmt_flutter/model/goal.dart';

import 'model/edited_goal.dart';


// TODO For the edit dialog, add complete on/off as well as notes for updates

class EditGoalDialog extends StatefulWidget {

  final Goal goalToEdit;

  final List<Goal> siblingGoals;  // chose a sibling goals, can move inside this to move down

  EditGoalDialog(this.goalToEdit, this.siblingGoals); // TODO if duplicate name then what?

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
    print(widget.siblingGoals.length);
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
          //if (widget.siblingGoals.isNotEmpty) { TODO implement this logic
          Container(
            child: DropdownButton<String>(
              //value: _chosenValue,
              //elevation: 5,
              style: TextStyle(color: Colors.black),

              items: widget.siblingGoals.map<DropdownMenuItem<String>>((Goal sibling) {
                return DropdownMenuItem<String>(
                  value: sibling.title,
                  child: Text(sibling.title),
                );
              }).toList(),
              hint: Text(
                "Move into this goal",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              // onChanged: {
              //   setState(() {
              //     _chosenValue = value;
              //   });
              //},
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
          child: Text('Move up'),
          onPressed: () {
            editGoal(true);
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            editGoal(false);
          },
        ),
      ],
    );
  }

  void editGoal(bool moveUp) {
    final editedGoal = new EditedGoal(titleController.value.text,
        descriptionController.value.text,
        getMoneyValue(),
        getTimeValue());
    editedGoal.moveUp = moveUp;
    titleController.clear();
    descriptionController.clear();
    moneyController.clear();
    timeController.clear();
    Navigator.of(context).pop(editedGoal);
  }


}

