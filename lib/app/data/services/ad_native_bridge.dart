import 'package:flutter/services.dart';

class AdNativeBridge {
  AdNativeBridge._();

  static const MethodChannel _channel = MethodChannel('sketch_flow/ad_config');

  static final Map<String, String> _cache = {};

  static Future<String?> get(String key) async {
    if (_cache.containsKey(key)) return _cache[key];
    try {
      final value = await _channel.invokeMethod<String>('getAdUnitId', {
        'key': key,
      });
      if (value != null && value.isNotEmpty) {
        _cache[key] = value;
      }
      return value;
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
