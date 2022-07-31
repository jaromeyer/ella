import 'dart:core';

import 'package:flutter/material.dart' hide Ink;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

class StrokePainter extends CustomPainter {
  final Ink ink;

  StrokePainter({required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white;
    for (Stroke stroke in ink.strokes) {
      List<Point> line = [
        for (StrokePoint sp in stroke.points) Point(sp.x, sp.y)
      ];
      drawLine(line, canvas, paint);
    }
  }

  void drawLine(List<Point> points, Canvas canvas, Paint paint) {
    // 1. Get the outline points from the input points
    final outlinePoints = getStroke(
      points,
      size: 10,
      smoothing: 1,
      thinning: -0.3,
      streamline: 1,
    );

    // 2. Render the points as a path
    final path = Path();

    if (outlinePoints.isEmpty) {
      // If the list is empty, don't do anything.
      return;
    } else if (outlinePoints.length < 2) {
      // If the list only has one point, draw a dot.
      path.addOval(Rect.fromCircle(
          center: Offset(outlinePoints[0].x, outlinePoints[0].y), radius: 1));
    } else {
      // Otherwise, draw a line that connects each point with a bezier curve segment.
      path.moveTo(outlinePoints[0].x, outlinePoints[0].y);

      for (int i = 1; i < outlinePoints.length - 1; ++i) {
        final p0 = outlinePoints[i];
        final p1 = outlinePoints[i + 1];
        path.quadraticBezierTo(
            p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
      }
    }

    // 3. Draw the path to the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StrokePainter oldDelegate) => true;
}
