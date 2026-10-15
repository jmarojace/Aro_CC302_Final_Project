import 'package:flutter_test/flutter_test.dart';

import 'package:mini_store/main.dart';

void main() {
  testWidgets('shows the sign-in screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniStoreApp());

    expect(find.text('Mini Store'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
