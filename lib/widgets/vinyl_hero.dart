import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/song.dart';
import '../theme/app_theme.dart';
import 'artwork_placeholder.dart';

class VinylHero extends StatelessWidget {
  const VinylHero({
    super.key,
    required this.song,
    required this.size,
    required this.spinController,
    required this.pulseController,
    required this.isPlaying,
  });

  final Song song;
  final double size;
  final AnimationController spinController;
  final AnimationController pulseController;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final scale = 1 + (pulseController.value * 0.06);
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: size * 0.92,
              height: size * 0.92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MzajColors.mintBlue.withValues(alpha: 0.42),
                boxShadow: [
                  BoxShadow(
                    color: MzajColors.navy.withValues(alpha: 0.18),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          RotationTransition(
            turns: spinController,
            child: CustomPaint(
              size: Size.square(size * 0.78),
              painter: _VinylPainter(),
              child: SizedBox.square(
                dimension: size * 0.78,
                child: Center(
                  child: ClipOval(
                    child: song.artworkUrl == null
                        ? ArtworkPlaceholder(size: size * 0.44)
                        : CachedNetworkImage(
                            imageUrl: song.highResArtwork,
                            width: size * 0.44,
                            height: size * 0.44,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                ArtworkPlaceholder(size: size * 0.44),
                            errorWidget: (_, __, ___) =>
                                ArtworkPlaceholder(size: size * 0.44),
                          ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: size * 0.17,
            right: size * 0.12,
            child: AnimatedRotation(
              turns: isPlaying ? 0.02 : -0.05,
              duration: const Duration(milliseconds: 420),
              child: const Icon(
                Icons.album_rounded,
                color: MzajColors.mintBlue,
                size: 46,
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 10,
            child: Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: MzajColors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.graphic_eq_rounded,
                color: MzajColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VinylPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final paint = Paint()..color = MzajColors.black;
    canvas.drawCircle(center, radius, paint);

    for (var i = 1; i <= 5; i++) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = MzajColors.white.withValues(alpha: 0.05 + i * 0.018);
      canvas.drawCircle(center, radius * (0.35 + i * 0.11), paint);
    }

    paint
      ..style = PaintingStyle.fill
      ..color = MzajColors.white.withValues(alpha: 0.08);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.88),
      -0.8,
      1.2,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
