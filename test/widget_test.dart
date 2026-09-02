import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mzaj/app.dart';
import 'package:mzaj/providers/app_providers.dart';
import 'package:mzaj/services/audio_service.dart';

void main() {
  testWidgets('Mzaj welcome screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MzajApp());

    expect(find.text('Mzaj'), findsOneWidget);
    expect(find.text('A soundtrack\nfor every mood.'), findsOneWidget);
    expect(find.text('GET STARTED'), findsOneWidget);
  });

  testWidgets('library button opens the saved playlists screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MzajApp());

    await tester.tap(find.text('GET STARTED'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.library_music_rounded));
    await tester.pumpAndSettle();

    expect(find.text('My Playlists'), findsOneWidget);
  });

  test('player pause is safe when no song is active', () async {
    final player = PlayerProvider(AudioService());

    await player.pause();

    expect(player.currentSong, isNull);
  });
}
