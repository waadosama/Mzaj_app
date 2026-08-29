import 'package:flutter_test/flutter_test.dart';
import 'package:mzaj/app.dart';

void main() {
  testWidgets('Mzaj welcome screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MzajApp());

    expect(find.text('Mzaj'), findsOneWidget);
    expect(find.text('A soundtrack\nfor every mood.'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });
}
