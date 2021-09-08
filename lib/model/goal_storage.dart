import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import 'app_state.dart';
import 'goal.dart';

class GoalStorage implements ReadWriteAppState {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/goal_storage.txt');
  }

  @override
  Future<File> writeAppState(AppState appState) async {
    final file = await _localFile;
    String jsonString = json.encode(appState.toJson());
    return file.writeAsString(jsonString);
  }

  @override
  Future<AppState> readAppState() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      Map<String, dynamic> appStateJson = json.decode(contents);
      return AppState.fromJson(appStateJson);
    } catch (e) {
      // If encountering an error, return 0
      // return default goals
      print("error caught $e");
      return AppState.defaultState();
    }
  }
}

abstract class ReadWriteAppState {

  Future<File> writeAppState(AppState appState);

  Future<AppState> readAppState();
}


