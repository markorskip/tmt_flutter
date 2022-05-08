import '../goal.dart';

class MoveGoal {

  bool _moveUp = false;
  Goal _goalToMove;
  Goal? goalToMoveTo;

  MoveGoal(this._goalToMove) {
    this._moveUp = true;
  }

  bool isMoveUp() {
    return _moveUp;
  }

  setGoalToMoveTo(Goal? goalToMoveTo) {
    this.goalToMoveTo = goalToMoveTo;
    this._moveUp = false;
  }

  Goal? getGoalToMoveTo() {
    return goalToMoveTo;
  }

  Goal getGoalToMove() {
    return this._goalToMove;
  }

}
