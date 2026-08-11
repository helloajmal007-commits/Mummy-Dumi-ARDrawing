import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/layer_model.dart';
import 'package:sketch_flow/app/data/models/project_model.dart';
import 'package:sketch_flow/app/data/models/stroke_model.dart';
import 'package:sketch_flow/app/data/models/tool_model.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/data/services/thumbnail_service.dart';
import 'package:sketch_flow/app/modules/canvas/widgets/sketch_painter.dart';
import 'package:sketch_flow/app/modules/settings/controllers/settings_controller.dart';
import 'package:sketch_flow/app/modules/sketches/controllers/sketches_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:uuid/uuid.dart';

class Stroke {
  final List<StrokePoint> points;
  final Color color;
  final double width;
  final SketchToolType tool;
  final BrushFamily family;
  final double opacity;
  final double hardness;
  final String layerId;
  final int seed;

  Stroke({
    required this.points,
    required this.color,
    required this.width,
    required this.tool,
    required this.family,
    required this.opacity,
    required this.hardness,
    required this.layerId,
    required this.seed,
  });
}

class CanvasController extends GetxController {
  final Rx<ProjectModel?> activeProject = Rx<ProjectModel?>(null);

  final RxList<Stroke> strokes = <Stroke>[].obs;
  final RxList<Stroke> _redoStack = <Stroke>[].obs;
  final List<StrokePoint> _activePoints = [];
  int _liveSeed = 0;

  final Rx<SketchToolType> activeTool = SketchToolType.pencil.obs;
  final Rx<BrushCategory> activeCategory = BrushCategory.basic.obs;
  final Rx<Color> activeColor = const Color(0xFF1C1B19).obs;
  final RxDouble brushSize = 8.0.obs;
  final RxDouble brushOpacity = 1.0.obs;
  final RxDouble brushHardness = 0.8.obs;

  final RxList<LayerModel> layers = <LayerModel>[].obs;
  final RxString activeLayerId = ''.obs;

  final RxDouble zoom = 1.0.obs;
  final RxBool showGrid = false.obs;
  final RxBool isToolSheetOpen = false.obs;

  ui.Picture? _cachedPicture;

  ui.Picture? get cachedPicture => _cachedPicture;

  final RxList<Color> recentColors = <Color>[
    const Color(0xFF1C1B19),
    const Color(0xFFFF6B4A),
    const Color(0xFF4C5FD5),
    const Color(0xFF3E9B6F),
    const Color(0xFFE0503C),
    const Color(0xFFF2C14E),
  ].obs;

  bool get canUndo => strokes.isNotEmpty;

  bool get canRedo => _redoStack.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    if (layers.isEmpty) {
      final base = LayerModel(id: const Uuid().v4(), name: 'Layer 1');
      layers.add(base);
      activeLayerId.value = base.id;
    }
    showGrid.value = Get.find<SettingsController>().showCanvasGridDefault.value;
    _restorePersistedState();
  }

  Size _canvasSize = Size.zero;

  void setCanvasSize(Size size) {
    if (size == _canvasSize) return;
    _canvasSize = size;
    _rebuildCache(_canvasSize);
    update(['strokes_cache']);
  }

  void _rebuildCache(Size size) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = SketchPainter(
      strokes: strokes,
      liveStroke: const [],
      liveColor: Colors.transparent,
      liveWidth: 0,
      liveSeed: 0,
      smoothing: Get.find<SettingsController>().smoothing.value,
    );
    painter.paint(canvas, size);
    _cachedPicture?.dispose();
    _cachedPicture = recorder.endRecording();
  }

  void _restorePersistedState() {
    final savedColor = StorageService.loadLastColor();
    if (savedColor != null) activeColor.value = savedColor;

    final savedSize = StorageService.loadBrushSize();
    if (savedSize != null) brushSize.value = savedSize;

    final savedOpacity = StorageService.loadBrushOpacity();
    if (savedOpacity != null) brushOpacity.value = savedOpacity;

    final savedRecents = StorageService.loadRecentColors();
    if (savedRecents.isNotEmpty) {
      recentColors
        ..clear()
        ..addAll(savedRecents);
    }
  }

  void loadProject(ProjectModel project) {
    activeProject.value = project;
    strokes.clear();
    _redoStack.clear();

    layers
      ..clear()
      ..addAll(
        List.generate(
          project.layerCount,
          (i) => LayerModel(
            id: const Uuid().v4(),
            name: 'Layer ${i + 1}',
            previewColor: project.thumbnailColor,
          ),
        ),
      );
    activeLayerId.value = layers.first.id;

    final validLayerIds = layers.map((l) => l.id).toSet();
    final fallbackLayerId = layers.first.id;

    for (final saved in project.strokes) {
      strokes.add(
        Stroke(
          points: List.generate(
            saved.points.length,
            (i) => StrokePoint(
              saved.points[i],
              i < saved.pressures.length ? saved.pressures[i] : 1.0,
            ),
          ),
          color: Color(saved.colorValue),
          width: saved.width,
          tool: saved.tool,
          family: saved.family,
          opacity: saved.opacity,
          hardness: saved.hardness,
          layerId: validLayerIds.contains(saved.layerId)
              ? saved.layerId
              : fallbackLayerId,
          seed: saved.seed,
        ),
      );
    }

    _rebuildCache(_canvasSize);
    update(['strokes_cache']);
  }

  void startStroke(Offset point, {double pressure = 1.0}) {
    if (Get.find<SettingsController>().hapticFeedback.value) {
      HapticFeedback.selectionClick();
    }
    _activePoints
      ..clear()
      ..add(StrokePoint(point, pressure));
    _liveSeed = DateTime.now().microsecondsSinceEpoch;
    update(['live_stroke']);
  }

  void extendStroke(Offset point, {double pressure = 1.0}) {
    _activePoints.add(StrokePoint(point, pressure));
    update(['live_stroke']);
  }

  void endStroke() {
    if (_activePoints.length > 1) {
      final isEraser = activeTool.value == SketchToolType.eraser;
      strokes.add(
        Stroke(
          points: List.of(_activePoints),
          color: isEraser ? AppColors.canvasWhite : activeColor.value,
          width: brushSize.value,
          tool: activeTool.value,
          family: isEraser
              ? BrushFamily.ink
              : resolveBrushFamily(
                  type: activeTool.value,
                  category: activeCategory.value,
                ),
          opacity: isEraser ? 1.0 : brushOpacity.value,
          hardness: brushHardness.value,
          layerId: activeLayerId.value,
          seed: _liveSeed,
        ),
      );
      _redoStack.clear();
      _rebuildCache(_canvasSize);
      update(['strokes_cache']);
    }
    _activePoints.clear();
    update(['live_stroke']);
    if (Get.find<SettingsController>().autosave.value) {
      saveCurrentProject();
    }
  }

  Future<void> saveCurrentProject() async {
    final project = activeProject.value;
    if (project == null) return;

    final savedStrokes = strokes
        .map(
          (s) => SavedStroke(
            points: s.points.map((p) => p.offset).toList(),
            pressures: s.points.map((p) => p.pressure).toList(),
            colorValue: s.color.toARGB32(),
            width: s.width,
            opacity: s.opacity,
            hardness: s.hardness,
            seed: s.seed,
            tool: s.tool,
            family: s.family,
            layerId: s.layerId,
          ),
        )
        .toList();

    var updated = project.copyWith(
      updatedAt: DateTime.now(),
      layerCount: layers.length,
      strokes: savedStrokes,
      canvasSize: _canvasSize == Size.zero ? project.canvasSize : _canvasSize,
    );

    activeProject.value = updated;

    if (Get.isRegistered<SketchesController>()) {
      Get.find<SketchesController>().updateSketch(updated);
    }

    try {
      final path = await ThumbnailService.saveThumbnail(updated);
      updated = updated.copyWith(thumbnailPath: path);
      activeProject.value = updated;
      if (Get.isRegistered<SketchesController>()) {
        Get.find<SketchesController>().updateSketch(updated);
      }
    } catch (_) {
      // thumbnail generation failed silently — sketch data itself is still saved
    }
  }

  List<StrokePoint> get liveStrokePoints => _activePoints;

  int get liveSeed => _liveSeed;

  void undo() {
    if (strokes.isEmpty) return;
    _redoStack.add(strokes.removeLast());
    _rebuildCache(_canvasSize);
    update(['strokes_cache']);
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    strokes.add(_redoStack.removeLast());
    _rebuildCache(_canvasSize);
    update(['strokes_cache']);
  }

  void clearCanvas() {
    strokes.clear();
    _redoStack.clear();
    _rebuildCache(_canvasSize);
    update(['strokes_cache']);
  }

  void selectTool(SketchToolType tool) {
    if (Get.find<SettingsController>().hapticFeedback.value) {
      HapticFeedback.lightImpact();
    }
    activeTool.value = tool;
    switch (tool) {
      case SketchToolType.pencil:
        activeCategory.value = BrushCategory.fineArt;
        break;
      case SketchToolType.pen:
        activeCategory.value = BrushCategory.basic;
        break;
      case SketchToolType.marker:
        activeCategory.value = BrushCategory.markers;
        break;
      case SketchToolType.airbrush:
        activeCategory.value = BrushCategory.basic;
        break;
      case SketchToolType.smear:
        activeCategory.value = BrushCategory.smudge;
        break;
      default:
        break;
    }
  }

  void setColor(Color color) {
    activeColor.value = color;
    if (!recentColors.contains(color)) {
      recentColors.insert(0, color);
      if (recentColors.length > 6) recentColors.removeLast();
    }
    StorageService.saveLastColor(color);
    StorageService.saveRecentColors(recentColors);
  }

  void setBrushSize(double size) {
    brushSize.value = size.clamp(1, 64);
    StorageService.saveBrushSettings(
      size: brushSize.value,
      opacity: brushOpacity.value,
    );
  }

  void setBrushOpacity(double v) {
    brushOpacity.value = v.clamp(0.05, 1.0);
    StorageService.saveBrushSettings(
      size: brushSize.value,
      opacity: brushOpacity.value,
    );
  }

  void setBrushHardness(double v) => brushHardness.value = v.clamp(0.0, 1.0);

  void selectCategory(BrushCategory category) =>
      activeCategory.value = category;

  void zoomIn() => zoom.value = (zoom.value + 0.1).clamp(0.25, 4.0);

  void zoomOut() => zoom.value = (zoom.value - 0.1).clamp(0.25, 4.0);

  void resetZoom() => zoom.value = 1.0;

  void addLayer() {
    final layer = LayerModel(
      id: const Uuid().v4(),
      name: 'Layer ${layers.length + 1}',
    );
    layers.add(layer);
    activeLayerId.value = layer.id;
  }

  void setActiveLayer(String id) => activeLayerId.value = id;

  void toggleLayerVisibility(String id) {
    final layer = layers.firstWhereOrNull((l) => l.id == id);
    if (layer != null) {
      layer.isVisible = !layer.isVisible;
      layers.refresh();
    }
  }
}
