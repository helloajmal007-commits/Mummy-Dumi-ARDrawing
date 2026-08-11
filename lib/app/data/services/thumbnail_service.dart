import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sketch_flow/app/data/models/project_model.dart';
import 'package:sketch_flow/app/data/models/stroke_model.dart';
import 'package:sketch_flow/app/data/models/tool_model.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:sketch_flow/app/modules/canvas/widgets/sketch_painter.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

class ThumbnailService {
  ThumbnailService._();

  static List<Stroke> _toStrokes(List<SavedStroke> saved) {
    return saved
        .map(
          (s) => Stroke(
            points: List.generate(
              s.points.length,
              (i) => StrokePoint(
                s.points[i],
                i < s.pressures.length ? s.pressures[i] : 1.0,
              ),
            ),
            color: Color(s.colorValue),
            width: s.width,
            tool: s.tool,
            family: s.family,
            opacity: s.opacity,
            hardness: s.hardness,
            layerId: s.layerId,
            seed: s.seed,
          ),
        )
        .toList();
  }

  static Future<Uint8List> renderPng(
    ProjectModel project, {
    double width = 480,
    double height = 600,
    Color background = AppColors.canvasWhite,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(width, height);

    canvas.drawRect(Offset.zero & size, Paint()..color = background);

    final safeCanvasWidth = project.canvasSize.width == 0
        ? width
        : project.canvasSize.width;
    final safeCanvasHeight = project.canvasSize.height == 0
        ? height
        : project.canvasSize.height;

    final scaleX = width / safeCanvasWidth;
    final scaleY = height / safeCanvasHeight;
    canvas.save();
    canvas.scale(scaleX, scaleY);

    final painter = SketchPainter(
      strokes: _toStrokes(project.strokes),
      liveStroke: const [],
      liveColor: Colors.transparent,
      liveWidth: 0,
      liveSeed: 0,
    );
    painter.paint(canvas, Size(safeCanvasWidth, safeCanvasHeight));
    canvas.restore();

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.round(), height.round());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    picture.dispose();
    image.dispose();
    return byteData!.buffer.asUint8List();
  }

  static Future<String> saveThumbnail(ProjectModel project) async {
    final bytes = await renderPng(project, width: 480, height: 600);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/thumb_${project.id}.png');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}
