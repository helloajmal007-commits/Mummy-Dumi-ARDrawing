import 'package:flutter/material.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

class ChromeIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;
  final double size;
  final String? tooltip;

  const ChromeIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.isActive = false,
    this.size = 40,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: isActive ? AppColors.accentSoft : Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: size * 0.5,
            color: onTap == null
                ? AppColors.inkFaint
                : (isActive ? AppColors.accent : AppColors.ink),
          ),
        ),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
