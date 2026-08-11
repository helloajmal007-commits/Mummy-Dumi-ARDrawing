import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/learn/controllers/learn_controller.dart';

class LearnBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LearnController>(() => LearnController());
  }
}