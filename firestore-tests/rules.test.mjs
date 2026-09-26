// Rules unit tests for firestore.rules, run against the Firestore emulator.
// Usage: npm test (from this directory) — see package.json.
//
// Covers the scenarios CLAUDE.md's Phase 3 spec calls out explicitly, plus
// two extra (marked BONUS) for the lock-on-ready and admin-write-denied
// behaviour, since those are just as central to §4's spec.
import { readFileSync } from 'node:fs';
import assert from 'node:assert/strict';
import {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} from '@firebase/rules-unit-testing';
import { doc, getDoc, setDoc, updateDoc } from 'firebase/firestore';

const FACULTY_A = 'facultyA';
const FACULTY_B = 'facultyB';
const ADMIN_A = 'adminA';

let testEnv;
let passed = 0;
let failed = 0;

async function check(name, fn) {
  try {
    await fn();
    console.log(`  ok   - ${name}`);
    passed++;
  } catch (e) {
    console.log(`  FAIL - ${name}`);
    console.log(`         ${e.message}`);
    failed++;
  }
}

async function main() {
  testEnv = await initializeTestEnvironment({
    projectId: 'cfms-bmu-app-rules-test',
    firestore: {
      rules: readFileSync('../firestore.rules', 'utf8'),
    },
  });

  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, 'users', FACULTY_A), {
      name: 'Faculty A',
      email: 'a@bmu.edu.in',
      role: 'faculty',
      department: 'cs',
    });
    await setDoc(doc(db, 'users', FACULTY_B), {
      name: 'Faculty B',
      email: 'b@bmu.edu.in',
      role: 'faculty',
      department: 'cs',
    });
    await setDoc(doc(db, 'users', ADMIN_A), {
      name: 'Admin A',
      email: 'admin@bmu.edu.in',
      role: 'admin',
      department: 'cs',
    });
    await setDoc(doc(db, 'courseFiles', 'fileA'), {
      courseId: 'course1',
      facultyUid: FACULTY_A,
      status: 'inProgress',
    });
    await setDoc(doc(db, 'courseFiles', 'fileReady'), {
      courseId: 'course1',
      facultyUid: FACULTY_A,
      status: 'ready',
      generatedFile: { storagePath: 'gs://x/y.docx', generatedAt: '2026-01-01', sizeBytes: 100 },
    });
  });

  const facultyACtx = testEnv.authenticatedContext(FACULTY_A);
  const facultyBCtx = testEnv.authenticatedContext(FACULTY_B);
  const adminCtx = testEnv.authenticatedContext(ADMIN_A);

  await check('faculty reading their own courseFile: allow', async () => {
    await assertSucceeds(getDoc(doc(facultyACtx.firestore(), 'courseFiles', 'fileA')));
  });

  await check("faculty reading someone else's courseFile: deny", async () => {
    await assertFails(getDoc(doc(facultyBCtx.firestore(), 'courseFiles', 'fileA')));
  });

  await check('faculty editing their own role field: deny', async () => {
    await assertFails(
      updateDoc(doc(facultyACtx.firestore(), 'users', FACULTY_A), { role: 'admin' }),
    );
  });

  await check('admin reading any courseFile: allow', async () => {
    await assertSucceeds(getDoc(doc(adminCtx.firestore(), 'courseFiles', 'fileA')));
  });

  await check('client writing generatedFile directly: deny', async () => {
    await assertFails(
      updateDoc(doc(facultyACtx.firestore(), 'courseFiles', 'fileA'), {
        generatedFile: { storagePath: 'gs://evil/x.docx', generatedAt: 'now', sizeBytes: 1 },
      }),
    );
  });

  // BONUS — beyond the minimum requested list, but core to §4's spec:

  await check('BONUS: faculty editing a ready (locked) courseFile: deny', async () => {
    await assertFails(
      updateDoc(doc(facultyACtx.firestore(), 'courseFiles', 'fileReady'), {
        description: 'trying to sneak an edit in',
      }),
    );
  });

  await check('BONUS: admin writing a courseFile directly: deny', async () => {
    await assertFails(
      updateDoc(doc(adminCtx.firestore(), 'courseFiles', 'fileA'), {
        description: 'admin should never edit course files',
      }),
    );
  });

  await testEnv.cleanup();

  console.log(`\n${passed} passed, ${failed} failed`);
  if (failed > 0) process.exit(1);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
