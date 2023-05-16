import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../providers/settings_provider.dart';
import '../utils/cached_image.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<Settings>(
        builder: (context, settings, child) {
          return SettingsList(
            sections: [
              SettingsSection(
                title: const Text('General'),
                tiles: <AbstractSettingsTile>[
                  SettingsTile(
                    onPressed: (_) => showAboutDialog(
                        context: context,
                        applicationVersion: '0.0.1',
                        applicationIcon: const Image(
                          image: AssetImage('assets/icon.png'),
                          height: 40,
                        ),
                        applicationLegalese: 'Licensed under the GPLv3'),
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About ella'),
                  ),
                  SettingsTile(
                    onPressed: (_) {
                      const AndroidIntent(
                              action: 'android.settings.HOME_SETTINGS')
                          .launch();
                    },
                    leading: const Icon(Icons.home),
                    title: const Text('Change default launcher'),
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
                    onToggle: (value) => settings.setShowClock(value),
                    initialValue: settings.getShowClock(),
                    title: const Text('Show clock'),
                  ),
                  if (settings.getShowClock())
                    SettingsTile(
                        title: const Text('(placeholder) Pick clock app')),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowDate(value),
                    initialValue: settings.getShowDate(),
                    title: const Text('Show date'),
                  ),
                  if (settings.getShowDate())
                    SettingsTile(
                        title: const Text('(placeholder) Pick calendar app')),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowWeather(value),
                    initialValue: settings.getShowWeather(),
                    title: const Text('Show weather'),
                  ),
                  if (settings.getShowWeather())
                    SettingsTile(
                        title: const Text(
                            '(placeholder) Configure weather format')),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowBattery(value),
                    initialValue: settings.getShowBattery(),
                    title: const Text('Show battery'),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('App list'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setEnableAnimations(value),
                    initialValue: settings.getEnableAnimations(),
                    title: const Text('Enable animations'),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowIcons(value),
                    initialValue: settings.getShowIcons(),
                    title: const Text('Show icons'),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowNames(value),
                    initialValue: settings.getShowNames(),
                    title: const Text('Show names'),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Developer settings'),
                tiles: <SettingsTile>[
                  SettingsTile(
                    onPressed: (_) => CachedMemoryImage.clearCache(),
                    title: const Text('Clear icon cache'),
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
