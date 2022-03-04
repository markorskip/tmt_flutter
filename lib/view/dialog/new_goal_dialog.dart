import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmt_flutter/model/goal.dart';

class NewGoalDialog extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        title: Text("New Task"),
          content: Container(
         width: double.minPositive,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.title),
                hintText: 'Name of Task',
                labelText: 'Title *',
              ),
              controller: titleController,
              validator: (String? value) {
                if (value == null) return 'Required';
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.description),
                hintText: 'Optional Description',
                labelText: 'Description',
              ),
              controller: descriptionController,
              validator: (String? value) {
                return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.attach_money),
                hintText: 'Estimated Cost',
                labelText: 'Cost in Dollars',
              ),
              controller: moneyController,
              validator: (String? value) {
                if (value != null && double.tryParse(value) == null) 'Numbers only for money';
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.hourglass_top_sharp),
                hintText: 'Estimated Time',
                labelText: 'Time in Hours',
              ),
              controller: timeController,
              validator: (String? value) {
                //TODO
                if (value != null && value.contains('@'))  return 'Do not use the @ char.';
                return null;
              },
            ),
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
          child: Text('Add'),
          onPressed: () {
            // TODO activate validators
            final goal = new Goal(titleController.value.text,
                descriptionController.value.text,
                getMoneyValue(),
                getTimeValue());
            titleController.clear();
            descriptionController.clear();
            moneyController.clear();
            timeController.clear();
            Navigator.of(context).pop(goal);
          },
        ),
      ],
    );
  }

}
