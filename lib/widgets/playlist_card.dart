import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../theme/app_theme.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onDelete;
  final VoidCallback onAddSongs;
  final VoidCallback onTap;

  const PlaylistCard({
    required this.playlist,
    required this.onDelete,
    required this.onAddSongs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(
          Icons.playlist_play,
          color: MzajColors.pink,
          size: 32,
        ),
        title: Text(
          playlist.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (playlist.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  playlist.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${playlist.songCount} ${playlist.songCount == 1 ? 'song' : 'songs'}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
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
            const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
