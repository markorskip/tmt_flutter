
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/edit_goal_directive.dart';
import 'package:tmt_flutter/model/goal.dart';

void main () {

  Goal createTestGoal({bool complete = false}) {
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

  Goal _getGoalWithTwoChildrenNotCompleted() {
    double cost = 0.0; // TODO refactor
    Goal parent = Goal("Test Goal","description",cost,0);
    Goal sub1 = Goal("child 1","description",cost,0);
    Goal sub2 = Goal("child 2","description",cost,0);
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);
    return parent;
  }

  test('Test cost and time is complete on a goal when they add are 0', () {
    Goal parent = _getGoalWithTwoChildrenNotCompleted();
    double completeCost = parent.getPercentageCompleteCost();
    double completeTime = parent.getPercentageCompleteTime();
    expect(completeCost, 1.0);
    expect(completeTime, 0.0);
  });


  test('Correct number of complete tasks simple', () {
    double cost = 0.0; // TODO refactor
    Goal parent = Goal("Test Goal","description",cost,0);
    Goal sub1 = Goal("child 1","description",cost,0);
    Goal sub2 = Goal("child 2","description",cost,0);
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);

    //expect(sub1.getTasksComplete(),0);
    //expect(sub2.getTasksComplete(),0);

    expect(parent.getTasksTotalCount(),2);
    //expect(parent.getTasksComplete(),0);

    parent.goals.forEach((g) { g.setComplete(true);});
    expect(sub1.getTasksCompleteRecursive(),1);
    expect(sub2.getTasksCompleteRecursive(),1);
    expect(parent.getTasksComplete(),2);
  });

  test('Correct number of complete tasks grandchildren', () {
    double cost = 0.0;
    Goal parent = Goal("Test Goal","description",cost,0);
    Goal sub1 = createTestGoal(complete: true);
    Goal sub2 = createTestGoal(complete: true);
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);

    sub2.addSubGoal(createTestGoal(complete: true));
    sub2.addSubGoal(createTestGoal(complete: true));

    expect(parent.getTasksTotalCount(),4);
    expect(parent.getTasksComplete(),4);
  });

  test('Correct number of total tasks', () {
    Goal parent = _getGoalWithTwoChildrenNotCompleted();
    expect(parent.getTasksTotalCount(),2);
    parent.getActiveGoals().forEach((g) {
      g.addSubGoal(new Goal("3rd level","test",0.0,0.0));
    });
    expect(parent.getTasksTotalCount(),4);
  });

  test('isComplete', () {
    Goal goal = createTestGoal();
    expect(goal.isComplete(), false);
    goal.setComplete(true);
    expect(goal.isComplete(), true);
    goal.addSubGoal(createTestGoal());
    goal.addSubGoal(createTestGoal());
    expect(goal.isComplete(), false);
    goal.goals.first.setComplete(true);
    goal.goals[1].setComplete(true);
    expect(goal.isComplete(), true);
    expect(goal.getTasksTotalCount(),2);
  });
}
