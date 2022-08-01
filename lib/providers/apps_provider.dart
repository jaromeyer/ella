import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppsProvider extends ChangeNotifier {
  Future<List<Application>> _appsFuture = DeviceApps.getInstalledApplications(
      onlyAppsWithLaunchIntent: true,
      includeSystemApps: true,
      includeAppIcons: true);
  final Box _pinnedAppsBox = Hive.box('pinnedApps');
  String _filter = '';

  AppsProvider() {
    // register change listener
    DeviceApps.listenToAppsChanges().listen((event) {
      _updateApps();
    });
  }

  void _updateApps() {
    _appsFuture = DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true);
    notifyListeners();
  }

  Future<List<Application>> getFilteredApps() {
    return _appsFuture.then((apps) {
      if (_filter.isEmpty) {
        apps = apps.where((app) => isPinned(app)).toList();
      } else if (_filter.length == 1) {
        apps = apps
            .where((app) =>
                app.appName.toLowerCase().startsWith(_filter.toLowerCase()))
            .toList();
      } else {
        apps = apps
            .where((app) => RegExp('\\b${_filter.toLowerCase()}')
                .hasMatch(app.appName.toLowerCase()))
            .toList();
      }
      // sort result alphabetically
      apps.sort((Application a, Application b) =>
          a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      return apps;
    });
  }

  String getFilter() {
    return _filter;
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void resetFilter() {
    _filter = '';
    notifyListeners();
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
