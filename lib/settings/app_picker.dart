import 'package:ella/providers/apps_provider.dart';
import 'package:ella/utils/cached_application.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/cached_image.dart';

void showAppPicker({
  required BuildContext context,
  required ValueChanged<CachedApplication> onAppPicked,
  String title = "Pick app",
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      List<CachedApplication> apps = context.read<AppsProvider>().getApps();
      return AlertDialog(
        title: Text(title),
        contentPadding: const EdgeInsets.only(top: 24),
        content: SizedBox(
          width: 100,
          child: ListView.builder(
            itemCount: apps.length,
            itemBuilder: (_, index) {
              var app = apps[index];
              return ListTile(
                title: Text(app.appName),
                leading: CachedMemoryImage(
                  width: 40,
                  bytes: app.icon,
                  identifier: ValueKey(app.packageName),
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
