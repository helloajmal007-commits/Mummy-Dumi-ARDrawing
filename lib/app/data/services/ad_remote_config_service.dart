import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:sketch_flow/app/data/models/ad_config_model.dart';

class AdRemoteConfigService {
  AdRemoteConfigService._();

  static final AdRemoteConfigService instance = AdRemoteConfigService._();

  static const String _debugKey = 'ad_config_debug';
  static const String _liveKey = 'ad_config_live';

  static const String _defaultJson = '{}';

  FirebaseRemoteConfig? _rc;
  Map<String, AdUnitConfig> _config = {};
  bool _initialized = false;

  String get _activeKey => kDebugMode ? _debugKey : _liveKey;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    _rc = FirebaseRemoteConfig.instance;

    await _rc!.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? const Duration(minutes: 1)
            : const Duration(minutes: 1),
      ),
    );

    await _rc!.setDefaults({_debugKey: _defaultJson, _liveKey: _defaultJson});

    try {
      await _rc!.fetchAndActivate();
    } catch (e) {
      debugPrint(
        'AdRemoteConfigService: fetch failed, using cached/default config. $e',
      );
    }

    _parseActiveConfig();
    _initialized = true;
  }

  void _parseActiveConfig() {
    final raw = _rc?.getString(_activeKey) ?? _defaultJson;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      _config = decoded.map(
        (key, value) =>
            MapEntry(key, AdUnitConfig.fromJson(value as Map<String, dynamic>)),
      );
    } catch (e) {
      debugPrint(
        'AdRemoteConfigService: failed to parse "$_activeKey" JSON. $e',
      );
      _config = {};
    }
  }

  bool isEnabled(String placementKey) {
    return _config[placementKey]?.show ?? false;
  }

  AdUnitConfig configFor(String placementKey) {
    return _config[placementKey] ?? AdUnitConfig.disabled();
  }

  Future<void> refresh() async {
    if (_rc == null) return;
    try {
      await _rc!.fetchAndActivate();
      _parseActiveConfig();
    } catch (e) {
      debugPrint('AdRemoteConfigService: refresh failed. $e');
    }
  }
}
