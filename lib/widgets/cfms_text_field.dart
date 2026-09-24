// Matches reference_screens/01-auth-login.html `.inputs` / `.inp`. Flat,
// opaque surface — never blurred.
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CfmsTextField extends StatelessWidget {
  const CfmsTextField({
    super.key,
    required this.icon,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
  });

  final IconData icon;
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 16, color: CfmsColors.label3),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              autofillHints: autofillHints,
              style: const TextStyle(fontSize: 15, color: CfmsColors.label),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: CfmsColors.label3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Container for a group of [CfmsTextField]s — flat surface1 background,
/// rounded 12px, with inset hairline dividers between fields.
class CfmsTextFieldGroup extends StatelessWidget {
  const CfmsTextFieldGroup({super.key, required this.fields});

  final List<CfmsTextField> fields;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CfmsColors.surface1,
        borderRadius: BorderRadius.circular(CfmsRadii.input),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < fields.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: ColoredBox(
                  color: CfmsColors.hairline,
                  child: SizedBox(height: 0.5, width: double.infinity),
                ),
              ),
            fields[i],
          ],
        ],
      ),
    );
  }
}
