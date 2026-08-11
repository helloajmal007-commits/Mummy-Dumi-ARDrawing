import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:sketch_flow/app/modules/sketches/controllers/sketches_controller.dart';

class SketchesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CanvasController>()) {
      Get.lazyPut<CanvasController>(() => CanvasController());
    }
    Get.lazyPut<SketchesController>(() => SketchesController());
  }
}