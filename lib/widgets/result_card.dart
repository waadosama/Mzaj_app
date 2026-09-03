import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import 'add_playlist_dialog.dart';
import 'neo_card.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.song,
    required this.index,
    required this.onTap,
  });

  final Song song;
  final int index;
  final VoidCallback onTap;

  static const _cardColors = [
    MzajColors.white,
    MzajColors.mintBlue,
    MzajColors.lavender,
    MzajColors.sky,
  ];

  void _showAddToPlaylistDialog(BuildContext context) {
    final playlistProvider = context.read<PlaylistProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add to Playlist'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (playlistProvider.playlists.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        'No playlists yet. Create one first!',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          showDialog(
                            context: context,
                            builder: (ctx) => const AddPlaylistDialog(),
                          ).then((_) {
                            context.read<PlaylistProvider>().loadPlaylists();
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create Playlist'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MzajColors.pink,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...playlistProvider.playlists.map((playlist) {
                  return ListTile(
                    title: Text(playlist.name),
                    subtitle: Text('${playlist.songCount} songs'),
                    onTap: () async {
                      await playlistProvider.addSongToPlaylist(
                        playlist.id!,
                        song,
                      );
                      if (!ctx.mounted) return;
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${song.title} added to ${playlist.name}',
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _cardColors[index % _cardColors.length];
    final isPlaying = context.select<PlayerProvider, bool>(
      (player) => player.isCurrentSong(song) && player.isPlaying,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeoCard(
        color: cardColor,
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Row(
          children: [
            ResultCoverArt(song: song),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.album,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: MzajColors.black.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.playlist_add, color: MzajColors.pink),
                  onPressed: () => _showAddToPlaylistDialog(context),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResultCoverArt extends StatelessWidget {
  const ResultCoverArt({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: NeoStyle.card(
        color: MzajColors.black,
        radius: 16,
        shadow: false,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: song.artworkUrl != null
            ? CachedNetworkImage(
                imageUrl: song.highResArtwork,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholder(),
                errorWidget: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 72,
      height: 72,
      color: MzajColors.softPink,
      child: const Icon(Icons.music_note, color: MzajColors.black),
    );
  }
}
