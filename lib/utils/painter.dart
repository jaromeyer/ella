import 'dart:core';

import 'package:ella/providers/settings_provider.dart';
import 'package:flutter/material.dart' hide Ink;
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:perfect_freehand/perfect_freehand.dart' hide StrokePoint;
import 'package:provider/provider.dart';

class StrokePainter extends CustomPainter {
  final BuildContext context;
  final Ink ink;

  StrokePainter({required this.context, required this.ink});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = context.read<Settings>().getTextColor();
    for (Stroke stroke in ink.strokes) {
      List<PointVector> line = [
        for (StrokePoint sp in stroke.points) PointVector(sp.x, sp.y)
      ];
      drawLine(line, canvas, paint);
    }
  }

  void drawLine(List<PointVector> points, Canvas canvas, Paint paint) {
    // 1. Get the outline points from the input points
    final outlinePoints = getStroke(
      points,
      options: StrokeOptions(
        size: 10,
        smoothing: 0.5,
        thinning: 0,
        streamline: 1,
      ),
    );

    // 2. Render the points as a path
    final path = Path();

    if (outlinePoints.isEmpty) {
      // If the list is empty, don't do anything.
      return;
    } else if (outlinePoints.length < 2) {
      // If the list only has one point, draw a dot.
      path.addOval(Rect.fromCircle(
          center: Offset(outlinePoints[0].dx, outlinePoints[0].dy), radius: 1));
    } else {
      // Otherwise, draw a line that connects each point with a bezier curve segment.
      path.moveTo(outlinePoints[0].dx, outlinePoints[0].dy);

      for (int i = 1; i < outlinePoints.length - 1; ++i) {
        final p0 = outlinePoints[i];
        final p1 = outlinePoints[i + 1];
        path.quadraticBezierTo(
            p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      }
    }

    // 3. Draw the path to the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StrokePainter oldDelegate) => true;
}
