import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import '../providers/settings_provider.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize hive stuff
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('pinnedApps');
  // make sure ink recognition model is downloaded
  DigitalInkRecognizerModelManager modelManager =
      DigitalInkRecognizerModelManager();
  if (!(await modelManager.isModelDownloaded('de'))) {
    await modelManager.downloadModel('de');
  }
  runApp(const EllaApp());
}

class EllaApp extends StatelessWidget {
  const EllaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppsProvider()),
        ChangeNotifierProvider(create: (context) => Settings()),
      ],
      child: MaterialApp(
        title: 'ella',
        darkTheme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
