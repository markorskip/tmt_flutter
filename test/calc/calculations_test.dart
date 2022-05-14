import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/calc/goal_calculator.dart';

void main() {

  Goal _createTestGoal({bool complete = false, double cost = 0.0, double time = 0.0 }) {
    Goal goal = Goal.empty();
    goal.setComplete(complete);
    goal.money = cost;
    goal.time = time;
    return goal;
  }

  Goal _getGoalWithTwoChildrenNotCompleted() {
    Goal parent = Goal.empty();
    Goal sub1 = Goal.empty();
    Goal sub2 = Goal.empty();
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);
    return parent;
  }

  test('Test cost is complete and time is 0 on a goal when they add are 0', () {
    Goal parent = _getGoalWithTwoChildrenNotCompleted();
    double completeCostPercentage = GoalCalc(parent).getCostPercentageComplete();
    double completeTime = GoalCalc(parent).getTimePercentageComplete();
    expect(completeCostPercentage, 1.0);
    expect(completeTime, 0.0);
  });

  test('Test time is 1.0 when time is 0 but all tasks are done', () {
    Goal parent = _getGoalWithTwoChildrenNotCompleted();
    parent.getActiveGoals().forEach((element) {element.setComplete(true);});

    double completeCost = GoalCalc(parent).getCostPercentageComplete();
    double completeTime = GoalCalc(parent).getCostPercentageComplete();
    expect(completeCost, 1.0);
    expect(completeTime, 1.0);
  });

  test('Correct number of complete tasks simple', () {
    double cost = 0.0;
    Goal parent = Goal.empty();
    Goal sub1 = Goal.empty();
    Goal sub2 = Goal.empty();
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);
   // expect(parent.getTasksTotalCount(),2);
    expect(GoalCalc(parent).getTasksTotal(),2);
    parent.goals.forEach((g) { g.setComplete(true);});
    expect(GoalCalc(parent).getTasksTotal(),2);
  });

  test('Correct number of complete tasks grandchildren', () {
    double cost = 0.0;
    Goal parent = Goal.empty();
    Goal sub1 = _createTestGoal(complete: true);
    Goal sub2 = _createTestGoal(complete: true);
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);
    sub2.addSubGoal(_createTestGoal(complete: false));
    sub2.addSubGoal(_createTestGoal(complete: true));
    GC gc = GoalCalc(parent);
    expect(gc.getTasksTotal(),3);
    expect(gc.getTasksComplete(),2);
  });

  test('Correct number of total tasks', () {
    Goal parent = _getGoalWithTwoChildrenNotCompleted();
    expect(GoalCalc(parent).getTasksTotal(),2);
    parent.getActiveGoals().forEach((g) {
      g.addSubGoal(Goal.empty());
    });
    expect(GoalCalc(parent).getTasksTotal(),2);
  });

  test('Time is calculated properly with grandchildren when all time is 0', () {
      Goal parent = _createTestGoal();
      Goal sub1 = _createTestGoal(); // 50 percent complete
      Goal grand1 = _createTestGoal(complete: true);
      Goal grand2 = _createTestGoal();
      sub1.addSubGoal(grand1);
      sub1.addSubGoal(grand2);
      parent.addSubGoal(sub1);
      parent.addSubGoal(_createTestGoal());
      // Parent has two children, one is 50 percent complete, the other is 0
      // We expect the parent to be 25 percent done
      // when totalTime = 0 then use total task / tasksCompleted
      expect(GoalCalc(parent).getTimePercentageComplete(),.33);
  });

  test('Time is calculated properly with grandchildren', () {
    Goal parent = _createTestGoal();
    Goal sub1 = _createTestGoal(complete: true, time: 2.0); // 50 percent complete
    Goal grand1 = _createTestGoal(complete: true, time: 2.0);
    Goal grand2 = _createTestGoal(time: 2.0);
    sub1.addSubGoal(grand1);
    sub1.addSubGoal(grand2);
    parent.addSubGoal(sub1);
    parent.addSubGoal(_createTestGoal(time: 4.0));
    // Parent has two children, one is 50 percent complete, the other is 0
    // We expect the parent to be 25 percent done
    GC gc = GoalCalc(parent);
    expect(gc.getTimeTotal(), 8.0);

    //expect(GoalCalc().getTMTCompleted(parent)[TMT.TIME], 2);
    expect(gc.getTimePercentageComplete(),.25);
  });

  test('Test leafs complete', () {
    Goal parent = _createTestGoal();
    Goal sub1 = _createTestGoal();
    Goal grand1 = _createTestGoal(complete: true);
    Goal grand2 = _createTestGoal(complete: true);
    sub1.addSubGoal(grand1);
    sub1.addSubGoal(grand2);
    parent.addSubGoal(sub1);
    parent.addSubGoal(_createTestGoal());
    GC gc = GoalCalc(parent);
    expect(gc.getTasksTotal(), 3);
    expect(gc.getTasksComplete(),2);
  });
}