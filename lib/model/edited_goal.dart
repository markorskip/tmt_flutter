
class EditGoal {
  String title;
  String? description;
  double costInDollars = 0.0;
  int timeInHours = 0;
  bool complete = false;

  EditGoal(this.title, this.description, this.costInDollars,
      this.timeInHours);

}
