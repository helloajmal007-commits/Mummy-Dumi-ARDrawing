import 'package:flutter/material.dart';

class TutorialStep {
  final String Function() titleResolver;
  final String Function() instructionResolver;
  final String imagePath;

  const TutorialStep({
    required this.titleResolver,
    required this.instructionResolver,
    required this.imagePath,
  });

  String get title => titleResolver();
  String get instruction => instructionResolver();
}

class Tutorial {
  final String id;
  final String Function() titleResolver;
  final String Function() descriptionResolver;
  final IconData icon;
  final Color color;
  final String Function() difficultyResolver;
  final List<TutorialStep> steps;

  const Tutorial({
    required this.id,
    required this.titleResolver,
    required this.descriptionResolver,
    required this.icon,
    required this.color,
    required this.difficultyResolver,
    required this.steps,
  });

  String get title => titleResolver();
  String get description => descriptionResolver();
  String get difficulty => difficultyResolver();
}

class TutorialTraceArgs {
  final List<TutorialStep> steps;
  final int startIndex;

  const TutorialTraceArgs({required this.steps, required this.startIndex});
}