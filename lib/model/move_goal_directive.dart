import 'goal.dart';

class MoveGoal {

bool _moveUp = false;
bool _moveDown = false;
Goal goalToMove;
Goal? goalToMoveTo;

MoveGoal(this.goalToMove);

  bool isMoveUp() {
    return _moveUp;
  }

  setGoalToMoveTo(Goal? goalToMoveTo) {
    this.goalToMoveTo = goalToMoveTo;
    this._moveDown = true;
  }

  Goal? getGoalToMoveTo() {
    return goalToMoveTo;
  }

  bool isMoveDown() {
    return _moveDown;
  }

  void setMoveUp(bool bool) {
    this._moveUp = bool;
  }



}
