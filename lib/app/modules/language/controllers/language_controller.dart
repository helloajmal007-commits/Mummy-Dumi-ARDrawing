import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/language_model.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/localization/locale_controller.dart';
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

  void select(AppLanguage language) {
    selected.value = language;
    Get.find<LocaleController>().changeLocale(language.englishName);
  }

  void goToConfirm() => Get.toNamed(Routes.languageConfirm);

  void confirmAndContinue() {
    StorageService.saveLanguageCode(selected.value.code);
    Get.find<LocaleController>().changeLocale(selected.value.englishName);
    Get.offAllNamed(Routes.onboarding);
  }

  void goToLanguageSelect() => Get.back();
}
