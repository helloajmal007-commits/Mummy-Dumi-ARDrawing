class AppLanguage {
  final String code;
  final String name;
  final String flagEmoji;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.flagEmoji,
  });
}

const List<AppLanguage> kSupportedLanguages = [
  AppLanguage(code: 'en', name: 'English', flagEmoji: '🇬🇧'),
  AppLanguage(code: 'es', name: 'Spanish', flagEmoji: '🇪🇸'),
  AppLanguage(code: 'fr', name: 'French', flagEmoji: '🇫🇷'),
  AppLanguage(code: 'de', name: 'German', flagEmoji: '🇩🇪'),
  AppLanguage(code: 'hi', name: 'Hindi', flagEmoji: '🇮🇳'),
  AppLanguage(code: 'zh', name: 'Chinese', flagEmoji: '🇨🇳'),
];
