import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../providers/settings_provider.dart';
import 'app_picker.dart';
import 'color_picker.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
                    value: Slider(
                        value: settings.getDrawingTimeout().toDouble(),
                        min: 0,
                        max: 2000,
                        divisions: 20,
                        label: '${settings.getDrawingTimeout().toString()}ms',
                        onChanged: (value) =>
                            settings.setDrawingTimeout(value.round())),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings
                        .setTextColor(value ? Colors.black : Colors.white),
                    initialValue: settings.getTextColor() == Colors.black,
                    title: const Text(
                        'Dark text on homescreen (for bright wallpapers)'),
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
                    title: const Text('Show date'),
                    initialValue: settings.getShowDate(),
                    onToggle: (value) => settings.setShowDate(value),
                  ),
                  if (settings.getShowDate())
                    SettingsTile(
                      title: const Text('Calendar app'),
                      trailing: Text(settings.getCalendarPackageName()),
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
                  if (settings.getShowWeather())
                    SettingsTile.switchTile(
                      title: const Text('Custom weather app'),
                      initialValue: settings.getUseWeatherApp(),
                      onToggle: (value) => settings.setUseWeatherApp(value),
                    ),
                  if (settings.getShowWeather() && settings.getUseWeatherApp())
                    SettingsTile(
                      title: const Text('Weather app'),
                      trailing: Text(settings.getWeatherPackageName()),
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
                    title: const Text('Enable animations'),
                    initialValue: settings.getEnableAnimations(),
                    onToggle: (value) => settings.setEnableAnimations(value),
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
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
