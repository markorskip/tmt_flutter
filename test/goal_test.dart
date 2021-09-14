
import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/edited_goal.dart';
import 'package:tmt_flutter/model/goal.dart';

void main () {

  test('Test editing a goal works', () {
    Goal goal = new Goal("Goal 1","description",0,0);
    EditGoal editedGoal = new EditGoal("Edited","description 2",5,5);
    editedGoal.complete = true;
    goal.editGoal(editedGoal);
    expect(goal.title, 'Edited');
    expect(goal.description, 'description 2');
    expect(goal.costInDollars, 5.0);
    expect(goal.timeInHours, 5);
    expect(goal.complete, true);
  });
}
