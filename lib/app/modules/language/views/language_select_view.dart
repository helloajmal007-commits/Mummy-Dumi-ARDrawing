import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/models/language_model.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/language/controllers/language_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/ads/native_ad_widget.dart';

class LanguageSelectView extends GetView<LanguageController> {
  const LanguageSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final isSettingsMode = controller.isSettingsMode;

    return PopScope(
      canPop: !isSettingsMode,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (isSettingsMode) controller.revertAndGoBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.accentSoft,
        appBar: isSettingsMode
            ? AppBar(
                backgroundColor: AppColors.accentSoft,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: controller.revertAndGoBack,
                ),
                title: Text(
                  TKeys.chooseYourLanguage.tr,
                  style: AppTypography.h3,
                ),
              )
            : null,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSettingsMode)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.lg,
                    AppSpace.lg,
                    AppSpace.lg,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        TKeys.chooseYourLanguage.tr,
                        style: AppTypography.h1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        TKeys.selectPreferredLanguage.tr,
                        style: AppTypography.body.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!isSettingsMode)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.lg,
                    AppSpace.md,
                    AppSpace.lg,
                    0,
                  ),
                  child: NativeAdWidget(
                    placementKey: AdPlacementKeys.arLanguageScreenNative,
                    adUnitIdOverride: AdUnitIds.arLanguageScreenNative,
                  ),
                ),
              const SizedBox(height: AppSpace.lg),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
                  itemCount: kSupportedLanguages.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpace.sm),
                  itemBuilder: (context, i) {
                    final language = kSupportedLanguages[i];
                    return Obx(() {
                      final isSelected =
                          controller.selected.value?.code == language.code;
                      return _LanguageTile(
                        language: language,
                        isSelected: isSelected,
                        onTap: () => controller.select(language),
                      );
                    });
                  },
                ),
              ),
              if (!isSettingsMode)
                Obx(() {
                  if (!controller.hasSelection) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpace.lg,
                      0,
                      AppSpace.lg,
                      AppSpace.sm,
                    ),
                    child: NativeAdWidget(
                      placementKey: AdPlacementKeys.arLanguageScreen2ndNative,
                      adUnitIdOverride: AdUnitIds.arLanguageScreen2ndNative,
                    ),
                  );
                }),
              Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.blue.withValues(
                          alpha: 0.35,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      onPressed: !controller.hasSelection
                          ? null
                          : (isSettingsMode
                                ? controller.saveAndGoBack
                                : controller.goToConfirm),
                      child: Text(
                        isSettingsMode ? TKeys.save.tr : TKeys.continueBtn.tr,
                        style: AppTypography.button.copyWith(
                          color: Colors.white,
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
      ),
    );
  }
}

// _LanguageTile unchanged

class _LanguageTile extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isSelected ? AppColors.accent : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.md,
              vertical: AppSpace.md,
            ),
            child: Row(
              children: [
                Text(language.flagEmoji, style: const TextStyle(fontSize: 26)),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Text(
                    language.nameKey.tr,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? Icon(
                          Icons.check_circle,
                          key: const ValueKey(true),
                          color: AppColors.accent,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          key: const ValueKey(false),
                          color: AppColors.dividerStrong,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
