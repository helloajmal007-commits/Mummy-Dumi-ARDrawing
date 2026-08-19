import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/home/controllers/home_controller.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/ads/banner_ad_widget.dart';
import 'package:sketch_flow/app/widgets/app_bottom_nav.dart';
import 'package:sketch_flow/app/widgets/asset_image_grid_view.dart';
import 'package:sketch_flow/app/widgets/image_source_sheet.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> _handleBack(BuildContext context) async {
    final shouldLeave = await Navigator.of(context).push<bool>(
      PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, _, _) => const _ExitConfirmScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    if (shouldLeave == true) {
      await SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handleBack(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.lg,
                    AppSpace.md,
                    AppSpace.lg,
                    AppSpace.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(),
                      const SizedBox(height: AppSpace.lg),
                      _StartDrawingHero(
                        onTapAr: () => Get.toNamed(Routes.arTrace),
                        onTapPaper: () => Get.toNamed(Routes.paperTrace),
                      ),
                      const SizedBox(height: AppSpace.xl),
                      _SectionHeaderRow(title: TKeys.exploreFeatures.tr),
                      const SizedBox(height: AppSpace.md),
                      _FeatureCard(
                        icon: Icons.edit_outlined,
                        iconColor: AppColors.amber,
                        cardBg: AppColors.amberSoft,
                        title: TKeys.sketch.tr,
                        onTap: () => Get.toNamed(Routes.sketches),
                      ),
                      const SizedBox(height: AppSpace.md),
                      Row(
                        children: [
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.grid_view_sharp,
                              iconColor: AppColors.accent,
                              cardBg: AppColors.accentSoft,
                              title: TKeys.categories.tr,
                              onTap: () => Get.toNamed(Routes.categories),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpace.md),
                      Row(
                        children: [
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.photo_library_outlined,
                              iconColor: AppColors.lavender,
                              cardBg: AppColors.lavenderSoft,
                              title: TKeys.gallery.tr,
                              onTap: () => Get.toNamed(Routes.gallery),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpace.xl),
                      _SectionHeaderRow(
                        title: TKeys.categories.tr,
                        onSeeAll: () => Get.toNamed(Routes.categories),
                      ),
                      const SizedBox(height: AppSpace.md),
                      Obx(
                        () => GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.categories.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: AppSpace.sm,
                                crossAxisSpacing: AppSpace.md,
                                childAspectRatio: 0.72,
                              ),
                          itemBuilder: (_, i) {
                            final category = controller.categories[i];
                            return _CategoryChip(
                              category: category,
                              onTap: () => Get.toNamed(
                                Routes.assetGrid,
                                arguments: AssetGridArgs(
                                  title: category.name,
                                  subtitle: TKeys.pickImageToTrace.tr,
                                  folderPath: category.assetFolder,
                                  accent: category.color,
                                  emptyIcon: category.icon,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: const Center(
                  child: BannerAdWidget(
                    placementKey: AdPlacementKeys.collapsableBannerHomeBottom,
                    collapsiblePlacement: 'bottom',
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.accent,
          elevation: 2,
          onPressed: () => showImageSourceSheet(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        bottomNavigationBar: const AppBottomNav(current: AppTab.home),
      ),
    );
  }
}

class _ExitConfirmScreen extends StatelessWidget {
  const _ExitConfirmScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.lg,
            AppSpace.xl,
            AppSpace.lg,
            AppSpace.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              SizedBox(
                width: 260,
                height: 260,
                child: SvgPicture.asset(
                  'assets/icons/exit_dialog_mascot_icon.svg',
                ),
              ),
              const SizedBox(height: AppSpace.xl),
              Text(
                TKeys.leavingSoSoon.tr,
                style: AppTypography.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpace.sm),
              Text(
                TKeys.missYourCreations.tr,
                style: AppTypography.body.copyWith(color: AppColors.inkMuted),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  TKeys.stayAndKeepDrawing.tr,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: AppSpace.sm),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  TKeys.leave.tr,
                  style: AppTypography.body.copyWith(color: AppColors.inkMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TKeys.arDrawingApp.tr,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.inkMuted,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(TKeys.helloArtist.tr, style: AppTypography.h1),
      ],
    );
  }
}

class _StartDrawingHero extends StatelessWidget {
  final VoidCallback onTapAr;
  final VoidCallback onTapPaper;

  const _StartDrawingHero({required this.onTapAr, required this.onTapPaper});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.lg),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TKeys.startADrawing.tr,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            TKeys.traceAnyPhoto.tr,
            style: AppTypography.h2.copyWith(color: Colors.white, height: 1.25),
          ),
          const SizedBox(height: AppSpace.lg),
          Row(
            children: [
              Expanded(
                child: _HeroButton(
                  icon: Icons.view_in_ar_outlined,
                  label: TKeys.arCamera.tr,
                  onTap: onTapAr,
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: _HeroButton(
                  icon: Icons.crop_portrait,
                  label: TKeys.onPaper.tr,
                  onTap: onTapPaper,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeroButton({
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

class _SectionHeaderRow extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeaderRow({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.h3),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              TKeys.seeAll.tr,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color cardBg;
  final String title;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.cardBg,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBadge(icon: icon, color: iconColor),
              const SizedBox(height: AppSpace.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTypography.body.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _ArrowDot(color: iconColor, small: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBadge({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _ArrowDot extends StatelessWidget {
  final Color color;
  final bool small;

  const _ArrowDot({required this.color, this.small = false});

  @override
  Widget build(BuildContext context) {
    final size = small ? 28.0 : 36.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(
        Icons.arrow_forward,
        color: Colors.white,
        size: small ? 14 : 18,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback onTap;

  const _CategoryChip({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(category.icon, color: category.color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(color: AppColors.ink),
            ),
          ],
        ),
      ),
    );
  }
}
