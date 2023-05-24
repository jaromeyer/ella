import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../utils/cached_image.dart';
import 'action_sheet.dart';

class AppTile extends StatelessWidget {
  final Application app;

  const AppTile(this.app, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, _) {
        var textColor = settings.getTextColor();
        return ListTile(
          onTap: () => DeviceApps.openApp(app.packageName),
          onLongPress: () => showActionSheet(context, app: app),
          leading: settings.getShowIcons()
              ? CachedMemoryImage(
                  width: settings.getScalingFactor() + 10,
                  bytes: (app as ApplicationWithIcon).icon,
                  identifier: ValueKey(app),
                )
              : null,
          title: settings.getShowNames()
              ? Text(
                  app.appName,
                  style: TextStyle(
                    fontSize: settings.getScalingFactor(),
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
