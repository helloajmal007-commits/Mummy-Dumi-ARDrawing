import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';

enum AppTab { home, learn, categories, settings }

class AppBottomNav extends StatelessWidget {
  final AppTab current;

  const AppBottomNav({super.key, required this.current});

  void _go(AppTab tab) {
    if (tab == current) return;

    switch (tab) {
      case AppTab.home:
        Get.offAllNamed(Routes.home);
        break;
      case AppTab.learn:
        Get.toNamed(Routes.learn);
        break;
      case AppTab.categories:
        Get.toNamed(Routes.categories);
        break;
      case AppTab.settings:
        Get.toNamed(Routes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      padding: EdgeInsets.zero,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_filled,
                label: 'Home',
                isActive: current == AppTab.home,
                onTap: () => _go(AppTab.home),
              ),
              _NavItem(
                icon: Icons.school_outlined,
                label: 'Learn',
                isActive: current == AppTab.learn,
                onTap: () => _go(AppTab.learn),
              ),
              const SizedBox(width: 40), // reserved notch space
              _NavItem(
                icon: Icons.grid_view_outlined,
                label: 'Categories',
                isActive: current == AppTab.categories,
                onTap: () => _go(AppTab.categories),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isActive: current == AppTab.settings,
                onTap: () => _go(AppTab.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.accent : AppColors.inkMuted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? AppColors.accentSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
