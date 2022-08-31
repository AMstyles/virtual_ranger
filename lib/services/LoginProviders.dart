import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  late var userIn;

  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount get currentUser => _currentUser!;

  Future<void> googleLogin() async {
    //try cacth

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
    userIn = user;
  }

  Future<void> googleLogout() async {
    await googleSignIn.disconnect();
    googleSignIn.signOut();
    _currentUser = null;
    notifyListeners();
  }
}

class FacebookLoginProvider extends ChangeNotifier {
  static Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> facebookLogout() async {
    await FacebookAuth.instance.logOut();
  }
}
