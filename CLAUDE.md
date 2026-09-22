# Course File Manager — Project Brief for Claude Code

> **Read this entire document for context before writing any code.**
> This project is built in **phases**, one at a time. At the start of a session,
> tell me (or check `PROGRESS.md` if it exists) which phase we're on, implement
> **only that phase**, then stop and summarize what you built so I can review
> before we move to the next one. Do not jump ahead to a later phase even if it
> seems related — dependencies between phases are called out explicitly below.

---

## 1. What this app is

**Course File Manager** — a university faculty application for managing
academic course files. Faculty upload required documents for each course into
a "course file"; the app compiles them into a single generated Word document
(cover page + index + merged sections). It also handles CO/PO (Course
Outcome / Program Outcome) management and CO attainment, following BML Munjal
University's official Course File template.

**Roles — exactly two:**
- **Faculty** — creates and manages their own course files.
- **Administrator** — manages faculty accounts, courses, the required-document
  checklist, department-wide CO/PO configuration, and views reports across
  all course files. Administrator does **not** approve or reject a faculty
  member's course file — there is no HOD/approval workflow in this app.

Both roles share one login screen; the app routes to the right dashboard
based on the role stored on the user's record.

---

## 2. Tech stack (decided — do not deviate without asking)

- **Frontend:** Flutter, single codebase for mobile (Android/iOS) and web.
- **Backend / data:** Firebase — Authentication, Firestore, Storage.
- **Auth:** Email/password + Google Sign-In. Google only proves identity; role
  always comes from the Firestore user record. No self-signup — a Google
  account whose email isn't already a registered user is denied.
- **Word generation:** a **separate Python service** (FastAPI, deployed on
  Cloud Run) using `python-docx` + `docxcompose`, NOT a Firebase Cloud
  Function in JS — document merging is painful in JS and deserves its own
  service so a failure there never breaks the rest of the app.
- **CO Attainment calculation:** a Cloud Function, triggered on-demand or
  after marks entry. **Do not invent the attainment formula or thresholds** —
  the template shows a worked example (students scoring ≥3, mapped to
  Attainment Level 1/2/3) but the exact threshold policy must come from BMU;
  leave it as a clearly-marked configuration value until confirmed.

---

## 3. Design system (locked — implement exactly as specified)

All colours as Flutter `Color`/`ColorScheme` constants in one file
(`lib/theme/`), never hardcoded per-screen.

```
Background:      bg0 #101113   bg1 #16181B
Surfaces:         surface1 #1A1C20   surface2 #24262B
Hairline:         #EBECF0 at 9% opacity — never a solid border
Text:             label #EDEDEF (off-white)   label2 #9A9CA5   label3 #606369
Brand (only accent): #4B6FA5   brand-hi #6C8CBE
Success:          #4F9E74     Warning: #C79A45     Error: #B8635C
```

- **One brand colour only.** No purple/violet/pink, no gradients on buttons
  or cards — flat brand colour with a soft shadow for depth. The only
  gradients allowed are the single-hue shading inside the sticker
  illustrations (see below) — never a second hue mixed in.
- **Liquid Glass (blur) is used selectively** — nav bar, segmented control,
  bottom tab bar, bottom action bars, sheets/modals only. Content rows, list
  items and cards are flat, opaque surfaces. Never blur an entire screen or
  every card — that's the "generic glassmorphism" look we explicitly moved
  away from.
- **Corner radii:** buttons/inputs 12–13px, grouped list blocks 12px, small
  icon badges 7px. No 24px+ "bubble" radii.
- **Typography:** SF Pro / Inter, off-white body text, uppercase
  letter-spaced section headers (11.5px, `label3` colour).
- **Illustrations:** soft-3D SVG stickers (folder, document stack, cloud
  upload, checkmark badge) used only at a few meaningful moments — login,
  empty states, generate/success, not on every screen. Built from 3 base
  shapes (folder, document, badge) recoloured with the same brand-blue and
  success-green gradients so they read as one family. Admin's dense list
  screens intentionally get no stickers.
- **Reference mockups exist for every screen** — 32 self-contained HTML files
  in `reference_screens/` (see its `README.md` for the full list,
  numbered to match this document's phase order, e.g.
  `08-faculty-course-detail-upload-checklist.html`). Before building any
  screen's UI, open the matching file and match its exact colours, spacing
  and structure — don't guess or restyle. If a screen genuinely has no
  reference file, ask rather than inventing a new visual style.

---

## 4. Data model (Firestore)

```
users/{uid}
  name, email, role: "faculty" | "admin", department

departments/{deptId}
  pos:  [{ id, code:"PO1", title }]
  psos: [{ id, code:"PSO1", title }]
  requiredDocumentTypes: [{ id, name, fileTypes, required:bool, active:bool }]

courses/{courseId}
  name, code, semester, section, academicYear, facultyUid, status: active|archived

courseFiles/{fileId}
  courseId, facultyUid, status: created|inProgress|readyToGenerate|generating|ready|failed|archived
  cos: [{ id, code:"CO1", title }]                     — faculty-defined, per course
  copoMapping: [{ coId, poId, level: 1|2|3 }]
  description, objectives                               — template item 6
  sessionPlan: [{ session, topic, coId }]                — template item 9
  timetable: [{ day, time, room }]                       — template item 10
  feedback, correctiveActions                            — template item 23
  facultyReview: { pedagogies, experientialLearning, visionIntegration, nextRunPlan } — item 24
  documents/{docId}
    typeId, fileName, storagePath, status: uploaded|uploading|missing|failed, uploadedAt
  assessments/{assessmentId}
    name, type, weightage, dueDate, maxMarks
    questions: [{ id, maxMarks, coId }]
  studentMarks/{studentId_assessmentId}
    answers: [{ questionId, marksScored }]
  coAttainment/{coId}          (computed, cached)
    studentsAboveThreshold, totalStudents, percentage, attainmentLevel
  generatedFile: { storagePath, generatedAt, sizeBytes }

notifications/{notifId}
  userId (or role-wide), type, title, body, read:bool, createdAt
```

**Security rules (Phase 3 — write these before any UI touches real data):**
- Faculty can read/write only `courseFiles` where `facultyUid == request.auth.uid`.
- Administrator can read all `courseFiles`, `courses`, `users`; can write
  `departments/*`, `courses/*`, `users/*`.
- No user can edit their own `role` field.
- A course file's fields become read-only once `status` is `ready` or later,
  except `generatedFile` (written only by the Cloud Run service via a
  service account, never directly by a client).

---

## 5. Full screen inventory (for reference — build per-phase, not all at once)

**Auth:** Login, Forgot Password
**Faculty:** Dashboard, Course Files (All/In Progress/Ready/Archived),
Create Course File, Course Detail/Upload Checklist, Upload Failed, Manage
CO-PO Data, View CO-PO Mapping, Generating, Course File Ready/Download,
Alerts, Profile, Empty State
**Template sections:** Course Description & Objectives, Session-wise Plan,
Weekly Timetable, Internal Assessment Details, CO Attainment Analysis,
Feedback & Corrective Actions, Faculty Course Review, Registered Students
List
**Admin:** All Course Files, Manage Users, Manage Courses, Manage Required
Document Types, CO-PO Configuration, View Reports, Alerts, Profile

---

## 6. Phased build plan

Work through these **in order**. Each phase should end in something you can
actually run and look at. After finishing a phase, stop, tell me what changed
and what to check, and wait before starting the next one.

### Phase 0 — Project setup
- `flutter create` (enable web), Git repo with a sane `.gitignore`.
- Connect Firebase (Android + web at minimum); enable Auth, Firestore,
  Storage in the console.
- `lib/theme/` with the colour tokens from §3 as Dart constants.
- One blank screen confirming the app runs and Firebase initializes without error.

### Phase 1 — Component library
- `GlassCard`, `GlassAppBar`, `GlassBottomBar`, `GlassButton` (flat, not
  gradient), grouped-list-row widget, segmented control widget.
- A throwaway "component gallery" screen showing all of them — delete or
  keep behind a debug flag once Phase 2 starts.

### Phase 2 — Authentication
- Firebase email/password + Google Sign-In.
- Login screen shows a Faculty/Administrator segmented control — **this is
  cosmetic only** (it changes the subtitle text to set expectations). It must
  never be the source of truth for role or access. After a successful login,
  read `users/{uid}.role` from Firestore and route based on that. If the
  selected tab doesn't match the account's actual role, either route silently
  to the correct dashboard or show a clear "this account is registered as
  {role}" message — never grant access based on which tab was selected.
- `users/{uid}` read on login to get `role`; route to Faculty or
  Administrator shell accordingly.
- Login, Forgot Password screens per §3's visual language.
- Logout.
- **Depends on:** Phase 0, 1.

### Phase 3 — Data model + security rules
- Create the Firestore collections from §4 (seed a couple of fake
  documents by hand or with a script for testing).
- Write and deploy the security rules described in §4.
- Test rules with the Firebase emulator before moving on.
- **Depends on:** Phase 2 (needs real auth to test rules meaningfully).

### Phase 4 — Faculty core: course files list + creation
- Faculty Dashboard (stats row, needs-attention, recent activity).
- Course Files list with the four filters; Empty State when there are none.
- Create Course File form.
- **Depends on:** Phase 3.

### Phase 5 — Document upload
- Course Detail screen: fixed checklist pulled from
  `departments/{deptId}.requiredDocumentTypes`.
- Upload/replace/delete to Storage, with type/size validation and an Upload
  Failed state with retry.
- Status per document (uploaded/uploading/missing/failed) rolls up into the
  course file's overall status.
- **Depends on:** Phase 4.

### Phase 6 — CO-PO management
- Admin: CO-PO Configuration screen (manage the department's POs/PSOs).
- Faculty: Manage CO-PO Data (per-course COs) + View CO-PO Mapping (matrix,
  edit mode for setting levels 1–3).
- **Depends on:** Phase 3 (data model), can build in parallel with Phase 4/5.

### Phase 7 — Course File template sections
- The eight structured-entry sections from §5 (forms/tables, not uploads,
  except Registered Students List which is an upload).
- **Depends on:** Phase 4.

### Phase 8 — Assessments, marks, CO attainment
- Assessment config (weightage, due date, question-to-CO mapping).
- Student marks entry.
- Cloud Function to compute `coAttainment` — **flag the threshold/level
  logic clearly in code comments as "confirm with BMU policy," don't guess.**
- CO Attainment Analysis screen displaying the computed table.
- **Depends on:** Phase 6, 7.

### Phase 9 — Word generation service
- FastAPI service on Cloud Run: fetch documents + template-section data +
  CO-PO data → build cover page + index → merge → store in Storage → update
  `courseFiles/{id}.status` and `.generatedFile`.
- Generating screen (progress) + Course File Ready/Download screen, with a
  retry path on failure.
- **Depends on:** Phase 5, 7, 8 (needs real content to merge).

### Phase 10 — Notifications
- `notifications` collection, triggers on: upload failed, generation
  complete/failed, course file needs attention.
- Alerts screen (Faculty and Admin variants).
- **Depends on:** Phase 5, 9.

### Phase 11 — Admin screens
- All Course Files (with the stats row), Manage Users, Manage Courses,
  Manage Required Document Types, View Reports, Admin Profile.
- **Depends on:** Phase 3; can build in parallel with Faculty-side phases
  once the data model is in place.

### Phase 12 — Profile & settings
- Faculty and Admin Profile screens: edit profile, change password,
  notification/appearance settings, sign out.
- **Depends on:** Phase 2.

### Phase 13 — Polish and testing
- Loading/empty/error states on every screen that doesn't already have one.
- Responsive layout check on web (not just phone width).
- Unit tests for validation logic and CO attainment calculation; widget
  tests for key screens; security rules tests.
- Performance pass — glass blur must stay only where §3 says, check it
  doesn't lag on a list screen.
- **Depends on:** everything else.

---

## 7. Ground rules for every phase

1. Don't introduce a second accent colour, a gradient button, or blur on a
   content row — even "just this once." Check §3 before styling anything.
2. Don't invent the CO attainment formula, thresholds, or any other academic
   policy number. Leave a clearly marked TODO and ask.
3. Keep the Word-generation service decoupled — nothing else in the app
   should break if it's down.
4. Security rules are not optional polish — Phase 3 blocks real data use in
   later phases.
5. When a screen's exact layout isn't obvious from this brief, ask for the
   reference mockup rather than guessing the design.
