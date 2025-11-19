import 'package:flutter_test/flutter_test.dart';
import 'package:demo/main.dart';

void main() {
  testWidgets('App loads UI correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check text field exists
    expect(find.byType(TextField), findsOneWidget);

    // Check button exists
    expect(find.text("<< Segment >>"), findsOneWidget);
  });
}
