import 'package:flutter/material.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final IconData primaryIcon;
  final IconData accentIcon;
  final Color background;
  final Color accentColor;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.primaryIcon,
    required this.accentIcon,
    required this.background,
    required this.accentColor,
  });
}