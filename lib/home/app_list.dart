import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import '../providers/settings_provider.dart';
import 'app_tile.dart';

class AppList extends StatefulWidget {
  const AppList({super.key, required this.filter});

  final String filter;

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Settings, AppsProvider>(
      builder: (context, settings, appsProvider, _) {
        List<Application> apps = widget.filter.isEmpty
            ? appsProvider.getPinnedApps()
            : appsProvider.getApps(filter: widget.filter);
        if (apps.isNotEmpty) {
          // app list is non empty: return list
          if (settings.getEnableAnimations()) {
            // animations disabled: return ImplicitlyAnimatedList
            return ImplicitlyAnimatedList<Application>(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              items: apps,
              areItemsTheSame: (a, b) => a.packageName == b.packageName,
              itemBuilder: (_, animation, app, __) {
                return SizeFadeTransition(
                  sizeFraction: 0.6,
                  curve: Curves.easeInOut,
                  animation: animation,
                  child: AppTile(app),
                );
              },
            );
          } else {
            // animations disabled: return normal ListView
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [for (Application app in apps) AppTile(app)],
            );
          }
        } else {
          // app list is empty: return text message
          return Text(
            widget.filter.isEmpty
                ? 'Add favorite apps to be displayed here'
                : 'No apps found for "${widget.filter}"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: settings.getTextColor(),
            ),
          );
        }
      },
    );
  }
}
