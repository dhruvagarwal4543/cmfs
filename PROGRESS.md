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

## Phase 2 — Authentication (2026-09-24)

`lib/auth/auth_service.dart`: email/password sign-in, Google sign-in
restricted to @bmu.edu.in (web uses Firebase's `signInWithPopup` with the
`hd` custom parameter so the trigger can stay a custom-styled GlassButton;
mobile uses the `google_sign_in` plugin's native flow — both paths do the
real post-signin email check and sign back out on a domain mismatch, since
the `hd` hint is a UX filter only, not a security boundary), password
reset, sign out, and `fetchRole(uid)` reading `users/{uid}.role`.
`lib/screens/auth_gate.dart` is the real access gate: routes to
FacultyHomeScreen or AdminHomeScreen (both placeholders — real dashboards
are Phase 4/11) based purely on the Firestore role, independent of which
tab was selected on the login screen; an authenticated user with no
`users/{uid}` document is signed out and shown "This account isn't
registered." `lib/screens/login_screen.dart` (reference 01) and
`forgot_password_screen.dart` (reference 02) built from the Phase 1 widget
library — extended `GlassButton` with an optional leading icon and a
loading spinner state rather than one-off styling, and added
`CfmsTextField`/`CfmsTextFieldGroup` as new shared widgets for the
`.inputs`/`.inp` pattern. `main.dart` now boots straight into `AuthGate`;
the Phase 1 debug component gallery is no longer wired in (file still
exists, just unreachable, per Phase 1's own "hide once Phase 2 starts").

**Two seeded test accounts** (Firebase Auth + matching `users/{uid}` doc),
so there's something to actually log in with — Phase 11 (Admin — Manage
Users) is real account creation, this is just enough to test Phase 2:

| Role  | Email                     | Password      |
|-------|---------------------------|---------------|
| Faculty | faculty.test@bmu.edu.in | `Faculty#2026` |
| Admin   | admin.test@bmu.edu.in   | `Admin#2026`   |

Verified end-to-end on web: email/password sign-in → Firestore role fetch
→ routed to the Faculty placeholder → Log out → back to Login.

**Open follow-ups / things to check:**
- **Google sign-in couldn't be tested end-to-end here** — it needs a real
  interactive Google consent flow, which isn't possible from this
  environment. Please try "Continue with Google" yourself with a real
  @bmu.edu.in Google Workspace account (and, separately, a non-BMU Google
  account to confirm it's rejected) before we call this phase fully done.
- **Firestore is still on the temporary open rule from Phase 0**
  (`allow read, write: if request.time < ...`, expires 2026-10-22) — that's
  what let `fetchRole` work before Phase 3 writes the real least-privilege
  rules. Deployed as-is; Phase 3 must replace it before that expiry.
- The login/reset-password sticker illustrations are simplified
  placeholders (a plain folder icon in a brand-gradient rounded square),
  not pixel-accurate redraws of the reference SVGs — flagged as a separate
  illustration-asset task, not core to the auth wiring in this phase.
- Added two more dependencies beyond Phase 1's google_fonts: `firebase_auth`,
  `cloud_firestore`, `google_sign_in` (all already implied by CLAUDE.md's
  tech stack), and `flutter_svg` (renders the exact multicolour Google "G"
  logo from the reference instead of an approximation).

---

## Phase 3 — Data model + security rules: not started
