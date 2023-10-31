import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:ella/home/help_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import '../utils/cached_image.dart';

void showActionSheet(BuildContext context, {Application? app}) {
  List<Widget> tiles = [
    Visibility(
      visible: ModalRoute.of(context)!.settings.name != "/allApps",
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/allApps');
        },
        leading: const Icon(Icons.apps),
        title: const Text('All apps'),
      ),
    ),
    ListTile(
      onTap: () {
        Navigator.pop(context);
        const AndroidIntent(action: 'android.intent.action.SET_WALLPAPER')
            .launchChooser('Set wallpaper using');
      },
      leading: const Icon(Icons.wallpaper),
      title: const Text('Change wallpaper'),
    ),
    ListTile(
      onTap: () {
        Navigator.pop(context);
        showHelpDialog(context);
      },
      leading: const Icon(Icons.help),
      title: const Text('Show help'),
    ),
    ListTile(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/settings');
      },
      leading: const Icon(Icons.settings),
      title: const Text('Launcher settings'),
    ),
    Container(height: MediaQuery.of(context).padding.bottom)
  ];

  // add app specific tiles if app parameter was given
  if (app != null) {
    AppsProvider appsProvider = context.read<AppsProvider>();
    bool isPinned = appsProvider.isPinned(app);
    List<Widget> appSpecificTiles = [
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
          if (isPinned) {
            appsProvider.unpinApp(app);
          } else {
            appsProvider.pinApp(app);
          }
          Navigator.pop(context);
        },
        leading:
            isPinned ? const Icon(Icons.star) : const Icon(Icons.star_outline),
        title: isPinned
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
    ];
    tiles = appSpecificTiles + tiles;
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return Wrap(children: tiles);
    },
  );
}
