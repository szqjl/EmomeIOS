import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants.dart';

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double life;
  double maxLife;

  Particle({
    double? x,
    double? y,
  })  : x = x ?? Random().nextDouble() * 200 + 100,
        y = y ?? Random().nextDouble() * 200 + 100,
        vx = (Random().nextDouble() - 0.5) * 300,
        vy = (Random().nextDouble() - 0.5) * 300,
        size = Random().nextDouble() * 4 + 4,
        life = 1.0,
        maxLife = 1.0 {
    // 随机颜色（红色系）
    final hue = Random().nextDouble() * 20 + 350; // 350-370度（红色范围）
    color = HSVColor.fromAHSV(1.0, hue, 0.8, 1.0).toColor();
  }

  void update(double dt) {
    x += vx * dt;
    y += vy * dt;
    life -= dt / 1.5; // 1.5秒生命周期
    if (life < 0) life = 0;
  }

  bool get isAlive => life > 0;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      if (!particle.isAlive) continue;

      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );

      // 涟漪效果
      if (particle.life > 0.8) {
        final ripplePaint = Paint()
          ..color = particle.color.withOpacity((1 - particle.life) * 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        
        final rippleRadius = particle.size * (1 - particle.life) * 5;
        canvas.drawCircle(
          Offset(particle.x, particle.y),
          rippleRadius,
          ripplePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
