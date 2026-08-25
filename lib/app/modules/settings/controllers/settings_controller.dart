import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sketch_flow/app/data/services/push_notification_service.dart';

enum StrokeSmoothing { off, light, strong }

class SettingsController extends GetxController with WidgetsBindingObserver {
  final RxBool pressureSensitivity = true.obs;
  final RxBool leftHandedMode = false.obs;
  final RxBool hapticFeedback = true.obs;
  final Rx<StrokeSmoothing> smoothing = StrokeSmoothing.light.obs;
  final RxBool showCanvasGridDefault = false.obs;
  final RxBool autosave = true.obs;
  final RxString unitSystem = 'px'.obs;
  final RxString appVersion = ''.obs;

  RxBool get notificationsEnabled => PushNotificationService.instance.isEnabled;

  @override
  void onInit() {
    super.onInit();
    _loadAppVersion();
    WidgetsBinding.instance.addObserver(this);
    PushNotificationService.instance.refreshStatus();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PushNotificationService.instance.refreshStatus();
    }
  }

  void togglePressure(bool v) => pressureSensitivity.value = v;

  void toggleLeftHanded(bool v) => leftHandedMode.value = v;

  void toggleHaptics(bool v) => hapticFeedback.value = v;

  void toggleAutosave(bool v) => autosave.value = v;

  void setSmoothing(StrokeSmoothing s) => smoothing.value = s;

  void setUnit(String u) => unitSystem.value = u;

  Future<void> toggleNotifications(bool wantsEnabled) async {
    final service = PushNotificationService.instance;

    if (wantsEnabled) {
      await service.requestPermission();
    } else {
      await service.openNotificationSettings();
    }

    await service.refreshStatus();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion.value = '${info.version}';
  }
}
