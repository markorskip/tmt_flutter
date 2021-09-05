
class EditedGoal {
  String title;
  String? description;
  double costInDollars = 0.0;
  int timeInHours = 0;
  bool complete = false;
  bool moveUp = false;


  EditedGoal(this.title, this.description, this.costInDollars,
      this.timeInHours);

}
