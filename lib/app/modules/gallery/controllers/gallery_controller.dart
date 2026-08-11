import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/project_model.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';

class GalleryController extends GetxController {
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;

  bool get isEmpty => projects.isEmpty;

  @override
  void onInit() {
    super.onInit();
    refresh();
  }

  @override
  void refresh() {
    final loaded = StorageService.loadProjects();
    loaded.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    projects.assignAll(loaded);
  }
}
