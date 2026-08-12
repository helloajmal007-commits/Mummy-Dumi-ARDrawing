import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/gallery/controllers/gallery_controller.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/chrome_icon_button.dart';
import 'package:sketch_flow/app/widgets/project_tile.dart';

class GalleryView extends GetView<GalleryController> {
  const GalleryView({super.key});

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
                children: [
                  ChromeIconButton(
                    icon: Icons.arrow_back_ios_new,
                    size: 36,
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(width: AppSpace.md),
                  Text(TKeys.galleryTitle.tr, style: AppTypography.h2),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () => controller.isEmpty
                    ? _EmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.all(AppSpace.lg),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: AppSpace.md,
                              crossAxisSpacing: AppSpace.md,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: controller.projects.length,
                        itemBuilder: (_, i) {
                          final project = controller.projects[i];
                          return ProjectTile(
                            project: project,
                            onTap: () =>
                                Get.toNamed(Routes.canvas, arguments: project),
                            onChanged: controller.refresh,
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 48,
              color: AppColors.inkFaint,
            ),
            const SizedBox(height: AppSpace.md),
            Text(TKeys.startYourFirstSketch.tr, style: AppTypography.h3),
            const SizedBox(height: AppSpace.xs),
            Text(
              TKeys.galleryEmptyDesc.tr,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            OutlinedButton(
              onPressed: () => Get.toNamed(Routes.canvas),
              child: Text(TKeys.newSketch.tr),
            ),
          ],
        ),
      ),
    );
  }
}
