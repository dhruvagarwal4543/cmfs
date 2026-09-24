// CLAUDE.md §2/§6 Phase 2:
// - Google only proves identity; role always comes from the Firestore
//   users/{uid} record. No self-signup.
// - @bmu.edu.in domain restriction: the `hd` hint on Google sign-in is a UX
//   filter only, NOT a security boundary — the real check is the post-signin
//   email check below, which signs the user back out on a mismatch.
// - The deeper gate that applies to EVERY sign-in method (Google or
//   email/password): an authenticated user with no matching users/{uid}
//   document is denied (see fetchRole + AuthGate).
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

const bmuEmailDomain = 'bmu.edu.in';

enum CfmsRole { faculty, admin }

/// Thrown when a Google account authenticates successfully but its email
/// isn't on the @bmu.edu.in domain. The user has already been signed out by
/// the time this is thrown.
class BmuDomainViolation implements Exception {
  const BmuDomainViolation();
}

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _authOverride = auth,
      _firestoreOverride = firestore;

  final FirebaseAuth? _authOverride;
  final FirebaseFirestore? _firestoreOverride;
  bool _googleInitialized = false;

  // Lazy so constructing an AuthService never touches Firebase.instance
  // until something is actually called — lets tests subclass and override
  // just authStateChanges/fetchRole without a real Firebase app.
  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Signs in with Google, restricted to @bmu.edu.in.
  ///
  /// Web uses Firebase's own popup flow (`signInWithPopup`) so the trigger
  /// can stay a normal custom-styled GlassButton — Google Identity Services'
  /// web SDK otherwise requires rendering its own unstyled button. Mobile
  /// uses the google_sign_in plugin's native flow.
  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider()
        ..setCustomParameters({'hd': bmuEmailDomain});
      await _auth.signInWithPopup(provider);
    } else {
      if (!_googleInitialized) {
        await GoogleSignIn.instance.initialize(hostedDomain: bmuEmailDomain);
        _googleInitialized = true;
      }
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      await _auth.signInWithCredential(credential);
    }

    final email = _auth.currentUser?.email ?? '';
    if (!email.toLowerCase().endsWith('@$bmuEmailDomain')) {
      await signOut();
      throw const BmuDomainViolation();
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Not signed in via Google, or not yet initialized — fine to ignore.
      }
    }
    await _auth.signOut();
  }

  /// Reads `users/{uid}.role`. Returns null if there's no matching user
  /// document at all, or the role field is neither "faculty" nor "admin" —
  /// both cases mean "not a registered user" to the caller.
  Future<CfmsRole?> fetchRole(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final role = snapshot.data()?['role'] as String?;
    return switch (role) {
      'faculty' => CfmsRole.faculty,
      'admin' => CfmsRole.admin,
      _ => null,
    };
  }
}
