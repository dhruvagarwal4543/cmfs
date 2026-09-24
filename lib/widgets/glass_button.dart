// Matches reference_screens/01-auth-login.html .btn — flat brand fill with
// a soft shadow, NOT a gradient. Rule from CLAUDE.md §3: one brand colour,
// no gradients on buttons.
import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum GlassButtonVariant { primary, secondary }

class GlassButton extends StatefulWidget {
  const GlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = GlassButtonVariant.primary,
    this.leading,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final GlassButtonVariant variant;

  /// Optional leading icon/logo — e.g. the Google "G" mark on
  /// "Continue with Google" (reference_screens/01-auth-login.html .btn.sec).
  final Widget? leading;

  /// Shows a spinner in place of [leading]/[label] and disables taps, without
  /// changing the button's colour (CLAUDE.md §3: flat brand fill, no
  /// separate "loading" style).
  final bool loading;

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null || widget.loading;
    final isPrimary = widget.variant == GlassButtonVariant.primary;

    final Color background;
    final Color textColor;
    final List<BoxShadow> shadows;

    if (disabled) {
      background = CfmsColors.surface2;
      textColor = CfmsColors.label3;
      shadows = const [];
    } else if (isPrimary) {
      background = CfmsColors.brand;
      textColor = Colors.white;
      shadows = [
        BoxShadow(
          color: CfmsColors.brand.withValues(alpha: 0.28),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
    } else {
      background = CfmsColors.surface2;
      textColor = CfmsColors.label;
      shadows = const [];
    }

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
      onTapCancel: disabled ? null : () => setState(() => _pressed = false),
      onTap: disabled ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.982 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(CfmsRadii.button),
            boxShadow: shadows,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.loading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textColor,
                  ),
                )
              else ...[
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 9),
                ],
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600, // CSS font-weight: 550
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
