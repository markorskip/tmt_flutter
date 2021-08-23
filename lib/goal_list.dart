import 'package:flutter/material.dart';

import 'package:tmt_flutter/model.dart';

class GoalList extends StatelessWidget {
  GoalList({@required this.goals});

  final List<Goal> goals;


  Widget _buildItem(BuildContext context, int index) {
    final goal = goals[index];

    return ListTile(
      leading: getIconForDepth(goal.levelDeep),
      title: Text(goal.title),
      subtitle: Text(goal.getSubTitle()),
      isThreeLine: true,
      dense: true,
     // onTap: _modifyGoal(),
    );
  }

  // _modifyGoal() async {
  //   final goal = await showDialog<Goal>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return NewGoalDialog();
  //     },
  //   );
  //
  //   if (goal != null) {
  //     setState(() {
  //       goals.add(goal);
  //     });
  //   }
  // }

  getIconForDepth(int levelDeep) {
    switch(levelDeep) {
      case 0: return Icon(
    Icons.airplanemode_active_rounded,
    color: Colors.pink,
    size: 24.0,
    semanticLabel: 'Text to announce in accessibility modes',
    );
          break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildItem,
      itemCount: goals.length,
    );
  }
}
