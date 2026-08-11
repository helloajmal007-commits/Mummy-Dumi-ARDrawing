import 'package:flutter/material.dart';
import 'package:sketch_flow/app/data/models/tool_model.dart';

class SavedStroke {
  final List<Offset> points;
  final List<double> pressures;
  final int colorValue;
  final double width;
  final double opacity;
  final double hardness;
  final int seed;
  final SketchToolType tool;
  final BrushFamily family;
  final String layerId;

  SavedStroke({
    required this.points,
    required this.pressures,
    required this.colorValue,
    required this.width,
    required this.opacity,
    required this.hardness,
    required this.seed,
    required this.tool,
    required this.family,
    required this.layerId,
  });

  Map<String, dynamic> toJson() => {
    'points': points.map((p) => [p.dx, p.dy]).toList(),
    'pressures': pressures,
    'color': colorValue,
    'width': width,
    'opacity': opacity,
    'hardness': hardness,
    'seed': seed,
    'tool': tool.index,
    'family': family.index,
    'layerId': layerId,
  };

  factory SavedStroke.fromJson(Map<String, dynamic> json) {
    return SavedStroke(
      points: (json['points'] as List)
          .map(
            (p) => Offset((p[0] as num).toDouble(), (p[1] as num).toDouble()),
          )
          .toList(),
      pressures: (json['pressures'] as List)
          .map((p) => (p as num).toDouble())
          .toList(),
      colorValue: json['color'] as int,
      width: (json['width'] as num).toDouble(),
      opacity: (json['opacity'] as num).toDouble(),
      hardness: (json['hardness'] as num).toDouble(),
      seed: json['seed'] as int,
      tool: SketchToolType.values[json['tool'] as int],
      family: BrushFamily.values[json['family'] as int],
      layerId: json['layerId'] as String,
    );
  }
}
