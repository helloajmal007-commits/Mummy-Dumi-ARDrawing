import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/data/services/asset_discovery.dart';
import 'package:sketch_flow/app/localization/translation_keys.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';

class CategoryItem {
  final String key;
  final String name;
  final IconData icon;
  final Color color;
  final String assetFolder;

  const CategoryItem({
    required this.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.assetFolder,
  });
}

class CategoriesController extends GetxController {
  final RxList<CategoryItem> categories = <CategoryItem>[
    CategoryItem(
      key: 'anime',
      name: TKeys.catAnime.tr,
      icon: Icons.face_retouching_natural,
      color: AppColors.coral,
      assetFolder: 'assets/categories/anime',
    ),
    CategoryItem(
      key: 'cartoon',
      name: TKeys.catCartoon.tr,
      icon: Icons.emoji_emotions_outlined,
      color: AppColors.amber,
      assetFolder: 'assets/categories/cartoon',
    ),
    CategoryItem(
      key: 'portrait',
      name: TKeys.catPortrait.tr,
      icon: Icons.face_outlined,
      color: AppColors.accent,
      assetFolder: 'assets/categories/portrait',
    ),
    CategoryItem(
      key: 'animal',
      name: TKeys.catAnimals.tr,
      icon: Icons.pets_outlined,
      color: AppColors.mint,
      assetFolder: 'assets/categories/animals',
    ),
    CategoryItem(
      key: 'nature',
      name: TKeys.catNature.tr,
      icon: Icons.park_outlined,
      color: AppColors.mint,
      assetFolder: 'assets/categories/nature',
    ),
    CategoryItem(
      key: 'objects',
      name: TKeys.catObjects.tr,
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
            previewImages[category.key] = images.first;
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
