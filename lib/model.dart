class Goal {
  String title;
  String description;
  double costInDollars;
  int timeInHours;
  bool complete = false;
  bool isDeleted = false;
  int levelDeep = 0;  // start at 0

  List<Goal> goals = [];

  Goal(this.title, this.description, this.costInDollars, this.timeInHours, this.levelDeep);

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
    return description + "\nEstimated Time: " +  getEstimatedTime().toString() + " hours. Estimated Cost: " + getEstimatedCost().toString() + " dollars";
  }

  delete() {
    this.isDeleted = true;
  }

  restore() {
    this.isDeleted = false;
  }


}
