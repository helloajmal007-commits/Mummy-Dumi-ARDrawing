import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/paper_trace/controllers/paper_trace_controller.dart';

class PaperTraceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaperTraceController>(() => PaperTraceController());
  }
}