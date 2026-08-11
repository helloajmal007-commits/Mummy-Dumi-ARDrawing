import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/export/controllers/export_controller.dart';

class ExportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExportController>(() => ExportController());
  }
}
