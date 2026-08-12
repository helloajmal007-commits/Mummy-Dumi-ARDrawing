import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';

enum BlendMode2 { normal, multiply, screen, overlay, darken, lighten }

extension BlendMode2Meta on BlendMode2 {
  String get label {
    switch (this) {
      case BlendMode2.normal:
        return TKeys.blendNormal.tr;
      case BlendMode2.multiply:
        return TKeys.blendMultiply.tr;
      case BlendMode2.screen:
        return TKeys.blendScreen.tr;
      case BlendMode2.overlay:
        return TKeys.blendOverlay.tr;
      case BlendMode2.darken:
        return TKeys.blendDarken.tr;
      case BlendMode2.lighten:
        return TKeys.blendLighten.tr;
    }
  }
}

class LayerModel {
  final String id;
  String name;
  bool isVisible;
  bool isLocked;
  double opacity;
  BlendMode2 blendMode;
  final Color previewColor;

  LayerModel({
    required this.id,
    required this.name,
    this.isVisible = true,
    this.isLocked = false,
    this.opacity = 1.0,
    this.blendMode = BlendMode2.normal,
    this.previewColor = Colors.white,
  });
}
