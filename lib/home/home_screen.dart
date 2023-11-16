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

    // show help dialog once widgets have been initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<Settings>().getShowHelp()) {
        showHelpDialog(context);
      }
    });
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
    String prefix = candidates.first.text;
    if (prefix == 'l' && !candidates.any((c) => c.text == 'L') ||
        prefix == '1' && candidates.any((c) => c.text == '|')) {
      prefix = 'i';
    }
    if (mounted) {
      setState(() => _filter = prefix);
    }
  }

  @override
  Widget build(BuildContext context) {
    // show pinned apps when going back
    return WillPopScope(
      onWillPop: () {
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
            child: Consumer<Settings>(
              builder: (context, settings, child) => Scaffold(
                backgroundColor: settings.getBackgroundColor(),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 160, 0, 0),
                      child: OverviewWidget(),
                    ),
                    Expanded(child: Center(child: AppList(filter: _filter))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
