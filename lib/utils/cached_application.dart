import 'dart:convert';
import 'dart:typed_data';

import 'package:device_apps/device_apps.dart';

class CachedApplication {
  late String packageName;
  late String appName;
  late String originalName;
  late int version;
  late Uint8List icon;
  late bool isSystem;
  bool pinned = false;

  CachedApplication.fromApplication(Application app) {
    packageName = app.packageName;
    appName = app.appName;
    originalName = app.appName;
    version = app.versionCode;
    icon = (app as ApplicationWithIcon).icon;
    isSystem = app.systemApp;
  }

  CachedApplication.fromJson(Map<String, dynamic> json) {
    packageName = json['packageName'];
    appName = json['appName'];
    originalName = json['originalName'];
    version = json['version'];
    icon = base64Decode(json['icon']);
    isSystem = json['isSystem'];
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
        'isSystem': isSystem,
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
