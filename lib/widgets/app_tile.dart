import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/cached_image.dart';

class AppTile extends StatelessWidget {
  final Application app;

  const AppTile(this.app, {Key? key}) : super(key: key);

  void _showActionSheet(BuildContext context) {
    AppsProvider appsProvider = context.read<AppsProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: CachedMemoryImage(
                    width: 40,
                    bytes: (app as ApplicationWithIcon).icon,
                    identifier: ValueKey(app),
                  ),
                ),
                Text(app.appName, style: const TextStyle(fontSize: 30)),
              ],
            ),
            ListTile(
              onTap: () {
                if (appsProvider.isPinned(app)) {
                  appsProvider.unpinApp(app);
                } else {
                  appsProvider.pinApp(app);
                  appsProvider.resetFilter(); // go "home"
                }
                Navigator.pop(context);
              },
              leading: appsProvider.isPinned(app)
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_outline),
              title: appsProvider.isPinned(app)
                  ? const Text('Remove from favorites')
                  : const Text('Add to favorites'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                DeviceApps.openAppSettings(app.packageName);
              },
              leading: const Icon(Icons.info),
              title: const Text('App info'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                DeviceApps.uninstallApp(app.packageName);
              },
              leading: const Icon(Icons.delete),
              title: const Text('Uninstall'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                const AndroidIntent(
                        action: 'android.intent.action.SET_WALLPAPER')
                    .launchChooser('Set wallpaper using');
              },
              leading: const Icon(Icons.wallpaper),
              title: const Text('Change wallpaper'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
              leading: const Icon(Icons.settings),
              title: const Text('Launcher settings'),
            ),
            Container(height: MediaQuery.of(context).padding.bottom),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, _) {
        var textColor = settings.getDarkText() ? Colors.black : Colors.white;
        return ListTile(
          onTap: () {
            DeviceApps.openApp(app.packageName);
            context.read<AppsProvider>().resetFilter();
          },
          onLongPress: () => _showActionSheet(context),
          leading: settings.getShowIcons()
              ? CachedMemoryImage(
                  width: 40,
                  bytes: (app as ApplicationWithIcon).icon,
                  identifier: ValueKey(app),
                )
              : null,
          title: settings.getShowNames()
              ? Text(
                  app.appName,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                    color: textColor,
                  ),
                )
              : null,
        );
      },
    );
  }
}
