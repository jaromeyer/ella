import 'package:ella/utils/cached_application.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../utils/cached_image.dart';
import 'action_sheet.dart';

class AppTile extends StatelessWidget {
  final CachedApplication app;

  const AppTile(this.app, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, _) {
        return ListTile(
          onTap: () {
            Navigator.popUntil(context, (route) => route.settings.name == "/");
            app.launch();
          },
          onLongPress: () => showActionSheet(context, app: app),
          leading: settings.getShowIcons()
              ? CachedMemoryImage(
                  width: 30 * settings.getScalingFactor() + 10,
                  bytes: app.icon,
                  identifier: ValueKey(app.packageName),
                )
              : null,
          title: settings.getShowNames()
              ? Text(
                  app.appName,
                  style: TextStyle(
                    fontSize: 30 * settings.getScalingFactor(),
                    fontWeight: FontWeight.w300,
                    color: settings.getTextColor(),
                  ),
                )
              : null,
        );
      },
    );
  }
}
