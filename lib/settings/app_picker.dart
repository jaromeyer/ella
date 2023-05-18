import 'package:device_apps/device_apps.dart';
import 'package:ella/providers/apps_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/cached_image.dart';

void showAppPicker({
  required BuildContext context,
  required ValueChanged<Application> onAppPicked,
  String title = "Pick app",
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      List<Application> apps = context.read<AppsProvider>().getAllApps();
      return AlertDialog(
        title: Text(title),
        contentPadding: const EdgeInsets.only(top: 24),
        content: SizedBox(
          width: 100,
          child: ListView.builder(
            itemCount: apps.length,
            itemBuilder: (_, int index) {
              var app = apps[index];
              return ListTile(
                title: Text(app.appName),
                leading: CachedMemoryImage(
                  width: 40,
                  bytes: (app as ApplicationWithIcon).icon,
                  identifier: ValueKey(app),
                ),
                onTap: () {
                  onAppPicked(app);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
