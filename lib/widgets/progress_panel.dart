import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class ProgressPanel extends StatelessWidget {
  const ProgressPanel({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (context, durationSnapshot) {
        final duration =
            durationSnapshot.data ??
            Duration(milliseconds: song.durationMs ?? 30000);
        return StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            final totalMs = duration.inMilliseconds.clamp(1, 1 << 31);
            final progress = (position.inMilliseconds / totalMs).clamp(
              0.0,
              1.0,
            );

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MzajColors.navy.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: player.isPlaying
                      ? MzajColors.lime.withValues(alpha: 0.3)
                      : MzajColors.white.withValues(alpha: 0.36),
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: MzajColors.white.withValues(alpha: 0.65),
                      valueColor: AlwaysStoppedAnimation(
                        player.isPlaying ? MzajColors.lime : MzajColors.navy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: _timeStyle(context),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: _timeStyle(context),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  TextStyle? _timeStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
        color: MzajColors.navy.withValues(alpha: 0.76),
      );

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
