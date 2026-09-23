// CFMS design tokens — CLAUDE.md §3. Values sourced from
// reference_screens/01-auth-login.html and 04-faculty-course-files-all.html.
//
// RULES — do not violate these, even "just this once":
// 1. One brand colour only. No purple/violet/pink, no gradients on buttons
//    or cards. Flat brand colour with a soft shadow for depth. The only
//    gradients allowed are the single-hue shading inside sticker
//    illustrations — never a second hue mixed in.
// 2. Liquid Glass (blur) is used SELECTIVELY: nav bar, segmented control,
//    bottom tab bar, bottom action bars, sheets/modals only.
// 3. Content rows, list items and cards are FLAT, OPAQUE surfaces — never
//    blurred. Never blur an entire screen or every card.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Flat colour tokens. Never hardcode these hex values per-screen — import
/// this class instead.
class CfmsColors {
  CfmsColors._();

  // Background
  static const bg0 = Color(0xFF101113);
  static const bg1 = Color(0xFF16181B);

  // Surfaces (flat, opaque — used for content rows/cards, never blurred)
  static const surface1 = Color(0xFF1A1C20);
  static const surface2 = Color(0xFF24262B);

  // Hairline — never a solid border. #EBECF0 at 9% opacity.
  static const hairline = Color(0x17EBECF0);

  // Text
  static const label = Color(0xFFEDEDEF); // off-white
  static const label2 = Color(0xFF9A9CA5);
  static const label3 = Color(0xFF606369);

  // Brand — the only accent colour in the app.
  static const brand = Color(0xFF4B6FA5);
  static const brandHi = Color(0xFF6C8CBE);

  // Status
  static const success = Color(0xFF4F9E74);
  static const warning = Color(0xFFC79A45);
  static const error = Color(0xFFB8635C);

  // Brand fill — segmented-control track background (brand @ 14% opacity).
  static const brandFill = Color(0x244B6FA5);

  // Glass materials (see CfmsGlass for blur usage rules).
  static const materialFill = Color(0xA8101113); // rgba(16,17,19,.66)
  static const materialFillTint = Color(0x94131519); // rgba(19,21,25,.58)
  static const materialHighlight = Color(0x1AE1E5EC); // rgba(225,229,236,.10)
}

/// Corner radii — CLAUDE.md §3: buttons/inputs 12–13px, grouped list blocks
/// 12px, small icon badges 7px. No 24px+ "bubble" radii anywhere.
class CfmsRadii {
  CfmsRadii._();

  static const button = 13.0;
  static const input = 12.0;
  static const iconBadge = 7.0;
  static const segmentContainer = 9.0;
  static const segmentThumb = 7.0;

  /// Grouped list blocks (GroupedListRow container) render edge-to-edge with
  /// 0 radius, matching every reference mockup — on a phone-width screen the
  /// list runs flush to the sides with no margin, so §3's "12px" never
  /// actually shows. Radius only applies if a screen explicitly insets the
  /// list in a margin/card (opt-in per instance, not a token default).
  static const groupedListDefault = 0.0;
}

/// Glass-blur constants. Only ever apply these to: nav bar, segmented
/// control, bottom tab bar, bottom action bars, sheets/modals.
/// NEVER apply to content rows, list items, or cards — those use the flat
/// CfmsColors.surface1 / surface2 tokens instead.
class CfmsGlass {
  CfmsGlass._();

  static const blurSigma = 30.0;
  static const saturationBoost = 1.8; // CSS saturate(180%)
}

/// Spacing / animation constants pulled from the reference CSS.
class CfmsMotion {
  CfmsMotion._();

  static const segmentThumbDuration = Duration(milliseconds: 320);
  // cubic-bezier(.32,.72,0,1)
  static const segmentThumbCurve = Cubic(0.32, 0.72, 0, 1);
}

class CfmsTheme {
  CfmsTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: CfmsColors.label,
      displayColor: CfmsColors.label,
    );

    return base.copyWith(
      scaffoldBackgroundColor: CfmsColors.bg0,
      colorScheme: base.colorScheme.copyWith(
        primary: CfmsColors.brand,
        secondary: CfmsColors.brandHi,
        surface: CfmsColors.surface1,
        error: CfmsColors.error,
      ),
      textTheme: textTheme,
    );
  }

  /// Uppercase, letter-spaced section header style — CLAUDE.md §3:
  /// 11.5px, label3 colour.
  static TextStyle get sectionHeader => GoogleFonts.inter(
        fontSize: 11.5,
        fontWeight: FontWeight.w600, // CSS font-weight: 550 (no exact match)
        letterSpacing: 11.5 * 0.04, // CSS: letter-spacing: .04em
        color: CfmsColors.label3,
      );
}
