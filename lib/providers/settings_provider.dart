import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Settings extends ChangeNotifier {
  final Box _settingsBox = Hive.box(name: 'settings');

  // getters
  int getAnimationDuration() =>
      _settingsBox.get('animationDurationMs', defaultValue: 500);

  String getCalendarPackageName() =>
      _settingsBox.get('calendarPackageName', defaultValue: "none");

  int getDrawingTimeout() =>
      _settingsBox.get('drawingTimeoutMs', defaultValue: 500);

  double getScalingFactor() =>
      _settingsBox.get('scalingFactor', defaultValue: 1.0);

  bool getShowBattery() => _settingsBox.get('showBattery', defaultValue: true);

  bool getShowClock() => _settingsBox.get('showClock', defaultValue: true);

  bool getShowDate() => _settingsBox.get('showDate', defaultValue: true);

  bool getShowHelp() => _settingsBox.get('showHelp', defaultValue: true);

  bool getShowIcons() => _settingsBox.get('showIcons', defaultValue: true);

  bool getShowNames() => _settingsBox.get('showNames', defaultValue: true);

  bool getShowNextAlarm() =>
      _settingsBox.get('showNextAlarm', defaultValue: true);

  bool getShowSearchString() =>
      _settingsBox.get('showSearchString', defaultValue: true);

  bool getShowWeather() => _settingsBox.get('showWeather', defaultValue: true);

  Color getTextColor() =>
      Color(_settingsBox.get('textColor', defaultValue: Colors.white.value));

  String getWeatherPackageName() =>
      _settingsBox.get('weatherPackageName', defaultValue: "none");

  String getWeatherUrl() => _settingsBox.get('weatherUrl',
      defaultValue: "https://wttr.in/?format=%l:+%c%t");

  // setters
  void setAnimationsDuration(int value) {
    _settingsBox.put('animationDurationMs', value);
    notifyListeners();
  }

  void setCalendarPackageName(String value) {
    _settingsBox.put('calendarPackageName', value);
    notifyListeners();
  }

  void setDrawingTimeout(int value) {
    _settingsBox.put('drawingTimeoutMs', value);
    notifyListeners();
  }

  void setScalingFactor(double value) {
    _settingsBox.put('scalingFactor', value);
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

  void setShowHelp(bool value) {
    _settingsBox.put('showHelp', value);
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

  void setShowNextAlarm(bool value) {
    _settingsBox.put('showNextAlarm', value);
    notifyListeners();
  }

  void setShowSearchString(bool value) {
    _settingsBox.put('showSearchString', value);
    notifyListeners();
  }

  void setShowWeather(bool value) {
    _settingsBox.put('showWeather', value);
    notifyListeners();
  }

  void setTextColor(Color color) {
    _settingsBox.put('textColor', color.value);
    notifyListeners();
  }

  void setWeatherPackageName(String value) {
    _settingsBox.put('weatherPackageName', value);
    notifyListeners();
  }

  void setWeatherUrl(String value) {
    _settingsBox.put('weatherUrl', value);
    notifyListeners();
  }
}
