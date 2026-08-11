import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/tutorial_model.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/chrome_icon_button.dart';

class TutorialStepsView extends StatelessWidget {
  const TutorialStepsView({super.key});

  @override
  Widget build(BuildContext context) {
    final tutorial = Get.arguments as Tutorial;

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
                  Expanded(
                    child: Text(
                      tutorial.title,
                      style: AppTypography.h2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
              child: Text(
                tutorial.description,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpace.lg),
                itemCount: tutorial.steps.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpace.md),
                itemBuilder: (_, i) {
                  final step = tutorial.steps[i];
                  return _StepCard(
                    index: i + 1,
                    step: step,
                    accent: tutorial.color,
                    onTap: () => _openModeSheet(context, step),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openModeSheet(BuildContext context, TutorialStep step) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ModeSheet(step: step),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int index;
  final TutorialStep step;
  final Color accent;
  final VoidCallback onTap;

  const _StepCard({
    required this.index,
    required this.step,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpace.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset(
                    step.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: accent.withValues(alpha: 0.1),
                      alignment: Alignment.center,
                      child: Text(
                        '$index',
                        style: AppTypography.body.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step $index: ${step.title}',
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.instruction,
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

class _ModeSheet extends StatelessWidget {
  final TutorialStep step;

  const _ModeSheet({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.lg,
        AppSpace.lg,
        AppSpace.xl,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
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
          Text(step.title, style: AppTypography.h3),
          const SizedBox(height: 4),
          Text(
            step.instruction,
            style: AppTypography.bodySmall.copyWith(color: AppColors.inkMuted),
          ),
          const SizedBox(height: AppSpace.md),
          _ModeOption(
            icon: Icons.view_in_ar_outlined,
            label: 'AR camera',
            sublabel: 'Overlay this step on your live camera view',
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.arTrace, arguments: step.imagePath);
            },
          ),
          _ModeOption(
            icon: Icons.crop_portrait,
            label: 'On paper',
            sublabel: 'Show this step on screen and copy it by eye',
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(Routes.paperTrace, arguments: step.imagePath);
            },
          ),
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  const _ModeOption({
    required this.icon,
    required this.label,
    required this.sublabel,
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
                    Text(
                      sublabel,
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
