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
    num sum = 0;
    goals.forEach((element) {sum += element.getEstimatedTime(); });
    return sum;
  }

  getEstimatedCost() {
    if (goals.length == 0) return costInDollars;
    num sum = 0;
    goals.forEach((element) {sum += element.getEstimatedCost(); });
    return sum;
  }

  getPercentageCompleteCost() {
    if (goals.length == 0 && !complete) return 0;
    if (goals.length == 0 && complete) return 100;
    num sum = 0;
    goals.forEach((element) {sum += element.getPercentageCompleteCost(); });
    return sum;
  }

  getPercentageCompleteTime() {
    if (goals.length == 0 && !complete) return 0;
    if (goals.length == 0 && complete) return 100;
    num sum = 0;
    goals.forEach((element) {sum += element.getPercentageCompleteTime(); });
    return sum;
  }

  String getSubTitle() {
    return "Time: " +  getEstimatedTime().toString() + " hrs. Cost: \$" + getEstimatedCost().toString()
    + "\n # of Subtasks: " + this.goals.length.toString();
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
