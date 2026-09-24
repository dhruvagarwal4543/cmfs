import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth/auth_service.dart';
import 'firebase_options.dart';
import 'screens/auth_gate.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CfmsApp());
}

class CfmsApp extends StatelessWidget {
  const CfmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course File Manager',
      theme: CfmsTheme.dark,
      home: AuthGate(authService: AuthService()),
    );
  }
}
