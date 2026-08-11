import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/language_model.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';

class LanguageController extends GetxController {
  final Rx<AppLanguage> selected = kSupportedLanguages.first.obs;

  @override
  void onInit() {
    super.onInit();
    final savedCode = StorageService.loadLanguageCode();
    if (savedCode != null) {
      final match = kSupportedLanguages.firstWhereOrNull(
            (l) => l.code == savedCode,
      );
      if (match != null) selected.value = match;
    }
  }

  void select(AppLanguage language) => selected.value = language;

  void goToConfirm() => Get.toNamed(Routes.languageConfirm);

  void confirmAndContinue() {
    StorageService.saveLanguageCode(selected.value.code);
    Get.offAllNamed(Routes.onboarding);
  }

  void goToLanguageSelect() => Get.back();
}