import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/categories/controllers/categories_controller.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/ads/banner_ad_widget.dart';
import 'package:sketch_flow/app/widgets/ads/grid_native_ad_widget.dart';
import 'package:sketch_flow/app/widgets/app_bottom_nav.dart';
import 'package:sketch_flow/app/widgets/asset_image_grid_view.dart';
import 'package:sketch_flow/app/widgets/image_source_sheet.dart';
import 'package:sketch_flow/app/widgets/locale_rebuilder.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadPreviews();
    debugPrint(
      'CATEGORIES VIEW BUILD: previewImages = ${controller.previewImages}',
    );
    return LocaleRebuilder(
      builder: (context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
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
                      child: Text(
                        TKeys.categoriesTitle.tr,
                        style: AppTypography.h2,
                      ),
                    ),
                    const SizedBox(height: AppSpace.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpace.lg,
                      ),
                      child: Text(
                        TKeys.categoriesSubtitle.tr,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(() {
                        debugPrint(
                          'GRID OBX REBUILD: previewImages = ${controller.previewImages}',
                        );
                        const adInsertIndex = 2;
                        final categories = controller.categories;
                        final showAdTile = categories.length > adInsertIndex;
                        final itemCount =
                            categories.length + (showAdTile ? 1 : 0);

                        return GridView.builder(
                          padding: const EdgeInsets.all(AppSpace.lg),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: AppSpace.lg,
                                crossAxisSpacing: AppSpace.lg,
                                childAspectRatio: 1.1,
                              ),
                          itemCount: itemCount,
                          itemBuilder: (_, i) {
                            if (showAdTile && i == adInsertIndex) {
                              return GridNativeAdWidget(
                                placementKey:
                                    AdPlacementKeys.nativeCategoriesGrid,
                                adUnitIdOverride:
                                    AdUnitIds.nativeCategoriesGrid,
                              );
                            }
                            final categoryIndex =
                                showAdTile && i > adInsertIndex ? i - 1 : i;
                            final category = categories[categoryIndex];
                            final previewPath =
                                controller.previewImages[category.key];
                            return _CategoryCard(
                              category: category,
                              previewPath: previewPath,
                              onTap: () => Get.toNamed(
                                Routes.assetGrid,
                                arguments: AssetGridArgs(
                                  title: category.name,
                                  subtitle: TKeys.pickImageToTraceArOrPaper.tr,
                                  folderPath: category.assetFolder,
                                  accent: category.color,
                                  emptyIcon: category.icon,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Center(
                  child: BannerAdWidget(
                    placementKey: AdPlacementKeys.bannerCategoriesBottom,
                    collapsiblePlacement: 'bottom',
                    adUnitIdOverride:
                        AdUnitIds.collapsibleBannerCategoriesBottom,
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
        bottomNavigationBar: const AppBottomNav(current: AppTab.categories),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryItem category;
  final String? previewPath;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.previewPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: category.color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (previewPath != null)
              Builder(
                builder: (context) {
                  debugPrint('RENDERING IMAGE: $previewPath');
                  return Image.asset(
                    previewPath!,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                          if (frame == null) {
                            debugPrint(
                              'IMAGE FRAME NULL (still loading?): $previewPath',
                            );
                          } else {
                            debugPrint(
                              'IMAGE FRAME READY (frame=$frame): $previewPath',
                            );
                          }
                          return child;
                        },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('IMAGE LOAD FAILED for $previewPath: $error');
                      return Container(
                        color: Colors.red.withValues(alpha: 0.3),
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  );
                },
              ),
            if (previewPath != null)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(category.icon, color: category.color, size: 22),
                  ),
                  Text(
                    category.name,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: previewPath != null ? Colors.white : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
