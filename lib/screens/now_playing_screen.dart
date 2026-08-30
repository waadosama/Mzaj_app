import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/neo_card.dart';
import '../widgets/equalizer.dart';
import '../widgets/no_song_view.dart';
import '../widgets/now_playing_header.dart';
import '../widgets/progress_panel.dart';
import '../widgets/song_details.dart';
import '../widgets/transport_controls.dart';
import '../widgets/vinyl_hero.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _spinController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;

    if (player.isPlaying) {
      _spinController.repeat();
    } else {
      _spinController.stop();
    }

    return Scaffold(
      backgroundColor: MzajColors.navy,
      appBar: AppBar(
        foregroundColor: MzajColors.white,
        title: const Text('Now playing'),
        titleTextStyle: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: MzajColors.white),
        leading: NeoIconButton(
          icon: Icons.keyboard_arrow_down_rounded,
          color: MzajColors.mintBlue,
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 72,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: NeoIconButton(
              icon: Icons.more_horiz_rounded,
              color: MzajColors.mintBlue,
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: MzajColors.sky,
          borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        ),
        child: SafeArea(
          top: false,
          child: song == null
              ? const NoSongView()
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final artSize = math.min(constraints.maxWidth - 52, 350.0);
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 24,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            NowPlayingHeader(isPlaying: player.isPlaying),
                            const SizedBox(height: 18),
                            VinylHero(
                              song: song,
                              size: artSize,
                              spinController: _spinController,
                              pulseController: _pulseController,
                              isPlaying: player.isPlaying,
                            ),
                            const SizedBox(height: 28),
                            SongDetails(song: song),
                            const SizedBox(height: 18),
                            ProgressPanel(song: song),
                            const SizedBox(height: 24),
                            TransportControls(player: player),
                            const SizedBox(height: 22),
                            Equalizer(
                              animation: _pulseController,
                              isPlaying: player.isPlaying,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
