class AppLanguage {
  final String code;
  final String englishName;
  final String nameKey;
  final String flagEmoji;

  const AppLanguage({
    required this.code,
    required this.englishName,
    required this.nameKey,
    required this.flagEmoji,
  });
}

const List<AppLanguage> kSupportedLanguages = [
  AppLanguage(
    code: 'en',
    englishName: 'English',
    nameKey: 'language_name_english',
    flagEmoji: '🇬🇧',
  ),
  AppLanguage(
    code: 'es',
    englishName: 'Spanish',
    nameKey: 'language_name_spanish',
    flagEmoji: '🇪🇸',
  ),
  AppLanguage(
    code: 'fr',
    englishName: 'French',
    nameKey: 'language_name_french',
    flagEmoji: '🇫🇷',
  ),
  AppLanguage(
    code: 'de',
    englishName: 'German',
    nameKey: 'language_name_german',
    flagEmoji: '🇩🇪',
  ),
  AppLanguage(
    code: 'hi',
    englishName: 'Hindi',
    nameKey: 'language_name_hindi',
    flagEmoji: '🇮🇳',
  ),
  AppLanguage(
    code: 'zh',
    englishName: 'Chinese',
    nameKey: 'language_name_chinese',
    flagEmoji: '🇨🇳',
  ),
];
