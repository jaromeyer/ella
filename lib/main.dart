import 'dart:async';

import 'package:ella/home/all_apps_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'home/home_screen.dart';
import 'providers/apps_provider.dart';
import 'providers/settings_provider.dart';
import 'settings/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // make status bar & system navbar transparent
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // configure hive
  final dir = await getApplicationDocumentsDirectory();
  Hive.defaultDirectory = dir.path;

  // make sure ink recognition model is downloaded
  DigitalInkRecognizerModelManager modelManager =
      DigitalInkRecognizerModelManager();
  if (!(await modelManager.isModelDownloaded('de'))) {
    await modelManager.downloadModel('de', isWifiRequired: false);
  }

  runApp(const EllaApp());
}

class EllaApp extends StatelessWidget {
  const EllaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppsProvider()),
        ChangeNotifierProvider(create: (context) => Settings()),
      ],
      child: MaterialApp(
        title: 'ella',
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/allApps': (context) => const AllAppsScreen(),
        },
      ),
    );
  }
}
