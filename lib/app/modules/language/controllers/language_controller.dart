import 'package:get/get.dart';
import 'package:sketch_flow/app/data/models/language_model.dart';
import 'package:sketch_flow/app/data/services/storage_service.dart';
import 'package:sketch_flow/app/localization/locale_controller.dart';
import 'package:sketch_flow/app/routes/app_routes.dart';

class LanguageController extends GetxController {
  final Rx<AppLanguage?> selected = Rx<AppLanguage?>(null);

  bool isSettingsMode = false;
  AppLanguage? _previousLanguage;

  bool get hasSelection => selected.value != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    isSettingsMode = args is Map && args['isSettingsMode'] == true;

    final savedCode = StorageService.loadLanguageCode();
    if (savedCode != null) {
      final match = kSupportedLanguages.firstWhereOrNull(
        (l) => l.code == savedCode,
      );
      if (match != null && isSettingsMode) selected.value = match;
    }

    _previousLanguage = selected.value;
  }

  void select(AppLanguage language) {
    selected.value = language;
    Get.find<LocaleController>().changeLocale(language.englishName);
  }

  void goToConfirm() {
    if (!hasSelection) return;
    Get.toNamed(Routes.languageConfirm);
  }

  void confirmAndContinue() {
    final language = selected.value;
    if (language == null) return;
    StorageService.saveLanguageCode(language.code);
    Get.find<LocaleController>().changeLocale(language.englishName);
    Get.offAllNamed(Routes.onboarding);
  }

  void goToLanguageSelect() => Get.back();

  void saveAndGoBack() {
    final language = selected.value;
    if (language == null) return;
    StorageService.saveLanguageCode(language.code);
    Get.find<LocaleController>().changeLocale(language.englishName);
    Get.back();
  }

  void revertAndGoBack() {
    final previous = _previousLanguage;
    if (previous != null) {
      Get.find<LocaleController>().changeLocale(previous.englishName);
    }
    selected.value = previous;
    Get.back();
  }
}
