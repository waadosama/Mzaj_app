import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'neo_card.dart';

enum MzajStateType { loading, empty, error }

class MzajStateView extends StatelessWidget {
  const MzajStateView({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.backgroundColor = MzajColors.mintBlue,
  });

  final MzajStateType type;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final (icon, defaultTitle, defaultMessage) = switch (type) {
      MzajStateType.loading => (
          Icons.hourglass_top_rounded,
          'Finding vibes…',
          'Searching the catalog for previewable tracks.',
        ),
      MzajStateType.empty => (
          Icons.music_off_rounded,
          'Nothing here yet',
          'Try a different search or pick a vibe chip.',
        ),
      MzajStateType.error => (
          Icons.wifi_off_rounded,
          'Connection lost',
          'Check your network and try again.',
        ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: NeoCard(
          color: backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (type == MzajStateType.loading)
                const SizedBox(
                  width: 56,
                  height: 56,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: MzajColors.black,
                  ),
                )
              else
                Container(
                  width: 72,
                  height: 72,
                  decoration: NeoStyle.card(color: MzajColors.white, radius: 999, shadow: false),
                  child: Icon(icon, size: 36),
                ),
              const SizedBox(height: 20),
              Text(
                title ?? defaultTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                message ?? defaultMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 24),
                NeoButton(label: actionLabel!, onPressed: onAction),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
