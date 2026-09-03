import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/neo_card.dart';
import '../widgets/result_card.dart';
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

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isOpeningNowPlaying = false;

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

  Future<void> _openNowPlaying(BuildContext context, Song song) async {
    if (_isOpeningNowPlaying) return;
    _isOpeningNowPlaying = true;

    try {
      final player = context.read<PlayerProvider>();
      if (!player.isCurrentSong(song)) {
        await player.togglePreview(song);
      }
      if (!context.mounted) return;
      await Navigator.push<void>(context, _buildNowPlayingRoute());
    } finally {
      _isOpeningNowPlaying = false;
    }
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
              return ResultCard(
                song: song,
                index: index,
                onTap: () => _openNowPlaying(context, song),
              );
            },
          ),
        ),
      ],
    );
  }
}
