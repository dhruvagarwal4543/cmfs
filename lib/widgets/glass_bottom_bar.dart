// Matches reference_screens/*.html `.material.tint.bottom` and
// `.material.tint.tabbar` — both share the same blurred container; only the
// content (a GlassButton vs a row of tab icons) differs per screen.
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

class GlassBottomBar extends StatelessWidget {
  const GlassBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: CfmsGlass.blurSigma,
          sigmaY: CfmsGlass.blurSigma,
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 14,
            bottom: 14 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: const BoxDecoration(
            color: CfmsColors.materialFillTint,
            border: Border(
              top: BorderSide(color: CfmsColors.hairline, width: 0.5),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
