
import 'package:flutter_test/flutter_test.dart';
import 'package:lzstring/lzstring.dart';
import 'package:tmt_flutter/model/app_state.dart';
import 'package:tmt_flutter/model/goal_storage.dart';

void main() {

  test("LZString", () async {
    String input = "Dart implemntation of lz-string";
    print('Input: $input');
    print('Compressed String: ${await LZString.compress(input)}');
    print('Compressed Base 64 String: ${await LZString.compressToBase64(input)}');
    print('Compressed UTF16 String: ${await LZString.compressToUTF16(input)}');
    print(
    'Compressed Encoded URI Component: ${await LZString.compressToEncodedURIComponent(input)}');
    print('Compressed Uint8 Array: ${await LZString.compressToUint8Array(input)}');
  });

  test("Compressing an app state and back", () async {
    AppState testAppState = AppState.defaultAppState();
    String compressed = await convertAppStateToCompressedString(testAppState) ?? "";
    print(compressed.length);
    AppState uncompressed = await convertCompressedStringToAppState(compressed);
    print(uncompressed.toJson().length);
    expect(uncompressed.isAppStateHealthy(), true);
  });




}