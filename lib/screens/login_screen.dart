// Matches reference_screens/01-auth-login.html. The Faculty/Administrator
// segmented control is COSMETIC ONLY (CLAUDE.md §6 Phase 2) — it changes
// _subtitle text and nothing else. It is never read to decide routing or
// access; AuthGate routes purely off users/{uid}.role after sign-in.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../theme/theme.dart';
import '../widgets/cfms_text_field.dart';
import '../widgets/glass_button.dart';
import '../widgets/google_logo.dart';
import '../widgets/segmented_control.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const _subtitles = [
    'Sign in to manage your course files',
    'Sign in to the administration console',
  ];

  int _roleTab = 0;
  bool _emailSubmitting = false;
  bool _googleSubmitting = false;
  String? _error;

  bool get _busy => _emailSubmitting || _googleSubmitting;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmailSignIn() async {
    setState(() {
      _emailSubmitting = true;
      _error = null;
    });
    try {
      await widget.authService.signInWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      // AuthGate reacts to the resulting auth-state change and routes.
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _friendlyError(e));
    } finally {
      if (mounted) setState(() => _emailSubmitting = false);
    }
  }

  Future<void> _submitGoogleSignIn() async {
    setState(() {
      _googleSubmitting = true;
      _error = null;
    });
    try {
      await widget.authService.signInWithGoogle();
    } on BmuDomainViolation {
      setState(
        () =>
            _error = 'Please sign in with your BMU email (@bmu.edu.in).',
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _friendlyError(e));
    } finally {
      if (mounted) setState(() => _googleSubmitting = false);
    }
  }

  String _friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'Sign-in failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CfmsColors.bg0,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _AuthSticker(),
                const SizedBox(height: 16),
                const Text(
                  'Course File',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700, // CSS font-weight: 650
                    letterSpacing: -0.78,
                    color: CfmsColors.label,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _subtitles[_roleTab],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: CfmsColors.label2,
                  ),
                ),
                const SizedBox(height: 20),
                SegmentedControl(
                  labels: const ['Faculty', 'Administrator'],
                  selectedIndex: _roleTab,
                  onChanged: (i) => setState(() => _roleTab = i),
                ),
                const SizedBox(height: 16),
                CfmsTextFieldGroup(
                  fields: [
                    CfmsTextField(
                      icon: Icons.mail_outline,
                      controller: _emailController,
                      hint: 'you@bmu.edu.in',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                    ),
                    CfmsTextField(
                      icon: Icons.lock_outline,
                      controller: _passwordController,
                      hint: 'Password',
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submitEmailSignIn(),
                      autofillHints: const [AutofillHints.password],
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CfmsColors.error,
                      fontSize: 12.5,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                GlassButton(
                  label: 'Sign in',
                  loading: _emailSubmitting,
                  onPressed: _busy ? null : _submitEmailSignIn,
                ),
                const _OrDivider(),
                GlassButton(
                  label: 'Continue with Google',
                  variant: GlassButtonVariant.secondary,
                  leading: const GoogleLogo(),
                  loading: _googleSubmitting,
                  onPressed: _busy ? null : _submitGoogleSignIn,
                ),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => ForgotPasswordScreen(
                              authService: widget.authService,
                            ),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: CfmsColors.brandHi,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: const [
          Expanded(child: ColoredBox(color: CfmsColors.hairline, child: SizedBox(height: 0.5))),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'OR',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.88,
                color: CfmsColors.label3,
              ),
            ),
          ),
          Expanded(child: ColoredBox(color: CfmsColors.hairline, child: SizedBox(height: 0.5))),
        ],
      ),
    );
  }
}

/// Simplified stand-in for the reference's hand-drawn folder+checkmark SVG
/// sticker (CLAUDE.md §3 illustrations) — a full pixel-accurate redraw is a
/// separate illustration-asset task, not core to Phase 2's auth wiring.
class _AuthSticker extends StatelessWidget {
  const _AuthSticker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CfmsColors.brandHi, CfmsColors.brand],
        ),
        boxShadow: [
          BoxShadow(
            color: CfmsColors.brand.withValues(alpha: 0.24),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: const Icon(Icons.folder_outlined, color: Colors.white, size: 40),
    );
  }
}
