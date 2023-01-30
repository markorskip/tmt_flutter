import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmt_flutter/model/goal.dart';

class NewGoalDialog extends StatelessWidget {
  NewGoalDialog(this.parent);

  final Goal parent; // any new goal know's it's parent
  final _formKey = GlobalKey<FormState>();

  final goalTitleController = new TextEditingController();
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
        child: Form(
          key: _formKey,
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
                  return (value == null || value == ''
                      ? 'A name of the task is required'
                      : null);
                },
                inputFormatters: <TextInputFormatter>[UpperCaseTextFormatter()],
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.hourglass_top_sharp),
                  hintText: 'Estimated Time',
                  labelText: 'Time in Hours',
                ),
                controller: timeController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
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
              final goal = new Goal(titleController.value.text, this.parent,
                  money: getMoneyValue(), time: getTimeValue());
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

// AlertDialog getDialog(BuildContext context) {
//   log("getDialog called");
//   if (parent.getDepth() == 0) {
//     log(parent.getDepth().toString());
//     return getNewGoalDialog(context);
//   }
//   return getNewTaskDialog(context);
// }

// AlertDialog getNewGoalDialog(BuildContext context) {
//   return AlertDialog(
//     title: Text("What is the goal you are going to accomplish?"),
//     content: Container(
//       width: double.minPositive,
//       child: Form(
//         key: _formKey,
//         child: ListView(
//           children: [
//             TextFormField(
//               decoration: const InputDecoration(
//                 icon: Icon(Icons.title),
//                 hintText: 'Name of the goal',
//                 labelText: 'Title *',
//               ),
//               controller: titleController,
//               validator: (String? value) {
//                 return (value == null || value == ''
//                     ? 'A name of the task is required'
//                     : null);
//               },
//               inputFormatters: <TextInputFormatter>[UpperCaseTextFormatter()],
//               maxLines: 3,
//               minLines: 2,
//             ),
//           ],
//         ),
//       ),
//     ),
//     actions: <Widget>[
//       TextButton(
//         child: Text('Cancel'),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//       TextButton(
//         child: Text('Add'),
//         onPressed: () {
//           if (_formKey.currentState!.validate()) {
//             final goal = new Goal(titleController.value.text, this.parent,
//                 money: getMoneyValue(), time: getTimeValue());
//             titleController.clear();
//             descriptionController.clear();
//             moneyController.clear();
//             timeController.clear();
//             Navigator.of(context).pop(goal);
//           }
//         },
//       ),
//     ],
//   );
// }

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return '';
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
