import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/repository/app_state_repository.dart';

void main () {
  group('Valid States', () {
    
    AppState appState = AppState.defaultAppState();
    appState.getCurrentGoal().title = "VALID STATE";
    String jsonString = json.encode(appState.toJson());
    AppStateRepository repo = new AppStateRepository(MockStorage(jsonString));
    test('Test reading a valid app state returns a valid app state', () async {
      AppState result = await repo.readAppState();
      expect(result.getCurrentGoal().title, "VALID STATE");
    });
    test('Test writing an valid app state', () {
      repo.writeAppState(AppState.defaultAppState());
    });
  });

    group('Test Invalid States', () {
    
    AppStateRepository repo = new AppStateRepository(BrokenMockStorage());
    test('Test reading an INVALID app state returns default app state', () async {
      AppState result = await repo.readAppState();
      expect(result.getCurrentGoal().title, AppState.defaultAppState().getCurrentGoal().title);
    });
    test('Test writing an INVALID app state', () {
      expect(() => repo.writeAppState(AppState.defaultAppState()), throwsException);
    });
  });
}

class MockStorage extends StorageInterface {

  String contents;

  MockStorage(this.contents);

  @override
  Future<String> readFromLocalFile() {
    return Future.value(this.contents);
  }

  @override
  void writeToLocalFile(String jsonString) {
  }
}

class BrokenMockStorage extends StorageInterface {

  @override
  Future<String> readFromLocalFile() {
    return Future.value("BROKEN");
  }

  @override
  void writeToLocalFile(String jsonString) {
    throw Exception("failure to write to local file");
  }
}