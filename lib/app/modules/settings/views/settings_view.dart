import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sketch_flow/app/modules/settings/controllers/settings_controller.dart';
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
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.lg,
            AppSpace.sm,
            AppSpace.lg,
            AppSpace.xxxl,
          ),
          children: [
            const SectionHeader(title: 'DRAWING'),
            const SizedBox(height: AppSpace.sm),
            _SettingsCard(
              children: [
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Pressure sensitivity',
                      style: AppTypography.body,
                    ),
                    subtitle: Text(
                      'For styluses that support it',
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
                    title: Text('Left-handed mode', style: AppTypography.body),
                    subtitle: Text(
                      'Move tool dock to the left',
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
                    title: Text('Stroke smoothing', style: AppTypography.body),
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
            const SectionHeader(title: 'GENERAL'),
            const SizedBox(height: AppSpace.sm),
            _SettingsCard(
              children: [
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Haptic feedback', style: AppTypography.body),
                    value: controller.hapticFeedback.value,
                    onChanged: controller.toggleHaptics,
                  ),
                ),
                const Divider(),
                Obx(
                  () => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Autosave', style: AppTypography.body),
                    subtitle: Text(
                      'Save changes as you draw',
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
                    title: Text('Measurement unit', style: AppTypography.body),
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
              ],
            ),
            const SizedBox(height: AppSpace.xl),
            const SectionHeader(title: 'ABOUT & SUPPORT'),
            const SizedBox(height: AppSpace.sm),
            _SettingsCard(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.apps_outlined),
                  title: Text('More Apps', style: AppTypography.body),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _openMoreApps,
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.share_outlined),
                  title: Text('Share App', style: AppTypography.body),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _shareApp(context),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.lock_outline),
                  title: Text('Privacy Policy', style: AppTypography.body),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _openPrivacyPolicy,
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.feedback_outlined),
                  title: Text('Feedback', style: AppTypography.body),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _sendEmail,
                ),
                if (Platform.isIOS) ...[
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.star_outline),
                    title: Text('Rate App', style: AppTypography.body),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _rateApp,
                  ),
                ],
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.info_outline),
                  title: Text('Version', style: AppTypography.body),
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
