import 'dart:async';
import 'dart:developer';

import 'package:android_intent_plus/android_intent.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../utils/native_helper.dart';
import '../utils/string_utils.dart';

class OverviewWidget extends StatefulWidget {
  const OverviewWidget({super.key});

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
  String _nextAlarm = "Not available";
  String _weatherString = 'Not available';
  DateTime _lastWeatherUpdate = DateTime.now();
  int _batteryLevel = 0;
  bool _isCharging = false;

  void _updateWeather(String weatherUrl) async {
    try {
      http.Response response =
          await http.get(Uri.parse(weatherUrl));
      _weatherString = response.body;
      _lastWeatherUpdate = DateTime.now();
      setState(() {});
    } on Exception {
      log("failed to retrieve weather");
    }
  }

  void _updateBattery() async {
    _batteryLevel = await Battery().batteryLevel;
    setState(() {});
  }

  void _updateAlarm() async {
    try {
      DateTime? nextAlarm = await NativeHelper.getNextAlarm();
      if (nextAlarm == null) {
        _nextAlarm = "⏰ No alarm set";
      } else {
        String timeString = DateFormat('EE HH:mm').format(nextAlarm);
        String durationString = StringUtils.formatDuration(
            nextAlarm.difference(DateTime.now()),
            precision: 2);
        _nextAlarm = "⏰ $timeString ($durationString)";
      }
    } on Exception {
      _nextAlarm = "Not available";
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // initial update
    _updateWeather(context.read<Settings>().getWeatherUrl());
    _updateBattery();
    _updateAlarm();

    // register receivers to trigger subsequent updates
    _broadcastReceiver.messages.listen((event) {
      if (event.name == "android.intent.action.TIME_TICK") {
        // update weather if last successful update was at least 15 minutes ago
        if (DateTime.now().difference(_lastWeatherUpdate) >
            const Duration(minutes: 15)) {
          _updateWeather(context.read<Settings>().getWeatherUrl());
        }
        _updateBattery();
        _updateAlarm();
      }
      if (event.name == "android.app.action.NEXT_ALARM_CLOCK_CHANGED") {
        _updateAlarm();
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
            if (settings.getShowDate())
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
                onTap: () =>
                    DeviceApps.openApp(settings.getCalendarPackageName()),
                child: Text(
                  DateFormat.MMMEd().format(DateTime.now()),
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
            if (settings.getShowWeather())
              GestureDetector(
                onTap: () =>
                    DeviceApps.openApp(settings.getWeatherPackageName()),
                child: Text(
                  "$_weatherString (${StringUtils.formatDuration(_lastWeatherUpdate.difference(DateTime.now()))})",
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
