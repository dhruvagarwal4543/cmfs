import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cfms/auth/auth_service.dart';
import 'package:cfms/screens/auth_gate.dart';

/// Overrides authStateChanges only, so this never touches a real Firebase
/// app — AuthService's other Firebase access stays lazy and unused here.
class _SignedOutAuthService extends AuthService {
  @override
  Stream<User?> get authStateChanges => Stream.value(null);
}

void main() {
  testWidgets('shows the Login screen when signed out', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: AuthGate(authService: _SignedOutAuthService())),
    );
    await tester.pump();

    expect(find.text('Course File'), findsOneWidget);
    expect(find.text('Faculty'), findsOneWidget);
    expect(find.text('Administrator'), findsOneWidget);
  });
}
