import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/onboarding_model.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final slide = controller.slides[controller.currentPage.value];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOut,
          color: slide.background,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.lg,
                    AppSpace.sm,
                    AppSpace.lg,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: controller.skip,
                        child: Text(
                          TKeys.skip.tr,
                          style: AppTypography.body.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.slides.length,
                    itemBuilder: (_, i) {
                      return _OnboardingSlideView(slide: controller.slides[i]);
                    },
                  ),
                ),
                _DotIndicator(
                  count: controller.slides.length,
                  activeIndex: controller.currentPage.value,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.lg,
                    AppSpace.lg,
                    AppSpace.lg,
                    AppSpace.lg,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      onPressed: controller.next,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          controller.isLastPage
                              ? TKeys.getStarted.tr
                              : TKeys.next.tr,
                          key: ValueKey(controller.isLastPage),
                          style: AppTypography.button.copyWith(
                            color: slide.background,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _OnboardingSlideView extends StatefulWidget {
  final OnboardingSlide slide;

  const _OnboardingSlideView({required this.slide});

  @override
  State<_OnboardingSlideView> createState() => _OnboardingSlideViewState();
}

class _OnboardingSlideViewState extends State<_OnboardingSlideView>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slide = widget.slide;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpace.md),
          Expanded(
            child: AnimatedBuilder(
              animation: _entranceController,
              builder: (context, child) {
                final scale = Tween<double>(begin: 0.85, end: 1.0)
                    .chain(CurveTween(curve: Curves.easeOutBack))
                    .evaluate(_entranceController);
                final opacity = Tween<double>(begin: 0.0, end: 1.0)
                    .chain(CurveTween(curve: Curves.easeOut))
                    .evaluate(_entranceController);
                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: _IllustrationScene(
                slide: slide,
                floatController: _floatController,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          AnimatedBuilder(
            animation: _entranceController,
            builder: (context, child) {
              final slideUp = Tween<double>(begin: 24, end: 0)
                  .chain(CurveTween(curve: Curves.easeOutCubic))
                  .evaluate(_entranceController);
              final opacity = Tween<double>(begin: 0.0, end: 1.0)
                  .chain(
                    CurveTween(
                      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                    ),
                  )
                  .evaluate(_entranceController);
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, slideUp),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: AppTypography.h1.copyWith(color: AppColors.ink),
                ),
                const SizedBox(height: AppSpace.sm),
                Text(
                  slide.description,
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: AppColors.ink,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
        ],
      ),
    );
  }
}

class _IllustrationScene extends StatelessWidget {
  final OnboardingSlide slide;
  final AnimationController floatController;

  const _IllustrationScene({
    required this.slide,
    required this.floatController,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;
        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(AppRadius.lg + 12),
                  ),
                ),
                Positioned(
                  top: size * 0.06,
                  left: size * 0.04,
                  child: _Blob(
                    size: size * 0.34,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                Positioned(
                  bottom: size * 0.08,
                  right: size * 0.06,
                  child: _Blob(
                    size: size * 0.24,
                    color: slide.accentColor.withValues(alpha: 0.9),
                  ),
                ),
                Positioned(
                  bottom: size * 0.32,
                  left: size * 0.06,
                  child: _Blob(
                    size: size * 0.14,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
                AnimatedBuilder(
                  animation: floatController,
                  builder: (context, _) {
                    final dy = 20 * (floatController.value - 0.5);
                    return Transform.translate(
                      offset: Offset(0, dy),
                      child: Container(
                        width: size * 0.58,
                        height: size * 0.58,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          painter: _DashedBorderPainter(
                            color: slide.background,
                          ),
                          child: Center(
                            child: Icon(
                              slide.primaryIcon,
                              color: slide.background,
                              size: size * 0.16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: floatController,
                  builder: (context, _) {
                    final dy = -16 * (floatController.value - 0.5);
                    return Positioned(
                      bottom: size * 0.14,
                      left: size * 0.1,
                      child: Transform.translate(
                        offset: Offset(0, dy),
                        child: Container(
                          width: size * 0.16,
                          height: size * 0.16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            slide.accentIcon,
                            color: slide.background,
                            size: size * 0.08,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: floatController,
                  builder: (context, _) {
                    final angle = floatController.value * 0.5 - 0.25;
                    return Positioned(
                      top: size * 0.1,
                      right: size * 0.08,
                      child: Transform.rotate(
                        angle: angle,
                        child: Container(
                          width: size * 0.13,
                          height: size * 0.13,
                          decoration: BoxDecoration(
                            color: slide.accentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(16),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;

  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;

  const _DotIndicator({required this.count, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.blue.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
