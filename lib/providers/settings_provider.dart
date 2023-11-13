import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Settings extends ChangeNotifier {
  final Box _settingsBox = Hive.box(name: 'settings');

  // getters
  int getAnimationDuration() =>
      _settingsBox.get('animationDurationMs', defaultValue: 500);

  bool getShowBattery() => _settingsBox.get('showBattery', defaultValue: true);

  bool getShowNextAlarm() =>
      _settingsBox.get('showNextAlarm', defaultValue: true);

  bool getShowHelp() => _settingsBox.get('showHelp', defaultValue: true);

  bool getShowClock() => _settingsBox.get('showClock', defaultValue: true);

  bool getShowDate() => _settingsBox.get('showDate', defaultValue: true);

  bool getShowIcons() => _settingsBox.get('showIcons', defaultValue: true);

  bool getShowNames() => _settingsBox.get('showNames', defaultValue: true);

  bool getShowWeather() => _settingsBox.get('showWeather', defaultValue: true);

  bool getShowSearchString() =>
      _settingsBox.get('showSearchString', defaultValue: true);

  int getDrawingTimeout() =>
      _settingsBox.get('drawingTimeoutMs', defaultValue: 500);

  String getCalendarPackageName() => _settingsBox.get('calendarPackageName',
      defaultValue: "org.lineageos.etar");

  String getWeatherUrl() => _settingsBox.get('weatherUrl',
      defaultValue: "https://wttr.in/?format=%l:+%c%t");

  String getWeatherPackageName() => _settingsBox.get('weatherPackageName',
      defaultValue: "ch.admin.meteoswiss");

  double getScalingFactor() =>
      _settingsBox.get('scalingFactor', defaultValue: 1.0);

  Color getTextColor() =>
      Color(_settingsBox.get('textColor', defaultValue: Colors.white.value));

  // setters
  void setAnimationsDuration(int value) {
    _settingsBox.put('animationDurationMs', value);
    notifyListeners();
  }

  void setShowBattery(bool value) {
    _settingsBox.put('showBattery', value);
    notifyListeners();
  }

  void setShowNextAlarm(bool value) {
    _settingsBox.put('showNextAlarm', value);
    notifyListeners();
  }

  void setShowHelp(bool value) {
    _settingsBox.put('showHelp', value);
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

  void setShowSearchString(bool value) {
    _settingsBox.put('showSearchString', value);
    notifyListeners();
  }

  void setDrawingTimeout(int value) {
    _settingsBox.put('drawingTimeoutMs', value);
    notifyListeners();
  }

  void setCalendarPackageName(String value) {
    _settingsBox.put('calendarPackageName', value);
    notifyListeners();
  }

  void setWeatherUrl(String value) {
    _settingsBox.put('weatherUrl', value);
    notifyListeners();
  }

  void setWeatherPackageName(String value) {
    _settingsBox.put('weatherPackageName', value);
    notifyListeners();
  }

  void setScalingFactor(double value) {
    _settingsBox.put('scalingFactor', value);
    notifyListeners();
  }

  void setTextColor(Color color) {
    _settingsBox.put('textColor', color.value);
    notifyListeners();
  }
}
