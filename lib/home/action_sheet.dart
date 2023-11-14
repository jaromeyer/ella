import 'package:android_intent_plus/android_intent.dart';
import 'package:ella/home/help_dialog.dart';
import 'package:ella/utils/cached_application.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import '../utils/cached_image.dart';

void showActionSheet(BuildContext context, {CachedApplication? app}) {
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
  ];

  // add app specific tiles if app parameter was given
  if (app != null) {
    var nameFocus = FocusNode();
    var nameController = TextEditingController(text: app.appName);
    AppsProvider appsProvider = context.read<AppsProvider>();
    List<Widget> appSpecificTiles = [
      StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: nameController,
              style: const TextStyle(fontSize: 30),
              focusNode: nameFocus,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: CachedMemoryImage(
                  width: 40,
                  bytes: app.icon,
                  identifier: ValueKey(app.packageName),
                ),
                suffixIcon: app.appName == app.originalName
                    ? IconButton(
                        onPressed: () {
                          nameFocus.requestFocus();
                        },
                        icon: const Icon(Icons.edit),
                      )
                    : IconButton(
                        onPressed: () {
                          app.appName = app.originalName;
                          nameController.text = app.originalName;
                          appsProvider.update(app);
                          setState(() {});
                        },
                        icon: const Icon(Icons.settings_backup_restore),
                      ),
              ),
              onFieldSubmitted: (name) {
                app.appName = name;
                appsProvider.update(app);
                setState(() {});
              },
            ),
          );
        },
      ),
      ListTile(
        onTap: () {
          if (app.pinned) {
            appsProvider.unpinApp(app);
          } else {
            appsProvider.pinApp(app);
          }
          Navigator.pop(context);
        },
        leading: app.pinned
            ? const Icon(Icons.star)
            : const Icon(Icons.star_outline),
        title: app.pinned
            ? const Text('Remove from favorites')
            : const Text('Add to favorites'),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          app.openAppSettings();
        },
        leading: const Icon(Icons.info),
        title: const Text('App info'),
      ),
      ListTile(
        onTap: () {
          Navigator.pop(context);
          app.uninstall();
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
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Wrap(children: tiles),
      );
    },
  );
}
