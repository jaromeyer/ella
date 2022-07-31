import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;

import '../utils/painter.dart';

class DrawingOverlay extends StatefulWidget {
  const DrawingOverlay({Key? key, this.callback, required this.child})
      : super(key: key);

  final Function(mlkit.Ink)? callback;
  final Widget child;

  @override
  State<DrawingOverlay> createState() => _DrawingOverlayState();
}

class _DrawingOverlayState extends State<DrawingOverlay> {
  final mlkit.Ink _ink = mlkit.Ink();
  Timer? _timer;

  void onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    final mlkit.StrokePoint strokePoint = mlkit.StrokePoint(
        x: point.dx, y: point.dy, t: DateTime.now().millisecondsSinceEpoch);
    final mlkit.Stroke stroke = mlkit.Stroke();
    stroke.points.add(strokePoint);
    _ink.strokes.add(stroke); // start new stroke
  }

  void onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    final mlkit.StrokePoint strokePoint = mlkit.StrokePoint(
        x: point.dx, y: point.dy, t: DateTime.now().millisecondsSinceEpoch);
    List<mlkit.StrokePoint> points = _ink.strokes.last.points;
    points.add(strokePoint); // add point to current stroke
    if (strokePoint.t - points.first.t >= 40) {
      _timer?.cancel(); // cancel timer if valid stroke has been detected
      setState(() {});
    }
  }

  void onPanEnd(DragEndDetails details) {
    List<mlkit.StrokePoint> points = _ink.strokes.last.points;
    // ignore short strokes
    if (points.last.t - points.first.t >= 40) {
      widget.callback!(_ink); // send strokes to callback
      _timer = Timer(const Duration(milliseconds: 500), () {
        setState(() => _ink.strokes = []);
      });
    } else {
      _ink.strokes.removeLast();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Stack(
        children: [
          widget.child,
          CustomPaint(
            painter: StrokePainter(ink: _ink),
          ),
        ],
      ),
    );
  }
}
