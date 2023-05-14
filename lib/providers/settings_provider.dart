import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Settings extends ChangeNotifier {
  final Box _settingsBox = Hive.box('settings');

  bool getDarkText() => _settingsBox.get('darkText', defaultValue: false);

  bool getEnableAnimations() =>
      _settingsBox.get('enableAnimations', defaultValue: true);

  bool getShowBattery() => _settingsBox.get('showBattery', defaultValue: true);

  bool getShowClock() => _settingsBox.get('showClock', defaultValue: true);

  bool getShowDate() => _settingsBox.get('showDate', defaultValue: true);

  bool getShowIcons() => _settingsBox.get('showIcons', defaultValue: true);

  bool getShowNames() => _settingsBox.get('showNames', defaultValue: true);

  bool getShowWeather() => _settingsBox.get('showWeather', defaultValue: true);

  int getDrawingTimeout() =>
      _settingsBox.get('drawingTimeoutMs', defaultValue: 500);

  String getCalendarPackageName() => _settingsBox.get('calendarPackageName',
      defaultValue: "org.lineageos.etar");

  void setDarkText(bool value) {
    _settingsBox.put('darkText', value);
    notifyListeners();
  }

  void setEnableAnimations(bool value) {
    _settingsBox.put('enableAnimations', value);
    notifyListeners();
  }

  void setShowBattery(bool value) {
    _settingsBox.put('showBattery', value);
    notifyListeners();
  }

  void setShowClock(bool value) {
    _settingsBox.put('showClock', value);
    notifyListeners();
  }

  void setShowDate(bool value) {
    _settingsBox.put('showDate', value);
    notifyListeners();
  }

  void setShowIcons(bool value) {
    _settingsBox.put('showIcons', value);
    notifyListeners();
  }

  void setShowNames(bool value) {
    _settingsBox.put('showNames', value);
    notifyListeners();
  }

  void setShowWeather(bool value) {
    _settingsBox.put('showWeather', value);
    notifyListeners();
  }

  void setDrawingTimeout(int value) {
    _settingsBox.put('drawingTimeoutMs', value);
    notifyListeners();
  }
}
