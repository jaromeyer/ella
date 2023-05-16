import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
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
  DateTime _dateTimeNow = DateTime.now();
  String _weatherString = 'Not available';
  int _batteryLevel = 0;
  bool _isCharging = false;

  late final Timer? _oneShotTimer;
  late final Timer? _periodicTimer;

  void _registerPeriodicTimer(void Function() callback) {
    var now = DateTime.now();
    var nextMinute =
        DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);
    // timer to register periodic timer exactly at the next minute
    _oneShotTimer = Timer(nextMinute.difference(now), () {
      _periodicTimer =
          Timer.periodic(const Duration(minutes: 1), (_) => callback());
      callback(); // execute callback the first time
    });
  }

  void _update() async {
    // workaround for timer calling setState on disposed widget
    if (!mounted) return;
    _batteryLevel = await Battery().batteryLevel;
    setState(() => _dateTimeNow = DateTime.now());
    // get weather information
    try {
      http.Response response =
          await http.get(Uri.parse('https://wttr.in/?format=%c%t'));
      setState(() => _weatherString = response.body);
    } on Exception {
      setState(() => _weatherString = 'Not available');
    }
  }

  @override
  void initState() {
    super.initState();
    _update(); // initialize values
    _registerPeriodicTimer(_update);
    // register battery state listener
    Battery().onBatteryStateChanged.listen((BatteryState state) {
      _isCharging = state == BatteryState.charging;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    // make sure timers are correctly stopped
    _oneShotTimer?.cancel();
    _periodicTimer?.cancel();
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
                  DateFormat('HH:mm').format(_dateTimeNow),
                  style: TextStyle(fontSize: 42, color: textColor),
                ),
              ),
            if (settings.getShowDate())
              GestureDetector(
                onTap: () => DeviceApps.openApp(
                  settings.getCalendarPackageName(),
                ),
                child: Text(
                  DateFormat.MMMEd().format(_dateTimeNow),
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
            if (settings.getShowWeather())
              GestureDetector(
                onTap: () {
                  const AndroidIntent(
                    action: 'action_view',
                    data: 'https://wttr.in',
                  ).launch();
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
