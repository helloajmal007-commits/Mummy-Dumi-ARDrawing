import 'package:flutter/material.dart';
import 'package:sketch_flow/app/data/models/stroke_model.dart';

class ProjectModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Color thumbnailColor;
  final Size canvasSize;
  final int layerCount;
  final List<SavedStroke> strokes;
  final String? thumbnailPath;

  ProjectModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.thumbnailColor,
    this.canvasSize = const Size(1080, 1350),
    this.layerCount = 1,
    this.strokes = const [],
    this.thumbnailPath,
  });

  ProjectModel copyWith({
    String? name,
    DateTime? updatedAt,
    int? layerCount,
    List<SavedStroke>? strokes,
    String? thumbnailPath,
    Size? canvasSize,
  }) {
    return ProjectModel(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      thumbnailColor: thumbnailColor,
      canvasSize: canvasSize ?? this.canvasSize,
      layerCount: layerCount ?? this.layerCount,
      strokes: strokes ?? this.strokes,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'thumbnailColor': thumbnailColor.toARGB32(),
    'canvasWidth': canvasSize.width,
    'canvasHeight': canvasSize.height,
    'layerCount': layerCount,
    'thumbnailPath': thumbnailPath,
    'strokes': strokes.map((s) => s.toJson()).toList(),
  };

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      thumbnailColor: Color(json['thumbnailColor'] as int),
      canvasSize: Size(
        (json['canvasWidth'] as num).toDouble(),
        (json['canvasHeight'] as num).toDouble(),
      ),
      layerCount: json['layerCount'] as int,
      thumbnailPath: json['thumbnailPath'] as String?,
      strokes: (json['strokes'] as List)
          .map((s) => SavedStroke.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
