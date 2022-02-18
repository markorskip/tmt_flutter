import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/goal.dart';
import 'package:tmt_flutter/model/goal_calculator.dart';

void main() {

  Goal _createTestGoal({bool complete = false, double cost = 0.0, double time = 0.0 }) {
    Goal goal = new Goal("Test Goal","description",cost,time);
    goal.setComplete(complete);
    return goal;
  }

  Goal _getGoalWithTwoChildrenNotCompleted() {
    Goal parent = Goal("Test Goal","description",0.0,0);
    Goal sub1 = Goal("child 1","description",0.0,0);
    Goal sub2 = Goal("child 2","description",0.0,0);
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);
    return parent;
  }

  test('Test cost is complete and time is 0 on a goal when they add are 0', () {
    Goal parent = _getGoalWithTwoChildrenNotCompleted();
    double completeCostPercentage = GoalCalc().getTMTPercentageComplete(parent).costInDollars;
    double completeTime = GoalCalc().getTMTPercentageComplete(parent).timeInHours;
    expect(completeCostPercentage, 1.0);
    expect(completeTime, 0.0);
  });

  test('Test time is 1.0 when time is 0 but all tasks are done', () {
    Goal parent = _getGoalWithTwoChildrenNotCompleted();
    parent.getActiveGoals().forEach((element) {element.setComplete(true);});

    double completeCost = GoalCalc().getTMTPercentageComplete(parent).costInDollars;
    double completeTime = GoalCalc().getTMTPercentageComplete(parent).costInDollars;
    expect(completeCost, 1.0);
    expect(completeTime, 1.0);
  });

  test('Correct number of complete tasks simple', () {
    double cost = 0.0; // TODO refactor
    Goal parent = Goal("Test Goal","description",cost,0);
    Goal sub1 = Goal("child 1","description",cost,0);
    Goal sub2 = Goal("child 2","description",cost,0);
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);
   // expect(parent.getTasksTotalCount(),2);
    expect(GoalCalc().getTMTTotal(parent).tasks,2);
    parent.goals.forEach((g) { g.setComplete(true);});
    expect(GoalCalc().getTMTCompleted(parent).tasks,2);
  });

  test('Correct number of complete tasks grandchildren', () {
    double cost = 0.0;
    Goal parent = Goal("Test Goal","description",cost,0);
    Goal sub1 = _createTestGoal(complete: true);
    Goal sub2 = _createTestGoal(complete: true);
    parent.addSubGoal(sub1);
    parent.addSubGoal(sub2);
    sub2.addSubGoal(_createTestGoal(complete: false));
    sub2.addSubGoal(_createTestGoal(complete: true));
    expect(GoalCalc().getTMTTotal(parent).tasks,3);
    expect(GoalCalc().getTMTCompleted(parent).tasks,2);
  });

  test('Correct number of total tasks', () {
    Goal parent = _getGoalWithTwoChildrenNotCompleted();
    expect(GoalCalc().getTMTTotal(parent).tasks,2);
    parent.getActiveGoals().forEach((g) {
      g.addSubGoal(new Goal("3rd level","test",0.0,0.0));
    });
    expect(GoalCalc().getTMTTotal(parent).tasks,2);
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
      expect(GoalCalc().getTMTPercentageComplete(parent).timeInHours,.33);
  });

  test('Time is calculated properly with grandchildren', () {
    Goal parent = _createTestGoal();
    Goal sub1 = _createTestGoal(); // 50 percent complete
    Goal grand1 = _createTestGoal(complete: true, time: 2.0);
    Goal grand2 = _createTestGoal(time: 2.0);
    sub1.addSubGoal(grand1);
    sub1.addSubGoal(grand2);
    parent.addSubGoal(sub1);
    parent.addSubGoal(_createTestGoal(time: 4.0));
    // Parent has two children, one is 50 percent complete, the other is 0
    // We expect the parent to be 25 percent done
    expect(GoalCalc().getTMTTotal(parent).timeInHours, 8.0);

    //expect(GoalCalc().getTMTCompleted(parent)[TMT.TIME], 2);
    expect(GoalCalc().getTMTPercentageComplete(parent).timeInHours,.25);
  });

  test('Test leafs complete', () {
    Goal parent = _createTestGoal();
    Goal sub1 = _createTestGoal(); // 50 percent complete
    Goal grand1 = _createTestGoal(complete: true);
    Goal grand2 = _createTestGoal(complete: true);
    sub1.addSubGoal(grand1);
    sub1.addSubGoal(grand2);
    parent.addSubGoal(sub1);
    parent.addSubGoal(_createTestGoal());
    expect(GoalCalc().getTMTTotal(parent).tasks, 3);
    expect(GoalCalc().getTMTCompleted(parent).tasks,2);

  });
}