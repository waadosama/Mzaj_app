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

  test('player pause is safe when no song is active', () async {
    final player = PlayerProvider(AudioService());

    await player.pause();

    expect(player.currentSong, isNull);
  });
}
