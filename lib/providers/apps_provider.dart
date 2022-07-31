import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppsProvider extends ChangeNotifier {
  final Box _pinnedAppsBox = Hive.box('pinnedApps');
  String _filter = '';
  late List<Application> _apps = [];

  AppsProvider() {
    _updateApps();
    // register change listener
    DeviceApps.listenToAppsChanges().listen((event) {
      _updateApps();
    });
  }

  void _updateApps() async {
    _apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true);
    notifyListeners();
  }

  List<Application> getFilteredApps() {
    List<Application> apps = List.from(_apps);
    if (_filter.isEmpty) {
      apps = apps
          .where((app) => _pinnedAppsBox.values.contains(app.packageName))
          .toList();
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
    _pinnedAppsBox.put(app.packageName, app.packageName);
    notifyListeners();
  }

  void unpinApp(Application app) {
    _pinnedAppsBox.delete(app.packageName);
    notifyListeners();
  }
}
