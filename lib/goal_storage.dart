import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'goal.dart';

class GoalStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/goal_storage.txt');
  }

  Future<List<Goal>> readGoals() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      print("Contents written to local storage");
      print(contents);

      String jsonString = contents;
      Map<String, dynamic> goalsJson = json.decode(jsonString);

      Goal rootGoal = Goal.fromJson(goalsJson);
      return rootGoal.goals;
    } catch (e) {
      // If encountering an error, return 0
      // return default goals
      print("error caught");
      print(e);
      List<Goal> goals = [];
      Goal houseUpgrades = new Goal("House Upgrades", "Improvements to make the house better",0,0);
      houseUpgrades.addSubGoal(new Goal("Paint interior","Professional Qoute",6000,5));
      Goal replaceCarpet = new Goal("Replace Carpet","Professional Quote",3500,5);
      replaceCarpet.complete = true;
      houseUpgrades.addSubGoal(replaceCarpet);

      goals.add(houseUpgrades);
      return goals;
    }
  }

  Future<File> writeGoals(List<Goal> goals) async {
    final file = await _localFile;

    Goal rootGoal = new Goal("root goal","used for storage",0,0);
    rootGoal.goals = goals;

    String jsonString = json.encode(rootGoal.toJson());
    print(jsonString);
    return file.writeAsString(jsonString);
  }
}
