import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sketch_flow/app/data/services/ad_consent_service.dart';
import 'package:sketch_flow/app/data/services/app_open_ad_manager.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';

class AdLoadingGateView extends StatefulWidget {
  final VoidCallback onFinished;

  const AdLoadingGateView({super.key, required this.onFinished});

  @override
  State<AdLoadingGateView> createState() => _AdLoadingGateViewState();
}

class _AdLoadingGateViewState extends State<AdLoadingGateView> {
  static const _displayDuration = Duration(seconds: 1);

  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    await Future.delayed(_displayDuration);
    if (!mounted) return;

    final canRequest = await AdConsentService.instance.canRequestAds();
    if (!mounted) return;

    if (canRequest && AppOpenAdManager.instance.isAdAvailable) {
      AppOpenAdManager.instance.show(onComplete: _finish);
    } else {
      _finish();
    }
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    if (!mounted) return;
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentSoft,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.accent),
            const SizedBox(height: 16),
            Text(
              TKeys.preparingYourExperience.tr,
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