import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';
import 'package:sketch_flow/app/data/services/ad_unit_ids.dart';
import 'package:sketch_flow/app/data/services/asset_discovery.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/ads/grid_native_ad_widget.dart';
import 'package:sketch_flow/app/widgets/chrome_icon_button.dart';

class AssetGridArgs {
  final String title;
  final String subtitle;
  final String folderPath;
  final Color accent;
  final IconData emptyIcon;

  const AssetGridArgs({
    required this.title,
    required this.subtitle,
    required this.folderPath,
    required this.accent,
    this.emptyIcon = Icons.image_outlined,
  });
}

class AssetImageGridView extends StatefulWidget {
  const AssetImageGridView({super.key});

  @override
  State<AssetImageGridView> createState() => _AssetImageGridViewState();
}

class _AssetImageGridViewState extends State<AssetImageGridView> {
  List<String>? _images;
  String? _error;
  late final AssetGridArgs args;

  @override
  void initState() {
    super.initState();
    args = Get.arguments as AssetGridArgs;
    AssetDiscovery.imagesInFolder(args.folderPath)
        .then((found) {
          if (mounted) setState(() => _images = found);
        })
        .catchError((e) {
          if (mounted)
            setState(
              () => _error = TKeys.errCouldNotLoadImages.trParams({
                'error': '$e',
              }),
            );
        });
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
                children: [
                  ChromeIconButton(
                    icon: Icons.arrow_back_ios_new,
                    size: 36,
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(width: AppSpace.md),
                  Expanded(
                    child: Text(
                      args.title,
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
                args.subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            Expanded(
              child: _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpace.xl),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    )
                  : _images == null
                  ? const Center(child: CircularProgressIndicator())
                  : _images!.isEmpty
                  ? _EmptyState(args: args)
                  : Builder(
                      builder: (context) {
                        const adInsertIndex = 2;
                        final images = _images!;
                        final showAdTile = images.length > adInsertIndex;
                        final itemCount = images.length + (showAdTile ? 1 : 0);

                        return GridView.builder(
                          padding: const EdgeInsets.all(AppSpace.lg),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: AppSpace.md,
                                crossAxisSpacing: AppSpace.md,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: itemCount,
                          itemBuilder: (_, i) {
                            if (showAdTile && i == adInsertIndex) {
                              return GridNativeAdWidget(
                                placementKey:
                                    AdPlacementKeys.nativeCategoryImageList,
                                adUnitIdOverride:
                                    AdUnitIds.nativeCategoryImageList,
                              );
                            }
                            final imageIndex = showAdTile && i > adInsertIndex
                                ? i - 1
                                : i;
                            final path = images[imageIndex];
                            return _ImageTile(
                              assetPath: path,
                              accent: args.accent,
                              onTap: () => _openModeSheet(context, path),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openModeSheet(BuildContext context, String assetPath) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ModeSheet(assetPath: assetPath),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String assetPath;
  final Color accent;
  final VoidCallback onTap;

  const _ImageTile({
    required this.assetPath,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: accent.withValues(alpha: 0.1),
                alignment: Alignment.center,
                child: Icon(Icons.broken_image_outlined, color: accent),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AssetGridArgs args;

  const _EmptyState({required this.args});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(args.emptyIcon, size: 40, color: AppColors.inkFaint),
            const SizedBox(height: AppSpace.md),
            Text(TKeys.noImagesYet.tr, style: AppTypography.h3),
            const SizedBox(height: AppSpace.xs),
            Text(
              TKeys.addImagesToFolder.trParams({'folder': args.folderPath}),
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeSheet extends StatelessWidget {
  final String assetPath;

  const _ModeSheet({required this.assetPath});

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
            Text(TKeys.howDoYouWantToTraceThis.tr, style: AppTypography.h3),
            const SizedBox(height: AppSpace.md),
            _ModeOption(
              icon: Icons.view_in_ar_outlined,
              label: TKeys.arCameraOption.tr,
              sublabel: TKeys.arCameraSublabel.tr,
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(Routes.arTrace, arguments: assetPath);
              },
            ),
            _ModeOption(
              icon: Icons.crop_portrait,
              label: TKeys.onPaperOption.tr,
              sublabel: TKeys.onPaperSublabel.tr,
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(Routes.paperTrace, arguments: assetPath);
              },
            ),
          ],
        ),
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
