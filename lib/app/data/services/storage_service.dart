import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sketch_flow/app/data/models/project_model.dart';

class StorageService {
  StorageService._();

  static final GetStorage _box = GetStorage();

  static const _kLastColor = 'last_color';
  static const _kLastPresetId = 'last_preset_id';
  static const _kLastBrushSize = 'last_brush_size';
  static const _kLastBrushOpacity = 'last_brush_opacity';
  static const _kRecentColors = 'recent_colors';
  static const _kProjects = 'projects';
  static const _kLanguageCode = 'language_code';

  static void saveLanguageCode(String code) {
    _box.write(_kLanguageCode, code);
  }

  static String? loadLanguageCode() => _box.read<String>(_kLanguageCode);
  static void saveLastColor(Color color) {
    _box.write(_kLastColor, color.toARGB32());
  }

  static Color? loadLastColor() {
    final value = _box.read<int>(_kLastColor);
    return value == null ? null : Color(value);
  }

  static void saveLastPreset(String presetId) {
    _box.write(_kLastPresetId, presetId);
  }

  static String? loadLastPresetId() => _box.read<String>(_kLastPresetId);

  static void saveBrushSettings({
    required double size,
    required double opacity,
  }) {
    _box.write(_kLastBrushSize, size);
    _box.write(_kLastBrushOpacity, opacity);
  }

  static double? loadBrushSize() => _box.read<double>(_kLastBrushSize);

  static double? loadBrushOpacity() => _box.read<double>(_kLastBrushOpacity);

  static void saveRecentColors(List<Color> colors) {
    _box.write(_kRecentColors, colors.map((c) => c.toARGB32()).toList());
  }

  static List<Color> loadRecentColors() {
    final raw = _box.read<List>(_kRecentColors);
    if (raw == null) return [];
    return raw.map((v) => Color(v as int)).toList();
  }

  static void saveProjects(List<ProjectModel> projects) {
    final raw = jsonEncode(projects.map((p) => p.toJson()).toList());
    _box.write(_kProjects, raw);
  }

  static List<ProjectModel> loadProjects() {
    final raw = _box.read<String>(_kProjects);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((p) => ProjectModel.fromJson(p as Map<String, dynamic>))
        .toList();
  }
}
