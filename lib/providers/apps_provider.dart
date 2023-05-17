import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppsProvider extends ChangeNotifier {
  late final Future<List<Application>> _apps;
  final Box _pinnedAppsBox = Hive.box('pinnedApps');
  String _filter = '';

  Future<List<Application>> _loadApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true);
    apps.sort((Application a, Application b) =>
        a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
    return apps;
  }

  AppsProvider() {
    _apps = _loadApps();
    // register change listener
    DeviceApps.listenToAppsChanges().listen((event) async {
      List<Application> apps = await _apps;
      switch (event.event) {
        case ApplicationEventType.installed:
        case ApplicationEventType.disabled: // disabled and enabled are mixed-up
          if (!apps.any((app) => app.packageName == event.packageName)) {
            apps.add((await DeviceApps.getApp(event.packageName, true))!);
          }
          break;
        case ApplicationEventType.updated:
          apps.removeWhere((app) => app.packageName == event.packageName);
          apps.add((await DeviceApps.getApp(event.packageName, true))!);
          break;
        case ApplicationEventType.uninstalled:
        case ApplicationEventType.enabled: // disabled and enabled are mixed-up
          apps.removeWhere((app) => app.packageName == event.packageName);
          break;
        default:
          break;
      }
      apps.sort((Application a, Application b) =>
          a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      notifyListeners();
    });
  }

  Future<List<Application>> getAllApps() => _apps;

  Future<List<Application>> getFilteredApps() async {
    List<Application> apps = await _apps;
    if (_filter.isEmpty) {
      return apps.where((app) => isPinned(app)).toList();
    } else if (_filter.length == 1) {
      return apps
          .where((app) =>
              app.appName.toLowerCase().startsWith(_filter.toLowerCase()))
          .toList();
    } else {
      return apps
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
