import 'dart:math';

import 'package:app_feria2024/config/paletaColores.config.dart';
import 'package:flutter/material.dart';

class BackgroundController {
  late AnimationController mainController;
  late AnimationController waveController;
  late AnimationController particleController;
  late AnimationController glowController;

  BackgroundController({required TickerProvider vsync}) {
    mainController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: vsync,
    )..repeat();

    waveController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: vsync,
    )..repeat();

    particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: vsync,
    )..repeat();

    glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    )..repeat(reverse: true);
  }

  void dispose() {
    mainController.dispose();
    waveController.dispose();
    particleController.dispose();
    glowController.dispose();
  }
}

class AnimatedBackgroundEffect extends StatelessWidget {
  final BackgroundController controller;

  const AnimatedBackgroundEffect({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        CustomPaint(
          painter: _EnhancedBackgroundPainter(
            controller: controller,
          ),
          size: Size.infinite,
        ),

        // Animated particles
        AnimatedParticles(controller: controller),

        // Energy waves
        AnimatedWaves(controller: controller),
      ],
    );
  }
}

class _EnhancedBackgroundPainter extends CustomPainter {
  final BackgroundController controller;

  _EnhancedBackgroundPainter({required this.controller})
      : super(repaint: controller.mainController);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Dynamic gradient background
    final Rect rect = Offset.zero & size;
    paint.shader = RadialGradient(
      center: const Alignment(0.0, -0.5),
      radius: 1.5,
      colors: [
        kPrimaryColor.withOpacity(0.2),
        kTerciaryColor.withOpacity(0.95),
        kTerciaryColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Add subtle patterns
    final patternPaint = Paint()
      ..color = kPrimaryColor.withOpacity(0.05)
      ..strokeWidth = 1.0;

    for (int i = 0; i < size.width; i += 20) {
      for (int j = 0; j < size.height; j += 20) {
        final offset =
            5 * sin(controller.mainController.value * 2 * pi + (i + j) / 50);
        canvas.drawCircle(
          Offset(i.toDouble(), j.toDouble() + offset),
          1,
          patternPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedParticles extends StatelessWidget {
  final BackgroundController controller;

  const AnimatedParticles({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            controller: controller,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class AnimatedWaves extends StatelessWidget {
  final BackgroundController controller;

  const AnimatedWaves({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.waveController,
      builder: (context, child) {
        return CustomPaint(
          painter: _WavePainter(
            controller: controller,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final BackgroundController controller;
  final Random random = Random();
  final List<_Particle> particles;
  static const int PARTICLE_COUNT = 50;

  _ParticlePainter({
    required this.controller,
  })  : particles =
            List.generate(PARTICLE_COUNT, (index) => _Particle(Random())),
        super(
            repaint: Listenable.merge([
          controller.particleController,
          controller.glowController,
        ]));

  @override
  void paint(Canvas canvas, Size size) {
    final time = controller.particleController.value * 2 * pi;
    final glowIntensity = (0.4 + controller.glowController.value * 0.6);

    for (var particle in particles) {
      // Actualizar posición de la partícula
      particle.update(time, size);

      // Crear gradiente radial para cada partícula
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            particle.color.withOpacity(0.7 * glowIntensity),
            particle.color.withOpacity(0.3 * glowIntensity),
            particle.color.withOpacity(0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(
          center: particle.position,
          radius: particle.size * 2,
        ));

      // Dibujar partícula principal
      canvas.drawCircle(
        particle.position,
        particle.size * particle.pulseValue,
        paint,
      );

      // Dibujar estela de la partícula
      final trailPaint = Paint()
        ..color = particle.color.withOpacity(0.3 * glowIntensity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final trailPath = Path();
      trailPath.moveTo(
        particle.position.dx,
        particle.position.dy,
      );

      // Crear estela con curva Bezier
      final controlPoint1 = Offset(
        particle.position.dx - particle.velocity.dx * 2,
        particle.position.dy - particle.velocity.dy * 2,
      );
      final controlPoint2 = Offset(
        particle.position.dx - particle.velocity.dx * 4,
        particle.position.dy - particle.velocity.dy * 4,
      );
      final endPoint = Offset(
        particle.position.dx - particle.velocity.dx * 6,
        particle.position.dy - particle.velocity.dy * 6,
      );

      trailPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint.dx,
        endPoint.dy,
      );

      canvas.drawPath(trailPath, trailPaint);

      // Efecto de brillo adicional
      if (random.nextDouble() < 0.1) {
        canvas.drawCircle(
          particle.position,
          particle.size * 1.5 * particle.pulseValue,
          Paint()
            ..color = particle.color.withOpacity(0.3 * glowIntensity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  late Offset position;
  late Offset velocity;
  late double size;
  late Color color;
  late double baseSpeed;
  late double pulseValue;
  final Random random;

  _Particle(this.random) {
    _initialize();
  }

  void _initialize() {
    // Velocidad y tamaño aleatorios
    baseSpeed = random.nextDouble() * 2 + 0.5;
    size = random.nextDouble() * 3 + 1;

    // Color aleatorio en tonos azules y cian
    color = Color.lerp(
      kPrimaryColor,
      Colors.cyan,
      random.nextDouble(),
    )!
        .withOpacity(0.8);

    // Posición inicial aleatoria
    position = Offset(
      random.nextDouble() * 1000,
      random.nextDouble() * 1000,
    );

    // Velocidad inicial aleatoria
    final angle = random.nextDouble() * 2 * pi;
    velocity = Offset(
      cos(angle) * baseSpeed,
      sin(angle) * baseSpeed,
    );
  }

  void update(double time, Size bounds) {
    // Actualizar posición
    position += velocity;

    // Efecto de pulso
    pulseValue = 0.8 + sin(time * 2) * 0.2;

    // Aplicar fuerzas adicionales
    final noiseOffset = _perlinNoise(time, position);
    velocity += noiseOffset;
    velocity = velocity.scale(0.98, 0.98); // Fricción

    // Mantener partículas dentro de los límites
    if (position.dx < 0) position = Offset(bounds.width, position.dy);
    if (position.dx > bounds.width) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, bounds.height);
    if (position.dy > bounds.height) position = Offset(position.dx, 0);
  }

  Offset _perlinNoise(double time, Offset position) {
    // Simulación simple de ruido Perlin
    final dx = sin(position.dx * 0.01 + time) * 0.05;
    final dy = cos(position.dy * 0.01 + time) * 0.05;
    return Offset(dx, dy);
  }
}

class _WavePainter extends CustomPainter {
  final BackgroundController controller;
  final List<Color> waveColors = [
    kPrimaryColor.withOpacity(0.2),
    kPrimaryColor.withOpacity(0.15),
    kSecondaryColor.withOpacity(0.1),
  ];

  _WavePainter({
    required this.controller,
  }) : super(
            repaint: Listenable.merge([
          controller.waveController,
          controller.glowController,
        ]));

  @override
  void paint(Canvas canvas, Size size) {
    final baseWaveHeight = size.height * 0.5;
    final waveLength = size.width * 0.8;
    final waveAmplitude = size.height * 0.05;

    // Crear múltiples ondas con diferentes fases y amplitudes
    for (int waveIndex = 0; waveIndex < 3; waveIndex++) {
      final path = Path();
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..color = waveColors[waveIndex]
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      double phase =
          controller.waveController.value * 2 * pi + (waveIndex * pi / 4);
      double amplitudeModifier =
          1.0 + (0.3 * sin(controller.glowController.value * pi));

      path.moveTo(0, baseWaveHeight);

      // Dibujar la onda con Curvas de Bézier
      for (double x = 0; x <= size.width; x += size.width / 20) {
        final normalizedX = x / waveLength;
        final wavePhase = phase + (normalizedX * 2 * pi);

        // Calcular la posición Y usando múltiples funciones sinusoidales
        final y = baseWaveHeight +
            sin(wavePhase) * waveAmplitude * amplitudeModifier +
            sin(wavePhase * 2) * (waveAmplitude * 0.5) +
            sin(wavePhase * 0.5) * (waveAmplitude * 0.3);

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          // Usar curvas cuadráticas para suavizar la onda
          final prevX = x - size.width / 20;
          final prevY = baseWaveHeight +
              sin(phase + ((prevX / waveLength) * 2 * pi)) *
                  waveAmplitude *
                  amplitudeModifier +
              sin(phase * 2 + ((prevX / waveLength) * 2 * pi)) *
                  (waveAmplitude * 0.5) +
              sin(phase * 0.5 + ((prevX / waveLength) * 2 * pi)) *
                  (waveAmplitude * 0.3);

          final controlX = (x + prevX) / 2;
          final controlY = (y + prevY) / 2;

          path.quadraticBezierTo(controlX, controlY, x, y);
        }
      }

      // Añadir efectos de brillo
      final gradientPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            waveColors[waveIndex]
                .withOpacity(0.5 * controller.glowController.value),
            waveColors[waveIndex].withOpacity(0.1),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      // Dibujar la onda con efecto de brillo
      canvas.drawPath(path, paint);

      // Añadir puntos brillantes en los picos de la onda
      final pointPaint = Paint()
        ..color = waveColors[waveIndex]
            .withOpacity(0.8 * controller.glowController.value)
        ..style = PaintingStyle.fill;

      for (double x = 0; x <= size.width; x += size.width / 10) {
        final normalizedX = x / waveLength;
        final wavePhase = phase + (normalizedX * 2 * pi);
        final y =
            baseWaveHeight + sin(wavePhase) * waveAmplitude * amplitudeModifier;

        if (sin(wavePhase).abs() > 0.8) {
          // Solo dibujar en los picos
          canvas.drawCircle(
            Offset(x, y),
            2.0 * controller.glowController.value,
            pointPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
