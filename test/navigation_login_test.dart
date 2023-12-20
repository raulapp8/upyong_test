
import 'package:flutter_test/flutter_test.dart';
import 'package:upyong_test/main.dart';


void main() {
  testWidgets('navigate to second page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp()); // MyApp 是你的應用程序入口

    //expect(find.text(''), findsOneWidget);

    // Tap on the button to navigate to the second page
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify that the second page is displayed
    expect(find.text('Second Page'), findsOneWidget);
    //expect(find.text('1'), findsNothing);
  });
}