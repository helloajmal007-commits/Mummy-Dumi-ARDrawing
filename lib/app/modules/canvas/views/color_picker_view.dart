import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/color_picker_controller.dart';
import 'package:sketch_flow/app/modules/canvas/widgets/color_value_sliders.dart';
import 'package:sketch_flow/app/modules/canvas/widgets/gradient_bar_picker.dart';
import 'package:sketch_flow/app/modules/canvas/widgets/palette_grid_view.dart';
import 'package:sketch_flow/app/modules/canvas/widgets/ring_diamond_wheel.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';

class ColorPickerView extends StatelessWidget {
  final ColorPickerController controller;

  const ColorPickerView({super.key, required this.controller});

  static const _bg = Color(0xFF424242);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bg,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TopTabs(controller: controller),
            _ComplementaryAndHistory(controller: controller),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: Obx(() {
                  switch (controller.activeTab.value) {
                    case PickerTab.wheel:
                      return _WheelTab(controller: controller);
                    case PickerTab.grid:
                      return SizedBox(
                        height: 420,
                        child: PaletteGridView(controller: controller),
                      );
                    case PickerTab.favorites:
                      return _FavoritesTab(controller: controller);
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showColorPicker(
  BuildContext context, {
  required Color initialColor,
  required ValueChanged<Color> onColorChanged,
}) {
  final pickerTag = 'color_picker_${DateTime.now().millisecondsSinceEpoch}';
  final controller = Get.put(
    ColorPickerController(
      initialColor: initialColor,
      onColorCommitted: onColorChanged,
    ),
    tag: pickerTag,
  );

  controller.current.listen((hsv) => onColorChanged(hsv.toColor()));

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.88,
      child: ColorPickerView(controller: controller),
    ),
  ).whenComplete(
    () => Get.delete<ColorPickerController>(tag: pickerTag, force: true),
  );
}

class _TopTabs extends StatelessWidget {
  final ColorPickerController controller;

  const _TopTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = controller.activeTab.value;
      return Row(
        children: [
          _TabButton(
            icon: Icons.color_lens_outlined,
            isActive: active == PickerTab.wheel,
            onTap: () => controller.setTab(PickerTab.wheel),
          ),
          _TabButton(
            icon: Icons.grid_view_rounded,
            isActive: active == PickerTab.grid,
            onTap: () => controller.setTab(PickerTab.grid),
          ),
          _TabButton(
            icon: Icons.star_rounded,
            isActive: active == PickerTab.favorites,
            onTap: () => controller.setTab(PickerTab.favorites),
          ),
        ],
      );
    });
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 64,
          color: isActive ? Colors.blue : const Color(0xFF9E9E9E),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class _ComplementaryAndHistory extends StatelessWidget {
  final ColorPickerController controller;

  const _ComplementaryAndHistory({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.lg,
        AppSpace.md,
        AppSpace.lg,
        0,
      ),
      child: Obx(() {
        final current = controller.currentColor;
        final complementary = controller.complementaryColor;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              height: 70,
              child: Row(
                children: [
                  Expanded(child: Container(color: current)),
                  Expanded(child: Container(color: complementary)),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complementary',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Container(
                    height: 18,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: complementary,
                  ),
                  const Text(
                    'Color History',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  SizedBox(
                    height: 18,
                    child: Row(
                      children: controller.colorHistory
                          .take(10)
                          .map(
                            (c) => Expanded(
                              child: GestureDetector(
                                onTap: () => controller.setColor(c),
                                child: Container(color: c),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _WheelTab extends StatelessWidget {
  final ColorPickerController controller;

  const _WheelTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => RingDiamondWheel(
              controller: controller,
              size: 280,
              showHarmonyOverlay:
                  controller.auxMode.value == PickerAuxMode.harmony,
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Obx(
            () => Align(
              alignment: Alignment.centerRight,
              child: Text(
                'HEX # ${controller.hexCode.replaceAll('#', '')}',
                style: const TextStyle(color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          _ModeTabsRow(controller: controller),
          const SizedBox(height: AppSpace.lg),
          Obx(() {
            if (controller.auxMode.value == PickerAuxMode.gradientBar) {
              return GradientBarPicker(controller: controller);
            }
            return ColorValueSliders(controller: controller);
          }),
        ],
      ),
    );
  }
}

class _ModeTabsRow extends StatelessWidget {
  final ColorPickerController controller;

  const _ModeTabsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final model = controller.valueModel.value;
      final aux = controller.auxMode.value;
      return Row(
        children: [
          _TextTab(
            label: 'HSL',
            isActive: model == ValueModel.hsl && aux == PickerAuxMode.none,
            onTap: () {
              controller.setValueModel(ValueModel.hsl);
              controller.auxMode.value = PickerAuxMode.none;
            },
          ),
          const SizedBox(width: AppSpace.lg),
          _TextTab(
            label: 'RGB',
            isActive: model == ValueModel.rgb && aux == PickerAuxMode.none,
            onTap: () {
              controller.setValueModel(ValueModel.rgb);
              controller.auxMode.value = PickerAuxMode.none;
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.shuffle,
              color: aux == PickerAuxMode.harmony
                  ? Colors.blue
                  : Colors.white54,
            ),
            onPressed: () => controller.toggleAuxMode(PickerAuxMode.harmony),
          ),
          IconButton(
            icon: Icon(
              Icons.view_column_outlined,
              color: aux == PickerAuxMode.gradientBar
                  ? Colors.blue
                  : Colors.white54,
            ),
            onPressed: () =>
                controller.toggleAuxMode(PickerAuxMode.gradientBar),
          ),
        ],
      );
    });
  }
}

class _TextTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TextTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white38,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  final ColorPickerController controller;

  const _FavoritesTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.favorites.isEmpty) {
        return const Center(
          child: Text(
            'No favorites yet — tap the star on any color.',
            style: TextStyle(color: Colors.white54),
          ),
        );
      }
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: controller.favorites.length,
        itemBuilder: (context, i) {
          final color = controller.favorites[i];
          return GestureDetector(
            onTap: () => controller.setColor(color),
            onLongPress: () => controller.toggleFavorite(color),
            child: Container(color: color),
          );
        },
      );
    });
  }
}
