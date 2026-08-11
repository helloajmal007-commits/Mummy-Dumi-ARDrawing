import 'package:flutter/material.dart';

class TutorialStep {
  final String title;
  final String instruction;
  final String imagePath;

  const TutorialStep({
    required this.title,
    required this.instruction,
    required this.imagePath,
  });
}

class Tutorial {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String difficulty;
  final List<TutorialStep> steps;

  const Tutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.difficulty,
    required this.steps,
  });
}

class TutorialTraceArgs {
  final List<TutorialStep> steps;
  final int startIndex;

  const TutorialTraceArgs({required this.steps, required this.startIndex});
}
