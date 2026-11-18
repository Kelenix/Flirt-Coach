import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Vague de l'écran d'accueil du kit : une colline ondulée violet → rose dont
/// la crête brille et qui se fond dans le fond vers le bas. Pleine largeur,
/// purement décorative.
class BrandWave extends StatelessWidget {
  const BrandWave({super.key, this.height = 110});

  final double height;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: OverflowBox(
          maxWidth: screenWidth,
          minWidth: screenWidth,
          child: const CustomPaint(
            size: Size.infinite,
            painter: _WavePainter(),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter();

  /// Crête : haute à gauche, creux au centre-droit, remonte à droite.
  Path _crest(Size size, double shift) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(0, h * (0.30 + shift))
      ..cubicTo(
        w * 0.30,
        h * (0.05 + shift),
        w * 0.55,
        h * (0.75 + shift),
        w,
        h * (0.15 + shift),
      );
  }

  Path _hill(Size size, double shift) => _crest(size, shift)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();

  Shader _colors(Rect bounds, double opacity) => LinearGradient(
    colors: [
      AppColors.secondaryDeep.withValues(alpha: opacity),
      AppColors.primary.withValues(alpha: opacity),
    ],
  ).createShader(bounds);

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;

    canvas.saveLayer(bounds, Paint());
    // Deux collines superposées, celle de derrière plus discrète.
    canvas
      ..drawPath(_hill(size, -0.12), Paint()..shader = _colors(bounds, 0.30))
      ..drawPath(_hill(size, 0), Paint()..shader = _colors(bounds, 0.55));
    // Fondu vers le bas : la vague se dissout dans le fond.
    canvas
      ..drawRect(
        bounds,
        Paint()
          ..blendMode = BlendMode.dstIn
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.transparent],
            stops: [0.35, 1],
          ).createShader(bounds),
      )
      ..restore();

    // Crête lumineuse.
    canvas
      ..drawPath(
        _crest(size, 0),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
          ..shader = _colors(bounds, 0.7),
      )
      ..drawPath(
        _crest(size, 0),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..shader = _colors(bounds, 0.9),
      );
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => false;
}
