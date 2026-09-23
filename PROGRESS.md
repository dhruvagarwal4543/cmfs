# CFMS — Progress Log

One entry per completed phase. See CLAUDE.md for the static brief and full
phase plan — this file just tracks where we actually are.

---

## Phase 0 — Project setup (2026-09-22)

`flutter create` (Android/iOS/Web, package id `com.bmu.cfms` — confirmed
permanent, do not revisit), git repo initialized, Firebase project
`cfms-bmu-app` created and wired via FlutterFire, Firestore database
created. `lib/main.dart` shows a plain "Firebase connected ✓" screen.
`lib/theme/` created as an empty placeholder.

**Follow-ups from this phase — all resolved:**
- Enabling Auth providers (Email/Password + Google) and Storage required
  manual console clicks (no CLI/API path exists for either). Done — user
  confirmed both are enabled in the Firebase console.

## Phase 1 — Component library (2026-09-24)

`lib/theme/theme.dart` with the full colour/radii/glass token set from
CLAUDE.md §3, sourced from the actual CSS in `reference_screens/01` and
`04`. `lib/widgets/`: GlassButton, GlassAppBar, GlassBottomBar, GlassCard,
GroupedListRow/GroupedRows, SegmentedControl (animated thumb). Temporary
`lib/debug/component_gallery_screen.dart`, reachable only via a
kDebugMode-gated button on the Phase 0 screen — not wired into real
navigation, delete before/at Phase 2. Added `google_fonts` (Inter)
dependency.

**Follow-ups from this phase — all resolved:**
- GlassCard scoped to sheets/modals only, never content rows/cards —
  approved.
- Icon-color naming uses semantic names (brand/success/warning/error/
  neutral) instead of the mockups' literal color names (blue/green/amber/
  red) — approved, keep this over matching the mockup class names.
- GroupedRows renders edge-to-edge with 0 radius by default (mockups have
  no side margin, so §3's "12px grouped list block" radius never actually
  shows) — decided, opt-in `radius`/`margin` params exist for screens that
  need an inset variant.

---

## Phase 2 — Authentication: not started
