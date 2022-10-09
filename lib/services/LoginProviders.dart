import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

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
  static Future<void> SWF() async {
    FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );
  }

  static Future<void> signInWithFacebook(BuildContext context) async {
    late var userIn;

    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    try {
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      if (e.code == 'account-exists-with-different-credential') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"))
                  ],
                ));
        // handle the error here
      } else if (e.code == 'invalid-credential') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"))
                  ],
                ));

        // handle the error here
      }
    } catch (e) {
      // handle the error here
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Error"),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"))
                ],
              ));

      //notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      userIn = user;
    }

    Future<void> facebookLogout() async {
      await FacebookAuth.instance.logOut();
    }
  }
}

class AppleLoginProvider extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<List<String>> LoginWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final email = appleIdCredential.email;
        print(email);
        final name = appleIdCredential.fullName;
        final mobile = "";
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        return [email.toString(), name.toString()];
        break;

      /*final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }*/
      //return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }
}
