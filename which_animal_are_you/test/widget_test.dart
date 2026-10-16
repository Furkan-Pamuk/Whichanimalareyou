import 'package:flutter_test/flutter_test.dart';
import 'package:which_animal_are_you/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const WhichAnimalApp());
    expect(find.text('Discover Your Inner Wild!'), findsOneWidget);
  });
}
