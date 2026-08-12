import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/tutorial_model.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/ar_trace/controllers/ar_trace_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';

class ArTraceView extends GetView<ArTraceController> {
  const ArTraceView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ArTraceController>()) {
      Get.put(ArTraceController());
    }
    return _ArTraceBody(controller: controller);
  }
}

class _ArTraceBody extends StatefulWidget {
  final ArTraceController controller;

  const _ArTraceBody({required this.controller});

  @override
  State<_ArTraceBody> createState() => _ArTraceBodyState();
}

class _ArTraceBodyState extends State<_ArTraceBody> {
  @override
  void initState() {
    super.initState();
    widget.controller.initCamera();
    final args = Get.arguments;
    if (args is TutorialTraceArgs) {
      widget.controller.loadStepSequence(args.steps, args.startIndex);
    } else if (args is String) {
      widget.controller.loadFromAssetPath(args);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Obx(() {
            if (controller.errorMessage.value.isNotEmpty) {
              return _ErrorState(message: controller.errorMessage.value);
            }
            if (!controller.isCameraReady.value ||
                controller.cameraController == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return _CameraPreview(controller: controller);
          }),
          Obx(
            () => controller.overlayImage.value != null
                ? _OverlayLayer(controller: controller)
                : const SizedBox.shrink(),
          ),
          Obx(() {
            if (controller.isLoadingImage.value) {
              return const Positioned(
                top: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }
            if (controller.imageLoadError.value.isNotEmpty) {
              return Positioned(
                top: 100,
                left: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.imageLoadError.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          _TopBar(controller: controller),
          Obx(() {
            if (!controller.hasSteps) return const SizedBox.shrink();
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpace.sm),
                    child: Center(child: _ZoomChips(controller: controller)),
                  ),
                  Obx(() {
                    if (!controller.hasSteps) return const SizedBox.shrink();
                    return _StepNavigatorBar(controller: controller);
                  }),
                  Obx(
                    () => controller.overlayImage.value != null
                        ? _BottomControls(controller: controller)
                        : _NoImagePrompt(controller: controller),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraPreview extends StatelessWidget {
  final ArTraceController controller;

  const _CameraPreview({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isFrozen.value && controller.frozenFrame.value != null) {
        return Image.file(
          controller.frozenFrame.value!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
      final cam = controller.cameraController!;
      return ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: cam.value.previewSize?.height ?? 1,
              height: cam.value.previewSize?.width ?? 1,
              child: CameraPreview(cam),
            ),
          ),
        ),
      );
    });
  }
}

class _OverlayLayer extends StatelessWidget {
  final ArTraceController controller;

  const _OverlayLayer({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isImageHidden.value) return const SizedBox.shrink();

      final image = controller.overlayImage.value!;
      final offset = controller.overlayOffset.value;
      final scale = controller.overlayScale.value;
      final rotation = controller.overlayRotation.value;
      final opacity = controller.opacity.value;

      return Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 64,
          bottom: 160,
        ),
        child: GestureDetector(
          onScaleUpdate: (details) {
            controller.updateTransform(
              offsetDelta: details.focalPointDelta,
              scaleDelta: details.scale == 1.0 ? 1.0 : details.scale,
              rotationDelta: 0.0,
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
                          child: Image.file(image, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

class _TopBar extends StatelessWidget {
  final ArTraceController controller;

  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg,
          vertical: AppSpace.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _CircleButton(icon: Icons.close, onTap: () => Get.back()),
                const SizedBox(width: AppSpace.sm),
                Obx(
                  () =>
                      controller.isCameraReady.value &&
                          !controller.isFrozen.value
                      ? Row(
                          children: [
                            _CircleButton(
                              icon: controller.isFlashOn.value
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              isActive: controller.isFlashOn.value,
                              onTap: controller.toggleFlash,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            Obx(
              () => controller.overlayImage.value != null
                  ? Row(
                      children: [
                        _CircleButton(
                          icon: Icons.rotate_left,
                          onTap: controller.rotateStep,
                        ),
                        const SizedBox(width: AppSpace.sm),
                        _CircleButton(
                          icon: controller.isFrozen.value
                              ? Icons.play_arrow
                              : Icons.pause,
                          isActive: controller.isFrozen.value,
                          onTap: controller.toggleFreeze,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomChips extends StatelessWidget {
  final ArTraceController controller;

  const _ZoomChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.overlayImage.value == null || controller.isFrozen.value) {
        return const SizedBox.shrink();
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomStepButton(
            icon: Icons.remove,
            onTap: controller.imageZoomStepOut,
          ),
          const SizedBox(width: AppSpace.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(
              () => Text(
                '${controller.overlayScale.value.toStringAsFixed(1)}x',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpace.sm),
          _ZoomStepButton(icon: Icons.add, onTap: controller.imageZoomStepIn),
        ],
      );
    });
  }
}

class _ZoomStepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomStepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppColors.accent : Colors.black.withValues(alpha: 0.45),
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
  final ArTraceController controller;

  const _NoImagePrompt({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpace.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpace.lg),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              TKeys.choosePhotoToTrace.tr,
              style: AppTypography.body.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpace.md),
            Row(
              children: [
                Expanded(
                  child: _PromptButton(
                    icon: Icons.camera_alt_outlined,
                    label: TKeys.camera.tr,
                    onTap: controller.captureWithCamera,
                  ),
                ),
                const SizedBox(width: AppSpace.sm),
                Expanded(
                  child: _PromptButton(
                    icon: Icons.photo_library_outlined,
                    label: TKeys.gallery.tr,
                    onTap: controller.pickFromGallery,
                  ),
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
  final ArTraceController controller;

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
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.visibility_off_outlined,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 18,
                ),
                Expanded(
                  child: Obx(
                    () => SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white.withValues(
                          alpha: 0.25,
                        ),
                        thumbColor: Colors.white,
                        overlayColor: Colors.white.withValues(alpha: 0.15),
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: controller.opacity.value,
                        min: 0.1,
                        max: 1.0,
                        onChanged: controller.setOpacity,
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.visibility_outlined,
                  color: Colors.white.withValues(alpha: 0.8),
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
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ToolbarAction(
                icon: Icons.opacity,
                label: TKeys.opacityLabel.tr,
                isActive: _showOpacitySlider,
                onTap: () =>
                    setState(() => _showOpacitySlider = !_showOpacitySlider),
              ),
              _ToolbarAction(
                icon: Icons.camera_alt_outlined,
                label: TKeys.camera.tr,
                isActive: false,
                onTap: controller.captureWithCamera,
              ),
              _ToolbarAction(
                icon: Icons.image_outlined,
                label: TKeys.gallery.tr ,
                isActive: false,
                onTap: controller.pickFromGallery,
              ),
              Obx(
                () => _ToolbarAction(
                  icon: controller.isImageHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility_off_outlined,
                  label: TKeys.hideLabel.tr,
                  isActive: controller.isImageHidden.value,
                  onTap: controller.toggleImageHidden,
                ),
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
    final color = isActive ? AppColors.coral : Colors.white;
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

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.videocam_off_outlined,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: AppSpace.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
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
          color: Colors.black.withValues(alpha: 0.75),
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
  final ArTraceController controller;

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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                TKeys.stepProgress.trParams({
                  'current': '${controller.currentStepIndex.value + 1}',
                  'total': '${controller.stepSequence.length}',
                }),
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
          ? Colors.grey.shade300
          : (isPrimary ? AppColors.coral : Colors.white),
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
