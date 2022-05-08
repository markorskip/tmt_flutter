import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lzstring/lzstring.dart';
import '../app_state.dart';

final String defaultAppStateString = '''
      {"goalStack":[{"id":298699,"title":"Time Money Task List","description":"root never should be displayed","costInDollars":0.0,"timeInHours":0,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[{"id":180478,"title":"App instructions ","description":"Welcome to TMT","costInDollars":0.0,"timeInHours":0,"complete":false,"isDeleted":false,"levelDeep":1,"goals":[{"id":663477,"title":"Slide task right to edit","description":"","costInDollars":0.0,"timeInHours":0.016,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]},{"id":721323,"title":"Slide task right to move to a different task","description":"","costInDollars":0.0,"timeInHours":0.016,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]},{"id":361509,"title":"Slide task left for delete option","description":"","costInDollars":0.0,"timeInHours":0.016,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]},{"id":166898,"title":"Parent tasks show percentage time complete","description":"","costInDollars":0.0,"timeInHours":0.016,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]},{"id":569918,"title":"Parent task shows % money complete","description":"","costInDollars":0.0,"timeInHours":0.016,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]}]},{"id":91755,"title":"test","description":"","costInDollars":0.0,"timeInHours":0,"complete":false,"isDeleted":true,"levelDeep":0,"goals":[]},{"id":643259,"title":"test 3","description":"","costInDollars":0.0,"timeInHours":0,"complete":false,"isDeleted":true,"levelDeep":0,"goals":[]},{"id":216859,"title":"DEMO: Home Improvement Project","description":"","costInDollars":0.0,"timeInHours":0,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[{"id":780486,"title":"Remodel Kitchen","description":"","costInDollars":0.0,"timeInHours":0,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[{"id":23455,"title":"Replace Cabinets","description":"","costInDollars":0.0,"timeInHours":0,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[{"id":123299,"title":"Research cabinets","description":"","costInDollars":0.0,"timeInHours":4,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]},{"id":111098,"title":"Buy cabinets","description":"","costInDollars":10000.0,"timeInHours":0,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]}]},{"id":105468,"title":"Replace Counter Tops","description":"","costInDollars":2000.0,"timeInHours":32,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]},{"id":51672,"title":"Replace Appliances","description":"","costInDollars":0.0,"timeInHours":0,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[{"id":844576,"title":"Research appliance packages","description":"","costInDollars":0.0,"timeInHours":8,"complete":true,"isDeleted":false,"levelDeep":0,"goals":[]},{"id":240203,"title":"Purchase appliance package","description":"","costInDollars":8000.0,"timeInHours":1,"complete":true,"isDeleted":false,"levelDeep":0,"goals":[]},{"id":164231,"title":"Install Appliances","description":"","costInDollars":0.0,"timeInHours":8,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]}]}]},{"id":659541,"title":"Paint Living Room","description":"","costInDollars":100.0,"timeInHours":8,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]},{"id":397166,"title":"Paint Office","description":"","costInDollars":50.0,"timeInHours":2,"complete":false,"isDeleted":false,"levelDeep":0,"goals":[]}]}]}]}
      ''';

class FirestoreStorage implements ReadWriteAppState {

  final String appStateId = 'demo';
  
  @override
  Future<AppState> readAppState(String userId) async {

    DocumentSnapshot<Map<String, dynamic>> ref = await FirebaseFirestore
        .instance
        .collection('appState')
        .doc(userId)
        .get();

    var json = ref.data()!["appStateString"];

    if (json != null) {
      AppState appState = await convertCompressedStringToAppState(json);
      return Future.value(appState);
    }

    return Future.value(convertStringToAppState(defaultAppStateString));
  }

  @override
  Future<bool> writeAppState(AppState appState) async {
    String compressedJsonString = await convertAppStateToCompressedString(appState);
    Map<String, dynamic> dataToSave = {"appStateString": compressedJsonString };

    Future<void> save = FirebaseFirestore
        .instance
        .collection('appState')
        .doc(appStateId)
        .set(dataToSave);

    print("Attempting to save:");
    bool success = false;
    await save.then((value) => success = true)
    .onError((error, stackTrace) => success = false);

    print("Savings... Success:" + success.toString());
    return Future.value(success);
  }
}

class LocalGoalStorage implements ReadWriteAppState {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/goal_storage.txt');
  }

  @override
  Future<bool> writeAppState(AppState appState) async {
    if (appState.isAppStateHealthy()) {
      String jsonString = json.encode(appState.toJson());
      final file = await _localFile;
      Future<File> response = file.writeAsString(jsonString);
      return Future.value(true);
    } else {
      throw Exception("AppState is not healthy. Will not write" + appState.toString());
    }
  }

  @override
  Future<AppState> readAppState(String userId) async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      AppState appState = convertStringToAppState(contents);
      if (appState.isAppStateHealthy()) {
        return appState;
      } throw Exception("App State unhealthy reading"+ appState.toString());
    } catch (e) {
      // If encountering an error, return 0
      // return default goals

      AppState appState = convertStringToAppState(defaultAppStateString);
      if (appState.isAppStateHealthy()) {
        return appState;
      }
      return Future.value(AppState.defaultAppState());
    }
  }
}

Future<String> convertAppStateToCompressedString(AppState appState) async {
  String result = json.encode(appState.toJson());
  return await LZString.compressToBase64(result) ?? "";
}

Future<AppState> convertCompressedStringToAppState(String compressed) async {
  String? decompressedJson = await LZString.decompressFromBase64(compressed);
  if (decompressedJson != null){
    AppState as = convertStringToAppState(decompressedJson);
    return as;
  }
  return AppState.defaultAppState();
}

AppState convertStringToAppState(String jsonString) {
  Map<String, dynamic> appStateJson = json.decode(jsonString);
  return AppState.fromJson(appStateJson);
}

abstract class ReadWriteAppState {

  Future<bool> writeAppState(AppState appState);

  Future<AppState> readAppState(String userID);
}


