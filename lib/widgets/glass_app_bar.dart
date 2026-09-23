// Matches reference_screens/04-faculty-course-files-all.html
// `.material.tint.nav` — one of the few places §3 permits blur.
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: CfmsGlass.blurSigma,
          sigmaY: CfmsGlass.blurSigma,
        ),
        child: Container(
          height: preferredSize.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: CfmsColors.materialFillTint,
            border: const Border(
              bottom: BorderSide(color: CfmsColors.hairline, width: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: CfmsColors.materialHighlight,
                offset: const Offset(0, 0.5),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              ?leading,
              Expanded(
                child: Text(
                  title,
                  textAlign:
                      leading == null && trailing == null
                          ? TextAlign.center
                          : TextAlign.left,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.15,
                    color: CfmsColors.label,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
