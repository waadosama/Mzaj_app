import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/playlist.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/add_playlist_dialog.dart';
import '../widgets/add_songs_dialog.dart';
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
      appBar: AppBar(
        title: const Text('My Playlists'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Consumer<PlaylistProvider>(
        builder: (ctx, playlistProvider, _) {
          if (playlistProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: MzajColors.pink),
            );
          }

          if (playlistProvider.playlists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.playlist_play, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No playlists yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first playlist to get started',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showCreatePlaylistDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Create Playlist'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MzajColors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePlaylistDialog,
        backgroundColor: MzajColors.pink,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
