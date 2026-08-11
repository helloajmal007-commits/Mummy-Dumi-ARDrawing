import 'package:flutter/material.dart';

enum BlendMode2 { normal, multiply, screen, overlay, darken, lighten }

extension BlendMode2Label on BlendMode2 {
  String get label {
    switch (this) {
      case BlendMode2.normal:
        return 'Normal';
      case BlendMode2.multiply:
        return 'Multiply';
      case BlendMode2.screen:
        return 'Screen';
      case BlendMode2.overlay:
        return 'Overlay';
      case BlendMode2.darken:
        return 'Darken';
      case BlendMode2.lighten:
        return 'Lighten';
    }
  }
}

/// Represents a single layer inside a sketch canvas.
class LayerModel {
  final String id;
  String name;
  bool isVisible;
  bool isLocked;
  double opacity; // 0.0 - 1.0
  BlendMode2 blendMode;
  final Color previewColor; // placeholder for a rendered thumbnail

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
