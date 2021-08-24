class Goal {
  String title;
  String description;
  double costInDollars;
  int timeInHours;
  bool complete;
  bool isDeleted;
  int levelDeep = 0;  // start at 0

  List<Goal> goals = [];

  Goal(this.title, this.description, this.costInDollars, this.timeInHours) {
    this.levelDeep = 0;
    this.isDeleted = false;
    this.complete = false;
  }

  getEstimatedTime() {
    if (goals.length == 0) return timeInHours;
  }

  getEstimatedCost() {
    if (goals.length == 0) return costInDollars;
  }

  getPercentageCompleteCost() {
    if (goals.length == 0 && !complete) return 0;
    if (goals.length == 0 && complete) return 100;
  }

  getPercentageCompleteTime() {
    if (goals.length == 0 && !complete) return 0;
    if (goals.length == 0 && complete) return 100;
  }

  String getSubTitle() {
    return description + "\nEstimated Time: " +  getEstimatedTime().toString() + " hours. Estimated Cost: " + getEstimatedCost().toString() + " dollars." +
    "# of Subtasks: " + this.goals.length.toString();
  }

  delete() {
    this.isDeleted = true;
  }

  restore() {
    this.isDeleted = false;
  }

  addSubGoal(Goal goal) {
    goal.levelDeep = this.levelDeep + 1;
    this.goals.add(goal);
  }


}
