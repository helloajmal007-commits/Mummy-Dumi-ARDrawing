import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sketch_flow/app/data/models/tutorial_model.dart';

class ArTraceController extends GetxController {
  CameraController? cameraController;
  final RxBool isCameraReady = false.obs;
  final RxBool isFrozen = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<File?> frozenFrame = Rx<File?>(null);
  bool _isCapturing = false;

  final Rx<File?> overlayImage = Rx<File?>(null);

  final RxDouble opacity = 0.55.obs;

  final Rx<Offset> overlayOffset = const Offset(0, 0).obs;
  final RxDouble overlayScale = 1.0.obs;
  final RxDouble overlayRotation = 0.0.obs;

  bool get hasImage => overlayImage.value != null;
  bool _isInitializing = false;

  final RxBool isImageHidden = false.obs;
  void toggleImageHidden() => isImageHidden.value = !isImageHidden.value;

  final RxList<TutorialStep> stepSequence = <TutorialStep>[].obs;
  final RxInt currentStepIndex = 0.obs;
  bool get hasSteps => stepSequence.isNotEmpty;
  bool get canGoPrevStep => currentStepIndex.value > 0;
  bool get canGoNextStep => currentStepIndex.value < stepSequence.length - 1;

  final RxBool isFlashOn = false.obs;
  final RxDouble zoomLevel = 1.0.obs;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  final RxBool isFrontCamera = false.obs;
  List<CameraDescription> _cameras = [];
  double _gestureStartZoom = 1.0;

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  void beginZoomGesture() {
    _gestureStartZoom = zoomLevel.value;
  }

  Future<void> applyZoomGesture(double cumulativeScale) async {
    const sensitivity = 0.20;
    final dampedScale = 1.0 + (cumulativeScale - 1.0) * sensitivity;
    await setZoom(_gestureStartZoom * dampedScale);
  }

  void imageZoomStepIn() {
    const step = 0.15;
    overlayScale.value = (overlayScale.value + step).clamp(0.2, 6.0);
  }

  void imageZoomStepOut() {
    const step = 0.15;
    overlayScale.value = (overlayScale.value - step).clamp(0.2, 6.0);
  }

  void rotateStep() {
    const step = 1.5707963267948966;
    var next = overlayRotation.value - step;
    const fullTurn = 6.283185307179586;
    next = next % fullTurn;
    if (next < 0) next += fullTurn;
    overlayRotation.value = next;
  }

  Future<void> initCamera() async {
    if (_isInitializing || isCameraReady.value) return;
    _isInitializing = true;
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        errorMessage.value = 'No camera found on this device.';
        return;
      }
      final backCamera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );
      await _startCamera(backCamera);
      isFrontCamera.value = false;
    } catch (e) {
      errorMessage.value = 'Could not start the camera. Check permissions.';
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _startCamera(CameraDescription description) async {
    final controller = CameraController(
      description,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await controller.initialize();

    _minZoom = await controller.getMinZoomLevel();
    _maxZoom = await controller.getMaxZoomLevel();
    zoomLevel.value = 1.0.clamp(_minZoom, _maxZoom);
    await controller.setZoomLevel(zoomLevel.value);
    await controller.setFlashMode(FlashMode.off);
    isFlashOn.value = false;

    cameraController = controller;
    isCameraReady.value = true;
  }

  Future<void> toggleFlash() async {
    final controller = cameraController;
    if (controller == null || !isCameraReady.value) return;
    try {
      final next = !isFlashOn.value;
      await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
      isFlashOn.value = next;
    } catch (e) {
      errorMessage.value = 'Could not toggle flash.';
    }
  }

  Future<void> setZoom(double level) async {
    final controller = cameraController;
    if (controller == null || !isCameraReady.value) return;
    final clamped = level.clamp(_minZoom, _maxZoom);
    await controller.setZoomLevel(clamped);
    zoomLevel.value = clamped;
  }

  Future<void> pickFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      overlayImage.value = File(picked.path);
      _resetTransform();
    }
  }

  Future<void> captureWithCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      overlayImage.value = File(picked.path);
      _resetTransform();
    }
  }

  void setPresetImage(File file) {
    overlayImage.value = file;
    _resetTransform();
  }

  final RxBool isLoadingImage = false.obs;
  final RxString imageLoadError = ''.obs;

  Future<void> loadFromAssetPath(String assetPath) async {
    isLoadingImage.value = true;
    imageLoadError.value = '';
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/preset_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(byteData.buffer.asUint8List());
      overlayImage.value = file;
      _resetTransform();
    } catch (e) {
      imageLoadError.value = 'Could not load this image: $e';
    } finally {
      isLoadingImage.value = false;
    }
  }

  void _resetTransform() {
    overlayOffset.value = const Offset(0, 0);
    overlayScale.value = 1.0;
    overlayRotation.value = 0.0;
    opacity.value = 0.55;
  }

  Future<void> toggleFreeze() async {
    if (isFrozen.value) {
      isFrozen.value = false;
      frozenFrame.value = null;
      return;
    }
    if (_isCapturing || cameraController == null) return;
    _isCapturing = true;
    try {
      final dir = await getTemporaryDirectory();
      final file = await cameraController!.takePicture();
      final saved = await File(file.path).copy(
        '${dir.path}/ar_freeze_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      frozenFrame.value = saved;
      isFrozen.value = true;
    } catch (e) {
      errorMessage.value = 'Could not freeze the frame. Try again.';
    } finally {
      _isCapturing = false;
    }
  }

  void setOpacity(double value) => opacity.value = value.clamp(0.1, 1.0);

  void updateTransform({
    required Offset offsetDelta,
    required double scaleDelta,
    required double rotationDelta,
  }) {
    overlayOffset.value = overlayOffset.value + offsetDelta;
    overlayScale.value = (overlayScale.value * scaleDelta).clamp(0.2, 6.0);
    overlayRotation.value = overlayRotation.value + rotationDelta;
  }

  void resetTransform() => _resetTransform();

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
