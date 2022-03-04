import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/cupertino.dart';

class InfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return EasyDialog(
        title: Text(
          "Time Money Tasklist",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.2,
        ),
        description: Text(
          "1. Create goals and subgoals \n2. Save to not lose work",
          textScaleFactor: 1.1,
          textAlign: TextAlign.center,
        )).show(context);
  }
  
}