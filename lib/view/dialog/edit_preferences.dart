import 'package:flutter/cupertino.dart';
import 'package:tmt_flutter/model/user_preferences.dart';

class EditPreferences extends StatelessWidget {

  EditPreferences(UserPreferences userPreferences);

  UserPreferences? get userPreferences => null;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  UserPreferences? edit() {
    return this.userPreferences;
  }
}