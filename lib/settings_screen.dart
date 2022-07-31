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
              const SettingsSection(
                title: Text('General'),
                tiles: <SettingsTile>[],
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
                    SettingsTile(title: const Text('Pick clock app')),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowDate(value),
                    initialValue: settings.getShowDate(),
                    title: const Text('Show date'),
                  ),
                  if (settings.getShowDate())
                    SettingsTile(title: const Text('Pick calendar app')),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowWeather(value),
                    initialValue: settings.getShowWeather(),
                    title: const Text('Show weather'),
                  ),
                  if (settings.getShowWeather())
                    SettingsTile(title: const Text('Configure weather format')),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowBattery(value),
                    initialValue: settings.getShowBattery(),
                    title: const Text('Show battery'),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Launcher'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setEnableAnimations(value),
                    initialValue: settings.getEnableAnimations(),
                    title: const Text('Enable animations'),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowIcons(value),
                    initialValue: settings.getShowIcons(),
                    title: const Text('Show app icons'),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) => settings.setShowNames(value),
                    initialValue: settings.getShowNames(),
                    title: const Text('Show app names'),
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
