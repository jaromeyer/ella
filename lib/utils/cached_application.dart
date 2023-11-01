import 'dart:convert';
import 'dart:typed_data';

import 'package:device_apps/device_apps.dart';

class CachedApplication {
  late String packageName;
  late String appName;
  late String originalName;
  late int version;
  late Uint8List icon;
  bool pinned = false;

  CachedApplication.fromApplication(Application app) {
    packageName = app.packageName;
    appName = app.appName;
    originalName = app.appName;
    version = app.versionCode;
    icon = (app as ApplicationWithIcon).icon;
  }

  CachedApplication.fromJson(Map<String, dynamic> json) {
    packageName = json['packageName'];
    appName = json['appName'];
    originalName = json['originalName'];
    icon = base64Decode(json['icon']);
    version = json['version'];
    pinned = json['pinned'];
  }

  void update(Application app) {
    if (packageName != app.packageName) {
      throw Error();
    }
    if (appName == originalName) {
      appName = app.appName;
    }
    originalName = app.appName;
    version = app.versionCode;
    icon = (app as ApplicationWithIcon).icon;
  }

  Map<String, dynamic> toJson() => {
        'packageName': packageName,
        'appName': appName,
        'originalName': originalName,
        'version': version,
        'icon': base64Encode(icon),
        'pinned': pinned,
      };

  void openAppSettings() {
    DeviceApps.openAppSettings(packageName);
  }

  void launch() {
    DeviceApps.openApp(packageName);
  }

  void uninstall() {
    DeviceApps.uninstallApp(packageName);
  }
}
