import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/color_picker_controller.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';
import 'package:sketch_flow/app/theme/app_typography.dart';

class ColorValueSliders extends StatelessWidget {
  final ColorPickerController controller;

  const ColorValueSliders({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.valueModel.value == ValueModel.hsl) {
        return _buildHsl();
      }
      return _buildRgb();
    });
  }

  Widget _buildHsl() {
    final hsl = controller.asHsl;
    return Column(
      children: [
        _GradientSlider(
          label: 'H',
          value: hsl.hue,
          max: 360,
          displayValue: hsl.hue.round().toString(),
          gradientColors: List.generate(
            7,
            (i) => HSVColor.fromAHSV(1, i * 60.0, 1, 1).toColor(),
          ),
          onChanged: (v) =>
              controller.setFromHsl(v, hsl.saturation, hsl.lightness),
        ),
        const SizedBox(height: AppSpace.md),
        _GradientSlider(
          label: 'S',
          value: hsl.saturation * 100,
          max: 100,
          displayValue: (hsl.saturation * 100).round().toString(),
          gradientColors: [
            HSLColor.fromAHSL(1, hsl.hue, 0, hsl.lightness).toColor(),
            HSLColor.fromAHSL(1, hsl.hue, 1, hsl.lightness).toColor(),
          ],
          onChanged: (v) =>
              controller.setFromHsl(hsl.hue, v / 100, hsl.lightness),
        ),
        const SizedBox(height: AppSpace.md),
        _GradientSlider(
          label: 'L',
          value: hsl.lightness * 100,
          max: 100,
          displayValue: (hsl.lightness * 100).round().toString(),
          gradientColors: const [Colors.black, Colors.white],
          onChanged: (v) =>
              controller.setFromHsl(hsl.hue, hsl.saturation, v / 100),
        ),
      ],
    );
  }

  Widget _buildRgb() {
    final color = controller.currentColor;
    return Column(
      children: [
        _GradientSlider(
          label: 'R',
          value: color.r * 255.0,
          max: 255,
          displayValue: (color.r * 255.0).round().toString(),
          gradientColors: [
            Color.fromARGB(
              255,
              0,
              (color.g * 255.0).round(),
              (color.b * 255.0).round(),
            ),
            Color.fromARGB(
              255,
              255,
              (color.g * 255.0).round(),
              (color.b * 255.0).round(),
            ),
          ],
          onChanged: (v) => controller.setFromRgb(
            v.round(),
            (color.g * 255.0).round(),
            (color.b * 255.0).round(),
          ),
        ),
        const SizedBox(height: AppSpace.md),
        _GradientSlider(
          label: 'G',
          value: color.g * 255.0,
          max: 255,
          displayValue: (color.g * 255.0).round().toString(),
          gradientColors: [
            Color.fromARGB(
              255,
              (color.r * 255.0).round(),
              0,
              (color.b * 255.0).round(),
            ),
            Color.fromARGB(
              255,
              (color.r * 255.0).round(),
              255,
              (color.b * 255.0).round(),
            ),
          ],
          onChanged: (v) => controller.setFromRgb(
            (color.r * 255.0).round(),
            v.round(),
            (color.b * 255.0).round(),
          ),
        ),
        const SizedBox(height: AppSpace.md),
        _GradientSlider(
          label: 'B',
          value: color.b * 255.0,
          max: 255,
          displayValue: (color.b * 255.0).round().toString(),
          gradientColors: [
            Color.fromARGB(
              255,
              (color.r * 255.0).round(),
              (color.g * 255.0).round(),
              0,
            ),
            Color.fromARGB(
              255,
              (color.r * 255.0).round(),
              (color.g * 255.0).round(),
              255,
            ),
          ],
          onChanged: (v) => controller.setFromRgb(
            (color.r * 255.0).round(),
            (color.g * 255.0).round(),
            v.round(),
          ),
        ),
      ],
    );
  }
}

class _GradientSlider extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final String displayValue;
  final List<Color> gradientColors;
  final ValueChanged<double> onChanged;

  const _GradientSlider({
    required this.label,
    required this.value,
    required this.max,
    required this.displayValue,
    required this.gradientColors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          child: Text(
            label,
            style: AppTypography.body.copyWith(color: Colors.white70),
          ),
        ),
        const SizedBox(width: AppSpace.sm),
        Expanded(
          child: SizedBox(
            height: 28,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(colors: gradientColors),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 0,
                    activeTrackColor: Colors.transparent,
                    inactiveTrackColor: Colors.transparent,
                    thumbColor: Colors.white,
                    overlayColor: Colors.white24,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                  ),
                  child: Slider(
                    value: value.clamp(0, max),
                    min: 0,
                    max: max,
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpace.sm),
        SizedBox(
          width: 36,
          child: Text(
            displayValue,
            textAlign: TextAlign.end,
            style: AppTypography.body.copyWith(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}
