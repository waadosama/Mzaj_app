import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ArtworkPlaceholder extends StatelessWidget {
  const ArtworkPlaceholder({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: MzajColors.mintBlue,
      child: const Icon(Icons.music_note_rounded, color: MzajColors.navy),
    );
  }
}
