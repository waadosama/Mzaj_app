import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'neo_card.dart';

class NoSongView extends StatelessWidget {
  const NoSongView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: NeoCard(
          color: MzajColors.white,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.music_off_rounded, size: 48),
              const SizedBox(height: 12),
              Text(
                'No song is playing',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Pick a track from the results list to open the player.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
