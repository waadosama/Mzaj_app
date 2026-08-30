import 'package:flutter/material.dart';

import '../models/song.dart';
import '../theme/app_theme.dart';

class SongDetails extends StatelessWidget {
  const SongDetails({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.favorite_border_rounded, size: 34),
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
                  fontSize: 30,
                  color: MzajColors.black.withValues(alpha: 0.72),
                ),
              ),
              Text(
                song.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: MzajColors.black.withValues(alpha: 0.48),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
