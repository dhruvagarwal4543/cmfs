// Blurred material card for SHEETS AND MODALS ONLY (CLAUDE.md §3 allows
// blur there). Do NOT use this for content rows, list items, or regular
// cards — those must be flat, opaque surfaces (see GroupedListRow, or just
// a Container with CfmsColors.surface1/surface2).
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(CfmsRadii.input),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: CfmsGlass.blurSigma,
          sigmaY: CfmsGlass.blurSigma,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: CfmsColors.materialFill,
            borderRadius: BorderRadius.circular(CfmsRadii.input),
            boxShadow: [
              BoxShadow(
                color: CfmsColors.materialHighlight,
                offset: const Offset(0, 0.5),
                blurRadius: 0,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
