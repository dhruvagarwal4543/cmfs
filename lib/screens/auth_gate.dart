// CLAUDE.md §6 Phase 2 — after any successful sign-in (email or Google),
// read users/{uid}.role and route accordingly. An authenticated user with
// no matching users/{uid} document is signed out and shown a clear message
// rather than left in limbo. This is the real access gate — the Faculty/
// Administrator tab on LoginScreen never factors into it.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../theme/theme.dart';
import 'admin_home_screen.dart';
import 'faculty_home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        final user = snapshot.data;
        if (user == null) {
          return LoginScreen(authService: authService);
        }

        return FutureBuilder<CfmsRole?>(
          // Keyed on uid so switching accounts re-fetches the role.
          key: ValueKey(user.uid),
          future: authService.fetchRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingScreen();
            }

            final role = roleSnapshot.data;
            if (role == null) {
              return _NotRegisteredScreen(authService: authService);
            }

            return switch (role) {
              CfmsRole.faculty => FacultyHomeScreen(authService: authService),
              CfmsRole.admin => AdminHomeScreen(authService: authService),
            };
          },
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CfmsColors.bg0,
      body: Center(
        child: CircularProgressIndicator(color: CfmsColors.brand),
      ),
    );
  }
}

class _NotRegisteredScreen extends StatefulWidget {
  const _NotRegisteredScreen({required this.authService});

  final AuthService authService;

  @override
  State<_NotRegisteredScreen> createState() => _NotRegisteredScreenState();
}

class _NotRegisteredScreenState extends State<_NotRegisteredScreen> {
  @override
  void initState() {
    super.initState();
    // Fire-and-forget: the AuthGate's StreamBuilder above will react once
    // this completes and route back to LoginScreen on its own.
    widget.authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CfmsColors.bg0,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "This account isn't registered. Contact your administrator "
              'to get access.',
              textAlign: TextAlign.center,
              style: TextStyle(color: CfmsColors.label2, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
