import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/tool_model.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:sketch_flow/app/modules/canvas/views/color_picker_view.dart';
import 'package:sketch_flow/app/modules/canvas/widgets/sketch_painter.dart';
import 'package:sketch_flow/app/modules/canvas/widgets/tool_dock.dart';
import 'package:sketch_flow/app/modules/settings/controllers/settings_controller.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/chrome_icon_button.dart';
import 'package:sketch_flow/app/widgets/color_swatch_button.dart';

class CanvasView extends GetView<CanvasController> {
  const CanvasView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(controller: controller),
            const SizedBox(height: AppSpace.sm),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpace.lg,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.setCanvasSize(constraints.biggest);
                          });
                          return Container(
                            width: double.infinity,
                            color: AppColors.canvasWhite,
                            child: Listener(
                              onPointerDown: (e) => controller.startStroke(
                                e.localPosition,
                                pressure: _normalizedPressure(e),
                              ),
                              onPointerMove: (e) => controller.extendStroke(
                                e.localPosition,
                                pressure: _normalizedPressure(e),
                              ),
                              onPointerUp: (_) => controller.endStroke(),
                              child: Stack(
                                children: [
                                  GetBuilder<CanvasController>(
                                    id: 'strokes_cache',
                                    builder: (_) => CustomPaint(
                                      painter: CachedStrokesPainter(
                                        controller.cachedPicture,
                                      ),
                                      size: Size.infinite,
                                    ),
                                  ),
                                  GetBuilder<CanvasController>(
                                    id: 'live_stroke',
                                    builder: (_) => Obx(
                                      () => CustomPaint(
                                        painter: SketchPainter(
                                          strokes: const [],
                                          liveStroke:
                                              controller.liveStrokePoints,
                                          liveColor:
                                              controller.activeColor.value,
                                          liveWidth: controller.brushSize.value,
                                          liveSeed: controller.liveSeed,
                                          liveFamily: resolveBrushFamily(
                                            type: controller.activeTool.value,
                                            category:
                                                controller.activeCategory.value,
                                          ),
                                          liveOpacity:
                                              controller.brushOpacity.value,
                                          liveHardness:
                                              controller.brushHardness.value,
                                          showGrid: controller.showGrid.value,
                                          smoothing:
                                              Get.find<SettingsController>()
                                                  .smoothing
                                                  .value,
                                        ),
                                        size: Size.infinite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Obx(() {
                    final leftHanded =
                        Get.find<SettingsController>().leftHandedMode.value;
                    return Positioned(
                      left: leftHanded ? null : AppSpace.xl,
                      right: leftHanded ? AppSpace.xl : null,
                      bottom: AppSpace.lg,
                      child: Obx(
                        () => ColorSwatchButton(
                          color: controller.activeColor.value,
                          size: AppSize.swatchLarge,
                          onTap: () => _showColorSheet(context, controller),
                        ),
                      ),
                    );
                  }),
                  Obx(() {
                    final leftHanded =
                        Get.find<SettingsController>().leftHandedMode.value;
                    return Positioned(
                      right: leftHanded ? null : AppSpace.xl,
                      left: leftHanded ? AppSpace.xl : null,
                      bottom: AppSpace.lg,
                      child: Column(
                        children: [
                          _MiniAction(
                            icon: Icons.add,
                            onTap: controller.zoomIn,
                          ),
                          const SizedBox(height: AppSpace.sm),
                          Obx(
                            () => Text(
                              '${(controller.zoom.value * 100).round()}%',
                              style: AppTypography.caption,
                            ),
                          ),
                          const SizedBox(height: AppSpace.sm),
                          _MiniAction(
                            icon: Icons.remove,
                            onTap: controller.zoomOut,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.lg),
              child: ToolDock(
                controller: controller,
                onOpenTools: () => Get.toNamed(Routes.tools),
                onOpenLayers: () => Get.toNamed(Routes.layers),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorSheet(BuildContext context, CanvasController controller) {
    showColorPicker(
      context,
      initialColor: controller.activeColor.value,
      onColorChanged: controller.setColor,
    );
  }
}

class _TopBar extends StatelessWidget {
  final CanvasController controller;

  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      child: SizedBox(
        height: AppSize.topBar,
        child: Row(
          children: [
            ChromeIconButton(
              icon: Icons.arrow_back_ios_new,
              size: 36,
              onTap: () => Get.back(),
            ),
            const Spacer(),
            Obx(
              () => ChromeIconButton(
                icon: Icons.undo,
                onTap: controller.canUndo ? controller.undo : null,
              ),
            ),
            Obx(
              () => ChromeIconButton(
                icon: Icons.redo,
                onTap: controller.canRedo ? controller.redo : null,
              ),
            ),
            Obx(
              () => ChromeIconButton(
                icon: Icons.grid_on_outlined,
                isActive: controller.showGrid.value,
                onTap: () =>
                    controller.showGrid.value = !controller.showGrid.value,
              ),
            ),
            ChromeIconButton(
              icon: Icons.save_outlined,
              onTap: () => _manualSave(context, controller),
            ),
            ChromeIconButton(
              icon: Icons.ios_share,
              onTap: () => Get.toNamed(Routes.export),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.divider),
          ),
          child: Icon(icon, size: 16, color: AppColors.ink),
        ),
      ),
    );
  }
}

double _normalizedPressure(PointerEvent e) {
  if (!Get.find<SettingsController>().pressureSensitivity.value) return 1.0;
  if (e.pressureMax <= e.pressureMin) return 1.0;
  return ((e.pressure - e.pressureMin) / (e.pressureMax - e.pressureMin)).clamp(
    0.0,
    1.0,
  );
}

Future<void> _manualSave(
  BuildContext context,
  CanvasController controller,
) async {
  if (controller.activeProject.value == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nothing to save yet — this sketch isn\'t linked to a project.',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
    return;
  }

  await controller.saveCurrentProject();
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved'), duration: Duration(seconds: 1)),
    );
  }
}
