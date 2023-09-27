import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Settings extends ChangeNotifier {
  final Box _settingsBox = Hive.box('settings');

  // getters
  Color getBackgroundColor() => Color(_settingsBox.get('backgroundColor',
      defaultValue: Colors.transparent.value));

  bool getEnableAnimations() =>
      _settingsBox.get('enableAnimations', defaultValue: true);

  bool getShowBattery() => _settingsBox.get('showBattery', defaultValue: true);

  bool getShowHelp() => _settingsBox.get('showHelp', defaultValue: true);

  bool getShowClock() => _settingsBox.get('showClock', defaultValue: true);

  bool getShowDate() => _settingsBox.get('showDate', defaultValue: true);

  bool getShowIcons() => _settingsBox.get('showIcons', defaultValue: true);

  bool getShowNames() => _settingsBox.get('showNames', defaultValue: true);

  bool getShowWeather() => _settingsBox.get('showWeather', defaultValue: true);

  bool getUseWeatherApp() =>
      _settingsBox.get('useWeatherApp', defaultValue: false);

  int getDrawingTimeout() =>
      _settingsBox.get('drawingTimeoutMs', defaultValue: 500);

  String getCalendarPackageName() => _settingsBox.get('calendarPackageName',
      defaultValue: "org.lineageos.etar");

  String getWeatherPackageName() => _settingsBox.get('weatherPackageName',
      defaultValue: "org.lineageos.etar");

  double getScalingFactor() =>
      _settingsBox.get('scalingFactor', defaultValue: 1.0);

  Color getTextColor() =>
      Color(_settingsBox.get('textColor', defaultValue: Colors.white.value));

  // setters
  void setBackgroundColor(Color color) {
    _settingsBox.put('backgroundColor', color.value);
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

  void setUseWeatherApp(bool value) {
    _settingsBox.put('useWeatherApp', value);
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
