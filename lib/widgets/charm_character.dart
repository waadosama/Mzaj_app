import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum CharmMood { happy, sleepy, calm }

/// Simple geometric mascot: rounded body, stick limbs, kawaii face.
class CharmCharacter extends StatelessWidget {
  const CharmCharacter({
    super.key,
    this.size = 140,
    this.color = MzajColors.lime,
    this.shape = BoxShape.rectangle,
    this.mood = CharmMood.happy,
    this.showHeadphones = false,
    this.showLegs = true,
  });

  final double size;
  final Color color;
  final BoxShape shape;
  final CharmMood mood;
  final bool showHeadphones;
  final bool showLegs;

  @override
  Widget build(BuildContext context) {
    final body = switch (shape) {
      BoxShape.circle => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: _face(size),
        ),
      BoxShape.rectangle => Container(
          width: size * 0.82,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(size * 0.22),
          ),
          child: _face(size),
        ),
    };

    return SizedBox(
      width: size * 1.35,
      height: size * (showLegs ? 1.35 : 1.12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showHeadphones)
            Positioned(
              top: 0,
              child: CustomPaint(
                size: Size(size * 0.92, size * 0.28),
                painter: _HeadphonePainter(),
              ),
            ),
          Positioned(
            left: 4,
            top: size * 0.42,
            child: _arm(flip: true),
          ),
          Positioned(
            right: 4,
            top: size * 0.42,
            child: _arm(flip: false),
          ),
          body,
          if (showLegs) ...[
            Positioned(left: size * 0.38, bottom: 0, child: _leg()),
            Positioned(right: size * 0.38, bottom: 0, child: _leg()),
          ],
        ],
      ),
    );
  }

  Widget _face(double s) {
    final closed = mood != CharmMood.happy;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _eye(closed: closed),
              SizedBox(width: s * 0.18),
              _eye(closed: closed),
            ],
          ),
          SizedBox(height: s * 0.08),
          if (mood == CharmMood.sleepy)
            Text(
              'Zzz',
              style: TextStyle(
                fontSize: s * 0.12,
                fontWeight: FontWeight.w800,
                color: MzajColors.navy.withValues(alpha: 0.55),
              ),
            )
          else
            CustomPaint(
              size: Size(s * 0.22, s * 0.1),
              painter: _SmilePainter(),
            ),
        ],
      ),
    );
  }

  Widget _eye({required bool closed}) {
    if (closed) {
      return Container(
        width: 14,
        height: 3,
        decoration: BoxDecoration(
          color: MzajColors.black,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(color: MzajColors.black, shape: BoxShape.circle),
    );
  }

  Widget _arm({required bool flip}) {
    return Transform.rotate(
      angle: flip ? -0.55 : 0.55,
      child: Container(
        width: 3,
        height: 28,
        color: MzajColors.black,
      ),
    );
  }

  Widget _leg() {
    return Container(
      width: 3,
      height: 22,
      color: MzajColors.black,
    );
  }
}

class CharmSemiCircle extends StatelessWidget {
  const CharmSemiCircle({super.key, this.size = 88, this.color = MzajColors.pink});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.78,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(left: 8, bottom: 22, child: _limb(-0.7)),
          Positioned(right: 8, bottom: 22, child: _limb(0.7)),
          ClipPath(
            clipper: _SemiClipper(),
            child: Container(
              width: size,
              height: size * 0.62,
              color: color,
              child: const Padding(
                padding: EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Dot(),
                    SizedBox(width: 16),
                    _Dot(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _limb(double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(width: 3, height: 22, color: MzajColors.black),
    );
  }
}

class CharmHexagon extends StatelessWidget {
  const CharmHexagon({super.key, this.size = 86, this.color = MzajColors.lime});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HexPainter(color),
      child: SizedBox(
        width: size,
        height: size,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SleepDash(),
                SizedBox(width: 16),
                _SleepDash(),
              ],
            ),
            SizedBox(height: 8),
            _Smile(),
          ],
        ),
      ),
    );
  }
}

class SpeechBubble extends StatelessWidget {
  const SpeechBubble({
    super.key,
    required this.label,
    required this.color,
    this.rotation = -0.12,
  });

  final String label;
  final Color color;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: MzajColors.navy,
                fontSize: 16,
              ),
        ),
      ),
    );
  }
}

class StarburstBubble extends StatelessWidget {
  const StarburstBubble({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarPainter(),
      child: SizedBox(
        width: 92,
        height: 92,
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: MzajColors.navy,
                  fontSize: 14,
                ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(color: MzajColors.black, shape: BoxShape.circle),
    );
  }
}

class _SleepDash extends StatelessWidget {
  const _SleepDash();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 3,
      decoration: BoxDecoration(
        color: MzajColors.black,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _Smile extends StatelessWidget {
  const _Smile();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(18, 8), painter: _SmilePainter());
  }
}

class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MzajColors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Offset.zero & size, 0.15, math.pi - 0.3, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeadphonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MzajColors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromLTWH(0, size.height * 0.15, size.width, size.height * 1.6),
      math.pi,
      math.pi,
      false,
      paint,
    );
    canvas.drawCircle(Offset(8, size.height * 0.72), 7, Paint()..color = MzajColors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SemiClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, size.height)
      ..arcToPoint(
        Offset(size.width, size.height),
        radius: Radius.circular(size.width / 2),
        clockwise: true,
      )
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _HexPainter extends CustomPainter {
  _HexPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    for (var i = 0; i < 6; i++) {
      final angle = -math.pi / 2 + i * math.pi / 3;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outer = size.width / 2;
    final inner = size.width / 3.1;
    const points = 10;
    for (var i = 0; i < points; i++) {
      final r = i.isEven ? outer : inner;
      final angle = -math.pi / 2 + i * math.pi / (points / 2);
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = MzajColors.yellow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
