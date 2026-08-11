import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  static const _storageKey = 'locale';
  static const _langNameKey = 'locale_name';

  final _box = GetStorage();

  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final saved = _box.read<String>(_storageKey);
    if (saved != null) {
      final parts = saved.split('_');
      if (parts.length == 2) {
        currentLocale.value = Locale(parts[0], parts[1]);
      }
    }
  }

  String getSavedLanguageName() {
    return _box.read<String>(_langNameKey) ?? 'English';
  }

  void changeLocale(String languageName) {
    final locale = _localeFromName(languageName);
    currentLocale.value = locale;
    Get.updateLocale(locale);

    _box.write(_storageKey, '${locale.languageCode}_${locale.countryCode}');
    _box.write(_langNameKey, languageName);
  }

  static Locale _localeFromName(String name) {
    switch (name) {
      case 'Spanish':
        return const Locale('es', 'ES');
      case 'French':
        return const Locale('fr', 'FR');
      case 'German':
        return const Locale('de', 'DE');
      case 'Hindi':
        return const Locale('hi', 'IN');
      case 'Chinese':
        return const Locale('zh', 'CN');
      case 'English':
      default:
        return const Locale('en', 'US');
    }
  }
}
