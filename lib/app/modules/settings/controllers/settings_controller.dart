import 'package:get/get.dart';

enum StrokeSmoothing { off, light, strong }

class SettingsController extends GetxController {
  final RxBool pressureSensitivity = true.obs;
  final RxBool leftHandedMode = false.obs;
  final RxBool hapticFeedback = true.obs;
  final Rx<StrokeSmoothing> smoothing = StrokeSmoothing.light.obs;
  final RxBool showCanvasGridDefault = false.obs;
  final RxBool autosave = true.obs;
  final RxString unitSystem = 'px'.obs;

  void togglePressure(bool v) => pressureSensitivity.value = v;
  void toggleLeftHanded(bool v) => leftHandedMode.value = v;
  void toggleHaptics(bool v) => hapticFeedback.value = v;
  void toggleAutosave(bool v) => autosave.value = v;
  void setSmoothing(StrokeSmoothing s) => smoothing.value = s;
  void setUnit(String u) => unitSystem.value = u;
}
