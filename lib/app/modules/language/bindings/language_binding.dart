import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/language/controllers/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageController>(() => LanguageController());
  }
}