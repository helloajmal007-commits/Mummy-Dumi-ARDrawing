import 'package:get/get.dart';
import 'package:sketch_flow/app/localization/de_de.dart';
import 'package:sketch_flow/app/localization/en_us.dart';
import 'package:sketch_flow/app/localization/es_es.dart';
import 'package:sketch_flow/app/localization/fr_fr.dart';
import 'package:sketch_flow/app/localization/hi_in.dart';
import 'package:sketch_flow/app/localization/zh_cn.dart';

export 'translation_keys.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'es_ES': esES,
    'fr_FR': frFR,
    'de_DE': deDE,
    'hi_IN': hiIN,
    'zh_CN': zhCN,
  };
}
