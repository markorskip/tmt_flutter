import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/model_helpers/edit_goal_directive.dart';
import 'package:tmt_flutter/model/goal.dart';
void main () {

  Goal _createTestGoal({bool complete = false}) {
    Goal goal = Goal.empty();
    goal.setComplete(complete);
    return goal;
  }

  test('Test editing a goal works', () {
    Goal goal = Goal.empty();
    EditGoal editedGoal = new EditGoal("Edited","description 2",5,5);
    editedGoal.complete = true;
    goal.editGoal(editedGoal);
    expect(goal.title, 'Edited');
    expect(goal.money, 5.0);
    expect(goal.time, 5);
    expect(goal.isComplete(), true);
  });

  test('test a goal is completable', () {
    Goal goal = _createTestGoal();
    expect(goal.isCompletable(), true);
    goal.addSubGoal(Goal.empty());
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


