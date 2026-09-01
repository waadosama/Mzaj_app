import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/playlist.dart';
import '../providers/app_providers.dart';

class AddSongsDialog extends StatefulWidget {
  final Playlist playlist;

  const AddSongsDialog({super.key, required this.playlist});

  @override
  State<AddSongsDialog> createState() => _AddSongsDialogState();
}

class _AddSongsDialogState extends State<AddSongsDialog> {
  final searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isSearching = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add songs to ${widget.playlist.name}'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search songs or artists',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
              onChanged: (value) async {
                if (value.isEmpty) {
                  setState(() {
                    searchResults = [];
                  });
                  return;
                }

                setState(() => isSearching = true);

                try {
                  await context.read<SearchProvider>().search(value);
                  if (mounted) {
                    setState(() {
                      searchResults = context.read<SearchProvider>().results;
                      isSearching = false;
                    });
                  }
                } catch (e) {
                  if (mounted) {
                    setState(() => isSearching = false);
                  }
                }
              },
            ),
            const SizedBox(height: 12),
            if (searchResults.isNotEmpty)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final song = searchResults[index];
                    return ListTile(
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      onTap: () async {
                        await context
                            .read<PlaylistProvider>()
                            .addSongToPlaylist(widget.playlist.id!, song);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Added "${song.title}" to playlist',
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              )
            else if (searchController.text.isNotEmpty && !isSearching)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No songs found',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
