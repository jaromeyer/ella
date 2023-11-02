import 'package:device_apps/device_apps.dart';
import 'package:ella/utils/cached_application.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppsProvider extends ChangeNotifier {
  final Box<CachedApplication> _appsBox =
      Hive.box<CachedApplication>(name: 'apps');

  AppsProvider() {
    Hive.registerAdapter(
        'CachedApplication', (json) => CachedApplication.fromJson(json));
    // query installed apps and update asynchronously
    DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: true,
            includeSystemApps: true,
            includeAppIcons: true)
        .then((apps) {
      _appsBox.deleteAll(_appsBox.keys
        ..removeWhere((pn) => apps.map((app) => app.packageName).contains(pn)));
      for (var app in apps) {
        if (_appsBox.containsKey(app.packageName)) {
          _appsBox.put(
              app.packageName, _appsBox.get(app.packageName)!..update(app));
        } else {
          _appsBox.put(app.packageName, CachedApplication.fromApplication(app));
        }
      }
      notifyListeners();
    });

    // register change listener to update _apps
    DeviceApps.listenToAppsChanges().listen((event) async {
      String packageName = event.packageName;
      switch (event.event) {
        case ApplicationEventType.installed:
        case ApplicationEventType.disabled: // disabled and enabled are mixed-up
        case ApplicationEventType.updated:
          var app = (await DeviceApps.getApp(packageName, true))!;
          _appsBox.put(
              app.packageName,
              (_appsBox.get(app.packageName)?..update(app)) ??
                  CachedApplication.fromApplication(app));
          break;
        case ApplicationEventType.uninstalled:
        case ApplicationEventType.enabled: // disabled and enabled are mixed-up
          _appsBox.delete(packageName);
          break;
      }
      notifyListeners();
    });
  }

  List<CachedApplication> getPinnedApps() => _appsBox
      .getAll(_appsBox.keys)
      .nonNulls
      .where((app) => app.pinned)
      .toList()
    ..sort((a, b) => a.appName.compareTo(b.appName));

  List<CachedApplication> getApps({String filter = ""}) {
    var apps = _appsBox.getAll(_appsBox.keys).nonNulls;
    if (filter.length == 1) {
      apps = apps.where(
          (app) => app.appName.toLowerCase().startsWith(filter.toLowerCase()));
    } else {
      apps = apps.where((app) => RegExp('\\b${filter.toLowerCase()}')
          .hasMatch(app.appName.toLowerCase()));
    }
    return apps.toList()..sort((a, b) => a.appName.compareTo(b.appName));
  }

  void pinApp(CachedApplication app) {
    app.pinned = true;
    _appsBox.put(app.packageName, app);
    notifyListeners();
  }

  void unpinApp(CachedApplication app) {
    app.pinned = false;
    _appsBox.put(app.packageName, app);
    notifyListeners();
  }

  void update(CachedApplication app) {
    _appsBox.put(app.packageName, app);
    notifyListeners();
  }
}
