import 'package:flutter/material.dart';

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

extension SketchToolMeta on SketchToolType {
  String get label {
    switch (this) {
      case SketchToolType.pencil:
        return 'Pencil';
      case SketchToolType.pen:
        return 'Pen';
      case SketchToolType.marker:
        return 'Marker';
      case SketchToolType.airbrush:
        return 'Airbrush';
      case SketchToolType.smear:
        return 'Smear';
      case SketchToolType.eraser:
        return 'Eraser';
      case SketchToolType.fill:
        return 'Fill';
      case SketchToolType.eyedropper:
        return 'Eyedropper';
      case SketchToolType.shape:
        return 'Shape';
      case SketchToolType.text:
        return 'Text';
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
        return 'Basic';
      case BrushCategory.fineArt:
        return 'Fine Art';
      case BrushCategory.markers:
        return 'Markers';
      case BrushCategory.legacy:
        return 'Legacy';
      case BrushCategory.artist:
        return 'Artist';
      case BrushCategory.pastel:
        return 'Pastel';
      case BrushCategory.synthetic:
        return 'Synthetic Paint';
      case BrushCategory.traditional:
        return 'Traditional';
      case BrushCategory.texture:
        return 'Texture';
      case BrushCategory.halfTone:
        return 'Half Tone';
      case BrushCategory.shape:
        return 'Shape';
      case BrushCategory.splatter:
        return 'Splatter';
      case BrushCategory.glow:
        return 'Glow';
      case BrushCategory.smudge:
        return 'Smudge';
      case BrushCategory.designer:
        return 'Designer';
      case BrushCategory.colorless:
        return 'Colorless';
    }
  }
}

enum BrushFamily {
  graphite, // grainy, pressure-thinned, textured edge
  ink, // crisp constant width, hard edge, high opacity
  markerFlat, // flat semi-transparent fill, overlap darkening, chisel cap
  airbrushSpray, // soft radial dab stamping, additive buildup
  softChalk, // broad low-opacity strokes, heavy grain scatter
  bristlePaint, // multi-line offset strokes simulating brush hairs
  smudgeDrag, // drags/samples existing canvas pixels
  splatterDots, // randomized particle stamping
  patternStamp, // repeating motif/texture/glow stamped along the path
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
