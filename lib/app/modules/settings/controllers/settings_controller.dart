import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum StrokeSmoothing { off, light, strong }

class SettingsController extends GetxController {
  final RxBool pressureSensitivity = true.obs;
  final RxBool leftHandedMode = false.obs;
  final RxBool hapticFeedback = true.obs;
  final Rx<StrokeSmoothing> smoothing = StrokeSmoothing.light.obs;
  final RxBool showCanvasGridDefault = false.obs;
  final RxBool autosave = true.obs;
  final RxString unitSystem = 'px'.obs;
  final RxString appVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAppVersion();
  }

  void togglePressure(bool v) => pressureSensitivity.value = v;

  void toggleLeftHanded(bool v) => leftHandedMode.value = v;

  void toggleHaptics(bool v) => hapticFeedback.value = v;

  void toggleAutosave(bool v) => autosave.value = v;

  void setSmoothing(StrokeSmoothing s) => smoothing.value = s;

  void setUnit(String u) => unitSystem.value = u;

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion.value = '${info.version}';
  }
}
