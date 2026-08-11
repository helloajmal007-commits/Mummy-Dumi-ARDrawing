import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/tool_model.dart';
import 'package:sketch_flow/app/modules/tools/controllers/tools_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/chrome_icon_button.dart';
import 'package:sketch_flow/app/widgets/section_header.dart';

class ToolsView extends GetView<ToolsController> {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.lg,
                AppSpace.md,
                AppSpace.lg,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChromeIconButton(
                    icon: Icons.close,
                    size: 36,
                    onTap: () => Get.back(),
                  ),
                  Text('Tools', style: AppTypography.h3),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.lg,
                  AppSpace.lg,
                  AppSpace.lg,
                  AppSpace.xxxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final grouped = controller.groupedPresets;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: grouped.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpace.xl),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionHeader(
                                  title: entry.key.label.toUpperCase(),
                                ),
                                const SizedBox(height: AppSpace.md),
                                Wrap(
                                  spacing: AppSpace.md,
                                  runSpacing: AppSpace.md,
                                  children: entry.value
                                      .map(
                                        (preset) => _PresetCard(
                                          preset: preset,
                                          isActive:
                                              controller.activePresetId.value ==
                                              preset.id,
                                          onTap: () =>
                                              controller.selectPreset(preset),
                                          onLongPress: () =>
                                              controller.toggleFavorite(preset),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: AppSpace.xl),
                    const SectionHeader(title: 'UTILITY'),
                    const SizedBox(height: AppSpace.md),
                    Wrap(
                      spacing: AppSpace.md,
                      runSpacing: AppSpace.md,
                      children: controller.utilityTools
                          .map(
                            (tool) => Obx(
                              () => _ToolChip(
                                tool: tool,
                                isActive:
                                    controller.canvas.activeTool.value == tool,
                                onTap: () => controller.selectTool(tool),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppSpace.xl),
                    const SectionHeader(title: 'BRUSH SETTINGS'),
                    const SizedBox(height: AppSpace.md),
                    _BrushSettingsCard(controller: controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final BrushPreset preset;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _PresetCard({
    required this.preset,
    required this.isActive,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: 104,
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.divider,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  preset.type.icon,
                  color: isActive ? AppColors.accent : AppColors.ink,
                  size: 22,
                ),
                if (preset.isFavorite)
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.coral,
                    size: 16,
                  ),
              ],
            ),
            const SizedBox(height: AppSpace.md),
            Text(
              preset.name,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  final SketchToolType tool;
  final bool isActive;
  final VoidCallback onTap;

  const _ToolChip({
    required this.tool,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.md,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.ink : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isActive ? AppColors.ink : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              tool.icon,
              size: 16,
              color: isActive ? Colors.white : AppColors.ink,
            ),
            const SizedBox(width: AppSpace.xs),
            Text(
              tool.label,
              style: AppTypography.bodySmall.copyWith(
                color: isActive ? Colors.white : AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrushSettingsCard extends StatelessWidget {
  final ToolsController controller;

  const _BrushSettingsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => _SliderRow(
              label: 'Size',
              value: controller.canvas.brushSize.value,
              min: 1,
              max: 64,
              display: '${controller.canvas.brushSize.value.round()}px',
              onChanged: controller.canvas.setBrushSize,
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Obx(
            () => _SliderRow(
              label: 'Opacity',
              value: controller.canvas.brushOpacity.value,
              min: 0.05,
              max: 1.0,
              display:
                  '${(controller.canvas.brushOpacity.value * 100).round()}%',
              onChanged: controller.canvas.setBrushOpacity,
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Obx(
            () => _SliderRow(
              label: 'Hardness',
              value: controller.canvas.brushHardness.value,
              min: 0.0,
              max: 1.0,
              display:
                  '${(controller.canvas.brushHardness.value * 100).round()}%',
              onChanged: controller.canvas.setBrushHardness,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String display;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.display,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.body),
            Text(display, style: AppTypography.bodySmall),
          ],
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}
