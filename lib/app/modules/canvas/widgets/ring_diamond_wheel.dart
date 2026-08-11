import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sketch_flow/app/modules/canvas/controllers/color_picker_controller.dart';

class RingDiamondWheel extends StatefulWidget {
  final ColorPickerController controller;
  final double size;
  final bool showHarmonyOverlay;

  const RingDiamondWheel({
    super.key,
    required this.controller,
    this.size = 300,
    this.showHarmonyOverlay = false,
  });

  @override
  State<RingDiamondWheel> createState() => _RingDiamondWheelState();
}

class _RingDiamondWheelState extends State<RingDiamondWheel> {
  static const double _ringThickness = 34;

  bool _draggingRing = false;
  bool _draggingDiamond = false;

  Offset get _center => Offset(widget.size / 2, widget.size / 2);

  double get _outerRadius => widget.size / 2;

  double get _innerRadius => _outerRadius - _ringThickness;

  void _handlePanStart(DragStartDetails details) {
    final local = details.localPosition;
    final distanceFromCenter = (local - _center).distance;
    if (distanceFromCenter >= _innerRadius) {
      _draggingRing = true;
      _updateHue(local);
    } else {
      _draggingDiamond = true;
      _updateSaturationValue(local);
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_draggingRing) {
      _updateHue(details.localPosition);
    } else if (_draggingDiamond) {
      _updateSaturationValue(details.localPosition);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    _draggingRing = false;
    _draggingDiamond = false;
    widget.controller.commitToHistory();
  }

  void _updateHue(Offset local) {
    final vector = local - _center;
    final angle = (atan2(vector.dy, vector.dx) * 180 / pi + 360) % 360;
    widget.controller.setHue(angle);
  }

  void _updateSaturationValue(Offset local) {
    final vector = local - _center;
    final half = _innerRadius * 0.72;
    final dx = (vector.dx / half).clamp(-1.0, 1.0);
    final dy = (vector.dy / half).clamp(-1.0, 1.0);

    final saturation = ((dx + dy) / 2 + 0.5).clamp(0.0, 1.0);
    final value = (1 - ((dy - dx) / 2 + 0.5)).clamp(0.0, 1.0);

    widget.controller.setSaturationValue(saturation, value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hsv = widget.controller.current.value;
      return GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RingDiamondPainter(
              hue: hsv.hue,
              saturation: hsv.saturation,
              value: hsv.value,
              ringThickness: _ringThickness,
              showHarmonyOverlay: widget.showHarmonyOverlay,
            ),
          ),
        ),
      );
    });
  }
}

class _RingDiamondPainter extends CustomPainter {
  final double hue;
  final double saturation;
  final double value;
  final double ringThickness;
  final bool showHarmonyOverlay;

  _RingDiamondPainter({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.ringThickness,
    required this.showHarmonyOverlay,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius - ringThickness;

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringThickness
      ..shader =
          SweepGradient(
            colors: List.generate(
              361,
              (i) => HSVColor.fromAHSV(1, i.toDouble(), 1, 1).toColor(),
            ),
          ).createShader(
            Rect.fromCircle(
              center: center,
              radius: innerRadius + ringThickness / 2,
            ),
          );

    canvas.drawCircle(center, innerRadius + ringThickness / 2, ringPaint);

    final hueAngleRad = hue * pi / 180;
    final handleRadius = innerRadius + ringThickness / 2;
    final huePos =
        center + Offset(cos(hueAngleRad), sin(hueAngleRad)) * handleRadius;
    _drawHandle(canvas, huePos, HSVColor.fromAHSV(1, hue, 1, 1).toColor());

    final half = innerRadius * 0.72;
    final top = center - Offset(0, half);
    final right = center + Offset(half, 0);
    final bottom = center + Offset(0, half);
    final left = center - Offset(half, 0);

    final diamondPath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();

    canvas.save();
    canvas.clipPath(diamondPath);

    final hueColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
    final rect = Rect.fromLTRB(left.dx, top.dy, right.dx, bottom.dy);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.white, hueColor],
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..blendMode = BlendMode.multiply
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.black],
        ).createShader(rect),
    );
    canvas.restore();

    canvas.drawPath(
      diamondPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withValues(alpha: 0.15),
    );

    final dx = saturation - (1 - value);
    final dy = saturation + (1 - value) - 1;
    final diamondPos = center + Offset(dx * half, dy * half);
    _drawHandle(
      canvas,
      diamondPos,
      HSVColor.fromAHSV(1, hue, saturation, value).toColor(),
    );

    if (showHarmonyOverlay) {
      final complementAngle = (hue + 180) * pi / 180;
      final complementPos =
          center +
          Offset(cos(complementAngle), sin(complementAngle)) * handleRadius;

      final guidePaint = Paint()
        ..color = const Color(0xFF4C9AFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawLine(huePos, center, guidePaint);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius - 2),
        hueAngleRad,
        pi,
        false,
        guidePaint,
      );
      _drawHandle(
        canvas,
        complementPos,
        HSVColor.fromAHSV(1, (hue + 180) % 360, 1, 1).toColor(),
        filled: false,
      );
    }
  }

  void _drawHandle(
    Canvas canvas,
    Offset position,
    Color fillColor, {
    bool filled = true,
  }) {
    canvas.drawCircle(
      position,
      11,
      Paint()..color = Colors.black.withValues(alpha: 0.3),
    );
    canvas.drawCircle(
      position,
      9,
      Paint()
        ..color = filled ? fillColor : Colors.transparent
        ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke,
    );
    canvas.drawCircle(
      position,
      9,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _RingDiamondPainter oldDelegate) {
    return oldDelegate.hue != hue ||
        oldDelegate.saturation != saturation ||
        oldDelegate.value != value ||
        oldDelegate.showHarmonyOverlay != showHarmonyOverlay;
  }
}
