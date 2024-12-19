import 'dart:math';

import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';

class AnimatedBackgroundWalle extends StatelessWidget {
  final AnimationController controller;

  const AnimatedBackgroundWalle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _BackgroundPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double animation;

  _BackgroundPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kPrimaryColor.withOpacity(0.2)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    // Dibujamos más figuras y con más movimiento
    for (var i = 0; i < 80; i++) {
      // Movimiento más rápido y amplio en X
      final x = (i * size.width / 40 + animation * 150) % size.width;

      // Movimiento ondulante en Y
      final y =
          ((i * 73) % 50) * size.height / 50 + sin(animation * 4 * pi + i) * 20;

      // Tamaño variable más notorio
      final radius = (3 + sin(animation * 3 * pi + i)) * 6;

      canvas.drawCircle(Offset(x, y), radius, paint);

      // Figuras adicionales con movimiento contrario
      final x2 = (i * size.width / 40 - animation * 120) % size.width;
      final y2 =
          ((i * 57) % 40) * size.height / 40 + cos(animation * 3 * pi + i) * 15;

      canvas.drawCircle(Offset(x2, y2), radius * 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) =>
      oldDelegate.animation != animation;
}
