import 'dart:async';

import 'package:flutter/material.dart' hide Ink;
import 'package:flutter/services.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import '../widgets/app_list.dart';
import '../widgets/drawing_overlay.dart';
import '../widgets/overview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _paused = false;

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
      _paused = true;
    } else if (state == AppLifecycleState.resumed) {
      // close any dialog/modalsheet/page
      Navigator.popUntil(context, ModalRoute.withName('/'));
      // show pinned apps
      context.read<AppsProvider>().resetFilter();
      // start animation when returning from another app
      if (_paused) {
        _paused = false;
        _controller.value = 0.7;
        _controller.animateTo(1);
      }
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
    // make statusbar transparent
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    // go "home" when back gesture received
    return WillPopScope(
      onWillPop: () {
        context.read<AppsProvider>().resetFilter();
        return Future.value(false);
      },
      child: GestureDetector(
        onDoubleTap: () {}, // TODO: add double tap action
        onLongPress: () => Navigator.pushNamed(context, '/settings'),
        child: DrawingOverlay(
          callback: _recognizeStrokes,
          child: ScaleTransition(
            scale: _animation,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 160, 0, 0),
                    child: OverviewWidget(),
                  ),
                  Expanded(child: Center(child: AppList())),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}