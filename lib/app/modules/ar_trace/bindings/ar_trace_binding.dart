import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/ar_trace/controllers/ar_trace_controller.dart';

class ArTraceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArTraceController>(() => ArTraceController());
  }
}