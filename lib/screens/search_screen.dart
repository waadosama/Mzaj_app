import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/charm_character.dart';
import '../widgets/neo_card.dart';
import '../widgets/vibe_chip.dart';
import 'results_screen.dart';

/// Screen 2 — dedicated music and mood search.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  static const _vibes = ['chill lofi', 'summer hits', 'workout energy', 'indie dream pop', '90s r&b', 'late night jazz'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String value) async {
    final query = value.trim();
    if (query.isEmpty) return;
    unawaited(context.read<SearchProvider>().search(query));
    await Navigator.push<void>(context, MaterialPageRoute<void>(builder: (_) => const ResultsScreen()));
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
          titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: MzajColors.white),
          iconTheme: const IconThemeData(color: MzajColors.white),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: NeoStyle.pill(color: MzajColors.lime),
                child: Text(
                  'Live',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: MzajColors.navy),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: NeoStyle.pill(color: MzajColors.white.withValues(alpha: 0.14)),
                            child: Text(
                              'Mood match',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: MzajColors.white),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'What are you\nin the mood for?',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
                      colors: [MzajColors.white.withValues(alpha: 0.96), MzajColors.sky.withValues(alpha: 0.9)],
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
                          prefixIcon: const Icon(Icons.search_rounded, color: MzajColors.navy),
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
                            borderSide: const BorderSide(color: MzajColors.navy, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('POPULAR VIBES', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: MzajColors.lime)),
                    Text('6 picks', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: MzajColors.white.withValues(alpha: 0.7))),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MzajColors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: MzajColors.white.withValues(alpha: 0.12)),
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 12,
                    children: _vibes
                        .map((vibe) => VibeChip(
                              label: vibe,
                              isSelected: false,
                              onTap: () {
                                _controller.text = vibe;
                                _search(vibe);
                              },
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 26),
                NeoButton(
                  label: 'Search music',
                  expanded: true,
                  color: MzajColors.lime,
                  textColor: MzajColors.navy,
                  icon: Icons.search_rounded,
                  onPressed: () => _search(_controller.text),
                ),
              ],
            ),
          ),
        ),
      );
}
