import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/layers/controllers/layers_controller.dart';

class LayersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayersController>(() => LayersController());
  }
}
