import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:sketch_flow/app/data/models/project_model.dart';
import 'package:sketch_flow/app/data/services/thumbnail_service.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/canvas_controller.dart';

enum ExportFormat { png, jpg, pdf, psd }

extension ExportFormatMeta on ExportFormat {
  String get label {
    switch (this) {
      case ExportFormat.png:
        return 'PNG';
      case ExportFormat.jpg:
        return 'JPG';
      case ExportFormat.pdf:
        return 'PDF';
      case ExportFormat.psd:
        return 'PSD (coming soon)';
    }
  }

  bool get isAvailable => this != ExportFormat.psd;
}

enum ExportResolution { standard, high, original }

extension ExportResolutionMeta on ExportResolution {
  String get label {
    switch (this) {
      case ExportResolution.standard:
        return 'Standard · 1x';
      case ExportResolution.high:
        return 'High · 2x';
      case ExportResolution.original:
        return 'Original canvas size';
    }
  }

  double get scale {
    switch (this) {
      case ExportResolution.standard:
        return 1.0;
      case ExportResolution.high:
        return 2.0;
      case ExportResolution.original:
        return 1.0;
    }
  }
}

class ExportController extends GetxController {
  late final ProjectModel _project;

  final Rx<ExportFormat> format = ExportFormat.png.obs;
  final Rx<ExportResolution> resolution = ExportResolution.high.obs;
  final RxBool flattenLayers = true.obs;
  final RxBool isExporting = false.obs;
  final RxBool exportComplete = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProjectModel) {
      _project = args;
    } else if (Get.isRegistered<CanvasController>()) {
      final active = Get.find<CanvasController>().activeProject.value;
      _project =
          active ??
          ProjectModel(
            id: 'temp',
            name: 'Untitled',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            thumbnailColor: const Color(0xFFFAFAF8),
          );
    }
  }

  void setFormat(ExportFormat f) {
    if (!f.isAvailable) return;
    format.value = f;
  }

  void setResolution(ExportResolution r) => resolution.value = r;

  void toggleFlatten(bool v) => flattenLayers.value = v;

  Future<void> runExport() async {
    isExporting.value = true;
    exportComplete.value = false;
    errorMessage.value = '';

    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          errorMessage.value = 'Permission to save photos was denied.';
          isExporting.value = false;
          return;
        }
      }

      final baseWidth = _project.canvasSize.width == 0
          ? 1080.0
          : _project.canvasSize.width;
      final baseHeight = _project.canvasSize.height == 0
          ? 1350.0
          : _project.canvasSize.height;

      final scale = resolution.value == ExportResolution.original
          ? 1.0
          : resolution.value.scale;

      switch (format.value) {
        case ExportFormat.png:
        case ExportFormat.jpg:
          final bytes = await ThumbnailService.renderPng(
            _project,
            width: baseWidth * scale,
            height: baseHeight * scale,
          );
          await Gal.putImageBytes(
            bytes,
            name: '${_project.name}_${DateTime.now().millisecondsSinceEpoch}',
          );
          break;
        case ExportFormat.pdf:
          await _exportPdf(baseWidth * scale, baseHeight * scale);
          break;
        case ExportFormat.psd:
          errorMessage.value = 'PSD export is coming soon.';
          isExporting.value = false;
          return;
      }

      exportComplete.value = true;
    } catch (e) {
      errorMessage.value = 'Export failed: $e';
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> _exportPdf(double width, double height) async {
    final pngBytes = await ThumbnailService.renderPng(
      _project,
      width: width,
      height: height,
    );
    final image = pw.MemoryImage(pngBytes);

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(width, height),
        build: (context) => pw.Image(image, fit: pw.BoxFit.contain),
      ),
    );

    final Uint8List pdfBytes = await doc.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/${_project.name}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(pdfBytes, flush: true);

    await Share.shareXFiles([XFile(file.path)], text: _project.name);
  }

  void resetExportState() => exportComplete.value = false;
}
