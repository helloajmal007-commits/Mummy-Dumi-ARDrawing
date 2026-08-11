import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';

Future<void> showImageSourceSheet(BuildContext context, {String? category}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => ImageSourceSheet(category: category),
  );
}

class ImageSourceSheet extends StatelessWidget {
  final String? category;

  const ImageSourceSheet({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.lg,
          AppSpace.lg,
          AppSpace.lg,
          AppSpace.xl,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Text(
              category != null
                  ? 'Draw from $category'
                  : 'How do you want to trace?',
              style: AppTypography.h3,
            ),
            const SizedBox(height: AppSpace.md),
            _SheetOption(
              icon: Icons.view_in_ar_outlined,
              label: 'AR camera',
              sublabel: 'Overlay the image on your live camera view',
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(Routes.arTrace);
              },
            ),
            _SheetOption(
              icon: Icons.crop_portrait,
              label: 'On paper',
              sublabel: 'Show the image on screen and copy it by eye',
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(Routes.paperTrace);
              },
            ),
            if (category != null) ...[
              const SizedBox(height: AppSpace.xs),
              Text(
                'You can browse $category presets once you\'re in either mode.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sublabel;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    this.sublabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (sublabel != null)
                      Text(
                        sublabel!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.inkFaint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
