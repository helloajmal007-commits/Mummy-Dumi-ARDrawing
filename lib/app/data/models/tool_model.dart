import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';

class StrokePoint {
  final Offset offset;
  final double pressure;

  const StrokePoint(this.offset, this.pressure);
}

enum SketchToolType {
  pencil,
  pen,
  marker,
  airbrush,
  smear,
  eraser,
  fill,
  eyedropper,
  shape,
  text,
}

extension SketchToolTypeMeta on SketchToolType {
  String get label {
    switch (this) {
      case SketchToolType.pencil:
        return TKeys.toolPencil.tr;
      case SketchToolType.pen:
        return TKeys.toolPen.tr;
      case SketchToolType.marker:
        return TKeys.toolMarker.tr;
      case SketchToolType.airbrush:
        return TKeys.toolAirbrush.tr;
      case SketchToolType.smear:
        return TKeys.toolSmear.tr;
      case SketchToolType.eraser:
        return TKeys.toolEraser.tr;
      case SketchToolType.fill:
        return TKeys.toolFill.tr;
      case SketchToolType.eyedropper:
        return TKeys.toolEyedropper.tr;
      case SketchToolType.shape:
        return TKeys.toolShape.tr;
      case SketchToolType.text:
        return TKeys.toolText.tr;
    }
  }

  IconData get icon {
    switch (this) {
      case SketchToolType.pencil:
        return Icons.edit_outlined;
      case SketchToolType.pen:
        return Icons.brush_outlined;
      case SketchToolType.marker:
        return Icons.gesture;
      case SketchToolType.airbrush:
        return Icons.blur_on;
      case SketchToolType.smear:
        return Icons.waves;
      case SketchToolType.eraser:
        return Icons.auto_fix_normal_outlined;
      case SketchToolType.fill:
        return Icons.format_color_fill;
      case SketchToolType.eyedropper:
        return Icons.colorize_outlined;
      case SketchToolType.shape:
        return Icons.category_outlined;
      case SketchToolType.text:
        return Icons.text_fields;
    }
  }
}

enum BrushCategory {
  basic,
  fineArt,
  markers,
  legacy,
  artist,
  pastel,
  synthetic,
  traditional,
  texture,
  halfTone,
  shape,
  splatter,
  glow,
  smudge,
  designer,
  colorless,
}

extension BrushCategoryLabel on BrushCategory {
  String get label {
    switch (this) {
      case BrushCategory.basic:
        return TKeys.categoryBasic.tr;
      case BrushCategory.fineArt:
        return TKeys.categoryFineArt.tr;
      case BrushCategory.markers:
        return TKeys.categoryMarkers.tr;
      case BrushCategory.legacy:
        return TKeys.categoryLegacy.tr;
      case BrushCategory.artist:
        return TKeys.categoryArtist.tr;
      case BrushCategory.pastel:
        return TKeys.categoryPastel.tr;
      case BrushCategory.synthetic:
        return TKeys.categorySynthetic.tr;
      case BrushCategory.traditional:
        return TKeys.categoryTraditional.tr;
      case BrushCategory.texture:
        return TKeys.categoryTexture.tr;
      case BrushCategory.halfTone:
        return TKeys.categoryHalfTone.tr;
      case BrushCategory.shape:
        return TKeys.categoryShape.tr;
      case BrushCategory.splatter:
        return TKeys.categorySplatter.tr;
      case BrushCategory.glow:
        return TKeys.categoryGlow.tr;
      case BrushCategory.smudge:
        return TKeys.categorySmudge.tr;
      case BrushCategory.designer:
        return TKeys.categoryDesigner.tr;
      case BrushCategory.colorless:
        return TKeys.categoryColorless.tr;
    }
  }
}

enum BrushFamily {
  graphite,
  ink,
  markerFlat,
  airbrushSpray,
  softChalk,
  bristlePaint,
  smudgeDrag,
  splatterDots,
  patternStamp,
}

extension BrushCategoryFamily on BrushCategory {
  BrushFamily get family {
    switch (this) {
      case BrushCategory.fineArt:
        return BrushFamily.graphite;
      case BrushCategory.basic:
      case BrushCategory.legacy:
      case BrushCategory.designer:
      case BrushCategory.traditional:
        return BrushFamily.ink;
      case BrushCategory.markers:
        return BrushFamily.markerFlat;
      case BrushCategory.pastel:
        return BrushFamily.softChalk;
      case BrushCategory.artist:
      case BrushCategory.synthetic:
        return BrushFamily.bristlePaint;
      case BrushCategory.smudge:
        return BrushFamily.smudgeDrag;
      case BrushCategory.splatter:
        return BrushFamily.splatterDots;
      case BrushCategory.texture:
      case BrushCategory.halfTone:
      case BrushCategory.shape:
      case BrushCategory.glow:
      case BrushCategory.colorless:
        return BrushFamily.patternStamp;
    }
  }
}

BrushFamily resolveBrushFamily({
  required SketchToolType type,
  required BrushCategory category,
}) {
  if (type == SketchToolType.airbrush) return BrushFamily.airbrushSpray;
  if (type == SketchToolType.smear) return BrushFamily.smudgeDrag;
  return category.family;
}

class BrushPreset {
  final String id;
  final String name;
  final SketchToolType type;
  final BrushCategory category;
  double size;
  double opacity;
  double hardness;
  bool isFavorite;

  BrushPreset({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    this.size = 8,
    this.opacity = 1.0,
    this.hardness = 0.8,
    this.isFavorite = false,
  });
}
