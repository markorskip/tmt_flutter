
import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/edit_goal_directive.dart';
import 'package:tmt_flutter/model/goal.dart';

void main () {

  Goal createTestGoal() {
    return new Goal("Test Goal","description",0,0);
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
    expect(goal.complete, true);
  });


  test('test a goal is completable', () {
    Goal goal = createTestGoal();
    expect(goal.isCompletable(), true);
    goal.addSubGoal(new Goal("Child goal","should no longer be completable",0,0));
    expect(goal.isCompletable(), false);
    goal.getGoals().first.isDeleted = true; // Once we delete all children, a goal should be completable again
    expect(goal.isCompletable(), true);
  });

  test('test no two goals are the same', () {
    Goal goal1 = createTestGoal();
    Goal goal2 = createTestGoal();
    expect(goal1 == goal2, false);
  });

  test('Test cost and time is complete on a goal when they add are 0', () {
    double cost = 0.0;
    Goal parent = Goal("Test Goal","description",cost,0);
    Goal sub1 = Goal("Test Goal","description",cost,0);
    Goal sub2 = Goal("Test Goal","description",cost,0);
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);
    double completeCost = parent.getPercentageCompleteCost();
    double completeTime = parent.getPercentageCompleteTime();
    expect(completeCost, 1.0);
    expect(completeTime, 1.0);
  });

}
