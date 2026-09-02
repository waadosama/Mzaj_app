import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../theme/app_theme.dart';
import 'neo_card.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onDelete;
  final VoidCallback onAddSongs;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onDelete,
    required this.onAddSongs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(18, 16, 10, 16),
      color: MzajColors.white,
      onTap: onTap,
      child: Row(
        children: [
          const Icon(
            Icons.queue_music_rounded,
            color: MzajColors.navy,
            size: 34,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (playlist.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      playlist.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${playlist.songCount} ${playlist.songCount == 1 ? 'song' : 'songs'}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: MzajColors.navy.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz_rounded),
            onSelected: (value) {
              if (value == 'add_songs') {
                onAddSongs();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'add_songs',
                child: Text('Add songs'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
