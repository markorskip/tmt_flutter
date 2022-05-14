import 'package:flutter/material.dart';

import 'package:tmt_flutter/model/goal.dart';

import '../../model/model_helpers/edit_goal_directive.dart';

//TODO make stateless
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

  double getTimeValue() {
    final result = double.tryParse(timeController.value.text);
    if (result == null) return 0;
    return result;
  }

  bool? _complete = false;

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.goalToEdit.title;
    moneyController.text = widget.goalToEdit.money.toString();
    timeController.text = widget.goalToEdit.time.toString();

    return AlertDialog(
      title: Text('Edit Goal'),
      content: Container(
      width: double.minPositive,
      // TODO refactor - edit and new goal should use the same form
      child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.title),
                hintText: 'Name of Task',
                labelText: 'Title *',
              ),
              controller: titleController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.attach_money),
                hintText: 'Estimated Cost',
                labelText: 'Cost in Dollars',
              ),
              controller: moneyController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.hourglass_top_sharp),
                hintText: 'Estimated Time',
                labelText: 'Time in Hours',
              ),
              controller: timeController,
            ),
            if (widget.goalToEdit.isCompletable()) getCompleteBox()
          ],
        ),
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
    editedGoal.complete = this._complete!;
    titleController.clear();
    descriptionController.clear();
    moneyController.clear();
    timeController.clear();
    Navigator.of(context).pop(editedGoal);
  }

  Widget getCompleteBox() {
      return Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ), //SizedBox
          Text(
            'Complete: ',
            style: TextStyle(fontSize: 17.0),
          ), //Text
          SizedBox(width: 10), //SizedBox
          /** Checkbox Widget **/
          Checkbox(
            value: this._complete,
            onChanged: (bool? value) {
              setState(() {
                this._complete = value;
              });
            },
          ), //Checkbox
        ], //<Widget>[]
      ); //Row
    }

}

