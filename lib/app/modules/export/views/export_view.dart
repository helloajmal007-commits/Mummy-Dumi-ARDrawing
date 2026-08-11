import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/export/controllers/export_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/chrome_icon_button.dart';
import 'package:sketch_flow/app/widgets/section_header.dart';

class ExportView extends GetView<ExportController> {
  const ExportView({super.key});

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
                  ChromeIconButton(
                    icon: Icons.close,
                    size: 36,
                    onTap: () => Get.back(),
                  ),
                  Text('Export', style: AppTypography.h3),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.lg,
                  AppSpace.lg,
                  AppSpace.lg,
                  AppSpace.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: AppColors.inkFaint,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpace.xl),
                    const SectionHeader(title: 'FORMAT'),
                    const SizedBox(height: AppSpace.sm),
                    Obx(
                      () => Wrap(
                        spacing: AppSpace.sm,
                        runSpacing: AppSpace.sm,
                        children: ExportFormat.values
                            .map(
                              (f) => ChoiceChip(
                                label: Text(f.label),
                                selected: controller.format.value == f,
                                onSelected: f.isAvailable
                                    ? (_) => controller.setFormat(f)
                                    : null,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpace.xl),
                    const SectionHeader(title: 'RESOLUTION'),
                    const SizedBox(height: AppSpace.sm),
                    Obx(
                      () => Column(
                        children: ExportResolution.values
                            .map(
                              (r) => RadioListTile<ExportResolution>(
                                contentPadding: EdgeInsets.zero,
                                value: r,
                                groupValue: controller.resolution.value,
                                onChanged: (v) => controller.setResolution(v!),
                                title: Text(r.label, style: AppTypography.body),
                                activeColor: AppColors.accent,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const Divider(height: AppSpace.xl),
                    Obx(
                      () => SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: controller.flattenLayers.value,
                        onChanged: controller.format.value == ExportFormat.psd
                            ? null
                            : controller.toggleFlatten,
                        title: Text(
                          'Flatten layers',
                          style: AppTypography.body,
                        ),
                        subtitle: Text(
                          'Combine all visible layers into one image',
                          style: AppTypography.caption,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.lg,
                0,
                AppSpace.lg,
                AppSpace.lg,
              ),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coral,
                    ),
                    onPressed: controller.isExporting.value
                        ? null
                        : controller.runExport,
                    child: controller.isExporting.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            controller.exportComplete.value
                                ? 'Exported ✓'
                                : 'Export sketch',
                          ),
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpace.lg,
                        0,
                        AppSpace.lg,
                        AppSpace.md,
                      ),
                      child: Text(
                        controller.errorMessage.value,
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
