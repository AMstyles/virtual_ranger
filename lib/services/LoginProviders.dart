import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount get currentUser => _currentUser!;

  Future<void> googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _currentUser = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;

    print(user?.displayName!);
    print(user?.email!);
    print(user?.photoURL);
  }

  Future<void> googleLogout() async {
    await googleSignIn.disconnect();
    googleSignIn.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
