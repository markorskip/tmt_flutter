import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/app_state.dart';

class AppStateRepository implements AbstractAppStateRepository {

  @override
  StorageInterface storage;

  AppStateRepository(this.storage);

  @override
  Future<bool> writeAppState(AppState appState) async {
    if (appState.isAppStateHealthy()) {
      String jsonString = json.encode(appState.toJson());
      storage.writeToLocalFile(jsonString);
      return Future.value(true);
    } else {
      throw Exception("AppState is not healthy. Will not write" + appState.toString());
    }
  }

  @override
  Future<AppState> readAppState() async {
    try {
      final String contents = await storage.readFromLocalFile();
      AppState appState = convertStringToAppState(contents);
      if (appState.isAppStateHealthy()) {
        return appState;
      } throw Exception("App State unhealthy reading"+ appState.toString());
    } catch (e) {
      return Future.value(AppState.defaultAppState());
    }
  }

  AppState convertStringToAppState(String jsonString) {
    Map<String, dynamic> appStateJson = json.decode(jsonString);
    return AppState.fromJson(appStateJson);
  }
  
}

// This is the class that writes the appstate to a string and reads from a JSON string into an appstate
abstract class AbstractAppStateRepository {

  StorageInterface storage;

  AbstractAppStateRepository(this.storage);

  Future<bool> writeAppState(AppState appState);

  Future<AppState> readAppState();
}

class LocalStorage implements StorageInterface {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/goal_storage.txt');
  }
  
  @override
  Future<String> readFromLocalFile() async {
  final File file = await _localFile;
  return await file.readAsString();
  }

  @override
  void writeToLocalFile(String jsonString) async {
    final file = await _localFile;
    Future<File> response = file.writeAsString(jsonString);
  }
}

// This is the code that actually store a String to local file and retrieves a string
abstract class StorageInterface {
  Future<String> readFromLocalFile();
  void writeToLocalFile(String jsonString);

}