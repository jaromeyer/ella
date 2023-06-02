import 'dart:async';
import 'package:android_intent_plus/android_intent.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class OverviewWidget extends StatefulWidget {
  const OverviewWidget({Key? key}) : super(key: key);

  @override
  State<OverviewWidget> createState() => _OverviewWidgetState();
}

class _OverviewWidgetState extends State<OverviewWidget> {
  final BroadcastReceiver _broadcastReceiver = BroadcastReceiver(
    names: [
      "android.intent.action.TIME_TICK",
      "android.app.action.NEXT_ALARM_CLOCK_CHANGED"
    ],
  );
  late final StreamSubscription<BatteryState> _batteryListener;
  static const platform = MethodChannel('samples.flutter.dev/nextAlarm');
  String _nextAlarm = "Not availale";
  String _weatherString = 'Not available';
  int _batteryLevel = 0;
  bool _isCharging = false;
  bool _alarmSet = false;
  final weekDays = <String>["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  void _update() async {
    _batteryLevel = await Battery().batteryLevel;
    // get weather information
    try {
      http.Response response =
          await http.get(Uri.parse('https://wttr.in/?format=%c%t\n%w'));
      _weatherString = response.body;
    } on Exception {
      _weatherString = 'Not available';
    }
    setState(() {});
  }

  Future<void> _getNextAlarm() async {
    String nextAlarm;
    bool alarmSet = false;
    try {
      final int result = await platform.invokeMethod('getNextAlarm');
      alarmSet = result != -1;

      DateTime resultDate = DateTime.fromMillisecondsSinceEpoch(result);
      String resultWeekDay = weekDays[resultDate.weekday - 1];
      String resultMinutes = (resultDate.minute >= 10)
          ? resultDate.minute.toString()
          : "0${resultDate.minute}";

      int diffMinutes = resultDate.difference(DateTime.now()).inMinutes + 1;

      nextAlarm = "⏰ $resultWeekDay ${resultDate.hour}:$resultMinutes";
      nextAlarm += " (in ";

      if (diffMinutes >= (60 * 24)) {
        nextAlarm += "${diffMinutes ~/ (60 * 24)} ";
        nextAlarm += (diffMinutes >= 2 * 60 * 24) ? "days" : "day";
        diffMinutes %= 60 * 24;
        nextAlarm += (diffMinutes != 0) ? ", " : "";
      }

      if (diffMinutes >= 60) {
        nextAlarm += "${diffMinutes ~/ 60} ";
        nextAlarm += diffMinutes >= 2 * 60 ? "hours" : "hour";
        diffMinutes %= 60;
        nextAlarm += diffMinutes != 0 ? " and " : "";
      }

      nextAlarm += diffMinutes > 0 ? "$diffMinutes " : "";
      nextAlarm += diffMinutes > 1 ? "minutes" : "minute";
      nextAlarm += ")";
    } on PlatformException catch (e) {
      nextAlarm = "Failed to get next alarm: '${e.message}'.";
    }

    setState(() {
      _nextAlarm = nextAlarm;
      _alarmSet = alarmSet;
    });
  }

  @override
  void initState() {
    super.initState();
    _update();
    _getNextAlarm();
    _broadcastReceiver.messages.listen((event) {
      if (event.name == "android.intent.action.TIME_TICK") {
        _update();
        _getNextAlarm();
      }
      if (event.name == "android.app.action.NEXT_ALARM_CLOCK_CHANGED") {
        _getNextAlarm();
      }
    });
    _broadcastReceiver.start();
    // register battery state listener
    _batteryListener = Battery().onBatteryStateChanged.listen((state) {
      setState(() => _isCharging = state == BatteryState.charging);
    });
  }

  @override
  void dispose() {
    _broadcastReceiver.stop;
    _batteryListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (_, settings, __) {
        var textColor = settings.getTextColor();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (settings.getShowClock())
              GestureDetector(
                onTap: () {
                  const AndroidIntent(
                    action: 'android.intent.action.SHOW_ALARMS',
                  ).launch();
                },
                child: Text(
                  DateFormat('HH:mm').format(DateTime.now()),
                  style: TextStyle(fontSize: 42, color: textColor),
                ),
              ),
            if (settings.getShowDate() && _alarmSet)
              GestureDetector(
                onTap: () {
                  const AndroidIntent(
                    action: 'android.intent.action.SHOW_ALARMS',
                  ).launch();
                },
                child: Text(
                  _nextAlarm,
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
            if (settings.getShowDate())
              GestureDetector(
                onTap: () => DeviceApps.openApp(
                  settings.getCalendarPackageName(),
                ),
                child: Text(
                  DateFormat.MMMEd().format(DateTime.now()),
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
            if (settings.getShowWeather())
              GestureDetector(
                onTap: () {
                  if (settings.getUseWeatherApp()) {
                    DeviceApps.openApp(
                      settings.getWeatherPackageName(),
                    );
                  } else {
                    const AndroidIntent(
                      action: 'action_view',
                      data: 'https://wttr.in',
                    ).launch();
                  }
                },
                child: Text(
                  _weatherString,
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
            if (settings.getShowBattery())
              Text(
                _isCharging ? '$_batteryLevel%+' : '$_batteryLevel%',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
          ],
        );
      },
    );
  }
}
