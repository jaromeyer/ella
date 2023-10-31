import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class OverviewWidget extends StatefulWidget {
  const OverviewWidget({super.key});

  @override
  State<OverviewWidget> createState() => _OverviewWidgetState();
}

class _OverviewWidgetState extends State<OverviewWidget> {
  final BroadcastReceiver _broadcastReceiver = BroadcastReceiver(
    names: ["android.intent.action.TIME_TICK"],
  );
  late final StreamSubscription<BatteryState> _batteryListener;
  String _weatherString = 'Not available';
  int _batteryLevel = 0;
  bool _isCharging = false;

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

  @override
  void initState() {
    super.initState();
    _update();
    _broadcastReceiver.messages.listen((event) {
      if (event.name == "android.intent.action.TIME_TICK") {
        _update();
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
                onTap: () => DeviceApps.openApp(
                  settings.getCalendarPackageName(),
                ),
                child: Text(
                  DateFormat.MMMEd().format(DateTime.now()),
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
            Text(
              "⏰ Thu 7:35",
              style: TextStyle(fontSize: 16, color: textColor),
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
