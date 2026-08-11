import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/layer_model.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:uuid/uuid.dart';

class LayersController extends GetxController {
  final CanvasController canvas = Get.find<CanvasController>();

  List<LayerModel> get layers => canvas.layers.reversed.toList();

  String get activeLayerId => canvas.activeLayerId.value;

  void select(String id) => canvas.setActiveLayer(id);

  void toggleVisibility(LayerModel layer) =>
      canvas.toggleLayerVisibility(layer.id);

  void toggleLock(LayerModel layer) {
    layer.isLocked = !layer.isLocked;
    canvas.layers.refresh();
  }

  void setOpacity(LayerModel layer, double value) {
    layer.opacity = value;
    canvas.layers.refresh();
  }

  void setBlendMode(LayerModel layer, BlendMode2 mode) {
    layer.blendMode = mode;
    canvas.layers.refresh();
  }

  void addLayer() => canvas.addLayer();

  void duplicateLayer(LayerModel layer) {
    final copy = LayerModel(
      id: const Uuid().v4(),
      name: '${layer.name} copy',
      isVisible: layer.isVisible,
      opacity: layer.opacity,
      blendMode: layer.blendMode,
      previewColor: layer.previewColor,
    );
    final index = canvas.layers.indexWhere((l) => l.id == layer.id);
    canvas.layers.insert(index + 1, copy);
  }

  void deleteLayer(LayerModel layer) {
    if (canvas.layers.length <= 1) return;
    canvas.layers.removeWhere((l) => l.id == layer.id);
    if (canvas.activeLayerId.value == layer.id) {
      canvas.activeLayerId.value = canvas.layers.last.id;
    }
  }

  void reorder(int oldIndex, int newIndex) {
    final uiList = layers;
    if (newIndex > oldIndex) newIndex -= 1;
    final moved = uiList.removeAt(oldIndex);
    uiList.insert(newIndex, moved);
    canvas.layers.assignAll(uiList.reversed.toList());
  }
}
