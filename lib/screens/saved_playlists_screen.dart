import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/playlist.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/add_playlist_dialog.dart';
import '../widgets/add_songs_dialog.dart';
import '../widgets/neo_card.dart';
import '../widgets/playlist_card.dart';
import 'playlist_detail_screen.dart';

class SavedPlaylistsScreen extends StatefulWidget {
  const SavedPlaylistsScreen({super.key});

  @override
  State<SavedPlaylistsScreen> createState() => _SavedPlaylistsScreenState();
}

class _SavedPlaylistsScreenState extends State<SavedPlaylistsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PlaylistProvider>().loadPlaylists());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showCreatePlaylistDialog() {
    showDialog(context: context, builder: (ctx) => const AddPlaylistDialog());
  }

  void _showAddSongsDialog(BuildContext context, Playlist playlist) {
    showDialog(
      context: context,
      builder: (ctx) => AddSongsDialog(playlist: playlist),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MzajColors.navy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: NeoIconButton(
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 72,
        title: const Text('My Playlists'),
        titleTextStyle: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: MzajColors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: NeoIconButton(
              icon: Icons.add_rounded,
              color: MzajColors.lime,
              onPressed: _showCreatePlaylistDialog,
            ),
          ),
        ],
      ),
      body: Consumer<PlaylistProvider>(
        builder: (ctx, playlistProvider, _) {
          if (playlistProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: MzajColors.pink),
            );
          }

          if (playlistProvider.playlists.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.queue_music_rounded,
                      size: 80,
                      color: MzajColors.lime,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No playlists yet',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: MzajColors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first playlist to get started',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: MzajColors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    NeoButton(
                      label: 'Create Playlist',
                      color: MzajColors.lime,
                      textColor: MzajColors.navy,
                      icon: Icons.add_rounded,
                      onPressed: _showCreatePlaylistDialog,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            itemCount: playlistProvider.playlists.length,
            itemBuilder: (ctx, index) {
              final playlist = playlistProvider.playlists[index];
              return PlaylistCard(
                playlist: playlist,
                onDelete: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Playlist?'),
                      content: Text(
                        'Are you sure you want to delete "${playlist.name}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && mounted) {
                    await context.read<PlaylistProvider>().deletePlaylist(
                      playlist.id!,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Playlist deleted')),
                      );
                    }
                  }
                },
                onAddSongs: () => _showAddSongsDialog(context, playlist),
                onTap: () async {
                  await context.read<PlaylistProvider>().loadPlaylistWithSongs(
                    playlist.id!,
                  );
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PlaylistDetailScreen(playlist: playlist),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
