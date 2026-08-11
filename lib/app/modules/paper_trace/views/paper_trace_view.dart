import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/tutorial_model.dart';
import 'package:sketch_flow/app/modules/paper_trace/controllers/paper_trace_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';

class PaperTraceView extends StatefulWidget {
  const PaperTraceView({super.key});

  @override
  State<PaperTraceView> createState() => _PaperTraceViewState();
}

class _PaperTraceViewState extends State<PaperTraceView> {
  late final PaperTraceController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<PaperTraceController>()
        ? Get.find<PaperTraceController>()
        : Get.put(PaperTraceController());
    final args = Get.arguments;
    if (args is TutorialTraceArgs) {
      controller.loadStepSequence(args.steps, args.startIndex);
    } else if (args is String) {
      controller.loadFromAssetPath(args);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.white),
          Obx(
            () => controller.hasImage
                ? _ImageLayer(controller: controller)
                : const SizedBox.shrink(),
          ),
          Obx(
            () => controller.isExtended.value
                ? const SizedBox.shrink()
                : _TopBar(controller: controller),
          ),
          Obx(() {
            if (controller.isExtended.value || !controller.hasSteps) {
              return const SizedBox.shrink();
            }
            final step =
                controller.stepSequence[controller.currentStepIndex.value];
            return _StepBanner(
              instruction: step.instruction,
              stepNumber: controller.currentStepIndex.value + 1,
              total: controller.stepSequence.length,
            );
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Obx(() {
                if (controller.isExtended.value) return const SizedBox.shrink();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.hasSteps)
                      _StepNavigatorBar(controller: controller),
                    controller.hasImage
                        ? _BottomControls(controller: controller)
                        : _NoImagePrompt(controller: controller),
                  ],
                );
              }),
            ),
          ),
          Obx(
            () => controller.isExtended.value
                ? Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onDoubleTap: controller.toggleExtended,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _ImageLayer extends StatelessWidget {
  final PaperTraceController controller;

  const _ImageLayer({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final image = controller.image.value!;
      final offset = controller.offset.value;
      final scale = controller.scale.value;
      final rotation = controller.rotation.value;
      final opacity = controller.opacity.value;

      return GestureDetector(
        onScaleUpdate: (details) {
          controller.updateTransform(
            offsetDelta: details.focalPointDelta,
            scaleDelta: details.scale == 1.0 ? 1.0 : details.scale,
            rotationDelta: details.rotation,
          );
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final boxWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : 400.0;
            final boxHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : 600.0;
            return Center(
              child: Transform.translate(
                offset: offset,
                child: Transform.rotate(
                  angle: rotation,
                  child: Transform.scale(
                    scale: scale,
                    child: SizedBox(
                      width: boxWidth,
                      height: boxHeight,
                      child: Opacity(
                        opacity: opacity,
                        child: Image.file(
                          image,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.surfaceRaised,
                              padding: const EdgeInsets.all(AppSpace.lg),
                              child: Text(
                                'This image could not be displayed. Try a different photo.',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _TopBar extends StatelessWidget {
  final PaperTraceController controller;

  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.18),
              Colors.black.withValues(alpha: 0.0),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.lg,
              vertical: AppSpace.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleButton(icon: Icons.close, onTap: () => Get.back()),
                Obx(
                  () => controller.hasImage
                      ? _CircleButton(
                          icon: Icons.refresh,
                          onTap: controller.resetTransform,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _NoImagePrompt extends StatelessWidget {
  final PaperTraceController controller;

  const _NoImagePrompt({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, size: 40, color: AppColors.inkFaint),
            const SizedBox(height: AppSpace.md),
            Text(
              'Choose a photo to trace',
              style: AppTypography.body.copyWith(color: AppColors.inkMuted),
            ),
            const SizedBox(height: AppSpace.lg),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PromptButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  onTap: controller.captureWithCamera,
                ),
                const SizedBox(width: AppSpace.sm),
                _PromptButton(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: controller.pickFromGallery,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PromptButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accentSoft,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.lg,
            vertical: 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.accent),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomControls extends StatefulWidget {
  final PaperTraceController controller;

  const _BottomControls({required this.controller});

  @override
  State<_BottomControls> createState() => _BottomControlsState();
}

class _BottomControlsState extends State<_BottomControls> {
  bool _showOpacitySlider = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showOpacitySlider)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.lg,
              vertical: AppSpace.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.inkMuted,
                  size: 18,
                ),
                Expanded(
                  child: Obx(
                    () => Slider(
                      value: controller.opacity.value,
                      min: 0.15,
                      max: 1.0,
                      onChanged: controller.setOpacity,
                    ),
                  ),
                ),
                Icon(
                  Icons.visibility_outlined,
                  color: AppColors.inkMuted,
                  size: 18,
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpace.sm),
        Container(
          margin: const EdgeInsets.all(AppSpace.lg),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.lg,
            vertical: AppSpace.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ToolbarAction(
                icon: Icons.opacity,
                label: 'Opacity',
                isActive: _showOpacitySlider,
                onTap: () =>
                    setState(() => _showOpacitySlider = !_showOpacitySlider),
              ),
              Obx(
                () => _ToolbarAction(
                  icon: controller.isLocked.value
                      ? Icons.lock
                      : Icons.lock_open_outlined,
                  label: 'Lock',
                  isActive: controller.isLocked.value,
                  onTap: controller.toggleLock,
                ),
              ),
              _ToolbarAction(
                icon: Icons.open_in_full,
                label: 'Extend',
                isActive: false,
                onTap: controller.toggleExtended,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolbarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToolbarAction({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.coral : AppColors.ink;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
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

class _StepBanner extends StatelessWidget {
  final String instruction;
  final int stepNumber;
  final int total;

  const _StepBanner({
    required this.instruction,
    required this.stepNumber,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 90,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.ink.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$stepNumber. $instruction',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}

class _StepNavigatorBar extends StatelessWidget {
  final PaperTraceController controller;

  const _StepNavigatorBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              icon: Icons.chevron_left,
              onTap: controller.canGoPrevStep ? controller.goToPrevStep : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Text(
                'Step: ${controller.currentStepIndex.value + 1}/${controller.stepSequence.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            _NavButton(
              icon: Icons.chevron_right,
              isPrimary: true,
              onTap: controller.canGoNextStep ? controller.goToNextStep : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _NavButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onTap == null
          ? AppColors.divider
          : (isPrimary ? AppColors.coral : AppColors.surface),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(
            icon,
            color: isPrimary && onTap != null ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
