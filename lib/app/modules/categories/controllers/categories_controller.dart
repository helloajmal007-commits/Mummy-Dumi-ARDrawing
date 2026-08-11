import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/services/asset_discovery.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;
  final String assetFolder;

  const CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.assetFolder,
  });
}

class CategoriesController extends GetxController {
  final RxList<CategoryItem> categories = <CategoryItem>[
    const CategoryItem(
      name: 'Anime',
      icon: Icons.face_retouching_natural,
      color: AppColors.coral,
      assetFolder: 'assets/categories/anime',
    ),
    const CategoryItem(
      name: 'Cartoon',
      icon: Icons.emoji_emotions_outlined,
      color: AppColors.amber,
      assetFolder: 'assets/categories/cartoon',
    ),
    const CategoryItem(
      name: 'Portrait',
      icon: Icons.face_outlined,
      color: AppColors.accent,
      assetFolder: 'assets/categories/portrait',
    ),
    const CategoryItem(
      name: 'Animals',
      icon: Icons.pets_outlined,
      color: AppColors.mint,
      assetFolder: 'assets/categories/animals',
    ),
    const CategoryItem(
      name: 'Nature',
      icon: Icons.park_outlined,
      color: AppColors.mint,
      assetFolder: 'assets/categories/nature',
    ),
    const CategoryItem(
      name: 'Objects',
      icon: Icons.category_outlined,
      color: AppColors.lavender,
      assetFolder: 'assets/categories/objects',
    ),
  ].obs;

  final RxMap<String, String> previewImages = <String, String>{}.obs;
  bool _isLoadingPreviews = false;
  bool _hasLoadedPreviews = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadPreviews());
  }

  Future<void> loadPreviews() async {
    if (_isLoadingPreviews || _hasLoadedPreviews) return;
    _isLoadingPreviews = true;
    try {
      for (final category in categories) {
        try {
          final images = await AssetDiscovery.imagesInFolder(
            category.assetFolder,
          );
          if (images.isNotEmpty) {
            previewImages[category.name] = images.first;
          }
        } catch (_) {
          // no preview available for this category — icon-only card is fine
        }
      }
      _hasLoadedPreviews = true;
    } finally {
      _isLoadingPreviews = false;
    }
  }
}
