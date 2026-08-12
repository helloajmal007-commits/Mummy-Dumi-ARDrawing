import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/palette_model.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:uuid/uuid.dart';

enum PickerTab { wheel, grid, favorites }

enum ValueModel { hsl, rgb }

enum PickerAuxMode { none, harmony, gradientBar }

class ColorPickerController extends GetxController {
  final Rx<PickerTab> activeTab = PickerTab.wheel.obs;
  final Rx<ValueModel> valueModel = ValueModel.hsl.obs;
  final Rx<PickerAuxMode> auxMode = PickerAuxMode.none.obs;

  final Rx<HSVColor> current = HSVColor.fromColor(const Color(0xFF6C4FCE)).obs;

  final Rx<Color> gradientStart = const Color(0xFFFF0000).obs;
  final Rx<Color> gradientEnd = const Color(0xFF0000FF).obs;
  final RxDouble gradientPosition = 0.0.obs;

  final RxList<Color> colorHistory = <Color>[].obs;
  final RxList<PaletteModel> palettes = <PaletteModel>[].obs;
  final RxInt activePaletteIndex = 0.obs;

  final ValueChanged<Color>? onColorCommitted;

  ColorPickerController({this.onColorCommitted, Color? initialColor}) {
    if (initialColor != null) {
      current.value = HSVColor.fromColor(initialColor);
    }
  }

  Color get currentColor => current.value.toColor();

  Color get complementaryColor {
    final hue = (current.value.hue + 180) % 360;
    return current.value.withHue(hue).toColor();
  }

  String get hexCode =>
      '#${currentColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  @override
  void onInit() {
    super.onInit();
    colorHistory.addAll(StorageService.loadRecentColors());
    _seedDefaultPalettes();
  }

  void _seedDefaultPalettes() {
    palettes.addAll([
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.paletteYellowOrange.tr,
        colors: [
          const Color(0xFFFFD400),
          const Color(0xFFFFC700),
          const Color(0xFFFFEA00),
          const Color(0xFFEFD98A),
          const Color(0xFFC9A700),
          const Color(0xFFFFF3B0),
          const Color(0xFFC9A227),
          const Color(0xFFC9A227),
          const Color(0xFFFFC107),
          const Color(0xFFB08D2E),
          const Color(0xFFF2C879),
          const Color(0xFFFF9800),
        ],
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.paletteWarmOranges.tr,
        colors: List.generate(
          12,
          (i) => Color.lerp(Colors.orange.shade200, Colors.deepOrange, i / 11)!,
        ),
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.paletteReds.tr,
        colors: List.generate(
          12,
          (i) => Color.lerp(Colors.red.shade200, Colors.red.shade900, i / 11)!,
        ),
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.paletteMagenta.tr,
        colors: List.generate(
          12,
          (i) => Color.lerp(Colors.pink.shade100, Colors.purple, i / 11)!,
        ),
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.palettePurples.tr,
        colors: List.generate(
          12,
          (i) => Color.lerp(
            Colors.deepPurple.shade100,
            Colors.deepPurple.shade900,
            i / 11,
          )!,
        ),
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.paletteBlues.tr,
        colors: List.generate(
          12,
          (i) => Color.lerp(
            Colors.lightBlue.shade100,
            Colors.blue.shade900,
            i / 11,
          )!,
        ),
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.paletteTeals.tr,
        colors: List.generate(
          12,
          (i) =>
              Color.lerp(Colors.teal.shade100, Colors.teal.shade900, i / 11)!,
        ),
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.paletteGreens.tr,
        colors: List.generate(
          12,
          (i) => Color.lerp(
            Colors.lightGreen.shade100,
            Colors.green.shade900,
            i / 11,
          )!,
        ),
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.paletteGreyscale.tr,
        colors: List.generate(
          12,
          (i) => Color.lerp(Colors.white, Colors.black, i / 11)!,
        ),
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.paletteBrowns.tr,
        colors: List.generate(
          12,
          (i) =>
              Color.lerp(Colors.brown.shade100, Colors.brown.shade900, i / 11)!,
        ),
      ),
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.palettePrimary.tr,
        colors: const [
          Colors.yellow,
          Colors.cyan,
          Colors.red,
          Color(0xFFFF00FF),
          Colors.blue,
          Colors.white,
          Colors.black,
          Colors.grey,
        ],
      ),
    ]);
  }

  void setHue(double hue) {
    current.value = current.value.withHue(hue % 360);
  }

  void setSaturationValue(double saturation, double value) {
    current.value = current.value
        .withSaturation(saturation.clamp(0.0, 1.0))
        .withValue(value.clamp(0.0, 1.0));
  }

  void setColor(Color color) {
    current.value = HSVColor.fromColor(color);
    _commit(color);
  }

  void setHexInput(String hex) {
    final cleaned = hex.replaceAll('#', '').padLeft(6, '0');
    final parsed = int.tryParse(cleaned, radix: 16);
    if (parsed != null) {
      setColor(Color(0xFF000000 | parsed));
    }
  }

  void commitToHistory() => _commit(currentColor);

  void _commit(Color color) {
    if (colorHistory.isEmpty || colorHistory.first != color) {
      colorHistory.insert(0, color);
      if (colorHistory.length > 20) colorHistory.removeLast();
      StorageService.saveRecentColors(colorHistory);
    }
  }

  void setFromHsl(double h, double s, double l) {
    final hsl = HSLColor.fromAHSL(1, h, s, l);
    current.value = HSVColor.fromColor(hsl.toColor());
  }

  HSLColor get asHsl => HSLColor.fromColor(currentColor);

  void setFromRgb(int r, int g, int b) {
    current.value = HSVColor.fromColor(Color.fromARGB(255, r, g, b));
  }

  void setTab(PickerTab tab) => activeTab.value = tab;

  void setValueModel(ValueModel model) => valueModel.value = model;

  void toggleAuxMode(PickerAuxMode mode) {
    auxMode.value = auxMode.value == mode ? PickerAuxMode.none : mode;
  }

  void setGradientEndpoints(Color start, Color end) {
    gradientStart.value = start;
    gradientEnd.value = end;
    _applyGradientPosition();
  }

  void setGradientPosition(double t) {
    gradientPosition.value = t.clamp(0.0, 1.0);
    _applyGradientPosition();
  }

  void _applyGradientPosition() {
    final color = Color.lerp(
      gradientStart.value,
      gradientEnd.value,
      gradientPosition.value,
    )!;
    current.value = HSVColor.fromColor(color);
  }

  void selectPalette(int index) => activePaletteIndex.value = index;

  void renamePalette(int index, String newName) {
    if (newName.trim().isEmpty) return;
    palettes[index].name = newName.trim();
    palettes.refresh();
  }

  void addPalette() {
    palettes.add(
      PaletteModel(
        id: const Uuid().v4(),
        name: TKeys.newPalette.tr,
        colors: List.generate(12, (_) => Colors.grey.shade300),
      ),
    );
    activePaletteIndex.value = palettes.length - 1;
  }

  void deleteActivePalette() {
    if (palettes.length <= 1) return;
    palettes.removeAt(activePaletteIndex.value);
    activePaletteIndex.value = activePaletteIndex.value.clamp(
      0,
      palettes.length - 1,
    );
  }

  void setSwatchInActivePalette(int swatchIndex, Color color) {
    palettes[activePaletteIndex.value].colors[swatchIndex] = color;
    palettes.refresh();
  }

  void nextPalette() {
    if (activePaletteIndex.value < palettes.length - 1) {
      activePaletteIndex.value++;
    }
  }

  void previousPalette() {
    if (activePaletteIndex.value > 0) {
      activePaletteIndex.value--;
    }
  }

  final RxList<Color> favorites = <Color>[].obs;

  void toggleFavorite(Color color) {
    if (favorites.contains(color)) {
      favorites.remove(color);
    } else {
      favorites.add(color);
    }
  }

  bool isFavorite(Color color) => favorites.contains(color);
}
