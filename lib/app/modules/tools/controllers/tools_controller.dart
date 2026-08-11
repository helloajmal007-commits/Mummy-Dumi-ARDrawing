import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/tool_model.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:uuid/uuid.dart';

class ToolsController extends GetxController {
  final CanvasController canvas = Get.find<CanvasController>();

  final RxList<BrushPreset> presets = <BrushPreset>[].obs;
  final RxString activePresetId = ''.obs;

  final List<SketchToolType> primaryTools = const [
    SketchToolType.pencil,
    SketchToolType.pen,
    SketchToolType.marker,
    SketchToolType.airbrush,
    SketchToolType.smear,
    SketchToolType.eraser,
  ];

  final List<SketchToolType> utilityTools = const [
    SketchToolType.fill,
    SketchToolType.eyedropper,
    SketchToolType.shape,
    SketchToolType.text,
  ];

  @override
  void onInit() {
    super.onInit();
    _seedPresets();
  }

  void _seedPresets() {
    final uuid = const Uuid();
    presets.addAll([
      // --- Basic ---
      BrushPreset(
        id: uuid.v4(),
        name: 'HB Pencil',
        type: SketchToolType.pencil,
        category: BrushCategory.basic,
        size: 4,
        hardness: 0.9,
        isFavorite: true,
      ),
      BrushPreset(
        id: uuid.v4(),
        name: 'Fine Liner',
        type: SketchToolType.pen,
        category: BrushCategory.basic,
        size: 3,
        hardness: 1.0,
      ),
      BrushPreset(
        id: uuid.v4(),
        name: 'Soft Marker',
        type: SketchToolType.marker,
        category: BrushCategory.basic,
        size: 14,
        opacity: 0.85,
      ),
      BrushPreset(
        id: uuid.v4(),
        name: 'Airbrush Soft',
        type: SketchToolType.airbrush,
        category: BrushCategory.basic,
        size: 28,
        opacity: 0.4,
        hardness: 0.2,
      ),

      // --- Fine Art: graphite pencil set, hard (4H) to soft (9B) ---
      for (final grade in [
        '4H',
        '3H',
        '2H',
        'H',
        'F',
        'HB',
        'B',
        '2B',
        '3B',
        '4B',
        '5B',
        '6B',
        '7B',
        '8B',
        '9B',
      ])
        BrushPreset(
          id: uuid.v4(),
          name: '$grade Pencil',
          type: SketchToolType.pencil,
          category: BrushCategory.fineArt,
          // Harder leads (H-range) → thinner, lower opacity.
          // Softer leads (B-range) → thicker, more opaque, less hard-edged.
          size: 2 + _gradeIndex(grade) * 0.9,
          opacity: 0.55 + _gradeIndex(grade) * 0.03,
          hardness: (1.0 - _gradeIndex(grade) * 0.05).clamp(0.3, 1.0),
        ),

      // --- Markers ---
      BrushPreset(
        id: uuid.v4(),
        name: 'Chisel Marker',
        type: SketchToolType.marker,
        category: BrushCategory.markers,
        size: 10,
        opacity: 0.9,
      ),
      BrushPreset(
        id: uuid.v4(),
        name: 'Bullet Marker',
        type: SketchToolType.marker,
        category: BrushCategory.markers,
        size: 6,
        opacity: 0.95,
      ),
      BrushPreset(
        id: uuid.v4(),
        name: 'Broad Marker',
        type: SketchToolType.marker,
        category: BrushCategory.markers,
        size: 20,
        opacity: 0.8,
      ),

      // --- Artist ---
      BrushPreset(
        id: uuid.v4(),
        name: 'Round Brush',
        type: SketchToolType.pen,
        category: BrushCategory.artist,
        size: 12,
        hardness: 0.6,
      ),
      BrushPreset(
        id: uuid.v4(),
        name: 'Flat Brush',
        type: SketchToolType.pen,
        category: BrushCategory.artist,
        size: 16,
        hardness: 0.5,
      ),
      BrushPreset(
        id: uuid.v4(),
        name: 'Fan Brush',
        type: SketchToolType.pen,
        category: BrushCategory.artist,
        size: 22,
        opacity: 0.7,
        hardness: 0.3,
      ),

      // --- Pastel ---
      BrushPreset(
        id: uuid.v4(),
        name: 'Soft Pastel',
        type: SketchToolType.pencil,
        category: BrushCategory.pastel,
        size: 18,
        opacity: 0.6,
        hardness: 0.25,
      ),
      BrushPreset(
        id: uuid.v4(),
        name: 'Hard Pastel',
        type: SketchToolType.pencil,
        category: BrushCategory.pastel,
        size: 10,
        opacity: 0.75,
        hardness: 0.55,
      ),

      // --- Texture ---
      BrushPreset(
        id: uuid.v4(),
        name: 'Crosshatch',
        type: SketchToolType.pen,
        category: BrushCategory.texture,
        size: 6,
        opacity: 0.5,
        hardness: 0.9,
      ),
      BrushPreset(
        id: uuid.v4(),
        name: 'Grain',
        type: SketchToolType.pencil,
        category: BrushCategory.texture,
        size: 8,
        opacity: 0.4,
        hardness: 0.2,
      ),
    ]);
    final savedId = StorageService.loadLastPresetId();
    final matched = presets.firstWhereOrNull((p) => p.name == savedId);
    activePresetId.value = matched?.id ?? presets.first.id;
  }

  /// Maps a pencil grade string to a 0-14 index (4H hardest → 9B softest),
  /// used to interpolate size/opacity/hardness across the set.
  int _gradeIndex(String grade) {
    const order = [
      '4H',
      '3H',
      '2H',
      'H',
      'F',
      'HB',
      'B',
      '2B',
      '3B',
      '4B',
      '5B',
      '6B',
      '7B',
      '8B',
      '9B',
    ];
    return order.indexOf(grade);
  }

  /// Presets grouped by category, in category-declaration order — used by
  /// the Tools view to render Sketchbook-style labeled sections.
  Map<BrushCategory, List<BrushPreset>> get groupedPresets {
    final map = <BrushCategory, List<BrushPreset>>{};
    for (final category in BrushCategory.values) {
      final inCategory = presets.where((p) => p.category == category).toList();
      if (inCategory.isNotEmpty) map[category] = inCategory;
    }
    return map;
  }

  void toggleFavorite(BrushPreset preset) {
    preset.isFavorite = !preset.isFavorite;
    presets.refresh();
  }

  void selectTool(SketchToolType type) => canvas.selectTool(type);

  void selectPreset(BrushPreset preset) {
    activePresetId.value = preset.id;
    canvas.selectTool(preset.type);
    canvas.selectCategory(preset.category);
    canvas.setBrushSize(preset.size);
    canvas.setBrushOpacity(preset.opacity);
    canvas.setBrushHardness(preset.hardness);
    StorageService.saveLastPreset(preset.name);
  }

  void updatePresetSize(BrushPreset preset, double size) {
    preset.size = size;
    presets.refresh();
    if (activePresetId.value == preset.id) canvas.setBrushSize(size);
  }

  void updatePresetOpacity(BrushPreset preset, double opacity) {
    preset.opacity = opacity;
    presets.refresh();
    if (activePresetId.value == preset.id) canvas.setBrushOpacity(opacity);
  }
}
