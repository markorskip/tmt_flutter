class UserPreferences {

  bool expandedView = false;
  bool detailedView = true;

  static UserPreferences defaultPreferences() {
    return UserPreferences();
  }
}