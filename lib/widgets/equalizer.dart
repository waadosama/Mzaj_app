import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class Equalizer extends StatelessWidget {
  const Equalizer({
    super.key,
    required this.animation,
    required this.isPlaying,
  });

  final Animation<double> animation;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(18, (index) {
              final wave =
                  (math.sin((animation.value * math.pi * 2) + index) + 1) / 2;
              final height = isPlaying ? 7 + (wave * 21) : 7.0;
              return Container(
                width: 5,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isPlaying
                      ? (index.isEven ? MzajColors.lime : MzajColors.navy)
                      : (index.isEven
                          ? MzajColors.navy.withValues(alpha: 0.3)
                          : MzajColors.mintBlue.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
