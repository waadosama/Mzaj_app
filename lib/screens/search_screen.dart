import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/charm_character.dart';
import '../widgets/neo_card.dart';
import 'results_screen.dart';
import 'saved_playlists_screen.dart';

/// Screen 2 — dedicated music and mood search.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  static const _moods = [
    (Icons.spa_rounded, 'Chill', 'chill lofi', MzajColors.mintBlue),
    (Icons.water_drop_rounded, 'Sad', 'sad acoustic', MzajColors.lavender),
    (Icons.bolt_rounded, 'Energetic', 'energetic pop', MzajColors.yellow),
    (
      Icons.favorite_rounded,
      'Romantic',
      'romantic love songs',
      MzajColors.pink,
    ),
    (Icons.psychology_rounded, 'Focus', 'focus instrumental', MzajColors.lime),
    (Icons.celebration_rounded, 'Party', 'party hits', MzajColors.softPink),
  ];
  String? _selectedMood;
  bool _isGenerating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String value) async {
    final query = value.trim();
    if (query.isEmpty) return;
    unawaited(context.read<SearchProvider>().search(query));
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const ResultsScreen()),
    );
  }

  Future<void> _generateMoodPlaylist(String mood, String query) async {
    if (_isGenerating) return;

    setState(() {
      _selectedMood = mood;
      _isGenerating = true;
      _controller.text = query;
    });

    final searchProvider = context.read<SearchProvider>();
    await searchProvider.search(query);
    if (!mounted) return;

    if (searchProvider.results.isEmpty) {
      setState(() => _isGenerating = false);
      return;
    }

    final playlist = await context.read<PlaylistProvider>().createMoodPlaylist(
      mood,
      searchProvider.results.take(12).toList(),
    );
    if (!mounted) return;

    setState(() => _isGenerating = false);
    if (playlist == null) return;

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const ResultsScreen()),
    );
  }

  Widget _buildMoodCard(
    BuildContext context,
    (IconData, String, String, Color) mood,
  ) {
    final isSelected = _selectedMood == mood.$2;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isGenerating
            ? null
            : () => _generateMoodPlaylist(mood.$2, mood.$3),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected ? MzajColors.white : mood.$4,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? MzajColors.navy : Colors.transparent,
              width: 3,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(mood.$1, color: MzajColors.navy, size: 19),
                  const SizedBox(height: 3),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      mood.$2,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: MzajColors.navy,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              if (isSelected)
                const Positioned(
                  right: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.check_rounded,
                    color: MzajColors.navy,
                    size: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: MzajColors.navy,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: NeoIconButton(
        icon: Icons.arrow_back_rounded,
        color: MzajColors.lime,
        onPressed: () => Navigator.pop(context),
      ),
      leadingWidth: 76,
      title: const Text('Find your vibe'),
      titleTextStyle: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(color: MzajColors.white),
      iconTheme: const IconThemeData(color: MzajColors.white),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: const Icon(Icons.library_music_rounded),
            tooltip: 'My Playlists',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const SavedPlaylistsScreen(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: NeoStyle.pill(color: MzajColors.lime),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.radio_button_checked_rounded,
                  size: 14,
                  color: MzajColors.navy,
                ),
                const SizedBox(width: 6),
                Text(
                  'Live',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: MzajColors.navy),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    body: SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: NeoStyle.pill(
                          color: MzajColors.white.withValues(alpha: 0.14),
                        ),
                        child: Text(
                          'Mood match',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: MzajColors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Which vibe would\nyou pick?',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              fontSize: 31,
                              color: MzajColors.white,
                              height: 1.08,
                            ),
                      ),
                    ],
                  ),
                ),
                const CharmSemiCircle(size: 110, color: MzajColors.softPink),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    MzajColors.white.withValues(alpha: 0.96),
                    MzajColors.sky.withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: MzajColors.black.withValues(alpha: 0.12),
                    offset: const Offset(0, 14),
                    blurRadius: 22,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search a song, artist, or describe the feeling.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: MzajColors.navy.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _search,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: MzajColors.white,
                      hintText: 'e.g. rainy-day jazz',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: MzajColors.navy,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(999),
                        borderSide: const BorderSide(
                          color: MzajColors.navy,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'CHOOSE YOUR MOOD',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: MzajColors.lime),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MzajColors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: MzajColors.white.withValues(alpha: 0.12),
                ),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.86,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final mood in _moods) _buildMoodCard(context, mood),
                ],
              ),
            ),
            const SizedBox(height: 26),
            NeoButton(
              label: _isGenerating ? 'Making your playlist...' : 'Search music',
              expanded: true,
              color: MzajColors.lime,
              textColor: MzajColors.navy,
              icon: Icons.search_rounded,
              onPressed: _isGenerating ? null : () => _search(_controller.text),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}
