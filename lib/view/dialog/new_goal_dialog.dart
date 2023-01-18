import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmt_flutter/model/goal.dart';


// TODO use the same dialog for new or editing a goal.  If new goal, pass a newly created goal in - discard if they cancel

class NewGoalDialog extends StatelessWidget {

  NewGoalDialog(this.parent);
  final Goal parent;

  // TODO can these be removed if we are using a TextFormField?
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

   final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        title: Text("New Task"),
          content: Container(
         width: double.minPositive,
        child: Form(
          key: _formKey,
          child:
         ListView(
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
                return (value == null || value == '' ? 'A name of the task is required' : null);
              } ,
              inputFormatters: <TextInputFormatter>[
              UpperCaseTextFormatter()
            ],
              maxLines: 3,
              minLines: 2,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.attach_money),
                hintText: 'Estimated Cost',
                labelText: 'Cost in Dollars',

              ),
              controller: moneyController,
              validator: (String? value) {
                return (value != null && value.contains(RegExp('a-z', caseSensitive: false))) ? 'Numbers only' : null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.hourglass_top_sharp),
                hintText: 'Estimated Time',
                labelText: 'Time in Hours',
              ),
              controller: timeController,
            ),
          ],
          ),
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
            if (_formKey.currentState!.validate()) {
              final goal = new Goal(
                titleController.value.text,
                this.parent,
                money: getMoneyValue(),
                time: getTimeValue());
              titleController.clear();
              descriptionController.clear();
              moneyController.clear();
              timeController.clear();
              Navigator.of(context).pop(goal);
            }
          },
        ),
      ],
    );
  }
}


class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
String capitalize(String value) {
  if(value.trim().isEmpty) return '';
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}