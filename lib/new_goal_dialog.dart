import 'package:flutter/material.dart';

import 'package:tmt_flutter/model.dart';

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

  int getTimeValue() {
    final result = int.tryParse(timeController.value.text);
    if (result == null) return 0;
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Goal'),
      content: ListView(
        children: [
          TextField(
          controller: titleController,
          autofocus: true,
         ),
          Text("Name of Goal/Task/Project"),
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
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Add'),
          onPressed: () {
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
