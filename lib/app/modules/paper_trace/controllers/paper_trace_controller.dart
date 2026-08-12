import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sketch_flow/app/data/models/tutorial_model.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';

class PaperTraceController extends GetxController {
  final Rx<File?> image = Rx<File?>(null);
  final RxDouble opacity = 1.0.obs;

  final Rx<Offset> offset = const Offset(0, 0).obs;
  final RxDouble scale = 1.0.obs;
  final RxDouble rotation = 0.0.obs;

  final RxBool isLocked = false.obs;

  final RxBool isExtended = false.obs;

  bool get hasImage => image.value != null;
  final RxBool isLoadingImage = false.obs;
  final RxString loadError = ''.obs;

  void toggleLock() => isLocked.value = !isLocked.value;

  void toggleExtended() => isExtended.value = !isExtended.value;

  final RxList<TutorialStep> stepSequence = <TutorialStep>[].obs;
  final RxInt currentStepIndex = 0.obs;

  bool get hasSteps => stepSequence.isNotEmpty;

  bool get canGoPrevStep => currentStepIndex.value > 0;

  bool get canGoNextStep => currentStepIndex.value < stepSequence.length - 1;

  Future<void> pickFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      image.value = File(picked.path);
      resetTransform();
    }
  }

  Future<void> captureWithCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      image.value = File(picked.path);
      resetTransform();
    }
  }

  void setPresetImage(File file) {
    image.value = file;
    resetTransform();
  }

  Future<void> loadFromAssetPath(String assetPath) async {
    isLoadingImage.value = true;
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/preset_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(byteData.buffer.asUint8List());
      image.value = file;
      resetTransform();
    } catch (e) {
      loadError.value = TKeys.errImageLoadFailedGeneric.tr;
    } finally {
      isLoadingImage.value = false;
    }
  }

  void setOpacity(double value) => opacity.value = value.clamp(0.15, 1.0);

  void updateTransform({
    required Offset offsetDelta,
    required double scaleDelta,
    required double rotationDelta,
  }) {
    if (isLocked.value) return;
    offset.value = offset.value + offsetDelta;
    scale.value = (scale.value * scaleDelta).clamp(0.2, 6.0);
    rotation.value = rotation.value + rotationDelta;
  }

  void resetTransform() {
    offset.value = const Offset(0, 0);
    scale.value = 1.0;
    rotation.value = 0.0;
    opacity.value = 1.0;
  }

  void loadStepSequence(List<TutorialStep> steps, int startIndex) {
    stepSequence.assignAll(steps);
    currentStepIndex.value = startIndex;
    loadFromAssetPath(steps[startIndex].imagePath);
  }

  void goToNextStep() {
    if (!canGoNextStep) return;
    currentStepIndex.value++;
    loadFromAssetPath(stepSequence[currentStepIndex.value].imagePath);
  }

  void goToPrevStep() {
    if (!canGoPrevStep) return;
    currentStepIndex.value--;
    loadFromAssetPath(stepSequence[currentStepIndex.value].imagePath);
  }
}
