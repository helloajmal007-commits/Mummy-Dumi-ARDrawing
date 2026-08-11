import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/color_picker_controller.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';

class GradientBarPicker extends StatelessWidget {
  final ColorPickerController controller;

  const GradientBarPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final start = controller.gradientStart.value;
      final end = controller.gradientEnd.value;
      final position = controller.gradientPosition.value;

      return SizedBox(
        height: 56,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth - 44; // minus endpoint boxes
            return Row(
              children: [
                _EndpointBox(color: start, isActive: true),
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragStart: (d) =>
                        _updateFromLocalX(d.localPosition.dx, width),
                    onHorizontalDragUpdate: (d) =>
                        _updateFromLocalX(d.localPosition.dx, width),
                    onTapDown: (d) =>
                        _updateFromLocalX(d.localPosition.dx, width),
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpace.sm,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        gradient: LinearGradient(colors: [start, end]),
                      ),
                      child: Align(
                        alignment: Alignment(position * 2 - 1, 0),
                        child: Container(
                          width: 4,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _EndpointBox(color: end, isActive: false),
              ],
            );
          },
        ),
      );
    });
  }

  void _updateFromLocalX(double x, double width) {
    controller.setGradientPosition((x / width).clamp(0.0, 1.0));
  }
}

class _EndpointBox extends StatelessWidget {
  final Color color;
  final bool isActive;

  const _EndpointBox({required this.color, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: Colors.white24),
      ),
    );
  }
}
