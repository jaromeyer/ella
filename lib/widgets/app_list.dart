import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import '../providers/settings_provider.dart';
import 'app_tile.dart';

class AppList extends StatefulWidget {
  const AppList({Key? key}) : super(key: key);

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Settings, AppsProvider>(
      builder: (context, settings, appsProvider, child) {
        return FutureBuilder(
          future: appsProvider.getFilteredApps(),
          builder: (_, AsyncSnapshot<List<Application>> snapshot) {
            if (snapshot.hasData) {
              // future has returned list: we can use it
              List<Application> apps = snapshot.data!;
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
                String filter = appsProvider.getFilter();
                return Text(
                  filter.isEmpty
                      ? 'Add favorite apps to be displayed here'
                      : 'No apps found for "$filter"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator(color: Colors.white);
            }
          },
        );
      },
    );
  }
}
