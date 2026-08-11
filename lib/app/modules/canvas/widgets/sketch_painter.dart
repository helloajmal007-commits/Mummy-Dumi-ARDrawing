import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:sketch_flow/app/data/models/tool_model.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:sketch_flow/app/modules/settings/controllers/settings_controller.dart';

class CachedStrokesPainter extends CustomPainter {
  final ui.Picture? picture;

  CachedStrokesPainter(this.picture);

  @override
  void paint(Canvas canvas, Size size) {
    if (picture != null) canvas.drawPicture(picture!);
  }

  @override
  bool shouldRepaint(covariant CachedStrokesPainter oldDelegate) =>
      oldDelegate.picture != picture;
}

class SketchPainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<StrokePoint> liveStroke;
  final Color liveColor;
  final double liveWidth;
  final BrushFamily liveFamily;
  final double liveOpacity;
  final double liveHardness;
  final int liveSeed;
  final bool showGrid;
  final StrokeSmoothing smoothing;

  SketchPainter({
    required this.strokes,
    required this.liveStroke,
    required this.liveColor,
    required this.liveWidth,
    required this.liveSeed,
    this.liveFamily = BrushFamily.ink,
    this.liveOpacity = 1.0,
    this.liveHardness = 0.8,
    this.showGrid = false,
    this.smoothing = StrokeSmoothing.light,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) _drawGrid(canvas, size);

    for (final stroke in strokes) {
      _dispatch(
        canvas,
        points: stroke.points,
        color: stroke.color,
        width: stroke.width,
        family: stroke.family,
        opacity: stroke.opacity,
        hardness: stroke.hardness,
        seed: stroke.seed,
      );
    }

    if (liveStroke.length > 1) {
      _dispatch(
        canvas,
        points: liveStroke,
        color: liveColor,
        width: liveWidth,
        family: liveFamily,
        opacity: liveOpacity,
        hardness: liveHardness,
        seed: liveSeed,
      );
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFEDEBE6)
      ..strokeWidth = 1;
    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _dispatch(
    Canvas canvas, {
    required List<StrokePoint> points,
    required Color color,
    required double width,
    required BrushFamily family,
    required double opacity,
    required double hardness,
    required int seed,
  }) {
    if (points.length < 2) return;
    switch (family) {
      case BrushFamily.graphite:
        _paintGraphite(canvas, points, color, width, opacity, hardness, seed);
        break;
      case BrushFamily.ink:
        _paintInk(canvas, points, color, width, opacity);
        break;
      case BrushFamily.markerFlat:
        _paintMarker(canvas, points, color, width, opacity);
        break;
      case BrushFamily.airbrushSpray:
        _paintAirbrush(canvas, points, color, width, opacity, seed);
        break;
      case BrushFamily.softChalk:
        _paintSoftChalk(canvas, points, color, width, opacity, hardness, seed);
        break;
      case BrushFamily.bristlePaint:
        _paintBristle(canvas, points, color, width, opacity, seed);
        break;
      case BrushFamily.smudgeDrag:
        _paintSmudge(canvas, points, color, width, opacity);
        break;
      case BrushFamily.splatterDots:
        _paintSplatter(canvas, points, color, width, opacity, seed);
        break;
      case BrushFamily.patternStamp:
        _paintPatternStamp(canvas, points, color, width, opacity, seed);
        break;
    }
  }

  Path _smoothPathFrom(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);

    if (smoothing == StrokeSmoothing.off || points.length < 3) {
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      return path;
    }

    if (smoothing == StrokeSmoothing.strong) {
      for (int i = 1; i < points.length - 1; i += 2) {
        final next = points[min(i + 2, points.length - 1)];
        final mid = Offset(
          (points[i].dx + next.dx) / 2,
          (points[i].dy + next.dy) / 2,
        );
        path.quadraticBezierTo(points[i].dx, points[i].dy, mid.dx, mid.dy);
      }
      path.lineTo(points.last.dx, points.last.dy);
      return path;
    }

    for (int i = 1; i < points.length - 1; i++) {
      final mid = Offset(
        (points[i].dx + points[i + 1].dx) / 2,
        (points[i].dy + points[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(points[i].dx, points[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);
    return path;
  }

  double _avgPressure(List<StrokePoint> points) {
    if (points.isEmpty) return 1.0;
    double sum = 0;
    for (final p in points) {
      sum += p.pressure;
    }
    return sum / points.length;
  }

  void _paintInk(
    Canvas canvas,
    List<StrokePoint> points,
    Color color,
    double width,
    double opacity,
  ) {
    final offsets = points.map((p) => p.offset).toList();
    final path = _smoothPathFrom(offsets);

    for (int i = 1; i < points.length; i++) {
      final pressure = (points[i].pressure + points[i - 1].pressure) / 2;
      final segWidth = (width * (0.4 + pressure * 0.9)).clamp(0.6, width * 1.6);
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..strokeWidth = segWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(points[i - 1].offset, points[i].offset, paint);
    }

    final smoothPaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = width * (0.4 + _avgPressure(points) * 0.9)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, smoothPaint);
  }

  void _paintGraphite(
    Canvas canvas,
    List<StrokePoint> points,
    Color color,
    double width,
    double opacity,
    double hardness,
    int seed,
  ) {
    final rnd = Random(seed);
    final offsets = points.map((p) => p.offset).toList();

    for (int i = 1; i < points.length; i++) {
      final pressure = (points[i].pressure + points[i - 1].pressure) / 2;
      final basePaint = Paint()
        ..color = color.withValues(
          alpha: (opacity * (0.35 + pressure * 0.55)).clamp(0.0, 1.0),
        )
        ..strokeWidth = width * (0.85 + pressure * 0.3)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(points[i - 1].offset, points[i].offset, basePaint);
    }

    final grainPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.35)
      ..strokeWidth = max(0.6, width * 0.12)
      ..strokeCap = StrokeCap.round;

    for (int i = 1; i < points.length; i++) {
      final pressure = points[i].pressure;
      final grainDensity =
          ((1 - hardness) * 0.6 + 0.15) * (0.5 + pressure * 0.5);
      if (rnd.nextDouble() > grainDensity) continue;
      final p = offsets[i];
      final jitter = width * 0.5;
      final offset = Offset(
        (rnd.nextDouble() - 0.5) * jitter,
        (rnd.nextDouble() - 0.5) * jitter,
      );
      canvas.drawLine(p, p + offset, grainPaint);
    }
  }

  void _paintMarker(
    Canvas canvas,
    List<StrokePoint> points,
    Color color,
    double width,
    double opacity,
  ) {
    final pressure = _avgPressure(points);
    final path = _smoothPathFrom(points.map((p) => p.offset).toList());
    final paint = Paint()
      ..color = color.withValues(
        alpha: (opacity * (0.45 + pressure * 0.2)).clamp(0.0, 1.0),
      )
      ..strokeWidth = width * 1.3
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
  }

  void _paintAirbrush(
    Canvas canvas,
    List<StrokePoint> points,
    Color color,
    double width,
    double opacity,
    int seed,
  ) {
    final rnd = Random(seed);
    final dabRadius = width * 1.1;
    for (final sp in points) {
      final dabCount = (1 + sp.pressure * 4).round();
      for (int i = 0; i < dabCount; i++) {
        final scatter = Offset(
          (rnd.nextDouble() - 0.5) * dabRadius * 0.8,
          (rnd.nextDouble() - 0.5) * dabRadius * 0.8,
        );
        final dabPaint = Paint()
          ..shader =
              RadialGradient(
                colors: [
                  color.withValues(
                    alpha: opacity * 0.18 * (0.5 + sp.pressure * 0.5),
                  ),
                  color.withValues(alpha: 0),
                ],
              ).createShader(
                Rect.fromCircle(center: sp.offset + scatter, radius: dabRadius),
              );
        canvas.drawCircle(sp.offset + scatter, dabRadius, dabPaint);
      }
    }
  }

  void _paintSoftChalk(
    Canvas canvas,
    List<StrokePoint> points,
    Color color,
    double width,
    double opacity,
    double hardness,
    int seed,
  ) {
    final rnd = Random(seed);
    final offsets = points.map((p) => p.offset).toList();

    for (int i = 1; i < points.length; i++) {
      final pressure = (points[i].pressure + points[i - 1].pressure) / 2;
      final basePaint = Paint()
        ..color = color.withValues(alpha: opacity * 0.4)
        ..strokeWidth = width * (1.1 + pressure * 0.5)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, width * 0.15);
      canvas.drawLine(points[i - 1].offset, points[i].offset, basePaint);
    }

    final grainPaint = Paint()..color = color.withValues(alpha: opacity * 0.3);
    for (int i = 0; i < offsets.length; i++) {
      final pressure = points[i].pressure;
      final grainCount = ((1 - hardness) * 6 * (0.4 + pressure * 0.6)).round();
      for (int g = 0; g < grainCount; g++) {
        final off = Offset(
          (rnd.nextDouble() - 0.5) * width * 1.3,
          (rnd.nextDouble() - 0.5) * width * 1.3,
        );
        canvas.drawCircle(
          offsets[i] + off,
          rnd.nextDouble() * width * 0.08 + 0.5,
          grainPaint,
        );
      }
    }
  }

  void _paintBristle(
    Canvas canvas,
    List<StrokePoint> points,
    Color color,
    double width,
    double opacity,
    int seed,
  ) {
    final rnd = Random(seed);
    const hairCount = 6;
    final avgPressure = _avgPressure(points);
    final splay = 0.5 + avgPressure * 0.8;

    for (int h = 0; h < hairCount; h++) {
      final hairOffset = (h - hairCount / 2) * (width / hairCount) * splay;
      final hairPoints = points
          .map(
            (p) =>
                p.offset + Offset(hairOffset, (rnd.nextDouble() - 0.5) * 1.2),
          )
          .toList();
      final path = _smoothPathFrom(hairPoints);
      final hairPaint = Paint()
        ..color = color.withValues(
          alpha: (opacity * (0.3 + rnd.nextDouble() * 0.25 + avgPressure * 0.2))
              .clamp(0.0, 1.0),
        )
        ..strokeWidth = max(1.0, width / hairCount * 1.3)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, hairPaint);
    }
  }

  void _paintSmudge(
    Canvas canvas,
    List<StrokePoint> points,
    Color color,
    double width,
    double opacity,
  ) {
    final pressure = _avgPressure(points);
    final path = _smoothPathFrom(points.map((p) => p.offset).toList());
    final paint = Paint()
      ..color = color.withValues(alpha: opacity * 0.25)
      ..strokeWidth = width * (1.3 + pressure * 0.6)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(
        BlurStyle.normal,
        width * (0.3 + pressure * 0.3),
      );
    canvas.drawPath(path, paint);
  }

  void _paintSplatter(
    Canvas canvas,
    List<StrokePoint> points,
    Color color,
    double width,
    double opacity,
    int seed,
  ) {
    final rnd = Random(seed);
    final paint = Paint()..color = color.withValues(alpha: opacity);
    for (final sp in points) {
      final dotCount = 1 + (sp.pressure * 4).round() + rnd.nextInt(2);
      for (int i = 0; i < dotCount; i++) {
        final spread = width * (1.6 + sp.pressure * 1.2);
        final offset = Offset(
          (rnd.nextDouble() - 0.5) * spread,
          (rnd.nextDouble() - 0.5) * spread,
        );
        final radius = rnd.nextDouble() * width * 0.35 + 0.8;
        canvas.drawCircle(sp.offset + offset, radius, paint);
      }
    }
  }

  void _paintPatternStamp(
    Canvas canvas,
    List<StrokePoint> points,
    Color color,
    double width,
    double opacity,
    int seed,
  ) {
    final rnd = Random(seed);
    final spacing = max(4.0, width * 0.6);
    double distanceSinceLastStamp = 0;

    for (int i = 1; i < points.length; i++) {
      final segment = points[i].offset - points[i - 1].offset;
      distanceSinceLastStamp += segment.distance;
      if (distanceSinceLastStamp < spacing) continue;
      distanceSinceLastStamp = 0;

      final sp = points[i];
      final p = sp.offset;
      final localOpacity = opacity * (0.4 + sp.pressure * 0.6);

      final ringPaint = Paint()
        ..color = color.withValues(alpha: localOpacity * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(0.8, width * 0.1);
      canvas.drawCircle(p, width * 0.35, ringPaint);

      final dotPaint = Paint()
        ..color = color.withValues(alpha: localOpacity * 0.6);
      canvas.drawCircle(
        p + Offset((rnd.nextDouble() - 0.5) * 2, (rnd.nextDouble() - 0.5) * 2),
        max(0.6, width * 0.08),
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) => true;
}
