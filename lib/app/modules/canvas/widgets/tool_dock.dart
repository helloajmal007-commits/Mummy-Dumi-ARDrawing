import 'package:flutter/material.dart';
import 'package:sketch_flow/app/data/models/tool_model.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:sketch_flow/app/theme/app_colors.dart';
import 'package:sketch_flow/app/theme/app_dimens.dart';

class ToolDock extends StatelessWidget {
  final CanvasController controller;
  final VoidCallback onOpenTools;
  final VoidCallback onOpenLayers;

  const ToolDock({
    super.key,
    required this.controller,
    required this.onOpenTools,
    required this.onOpenLayers,
  });

  static const List<SketchToolType> _quickTools = [
    SketchToolType.pencil,
    SketchToolType.pen,
    SketchToolType.eraser,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.toolDock,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.md),
      decoration: BoxDecoration(
        color: AppColors.toolbarGlass,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final tool in _quickTools) ...[
            _DockIcon(
              icon: tool.icon,
              isActive: controller.activeTool.value == tool,
              onTap: () => controller.selectTool(tool),
            ),
            const SizedBox(width: AppSpace.xs),
          ],
          _DockDivider(),
          const SizedBox(width: AppSpace.xs),
          _DockIcon(
            icon: Icons.tune,
            isActive: false,
            onTap: onOpenTools,
          ),
          const SizedBox(width: AppSpace.xs),
          _DockIcon(
            icon: Icons.layers_outlined,
            isActive: false,
            onTap: onOpenLayers,
          ),
        ],
      ),
    );
  }
}

class _DockDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      color: AppColors.divider,
      margin: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
    );
  }
}

class _DockIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _DockIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppColors.ink : Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: AppSize.toolIcon,
          height: AppSize.toolIcon,
          child: Icon(
            icon,
            size: 20,
            color: isActive ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
