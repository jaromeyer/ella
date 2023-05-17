import 'dart:async';

import 'package:ella/providers/settings_provider.dart';
import 'package:flutter/material.dart' hide Ink;
import 'package:flutter/services.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import 'action_sheet.dart';
import 'app_list.dart';
import 'drawing_overlay.dart';
import 'overview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _wasPaused = false;

  final DigitalInkRecognizer digitalInkRecognizer =
      DigitalInkRecognizer(languageCode: 'de');

  // animation stuff
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    value: 1,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasPaused = true;
    } else if (state == AppLifecycleState.resumed && _wasPaused) {
      _wasPaused = false;
      // start animation when returning from another app
      _controller.value = 0.7;
      _controller.animateTo(1);
    }
  }

  void _recognizeStrokes(Ink ink) async {
    final List<RecognitionCandidate> candidates =
        await digitalInkRecognizer.recognize(ink);
    // apply manual tweaks to result
    String prefix = candidates.first.text;
    if (prefix == 'l' && !candidates.any((c) => c.text == 'L') ||
        prefix == '1' && candidates.any((c) => c.text == '|')) {
      prefix = 'i';
    }
    if (mounted) context.read<AppsProvider>().setFilter(prefix);
  }

  @override
  Widget build(BuildContext context) {
    // go "home" when back gesture received
    return WillPopScope(
      onWillPop: () {
        context.read<AppsProvider>().resetFilter();
        return Future.value(false);
      },
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.heavyImpact();
          showActionSheet(context);
        },
        child: DrawingOverlay(
          callback: _recognizeStrokes,
          child: ScaleTransition(
              scale: _animation,
              child: Consumer<Settings>(
                builder: (context, settings, child) => Scaffold(
                  backgroundColor: settings.getBackgroundColor(),
                  body: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 160, 0, 0),
                        child: OverviewWidget(),
                      ),
                      Expanded(child: Center(child: AppList())),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
