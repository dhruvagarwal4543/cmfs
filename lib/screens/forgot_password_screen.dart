// Matches reference_screens/02-auth-forgot-password.html.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import '../theme/theme.dart';
import '../widgets/cfms_text_field.dart';
import '../widgets/glass_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _submitting = false;
  String? _error;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.authService.sendPasswordResetEmail(_emailController.text);
      if (mounted) setState(() => _sent = true);
    } on FirebaseAuthException catch (e) {
      setState(
        () =>
            _error =
                e.code == 'invalid-email'
                    ? 'Enter a valid email address.'
                    : 'Couldn\'t send the reset link. Please try again.',
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
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
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [CfmsColors.brandHi, CfmsColors.brand],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CfmsColors.brand.withValues(alpha: 0.24),
                        blurRadius: 24,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_clock_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reset Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.78,
                    color: CfmsColors.label,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Enter your registered email and we'll\nsend you a reset link",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.5, color: CfmsColors.label2),
                ),
                const SizedBox(height: 26),
                if (_sent)
                  const Text(
                    'Reset link sent — check your inbox.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CfmsColors.success, fontSize: 13),
                  )
                else ...[
                  CfmsTextFieldGroup(
                    fields: [
                      CfmsTextField(
                        icon: Icons.mail_outline,
                        controller: _emailController,
                        hint: 'you@bmu.edu.in',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        autofillHints: const [AutofillHints.email],
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
                  const SizedBox(height: 18),
                  GlassButton(
                    label: 'Send Reset Link',
                    loading: _submitting,
                    onPressed: _submitting ? null : _submit,
                  ),
                ],
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Back to Sign In',
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
