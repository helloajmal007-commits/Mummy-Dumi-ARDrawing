import 'package:flutter/services.dart' show rootBundle, AssetManifest;

class AssetDiscovery {
  AssetDiscovery._();

  static AssetManifest? _manifestCache;
  static Future<AssetManifest>? _pendingLoad;

  static const _imageExtensions = ['.png', '.jpg', '.jpeg', '.webp'];

  static Future<AssetManifest> _loadManifest() async {
    if (_manifestCache != null) return _manifestCache!;

    if (_pendingLoad != null) return _pendingLoad!;

    final future = AssetManifest.loadFromAssetBundle(rootBundle);
    _pendingLoad = future;

    try {
      final manifest = await future;
      if (manifest.listAssets().isNotEmpty) {
        _manifestCache = manifest;
      }
      return manifest;
    } finally {
      _pendingLoad = null;
    }
  }

  static Future<List<String>> imagesInFolder(String folderPath) async {
    final manifest = await _loadManifest();
    final normalized = folderPath.endsWith('/') ? folderPath : '$folderPath/';
    final allPaths = manifest.listAssets();
    final matches = allPaths.where((path) {
      if (!path.startsWith(normalized)) return false;
      final lower = path.toLowerCase();
      return _imageExtensions.any(lower.endsWith);
    }).toList();
    matches.sort();
    return matches;
  }
}