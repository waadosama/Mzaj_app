import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/neo_card.dart';
import '../widgets/state_views.dart';
import 'now_playing_screen.dart';

Route<void> _buildNowPlayingRoute() {
  return PageRouteBuilder<void>(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const NowPlayingScreen(),
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 420),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween<Offset>(
        begin: const Offset(0, 0.22),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      final fadeTween = Tween<double>(
        begin: 0.15,
        end: 1,
      ).chain(CurveTween(curve: Curves.easeOut));

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

    return Scaffold(
      backgroundColor: MzajColors.sky,
      appBar: AppBar(
        title: Text(search.lastQuery.isEmpty ? 'Results' : search.lastQuery),
        leading: NeoIconButton(
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 72,
      ),
      body: _buildBody(context, search),
    );
  }

  Widget _buildBody(BuildContext context, SearchProvider search) {
    if (search.status == SearchStatus.loading) {
      return const MzajStateView(type: MzajStateType.loading);
    }

    if (search.status == SearchStatus.error) {
      return MzajStateView(
        type: MzajStateType.error,
        message: search.errorMessage,
        actionLabel: 'Try again',
        onAction: () => search.search(search.lastQuery),
      );
    }

    if (search.results.isEmpty) {
      return MzajStateView(
        type: MzajStateType.empty,
        title: 'No tracks found',
        message: search.errorMessage ?? 'Try another vibe or artist name.',
        actionLabel: 'Go back',
        onAction: () => Navigator.pop(context),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Text(
            '${search.results.length} PREVIEWABLE TRACKS',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            itemCount: search.results.length,
            itemBuilder: (context, index) {
              final song = search.results[index];
              return _ResultCard(
                song: song,
                index: index,
                onTap: () async {
                  final player = context.read<PlayerProvider>();
                  if (!player.isCurrentSong(song)) {
                    await player.togglePreview(song);
                  }
                  if (!context.mounted) return;
                  await Navigator.push<void>(context, _buildNowPlayingRoute());
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
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

  @override
  Widget build(BuildContext context) {
    final cardColor = _cardColors[index % _cardColors.length];
    final player = context.watch<PlayerProvider>();
    final isCurrent = player.isCurrentSong(song);
    final isPlaying = isCurrent && player.isPlaying;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeoCard(
        color: cardColor,
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Row(
          children: [
            _CoverArt(song: song),
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
            Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
          ],
        ),
      ),
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({required this.song});

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
