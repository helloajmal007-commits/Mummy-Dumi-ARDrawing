import 'package:flutter/material.dart';

class PaletteModel {
  final String id;
  String name;
  List<Color> colors;

  PaletteModel({
    required this.id,
    required this.name,
    required this.colors,
  });

  List<Color> get preview => colors.take(4).toList();
}