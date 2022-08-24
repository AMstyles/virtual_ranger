import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
/*
    print(user?.displayName!);
    print(user?.email!);
    print(user?.photoURL);
    print(user?.uid);
    print(user?.phoneNumber);
    print(user?.providerData);
    print(user?.isAnonymous);*/
  }

  Future<void> googleLogout() async {
    await googleSignIn.disconnect();
    googleSignIn.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
