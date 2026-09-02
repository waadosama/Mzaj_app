import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/charm_character.dart';
import '../widgets/neo_card.dart';
import 'search_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MzajColors.navy,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mzaj',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(fontSize: 28, color: MzajColors.white),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            const CharmCharacter(
                              size: 190,
                              color: MzajColors.lime,
                              showHeadphones: true,
                            ),
                            Positioned(
                              top: -28,
                              right: -6,
                              child: const StarburstBubble(label: 'hello!'),
                            ),
                            Positioned(
                              bottom: 12,
                              left: -16,
                              child: SpeechBubble(
                                label: 'let\'s listen',
                                color: MzajColors.mintBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'A soundtrack\nfor every mood.',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(color: MzajColors.lime, fontSize: 42),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Tell us what you feel and discover songs that fit your moment.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: MzajColors.white.withValues(alpha: 0.82),
                        ),
                      ),
                      const SizedBox(height: 40),
                      NeoButton(
                        label: 'Get started',
                        expanded: true,
                        color: MzajColors.lime,
                        textColor: MzajColors.navy,
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const SearchScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Discover music your way',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: MzajColors.white.withValues(alpha: 0.62),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
