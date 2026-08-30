import 'package:flutter/material.dart';

import '../models/song.dart';
import '../theme/app_theme.dart';

class SongDetails extends StatelessWidget {
  const SongDetails({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: MzajColors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: MzajColors.mintBlue),
        boxShadow: [
          BoxShadow(
            color: MzajColors.navy.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: MzajColors.navy,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: MzajColors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 28,
                    color: MzajColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: MzajColors.navy.withValues(alpha: 0.68),
                  ),
                ),
                Text(
                  song.album,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: MzajColors.black.withValues(alpha: 0.46),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
