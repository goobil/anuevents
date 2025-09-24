import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// foundation import removed after removing debug-only prints

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Use the new singleton API from google_sign_in 7.x
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleInitialized = false;

  // Optional: set your Web client ID (OAuth 2.0 client ID for Web) from
  // Firebase console here to ensure idToken is returned on some platform
  // configurations. Leave empty to use default behavior.
  // Example: const String kGoogleServerClientId = '1234-abc.apps.googleusercontent.com';
  static const String kGoogleServerClientId = '563497241493-ds5h91elj88sh2lag3nu7glhd34q5936.apps.googleusercontent.com';

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    try {
      if (kGoogleServerClientId.isNotEmpty) {
        await _googleSignIn.initialize(serverClientId: kGoogleServerClientId);
      } else {
        await _googleSignIn.initialize();
      }
    } catch (_) {
      // initialize may not be required on all platforms; ignore errors
    }
    _googleInitialized = true;
  }

  Future<void> signOut() async {
    // Sign out from Google as well if used
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  Future<UserCredential?> signInWithGoogle() async {
    await _ensureGoogleInitialized();

    final GoogleSignInAccount account;
    try {
      // Use interactive authenticate() (new API) to start sign-in flow
      account = await _googleSignIn.authenticate();
    } catch (e) {
      // authentication failed or was cancelled
      // Authentication failed or was cancelled
      return null;
    }

  // idToken is available via account.authentication
    final auth = account.authentication;
    final idToken = auth.idToken;
    // Defensive check: idToken is required to create a Firebase credential.
    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-google-id-token',
        message:
            'Google idToken was null or empty. Check Google iOS configuration (GoogleService-Info.plist, URL types / REVERSED_CLIENT_ID) and OAuth client IDs in Firebase console.',
      );
    }

    // accessToken may not be present on all platforms; try to request it
    String? accessToken;
    try {
      final clientAuth = await account.authorizationClient
          .authorizationForScopes(<String>['email']);
      accessToken = clientAuth?.accessToken;
    } catch (_) {
      accessToken = null;
    }

    // proceed with credential creation

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: accessToken,
    );

    return _auth.signInWithCredential(credential);
  }

  // Link currently signed-in user with Google account
  Future<UserCredential?> linkWithGoogle() async {
    final user = _auth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'no-current-user', message: 'No signed-in user');

    await _ensureGoogleInitialized();

    final GoogleSignInAccount account;
    try {
      account = await _googleSignIn.authenticate();
    } catch (e) {
      // authentication failed or was cancelled for linking
      return null;
    }

  final auth = account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-google-id-token',
        message:
            'Google idToken was null or empty. Check Google iOS configuration (GoogleService-Info.plist, URL types / REVERSED_CLIENT_ID) and OAuth client IDs in Firebase console.',
      );
    }
    String? accessToken;
    try {
      final clientAuth = await account.authorizationClient
          .authorizationForScopes(<String>['email']);
      accessToken = clientAuth?.accessToken;
    } catch (_) {
      accessToken = null;
    }

    // proceed with credential creation for linking

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: accessToken,
    );
    return user.linkWithCredential(credential);
  }

  // Link current user to an email/password credential
  Future<UserCredential> linkWithEmail(String email, String password) async {
    final user = _auth.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'no-current-user', message: 'No signed-in user');
    final cred = EmailAuthProvider.credential(email: email, password: password);
    return user.linkWithCredential(cred);
  }

  // Send password reset email
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
