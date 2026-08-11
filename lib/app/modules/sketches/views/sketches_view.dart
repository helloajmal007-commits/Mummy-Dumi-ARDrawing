import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/sketches/controllers/sketches_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/chrome_icon_button.dart';
import 'package:sketch_flow/app/widgets/project_tile.dart';

class SketchesView extends GetView<SketchesController> {
  const SketchesView({super.key});

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
                      Text('Sketches', style: AppTypography.h2),
                    ],
                  ),
                  Material(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      onTap: controller.createNewSketch,
                      child: const Padding(
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
                              'New sketch',
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
                            onTap: () => controller.openSketch(sketch),
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
            Text('Start your first sketch', style: AppTypography.h3),
            const SizedBox(height: AppSpace.xs),
            Text(
              'Drawings you make with the sketch tool show up here.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            ElevatedButton(
              onPressed: onCreate,
              child: const Text('New sketch'),
            ),
          ],
        ),
      ),
    );
  }
}
