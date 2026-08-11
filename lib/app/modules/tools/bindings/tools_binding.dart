import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/tools/controllers/tools_controller.dart';

class ToolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToolsController>(() => ToolsController());
  }
}
