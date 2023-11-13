import 'dart:async';

import 'package:ella/home/help_dialog.dart';
import 'package:ella/providers/settings_provider.dart';
import 'package:flutter/material.dart' hide Ink;
import 'package:flutter/services.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:provider/provider.dart';

import 'action_sheet.dart';
import 'app_list.dart';
import 'drawing_overlay.dart';
import 'overview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  String _filter = "";

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

    // show help dialog on first launch
    if (context.read<Settings>().getShowHelp()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showHelpDialog(context, dismissForever: true);
      });
    }
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
      setState(() => _filter = "");
      _controller.value = 0.7;
    } else if (state == AppLifecycleState.resumed) {
      _controller.animateTo(1);
    }
  }

  void _recognizeStrokes(Ink ink) async {
    final List<RecognitionCandidate> candidates =
        await digitalInkRecognizer.recognize(ink);
    // apply manual tweaks to result
    String prefix = candidates
        .firstWhere(
            (candidate) => RegExp(r'^[a-zA-Z]+$').hasMatch(candidate.text))
        .text;
    if (prefix == 'l' && !candidates.any((c) => c.text == 'L') ||
        prefix == '1' && candidates.any((c) => c.text == '|')) {
      prefix = 'i';
    }
    if (mounted) {
      setState(() => _filter = prefix.toLowerCase());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, _) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarIconBrightness:
                ThemeData.estimateBrightnessForColor(settings.getTextColor()),
          ),
          child: WillPopScope(
            onWillPop: () {
              // show pinned apps when going back
              setState(() => _filter = "");
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
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: Colors.transparent,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: OverviewWidget(),
                        ),
                        Center(child: AppList(filter: _filter)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
