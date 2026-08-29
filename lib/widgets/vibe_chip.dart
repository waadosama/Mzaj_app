import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class VibeChip extends StatelessWidget {
  const VibeChip({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: NeoStyle.pill(
          color: isSelected ? MzajColors.navy : MzajColors.white,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isSelected ? MzajColors.white : MzajColors.navy,
              ),
        ),
      ),
    );
  }
}
