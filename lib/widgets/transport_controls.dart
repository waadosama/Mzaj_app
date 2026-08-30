import 'package:flutter/material.dart';

import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class TransportControls extends StatelessWidget {
  const TransportControls({super.key, required this.player});

  final PlayerProvider player;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.shuffle_rounded, color: MzajColors.navy, size: 30),
        const Icon(
          Icons.skip_previous_rounded,
          color: MzajColors.navy,
          size: 44,
        ),
        GestureDetector(
          onTap: player.toggleCurrent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: player.isPlaying ? MzajColors.mintBlue : MzajColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: MzajColors.black.withValues(alpha: 0.4)),
            ),
            child: Icon(
              player.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: MzajColors.black.withValues(alpha: 0.65),
              size: 52,
            ),
          ),
        ),
        const Icon(Icons.skip_next_rounded, color: MzajColors.navy, size: 44),
        const Icon(Icons.repeat_rounded, color: MzajColors.navy, size: 30),
      ],
    );
  }
}
