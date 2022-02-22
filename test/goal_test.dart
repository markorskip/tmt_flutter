
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/edit_goal_directive.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/calc/goal_calculator.dart';

void main () {

  Goal _createTestGoal({bool complete = false}) {
    Goal goal = new Goal("Test Goal","description",0,0);
    goal.setComplete(complete);
    return goal;
  }

  test('Test editing a goal works', () {
    Goal goal = new Goal("Goal 1","description",0,0);
    EditGoal editedGoal = new EditGoal("Edited","description 2",5,5);
    editedGoal.complete = true;
    goal.editGoal(editedGoal);
    expect(goal.title, 'Edited');
    expect(goal.description, 'description 2');
    expect(goal.costInDollars, 5.0);
    expect(goal.timeInHours, 5);
    expect(goal.isComplete(), true);
  });

  test('test a goal is completable', () {
    Goal goal = _createTestGoal();
    expect(goal.isCompletable(), true);
    goal.addSubGoal(new Goal("Child goal","should no longer be completable",0,0));
    expect(goal.isCompletable(), false);
    goal.getGoals().first.isDeleted = true; // Once we delete all children, a goal should be completable again
    expect(goal.isCompletable(), true);
  });

  test('test no two goals are the same', () {
    Goal goal1 = _createTestGoal();
    Goal goal2 = _createTestGoal();
    expect(goal1 == goal2, false);
  });

  test('isComplete', () {
    Goal goal = _createTestGoal();
    expect(goal.isComplete(), false);
    goal.setComplete(true);
    expect(goal.isComplete(), true);
    goal.addSubGoal(_createTestGoal());
    goal.addSubGoal(_createTestGoal());
    expect(goal.isComplete(), false);
    goal.goals.first.setComplete(true);
    goal.goals[1].setComplete(true);
    expect(goal.isComplete(), true);
  });


}
