// Placeholder — the real Faculty Dashboard is built in Phase 4.
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../theme/theme.dart';
import '../widgets/glass_button.dart';

class FacultyHomeScreen extends StatelessWidget {
  const FacultyHomeScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CfmsColors.bg0,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Faculty',
                  style: TextStyle(fontSize: 22, color: CfmsColors.label),
                ),
                const SizedBox(height: 24),
                GlassButton(
                  label: 'Log out',
                  variant: GlassButtonVariant.secondary,
                  onPressed: authService.signOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
