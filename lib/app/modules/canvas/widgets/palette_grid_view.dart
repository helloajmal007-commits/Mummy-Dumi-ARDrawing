import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/color_picker_controller.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';

class PaletteGridView extends StatelessWidget {
  final ColorPickerController controller;

  const PaletteGridView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final palettes = controller.palettes;
      if (palettes.isEmpty) {
        return const Center(
          child: Text(
            'No palettes yet',
            style: TextStyle(color: Colors.white54),
          ),
        );
      }
      final activeIndex = controller.activePaletteIndex.value.clamp(
        0,
        palettes.length - 1,
      );
      final active = palettes[activeIndex];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64,
                  child: ListView.separated(
                    itemCount: palettes.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpace.sm),
                    itemBuilder: (context, i) {
                      final palette = palettes[i];
                      final isActive = i == activeIndex;
                      return GestureDetector(
                        onTap: () => controller.selectPalette(i),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isActive ? Colors.white : Colors.white24,
                              width: isActive ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            children: palette.preview
                                .map((c) => Container(color: c))
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpace.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              active.name,
                              style: AppTypography.body.copyWith(
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 16,
                              color: Colors.white54,
                            ),
                            onPressed: () => _showRenameDialog(
                              context,
                              controller,
                              active.name,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpace.sm),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                              ),
                          itemCount: active.colors.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () =>
                                  controller.setColor(active.colors[i]),
                              child: Container(color: active.colors[i]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white54),
                onPressed: controller.deleteActivePalette,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white54),
                    onPressed: controller.previousPalette,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white54,
                    ),
                    onPressed: controller.nextPalette,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white54),
                onPressed: controller.addPalette,
              ),
            ],
          ),
        ],
      );
    });
  }

  void _showRenameDialog(
    BuildContext context,
    ColorPickerController controller,
    String current,
  ) {
    final textController = TextEditingController(text: current);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Rename palette',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.renamePalette(
                controller.activePaletteIndex.value,
                textController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
