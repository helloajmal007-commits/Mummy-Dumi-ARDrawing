import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class HomeController extends GetxController {
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
}
