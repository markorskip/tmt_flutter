import 'package:flutter/material.dart';

import 'package:tmt_flutter/model.dart';

class GoalList extends StatelessWidget {
  final Function deleteHandler;
  final Function addSubGoalHandler;
  GoalList({@required this.goals, this.deleteHandler, this.addSubGoalHandler});

  final List<Goal> goals;

  Widget _buildItem(BuildContext context, int index) {
    final goal = goals[index];

    return ListTile(
      leading: getIconForDepth(goal.levelDeep),
      title: Text(goal.title),
      subtitle: Text(goal.getSubTitle()),
      isThreeLine: true,
      dense: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 20.0,
              color: Colors.brown[900],
            ),
            onPressed: () {
              addSubGoalHandler(goal);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 20.0,
              color: Colors.brown[900],
            ),
            onPressed: (){
              deleteHandler(goal);
            },
          ),
        ],
      ),
 // onTap: navigateToSubTasks,
    );
  }

  getIconForDepth(int levelDeep) {
    switch(levelDeep) {
      case 0: return Icon(
    Icons.airplanemode_active_rounded,
    color: Colors.blue,
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
