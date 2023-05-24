import 'dart:collection';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppsProvider extends ChangeNotifier {
  static late final SplayTreeSet<Application> _apps;
  final Box _pinnedAppsBox = Hive.box('pinnedApps');

  static Future<void> initialize() async {
    _apps = SplayTreeSet.from(
      await DeviceApps.getInstalledApplications(
          onlyAppsWithLaunchIntent: true,
          includeSystemApps: true,
          includeAppIcons: true),
      (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()),
    );
  }

  AppsProvider() {
    // register change listener to update _apps
    DeviceApps.listenToAppsChanges().listen((event) async {
      String packageName = event.packageName;
      switch (event.event) {
        case ApplicationEventType.installed:
        case ApplicationEventType.disabled: // disabled and enabled are mixed-up
        case ApplicationEventType.updated:
          _apps.removeWhere((app) => app.packageName == packageName);
          _apps.add((await DeviceApps.getApp(packageName, true))!);
          break;
        case ApplicationEventType.uninstalled:
        case ApplicationEventType.enabled: // disabled and enabled are mixed-up
          _apps.removeWhere((app) => app.packageName == packageName);
          _pinnedAppsBox.delete(packageName); // unpin app
          break;
      }
      notifyListeners();
    });
  }

  List<Application> getAllApps() => _apps.toList();

  List<Application> getPinnedApps() =>
      _apps.where((app) => isPinned(app)).toList();

  List<Application> getFilteredApps(String filter) {
    if (filter.isEmpty) {
      return getPinnedApps();
    } else if (filter.length == 1) {
      return _apps
          .where((app) =>
              app.appName.toLowerCase().startsWith(filter.toLowerCase()))
          .toList();
    } else {
      return _apps
          .where((app) => RegExp('\\b${filter.toLowerCase()}')
              .hasMatch(app.appName.toLowerCase()))
          .toList();
    }
  }

  bool isPinned(Application app) {
    return _pinnedAppsBox.containsKey(app.packageName);
  }

  void pinApp(Application app) {
    _pinnedAppsBox.put(app.packageName, null);
    notifyListeners();
  }

  void unpinApp(Application app) {
    _pinnedAppsBox.delete(app.packageName);
    notifyListeners();
  }
}
