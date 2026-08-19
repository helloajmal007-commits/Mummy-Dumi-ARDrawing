import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/data/services/app_click_interstitial_manager.dart';
import 'package:sketch_flow/app/data/services/interstitial_ad_manager.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/onboarding/views/ad_loading_gate_view.dart';
import 'package:sketch_flow/app/modules/sketches/controllers/sketches_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/ads/banner_ad_widget.dart';
import 'package:sketch_flow/app/widgets/chrome_icon_button.dart';
import 'package:sketch_flow/app/widgets/project_tile.dart';

class SketchesView extends StatefulWidget {
  const SketchesView({super.key});

  @override
  State<SketchesView> createState() => _SketchesViewState();
}

class _SketchesViewState extends State<SketchesView> {
  final SketchesController controller = Get.find<SketchesController>();

  @override
  void initState() {
    super.initState();
    InterstitialAdManager.instance.preload(
      AdPlacementKeys.interstitialSketchPlusButton,
      AdUnitIds.interstitialSketchPlusButton,
    );
  }

  void _onPlusButtonTapped() {
    AppClickInterstitialManager.instance.suppressNextCount();

    final placementKey = AdPlacementKeys.interstitialSketchPlusButton;

    if (!InterstitialAdManager.instance.isReady(placementKey)) {
      controller.createNewSketch();
      InterstitialAdManager.instance.preload(
        placementKey,
        AdUnitIds.interstitialSketchPlusButton,
      );
      return;
    }

    Get.to(
      () => AdLoadingGateView(
        isReady: () => InterstitialAdManager.instance.isReady(placementKey),
        showAd: (onComplete) => InterstitialAdManager.instance.showThenProceed(
          placementKey,
          adUnitIdFuture: () => AdUnitIds.interstitialSketchPlusButton,
          onProceed: onComplete,
        ),
        onFinished: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.back();
            controller.createNewSketch();
            AppClickInterstitialManager.instance.resetCount();
          });
        },
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 200),
    );
  }

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
                  Row(
                    children: [
                      ChromeIconButton(
                        icon: Icons.arrow_back_ios_new,
                        size: 36,
                        onTap: () => Get.back(),
                      ),
                      const SizedBox(width: AppSpace.md),
                      Text(TKeys.sketchesTitle.tr, style: AppTypography.h2),
                    ],
                  ),
                  Material(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      onTap: _onPlusButtonTapped,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpace.md,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 18, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              TKeys.newSketch.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            Center(
              child: BannerAdWidget(
                placementKey: AdPlacementKeys.bannerSketchScreen,
                adUnitIdOverride: AdUnitIds.bannerSketchScreen,
              ),
            ),
            Expanded(
              child: Obx(
                () => controller.isEmpty
                    ? _EmptyState(onCreate: controller.createNewSketch)
                    : GridView.builder(
                        padding: const EdgeInsets.all(AppSpace.lg),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: AppSpace.md,
                              crossAxisSpacing: AppSpace.md,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: controller.sketches.length,
                        itemBuilder: (_, i) {
                          final sketch = controller.sketches[i];
                          return ProjectTile(
                            project: sketch,
                            onTap: () => _onPlusButtonTapped,
                            onChanged: () {},
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, size: 48, color: AppColors.inkFaint),
            const SizedBox(height: AppSpace.md),
            Text(TKeys.startYourFirstSketch.tr, style: AppTypography.h3),
            const SizedBox(height: AppSpace.xs),
            Text(
              TKeys.sketchesEmptyDesc.tr,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            ElevatedButton(
              onPressed: onCreate,
              child: Text(TKeys.newSketch.tr),
            ),
          ],
        ),
      ),
    );
  }
}
