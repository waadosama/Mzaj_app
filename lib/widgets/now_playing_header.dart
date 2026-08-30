import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NowPlayingHeader extends StatelessWidget {
  const NowPlayingHeader({super.key, required this.isPlaying});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isPlaying
                 ? [
                     MzajColors.lime,
                     MzajColors.lime.withValues(alpha: 0.85),
                   ]
                 : [
                     MzajColors.sky.withValues(alpha: 0.3),
                     MzajColors.mintBlue.withValues(alpha: 0.2),
                   ],
            ),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isPlaying
                 ? MzajColors.lime.withValues(alpha: 0.8)
                 : MzajColors.sky.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isPlaying
                   ? MzajColors.lime.withValues(alpha: 0.25)
                   : MzajColors.sky.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPlaying
                   ? Icons.graphic_eq_rounded
                   : Icons.pause_circle_outline_rounded,
                size: 18,
                color: isPlaying ? MzajColors.navy : MzajColors.navy,
              ),
              const SizedBox(width: 8),
              Text(
                isPlaying ? 'PLAYING TRACK' : 'TRACK PAUSED',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                 color: isPlaying ? MzajColors.navy : MzajColors.navy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
