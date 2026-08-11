import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/layer_model.dart';
import 'package:sketch_flow/app/modules/layers/controllers/layers_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/chrome_icon_button.dart';

class LayersView extends GetView<LayersController> {
  const LayersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpace.lg, AppSpace.md, AppSpace.lg, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChromeIconButton(
                    icon: Icons.close,
                    size: 36,
                    onTap: () => Get.back(),
                  ),
                  Text('Layers', style: AppTypography.h3),
                  ChromeIconButton(
                    icon: Icons.add,
                    size: 36,
                    onTap: controller.addLayer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            Expanded(
              child: Obx(() {
                final layers = controller.layers;
                return ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpace.lg, 0, AppSpace.lg, AppSpace.xxxl),
                  itemCount: layers.length,
                  onReorder: controller.reorder,
                  itemBuilder: (context, i) {
                    final layer = layers[i];
                    return _LayerTile(
                      key: ValueKey(layer.id),
                      layer: layer,
                      isActive: layer.id == controller.activeLayerId,
                      controller: controller,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _LayerTile extends StatelessWidget {
  final LayerModel layer;
  final bool isActive;
  final LayersController controller;

  const _LayerTile({
    super.key,
    required this.layer,
    required this.isActive,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.sm),
      child: GestureDetector(
        onTap: () => controller.select(layer.id),
        onLongPress: () => _showLayerSheet(context, layer, controller),
        child: Container(
          padding: const EdgeInsets.all(AppSpace.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isActive ? AppColors.accent : AppColors.divider,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.drag_indicator, color: AppColors.inkFaint, size: 18),
              const SizedBox(width: AppSpace.xs),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: layer.previewColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.divider),
                ),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      layer.name,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                        layer.isVisible ? AppColors.ink : AppColors.inkFaint,
                      ),
                    ),
                    Text(
                      '${layer.blendMode.label} · ${(layer.opacity * 100).round()}%',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              ChromeIconButton(
                icon: layer.isLocked ? Icons.lock_outline : Icons.lock_open,
                size: 36,
                isActive: layer.isLocked,
                onTap: () => controller.toggleLock(layer),
              ),
              ChromeIconButton(
                icon: layer.isVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 36,
                onTap: () => controller.toggleVisibility(layer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showLayerSheet(
    BuildContext context, LayerModel layer, LayersController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(AppSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(layer.name, style: AppTypography.h3),
          const SizedBox(height: AppSpace.lg),
          Text('Opacity', style: AppTypography.label),
          StatefulBuilder(
            builder: (context, setState) => Slider(
              value: layer.opacity,
              onChanged: (v) {
                setState(() {});
                controller.setOpacity(layer, v);
              },
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Text('Blend mode', style: AppTypography.label),
          const SizedBox(height: AppSpace.sm),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            children: BlendMode2.values
                .map(
                  (mode) => ChoiceChip(
                label: Text(mode.label),
                selected: layer.blendMode == mode,
                onSelected: (_) => controller.setBlendMode(layer, mode),
              ),
            )
                .toList(),
          ),
          const SizedBox(height: AppSpace.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    controller.duplicateLayer(layer);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: const Text('Duplicate'),
                ),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    controller.deleteLayer(layer);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete_outline,
                      size: 18, color: AppColors.danger),
                  label: Text('Delete',
                      style: TextStyle(color: AppColors.danger)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
