import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/DrawerApp.dart';
import 'package:virtual_ranger/apis/In.dart';
import 'package:virtual_ranger/pages/forgot.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';
import '../models/constants.dart';
import '../models/user.dart';
import 'package:virtual_ranger/pages/sign_up_page.dart';
import 'dart:io' show Platform;
import '../services/LoginProviders.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late User user;
  late String data;
  late String email;
  late String password;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late final sharePrefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharePrefs = SharedPreferences.getInstance();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN IN'),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(children: [
            Image.asset(
              'lib/assets/mainLogo.png',
              color: Colors.grey.shade600,
              fit: BoxFit.cover,
            ),
            Platform.isIOS
                ? _buildAppleSignInButton(context)
                : const SizedBox(),
            const SizedBox(height: 12),
            _buildFacebookSignInButton(context),
            const SizedBox(height: 12),

            _buildGoogleSignInButton(context),

            const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'OR',
                  style: TextStyle(fontSize: 30, color: Colors.blueGrey),
                )),
            const SizedBox(height: 5),
            TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgortPage()));
              },
              child: Text(
                textAlign: TextAlign.center,
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _buildSignInButton(context),
            const SizedBox(height: 15),
            _buildSignUpButton(context),
            const SizedBox(height: 20),
            //_buildRow(context),
          ]),
        ),
      ),
    );
  }

//!methods
//!recreations

  Widget _buildSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () => handleSubmit2(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
        ),
        child: const Text(
          'SIGN IN',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const SignUpPage()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors.secondaryColor,
        ),
        child: const Text(
          'SIGN UP/REGISTER',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

//!fancy
  Widget _buildAppleSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final provider =
            Provider.of<AppleLoginProvider>(context, listen: false);
        await provider.LoginWithApple();
        if (auth.FirebaseAuth.instance.currentUser != null) {
          print("instance not null");
          final nice = auth.FirebaseAuth.instance.currentUser;
          print("name is: " + nice!.email!.toString());

          final vedict = await signUpAPI.signInWithGoogle(nice.email ?? '');
          final finalVedict = jsonDecode(vedict);
          print(finalVedict);

          if (finalVedict['success'] == true) {
            final userToBe = User.fromjson((finalVedict['data']));
            UserData.setUser(userToBe);
            Provider.of<UserProvider>(context, listen: false).setUser(userToBe);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: ((context) => DrawerApp())));
            showDialogs();
          } else {
            final things = await signUpAPI.signUp(
                nice.displayName ?? "",
                nice.email ?? '',
                nice.phoneNumber ?? '  ',
                'none',
                'none',
                '000000',
                '000000');

            await auth.FirebaseAuth.instance.signOut();

            print(things);
            final perfectThings = jsonDecode(things);

            final userToBe = User.fromjson(perfectThings['data']);
            Provider.of<UserProvider>(context, listen: false).setUser(userToBe);
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: ((context) => DrawerApp())));
            showDialogs();
          }
        } else {}
        auth.FirebaseAuth.instance.signOut();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        alignment: Alignment.center,
        height: 45,
        width: 140,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(
              Icons.apple,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(width: 20),
            Text(
              "Sign in with Apple",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacebookSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //loading dialog
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: LoadingBouncingGrid.circle(
                  backgroundColor: Colors.lightGreen,
                  duration: Duration(milliseconds: 500),
                  inverted: true,
                ),
              );
            });

        await FacebookLoginProvider.signInWithFacebook(context);

        if (auth.FirebaseAuth.instance.currentUser != null) {
          final nice = auth.FirebaseAuth.instance.currentUser;

          final vedict = await signUpAPI.signInWithGoogle(nice!.email ?? '');
          final finalVedict = jsonDecode(vedict);

          if (finalVedict['success'] == true) {
            final userToBe = User.fromjson((finalVedict['data']));
            UserData.setUser(userToBe);
            Provider.of<UserProvider>(context, listen: false).setUser(userToBe);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: ((context) => DrawerApp())));
            showDialogs();
          } else {
            final things = await signUpAPI.signUpG(
                nice.displayName ?? "",
                nice.email ?? '${nice.displayName}@autoEmail.com',
                nice.phoneNumber ?? '  ',
                'none',
                'none',
                '000000',
                '000000',
                nice.photoURL ?? '');

            await auth.FirebaseAuth.instance.signOut();

            Navigator.pop(context);

            print(things);
            final perfectThings = jsonDecode(things);

            final userToBe = User.fromjson(perfectThings['data']);
            Provider.of<UserProvider>(context, listen: false).setUser(userToBe);
            Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => DrawerApp()),
            ));
            showDialogs();
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        alignment: Alignment.center,
        height: 45,
        width: 140,
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(
              size: 40,
              Icons.facebook,
              color: Colors.white,
            ),
            SizedBox(width: 20),
            Text(
              "Sign in with Facebook",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: LoadingBouncingGrid.circle(
                  backgroundColor: Colors.lightGreen,
                  duration: Duration(milliseconds: 500),
                  inverted: true,
                ),
              );
            });
        await Provider.of<GoogleSignInProvider>(context, listen: false)
            .googleLogin(context);
        if (auth.FirebaseAuth.instance.currentUser != null) {
          final nice = auth.FirebaseAuth.instance.currentUser;

          final vedict = await signUpAPI.signInWithGoogle(nice!.email ?? '');
          final finalVedict = jsonDecode(vedict);

          if (finalVedict['success'] == true) {
            final userToBe = User.fromjson((finalVedict['data']));
            UserData.setUser(userToBe);
            Provider.of<UserProvider>(context, listen: false).setUser(userToBe);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: ((context) => DrawerApp())));
            showDialogs();
          } else {
            final things = await signUpAPI.signUp(
                nice.displayName ?? "",
                nice.email ?? '',
                nice.phoneNumber ?? '  ',
                'none',
                'none',
                '000000',
                '000000');

            await auth.FirebaseAuth.instance.signOut();

            print(things);
            final perfectThings = jsonDecode(things);

            final userToBe = User.fromjson(perfectThings['data']);
            Provider.of<UserProvider>(context, listen: false).setUser(userToBe);
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: ((context) => DrawerApp())));
            showDialogs();
          }
        } else {}
        auth.FirebaseAuth.instance.signOut();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        alignment: Alignment.center,
        height: 45,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Image.asset(
                'lib/assets/googleIcon.png',
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(width: 20),
            const Text(
              "Sign in with Google",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget space(BuildContext context) {
    return const SizedBox(width: 20);
  }

  //!Sign in method
  void handleSubmit2() async {
    email = _emailController.text;
    password = _passwordController.text;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          const Center(child: CircularProgressIndicator.adaptive()),
    );

    data = await signUpAPI.signIn(email, password);
    Navigator.pop(context);

    final finalData = jsonDecode(data)!;
    print(data);

    if (finalData['success'] == true) {
      user = User.fromjson(finalData['data']);
      await UserData.setUser(user);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      print(
          Provider.of<UserProvider>(context, listen: false).user!.secret_key ??
              "" + "success?");

      //print("the logged in key: " + user.secret_key.toString());

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const DrawerApp()));
      showDialogs();
    } else {
      showDialog(
          context: context,
          builder: (context) => Platform.isAndroid
              ? AlertDialog(
                  title: const Text(
                    'Error',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(finalData['data']),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              : CupertinoAlertDialog(
                  title: const Text(
                    'Error',
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(finalData['data']),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
      //cupertion

    }
    //print(finalData['success']);
  }

  void showDialogs() async {
    getOffline().then((value) async {
      if (value) {
        final pref = await SharedPreferences.getInstance();
        final condition = await pref.getBool('opened1') ?? false;

        !condition
            ? showDialog(
                context: context,
                builder: (context) => Platform.isAndroid
                    ? AlertDialog(
                        title: Text(
                          "Welcome to Virtual Ranger",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                            "You're in offline mode. You can still use the app but you won't be able to see any new sightings or news in real time. You can turn on online mode in the settings."),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Dismiss",
                                  style: TextStyle(color: Colors.red))),
                          TextButton(
                              onPressed: () async {
                                final useful =
                                    await SharedPreferences.getInstance();
                                useful.setBool("opened1", true);
                                Navigator.pop(context);
                                Provider.of<PageProvider>(context,
                                        listen: false)
                                    .jumpToSettings();
                              },
                              child: Text("Go to settings"))
                        ],
                      )
                    : CupertinoAlertDialog(
                        title: Text(
                          "Welcome to Virtual Ranger",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                            "You're in offline mode. You can still use the app but you won't be able to see any new sightings or news in real time. You can turn on online mode in the settings."),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("dismiss",
                                  style: TextStyle(color: Colors.red))),
                          TextButton(
                              onPressed: () async {
                                final useful =
                                    await SharedPreferences.getInstance();
                                useful.setBool("opened1", true);

                                Provider.of<PageProvider>(context,
                                        listen: false)
                                    .jumpToSettings();
                                Navigator.pop(context);
                              },
                              child: Text("Go to settings"))
                        ],
                      ),
              )
            : () {};
      } else {
        final pref = await SharedPreferences.getInstance();
        final condition = await pref.getBool('opened') ?? false;

        !condition
            ? showDialog(
                context: context,
                builder: (context) => Platform.isAndroid
                    ? AlertDialog(
                        title: Text(
                          "Welcome to Virtual Ranger",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                            "To use this app in areas without signal please go to settings, download content and toggle on offline mode"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Dismiss",
                                  style: TextStyle(color: Colors.red))),
                          TextButton(
                              onPressed: () async {
                                final useful =
                                    await SharedPreferences.getInstance();
                                useful.setBool("opened", true);
                                Navigator.pop(context);
                                Provider.of<PageProvider>(context,
                                        listen: false)
                                    .jumpToDownload();
                              },
                              child: Text("Go to settings"))
                        ],
                      )
                    : CupertinoAlertDialog(
                        title: Text(
                          "Welcome to Virtual Ranger",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        content: Text(
                            "To use this app in areas without signal please go to settings, download content and toggle on offline mode"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("dismiss",
                                  style: TextStyle(color: Colors.red))),
                          TextButton(
                              onPressed: () async {
                                final useful =
                                    await SharedPreferences.getInstance();
                                useful.setBool("opened", true);
                                Navigator.pop(context);
                                Provider.of<PageProvider>(context,
                                        listen: false)
                                    .jumpToDownload();
                              },
                              child: Text("Go to settings"))
                        ],
                      ),
              )
            : () {};
      }
    });
  }

  Future<bool> getOffline() async {
    SharedPreferences prefs = await sharePrefs;
    return await prefs.getBool('offlineMode') ?? false;
  }
}
