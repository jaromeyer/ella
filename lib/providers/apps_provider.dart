import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppsProvider extends ChangeNotifier {
  static late final List<Application> _apps;
  final Box _pinnedAppsBox = Hive.box('pinnedApps');
  String _filter = '';

  static Future<void> initialize() async {
    _apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true);
    _apps.sort((Application a, Application b) =>
        a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
  }

  AppsProvider() {
    // register change listener to update _apps
    DeviceApps.listenToAppsChanges().listen((event) async {
      String packageName = event.packageName;
      switch (event.event) {
        case ApplicationEventType.installed:
        case ApplicationEventType.disabled: // disabled and enabled are mixed-up
          if (!_apps.any((app) => app.packageName == packageName)) {
            _apps.add((await DeviceApps.getApp(packageName, true))!);
          }
          break;
        case ApplicationEventType.updated:
          _apps.removeWhere((app) => app.packageName == event.packageName);
          _apps.add((await DeviceApps.getApp(packageName, true))!);
          break;
        case ApplicationEventType.uninstalled:
        case ApplicationEventType.enabled: // disabled and enabled are mixed-up
          _apps.removeWhere((app) => app.packageName == packageName);
          // unpin app
          if (_pinnedAppsBox.containsKey(packageName)) {
            _pinnedAppsBox.delete(packageName);
          }
          break;
      }
      _apps.sort((Application a, Application b) =>
          a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      notifyListeners();
    });
  }

  List<Application> getAllApps() => _apps;

  List<Application> getFilteredApps() {
    if (_filter.isEmpty) {
      return _apps.where((app) => isPinned(app)).toList();
    } else if (_filter.length == 1) {
      return _apps
          .where((app) =>
              app.appName.toLowerCase().startsWith(_filter.toLowerCase()))
          .toList();
    } else {
      return _apps
          .where((app) => RegExp('\\b${_filter.toLowerCase()}')
              .hasMatch(app.appName.toLowerCase()))
          .toList();
    }
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
