import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/project_model.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/canvas_controller.dart';

class CanvasBinding extends Bindings {
  @override
  void dependencies() {
    final controller = Get.put<CanvasController>(
      CanvasController(),
      permanent: true,
    );
    final project = Get.arguments;
    if (project is ProjectModel) {
      controller.loadProject(project);
    }
  }
}
