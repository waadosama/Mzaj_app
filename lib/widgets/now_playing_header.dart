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
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: NeoStyle.pill(
            color: isPlaying ? MzajColors.mintBlue : MzajColors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPlaying
                    ? Icons.graphic_eq_rounded
                    : Icons.pause_circle_outline_rounded,
                size: 18,
                color: MzajColors.navy,
              ),
              const SizedBox(width: 8),
              Text(
                isPlaying ? 'PLAYING PREVIEW' : 'PREVIEW PAUSED',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: MzajColors.navy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
