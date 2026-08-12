import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/modules/settings/controllers/settings_controller.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';
import 'package:sketch_flow/app/widgets/app_bottom_nav.dart';
import 'package:sketch_flow/app/widgets/image_source_sheet.dart';
import 'package:sketch_flow/app/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  static const String privacyUrl =
      'https://sites.google.com/view/mummydummyapplicationsprivacyp/home';
  static const String moreAppsUrlIOS =
      'https://apps.apple.com/developer/id1234567890';
  static const String moreAppsUrlAndroid =
      'https://play.google.com/store/apps/developer?id=Mummy+Dummy';
  static const String appStoreUrl = 'https://apps.apple.com/app/id6762111453';
  static const String playstoreStoreUrl =
      'https://play.google.com/store/apps/details?id=com.artsketch.trace2sketch.ar.drawing';
  static const String email = 'mummydumiapps@gmail.com';

  Future<void> _openPrivacyPolicy() async {
    final Uri url = Uri.parse(privacyUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $privacyUrl';
    }
  }

  Future<void> _openMoreApps() async {
    final String url = Platform.isIOS ? moreAppsUrlIOS : moreAppsUrlAndroid;
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  void _shareApp(BuildContext context) {
    final storeUrl = Platform.isIOS ? appStoreUrl : playstoreStoreUrl;
    final shareText = 'Check out this app!\n$storeUrl';

    final box = context.findRenderObject() as RenderBox?;
    SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: 'Check out this app!',
        sharePositionOrigin: box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : Rect.fromLTWH(
                0,
                0,
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height / 2,
              ),
      ),
    );
  }

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (!await launchUrl(emailUri)) {
      throw 'Could not launch email';
    }
  }

  Future<void> _rateApp() async {
    final Uri rateUrl = Uri.parse(appStoreUrl);
    if (!await launchUrl(rateUrl, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch App Store';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(TKeys.settingsTitle.tr)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.lg,
            AppSpace.sm,
            AppSpace.lg,
            AppSpace.xxxl,
          ),
          children: [
            SectionHeader(title: TKeys.sectionDrawing.tr),
            const SizedBox(height: AppSpace.sm),
            _SettingsCard(
              children: [
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      TKeys.pressureSensitivity.tr,
                      style: AppTypography.body,
                    ),
                    subtitle: Text(
                      TKeys.pressureSensitivitySub.tr,
                      style: AppTypography.caption,
                    ),
                    value: controller.pressureSensitivity.value,
                    onChanged: controller.togglePressure,
                  ),
                ),
                const Divider(),
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      TKeys.leftHandedMode.tr,
                      style: AppTypography.body,
                    ),
                    subtitle: Text(
                      TKeys.leftHandedModeSub.tr,
                      style: AppTypography.caption,
                    ),
                    value: controller.leftHandedMode.value,
                    onChanged: controller.toggleLeftHanded,
                  ),
                ),
                const Divider(),
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      TKeys.strokeSmoothing.tr,
                      style: AppTypography.body,
                    ),
                    trailing: DropdownButton<StrokeSmoothing>(
                      value: controller.smoothing.value,
                      underline: const SizedBox(),
                      items: StrokeSmoothing.values
                          .map(
                            (s) =>
                                DropdownMenuItem(value: s, child: Text(s.name)),
                          )
                          .toList(),
                      onChanged: (v) => controller.setSmoothing(v!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.xl),
            SectionHeader(title: TKeys.sectionGeneral.tr),
            const SizedBox(height: AppSpace.sm),
            _SettingsCard(
              children: [
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      TKeys.hapticFeedback.tr,
                      style: AppTypography.body,
                    ),
                    value: controller.hapticFeedback.value,
                    onChanged: controller.toggleHaptics,
                  ),
                ),
                const Divider(),
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(TKeys.autosave.tr, style: AppTypography.body),
                    subtitle: Text(
                      TKeys.autosaveSub.tr,
                      style: AppTypography.caption,
                    ),
                    value: controller.autosave.value,
                    onChanged: controller.toggleAutosave,
                  ),
                ),
                const Divider(),
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      TKeys.measurementUnit.tr,
                      style: AppTypography.body,
                    ),
                    trailing: DropdownButton<String>(
                      value: controller.unitSystem.value,
                      underline: const SizedBox(),
                      items: ['px', 'in', 'cm']
                          .map(
                            (u) => DropdownMenuItem(value: u, child: Text(u)),
                          )
                          .toList(),
                      onChanged: (v) => controller.setUnit(v!),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.language_outlined),
                  title: Text(
                    TKeys.languageSetting.tr,
                    style: AppTypography.body,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.toNamed(
                    Routes.languageSelect,
                    arguments: {'isSettingsMode': true},
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.xl),
            SectionHeader(title: TKeys.sectionAboutSupport.tr),
            const SizedBox(height: AppSpace.sm),
            _SettingsCard(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.apps_outlined),
                  title: Text(TKeys.moreApps.tr, style: AppTypography.body),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _openMoreApps,
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.share_outlined),
                  title: Text(TKeys.shareApp.tr, style: AppTypography.body),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _shareApp(context),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.lock_outline),
                  title: Text(
                    TKeys.privacyPolicy.tr,
                    style: AppTypography.body,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _openPrivacyPolicy,
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.feedback_outlined),
                  title: Text(TKeys.feedback.tr, style: AppTypography.body),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _sendEmail,
                ),
                if (Platform.isIOS) ...[
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.star_outline),
                    title: Text(TKeys.rateApp.tr, style: AppTypography.body),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _rateApp,
                  ),
                ],
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.info_outline),
                  title: Text(TKeys.version.tr, style: AppTypography.body),
                  trailing: Text('1.0.0', style: AppTypography.bodySmall),
                ),
              ],
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
      bottomNavigationBar: const AppBottomNav(current: AppTab.settings),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          child: Column(children: children),
        ),
      ),
    );
  }
}
