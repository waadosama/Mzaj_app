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
        _ControlCircle(
          icon: Icons.shuffle_rounded,
          size: 24,
          isPlaying: player.isPlaying,
        ),
        _ControlCircle(
          icon: Icons.skip_previous_rounded,
          size: 34,
          isPlaying: player.isPlaying,
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.92, end: player.isPlaying ? 1.0 : 0.96),
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTap: player.toggleCurrent,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 420),
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: player.isPlaying
                        ? MzajColors.lime
                        : MzajColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: player.isPlaying
                          ? MzajColors.lime.withValues(alpha: 0.8)
                          : MzajColors.white.withValues(alpha: 0.7),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: player.isPlaying
                            ? MzajColors.lime.withValues(alpha: 0.3)
                            : MzajColors.navy.withValues(alpha: 0.24),
                        blurRadius: player.isPlaying ? 26 : 18,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      key: ValueKey<bool>(player.isPlaying),
                      player.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: MzajColors.navy,
                      size: 52,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        _ControlCircle(
          icon: Icons.skip_next_rounded,
          size: 34,
          isPlaying: player.isPlaying,
        ),
        _ControlCircle(
          icon: Icons.repeat_rounded,
          size: 24,
          isPlaying: player.isPlaying,
        ),
      ],
    );
  }
}

class _ControlCircle extends StatelessWidget {
  const _ControlCircle({
    required this.icon,
    required this.size,
    this.isPlaying = false,
  });

  final IconData icon;
  final double size;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isPlaying
            ? MzajColors.white.withValues(alpha: 0.58)
            : MzajColors.white.withValues(alpha: 0.4),
        shape: BoxShape.circle,
        border: Border.all(
          color: isPlaying
              ? MzajColors.lime.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Icon(
        icon,
        color: isPlaying ? MzajColors.lime : MzajColors.navy,
        size: size,
      ),
    );
  }
}
