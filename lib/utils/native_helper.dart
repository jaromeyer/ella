import 'package:flutter/services.dart';

class NativeHelper {
  static const platform = MethodChannel('samples.flutter.dev/nextAlarm');

  static Future<DateTime?> getNextAlarm() async {
    var result = await platform.invokeMethod('getNextAlarm');
    if (result == -1) {
      return null;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(result);
    }
  }

  static Future<int> getBatteryPercentage() async {
    return await platform.invokeMethod('getBatteryPercentage');
  }
}
