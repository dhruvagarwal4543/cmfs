import 'package:flutter_test/flutter_test.dart';

import 'package:cfms/main.dart';

void main() {
  testWidgets('shows Firebase init status', (WidgetTester tester) async {
    await tester.pumpWidget(const CfmsApp());
    await tester.pump();

    expect(find.textContaining('Firebase'), findsOneWidget);
  });
}
