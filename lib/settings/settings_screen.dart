import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../providers/settings_provider.dart';
import 'app_picker.dart';
import 'color_picker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<Settings>(
        builder: (context, settings, _) {
          return SettingsList(
            sections: [
              SettingsSection(
                title: const Text('General'),
                tiles: <AbstractSettingsTile>[
                  SettingsTile(
                    title: const Text('About ella'),
                    leading: const Icon(Icons.info_outline),
                    onPressed: (_) => showAboutDialog(
                        context: context,
                        applicationVersion: '1.0.0',
                        applicationIcon: const Image(
                          image: AssetImage('assets/icon.png'),
                          height: 40,
                        ),
                        applicationLegalese: 'Licensed under the GPLv3'),
                  ),
                  SettingsTile(
                    title: const Text('Change default launcher'),
                    leading: const Icon(Icons.home),
                    onPressed: (_) {
                      const AndroidIntent(
                        action: 'android.settings.HOME_SETTINGS',
                      ).launch();
                    },
                  ),
                  SettingsTile(
                    title: const Text('Gesture timeout'),
                    trailing: Text('${settings.getDrawingTimeout()} ms'),
                    value: Slider(
                        value: settings.getDrawingTimeout().toDouble(),
                        min: 0,
                        max: 2000,
                        divisions: 20,
                        label: '${settings.getDrawingTimeout()} ms',
                        onChanged: (value) =>
                            settings.setDrawingTimeout(value.round())),
                  ),
                  SettingsTile(
                    title: const Text('Text color'),
                    trailing: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: settings.getTextColor(),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).highlightColor, width: 2),
                      ),
                    ),
                    onPressed: (_) => showColorPicker(
                      context: context,
                      onColorSelected: settings.setTextColor,
                      initialColor: settings.getTextColor(),
                    ),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Overview'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    title: const Text('Show clock'),
                    initialValue: settings.getShowClock(),
                    onToggle: (value) => settings.setShowClock(value),
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Show next alarm'),
                    initialValue: settings.getShowNextAlarm(),
                    onToggle: (value) => settings.setShowNextAlarm(value),
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Show date'),
                    initialValue: settings.getShowDate(),
                    onToggle: (value) => settings.setShowDate(value),
                  ),
                  SettingsTile(
                    title: const Text('Calendar app'),
                    description: Text(settings.getCalendarPackageName()),
                    trailing: const Icon(Icons.arrow_forward),
                    enabled: settings.getShowDate(),
                    onPressed: (_) {
                      showAppPicker(
                        context: context,
                        title: "Pick calendar app",
                        onAppPicked: (app) =>
                            settings.setCalendarPackageName(app.packageName),
                      );
                    },
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Show weather'),
                    initialValue: settings.getShowWeather(),
                    onToggle: (value) => settings.setShowWeather(value),
                  ),
                  SettingsTile(
                    title: const Text('Weather query URL'),
                    enabled: settings.getShowWeather(),
                    value: TextFormField(
                      onFieldSubmitted: (value) {
                        settings.setWeatherUrl(value);
                      },
                      initialValue: settings.getWeatherUrl(),
                    ),
                  ),
                  SettingsTile(
                    title: const Text('Weather app'),
                    description: Text(settings.getWeatherPackageName()),
                    trailing: const Icon(Icons.arrow_forward),
                    enabled: settings.getShowWeather(),
                    onPressed: (_) {
                      showAppPicker(
                        context: context,
                        title: "Pick weather app",
                        onAppPicked: (app) =>
                            settings.setWeatherPackageName(app.packageName),
                      );
                    },
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Show battery'),
                    initialValue: settings.getShowBattery(),
                    onToggle: (value) => settings.setShowBattery(value),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('App list'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    title: const Text('Show search string'),
                    initialValue: settings.getShowSearchString(),
                    onToggle: (value) => settings.setShowSearchString(value),
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Show icons'),
                    initialValue: settings.getShowIcons(),
                    onToggle: (value) => settings.setShowIcons(value),
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Show names'),
                    initialValue: settings.getShowNames(),
                    onToggle: (value) => settings.setShowNames(value),
                  ),
                  SettingsTile(
                    title: const Text('Animation duration'),
                    trailing: Text('${settings.getAnimationDuration()} ms'),
                    value: Slider(
                        value: settings.getAnimationDuration().toDouble(),
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        label: '${settings.getAnimationDuration()} ms',
                        onChanged: (value) =>
                            settings.setAnimationsDuration(value.round())),
                  ),
                  SettingsTile(
                    title: const Text('Scale factor'),
                    trailing: Text(settings.getScalingFactor().toString()),
                    value: Slider(
                        value: settings.getScalingFactor(),
                        min: 0.5,
                        max: 1.5,
                        divisions: 10,
                        label: settings.getScalingFactor().toString(),
                        onChanged: (value) => settings.setScalingFactor(value)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
