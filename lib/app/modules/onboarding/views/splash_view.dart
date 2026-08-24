import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/services/ad_remote_config_service.dart';
import 'package:sketch_flow/app/data/services/app_open_ad_manager.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/onboarding/views/ad_loading_gate_view.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _adReadyTimeout = Duration(seconds: 12);
  static const _splashMinimumDisplay = Duration(seconds: 3);

  static const _hardCeiling = Duration(seconds: 40);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _run();
  }

  Future<void> _run() async {
    final showAdGate = AdRemoteConfigService.instance.isEnabled(
      AdPlacementKeys.splashOpen,
    );

    final splashMinimumWait = Future.delayed(_splashMinimumDisplay);
    final adReadyWait = showAdGate
        ? AppOpenAdManager.instance.waitUntilReadyOrTimeout(_adReadyTimeout)
        : Future.value(false);

    final results =
        await Future.wait([
          splashMinimumWait.then((_) => true),
          adReadyWait,
        ]).timeout(
          _hardCeiling,
          onTimeout: () => [true, AppOpenAdManager.instance.isAdAvailable],
        );
    final adIsReady = results[1];

    if (!mounted) return;
    _proceedPastSplash(adIsReady: adIsReady);
  }

  void _proceedPastSplash({required bool adIsReady}) {
    final destination = StorageService.hasCompletedOnboarding()
        ? Routes.home
        : Routes.languageSelect;

    if (!adIsReady) {
      Get.offNamed(destination);
      return;
    }

    Get.off(
      () => AdLoadingGateView(
        isReady: () => AppOpenAdManager.instance.isAdAvailable,
        showAd: (onComplete) =>
            AppOpenAdManager.instance.show(onComplete: onComplete),
        onFinished: () => Get.offNamed(destination),
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentSoft,
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -40,
            child: _Blob(size: 220, color: Colors.blue.withValues(alpha: 0.1)),
          ),
          Positioned(
            top: 120,
            right: -50,
            child: _Blob(
              size: 140,
              color: AppColors.amber.withValues(alpha: 0.59),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: _Blob(size: 260, color: Colors.blue.withValues(alpha: 0.08)),
          ),
          Positioned(
            bottom: 140,
            left: -30,
            child: _Blob(
              size: 110,
              color: AppColors.coral.withValues(alpha: 0.65),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final scale = Tween<double>(begin: 0.7, end: 1.0)
                    .chain(CurveTween(curve: Curves.easeOutBack))
                    .evaluate(_controller);
                final opacity = Tween<double>(begin: 0.0, end: 1.0)
                    .chain(CurveTween(curve: Curves.easeOut))
                    .evaluate(_controller);
                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: AppColors.accent,
                          size: 44,
                        ),
                      ),
                      Positioned(
                        bottom: -8,
                        right: -8,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.amber,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.crop_free,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpace.lg),
                  Text(
                    'AR Drawing',
                    style: AppTypography.h1.copyWith(color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    TKeys.appTagline.tr,
                    style: AppTypography.body.copyWith(
                      color: Colors.blue.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 64,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const _LoadingDots(),
                const SizedBox(height: AppSpace.sm),
                Text(
                  TKeys.loadingYourCanvas.tr,
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.blue.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = (_controller.value - (i * 0.2)) % 1.0;
            final bump = t < 0.5 ? t * 2 : (1 - t) * 2;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Color.lerp(
                  Colors.blue.withValues(alpha: 0.3),
                  Colors.blue,
                  bump.clamp(0.0, 1.0),
                ),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
