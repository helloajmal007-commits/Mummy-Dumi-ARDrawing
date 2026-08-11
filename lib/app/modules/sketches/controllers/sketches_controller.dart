import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/project_model.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';
import 'package:uuid/uuid.dart';

class SketchesController extends GetxController {
  final RxList<ProjectModel> sketches = <ProjectModel>[].obs;

  bool get isEmpty => sketches.isEmpty;

  @override
  void onInit() {
    super.onInit();
    sketches.assignAll(StorageService.loadProjects());
  }

  void openSketch(ProjectModel project) {
    Get.toNamed(Routes.canvas, arguments: project);
  }

  void createNewSketch() {
    final project = ProjectModel(
      id: const Uuid().v4(),
      name: 'Untitled sketch ${sketches.length + 1}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      thumbnailColor: const Color(0xFFFAFAF8),
    );
    sketches.insert(0, project);
    StorageService.saveProjects(sketches);
    Get.toNamed(Routes.canvas, arguments: project);
  }

  void updateSketch(ProjectModel updated) {
    final i = sketches.indexWhere((s) => s.id == updated.id);
    if (i != -1) {
      sketches[i] = updated;
    } else {
      sketches.insert(0, updated);
    }
    StorageService.saveProjects(sketches);
  }

  void renameSketch(ProjectModel project, String newName) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    final updated = project.copyWith(name: trimmed, updatedAt: DateTime.now());
    updateSketch(updated);
  }

  void deleteSketch(ProjectModel project) {
    sketches.removeWhere((s) => s.id == project.id);
    StorageService.saveProjects(sketches);
    if (project.thumbnailPath != null) {
      final file = File(project.thumbnailPath!);
      file.exists().then((exists) {
        if (exists) file.delete();
      });
    }
  }
}
