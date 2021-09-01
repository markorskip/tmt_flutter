import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import 'model/goal.dart';

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
      Goal error = new Goal("App not loading ", "Improvements to make the house better",0,0);
      goals.add(error);
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

  Future<File> writeAppState(AppState appState) async {
    final file = await _localFile;
    String jsonString = json.encode(appState.toJson());
    print(jsonString);
    return file.writeAsString(jsonString);
  }

  Future<AppState> readAppState() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      Map<String, dynamic> appStateJson = json.decode(contents);
      return AppState.fromJson(appStateJson);
    } catch (e) {
      // If encountering an error, return 0
      // return default goals
      print("error caught");
      print(e);
      return AppState.defaultState();
    }
  }
}

class AppState {
  List<Goal> currentlyDisplayedGoals = [];
  String title = "";
  List<String> titleStack = [];
  List<List<Goal>> goalsStack = [[]];

  AppState();

  Map<String, dynamic> toJson() => {
    'title': title,
    'currentlyDisplayedGoals' : currentlyDisplayedGoals,
    'titleStack' : titleStack,
    'goalsStack' : goalsStack
  };

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    AppState appState = new AppState();
    appState.title = jsonMap["title"];
    var list = jsonMap['currentlyDisplayedGoals'] as List;
    appState.currentlyDisplayedGoals = list.map((i) => Goal.fromJson(i)).toList();

    list = jsonMap['titleStack'] as List;
    appState.titleStack = list.map((e) => e as String).toList();

    list =  jsonMap['goalsStack'] as List;
    list.forEach((element) {
      List innerList = element as List;
      List<Goal> innerGoalList = innerList.map((e) => Goal.fromJson(e)).toList();
      appState.goalsStack.add(innerGoalList);
    });

    return appState;
  }

  static Future<AppState> defaultState() {
    AppState appState = new AppState();
    appState.title = "Learn Time Money TaskList";
    appState.currentlyDisplayedGoals = [new Goal("Welcome to TMT","",0,0)];
    appState.titleStack = [];
    appState.goalsStack = [[]];
    return Future.value(appState);
  }

  @override
  String toString() {
    return 'AppState{currentlyDisplayedGoals: $currentlyDisplayedGoals, title: $title, titleStack: $titleStack, goalsStack: $goalsStack}';
  }
}
