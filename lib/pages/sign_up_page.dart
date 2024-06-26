import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ranger/DrawerApp.dart';
import 'package:virtual_ranger/apis/In.dart';
import 'package:virtual_ranger/services/LoginProviders.dart';
import 'package:virtual_ranger/services/page_service.dart';
import 'package:virtual_ranger/services/shared_preferences.dart';
import '../models/constants.dart';
import '../models/user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String data;
  late User user;
  late final sharePrefs;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  late String name;
  late String email;
  late String password;
  late String confirmPassword;
  late String age_range;
  late String gender;
  late String mobile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharePrefs = SharedPreferences.getInstance();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SIGN UP'),
        ),
        body: SafeArea(
          bottom: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              // Image.asset(
              //   'lib/assets/mainLogo.png',
              //   color: Colors.grey.shade600,
              //   fit: BoxFit.cover,
              // ),
              Platform.isIOS
                  ? _buildAppleSignInButton(context)
                  : const SizedBox(),

              _makeSpace(context),
              _buildFacebookSignInButton(context),
              _makeSpace(context),
              _buildGoogleSignInButton(context),
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'OR',
                    style: TextStyle(fontSize: 30, color: Colors.blueGrey),
                  )),
              TextField(
                textInputAction: TextInputAction.next,
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name and Surname',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _mobileController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              const SizedBox(height: 10),
              buildGender(context),
              const SizedBox(height: 10),
              buildAgeRange(context),
              //_buildRadioButtonGroup(context),
              const SizedBox(height: 10),
              TextField(
                textInputAction: TextInputAction.next,
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                textInputAction: TextInputAction.done,
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'confirm password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              _makeSpace(context),
              _buildSignUpButton(context),
              _makeSpace(context),
              _makeSpace(context)
            ],
          ),
        ));
  }

  //!remakes
  Widget _buildSignUpButton(BuildContext context) {
    return GestureDetector(
      onTap: () => handleSubmit(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MyColors.primaryColor,
        ),
        child: const Text(
          'REGISTER',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  //!fancy
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
            final things = await signUpAPI.signUpG(
                nice.displayName ?? "",
                nice.email ?? '',
                nice.phoneNumber ?? '  ',
                'none',
                'none',
                '000000',
                '000000',
                nice.photoURL ?? '');

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

//!fancy
  Widget _buildAppleSignInButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final provider =
            Provider.of<AppleLoginProvider>(context, listen: false);
        await provider.LoginWithApple();
        if (auth.FirebaseAuth.instance.currentUser != null) {
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
            Navigator.pop(context);
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
            Navigator.pop(context);
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

  Widget _makeSpace(BuildContext context) {
    return const SizedBox(height: 10);
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

//!drop down for gender
  Widget buildGender(BuildContext context) {
    return DropdownButtonFormField(
        decoration: const InputDecoration(
          hintText: 'Gender',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        isExpanded: false,
        items: const [
          DropdownMenuItem<String>(
            value: 'none',
            child: Text('none'),
          ),
          DropdownMenuItem<String>(
            value: 'Male',
            child: Text('Male'),
          ),
          DropdownMenuItem<String>(
            value: 'Female',
            child: Text('Female'),
          ),
        ],
        onChanged: ((value) {
          setState(() {
            gender = value.toString();
          });
        }));
  }

//!dropdown
  Widget buildAgeRange(BuildContext context) {
    return DropdownButtonFormField(
        decoration: const InputDecoration(
          hintText: 'Age Range',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
        isExpanded: false,
        items: const [
          DropdownMenuItem<String>(
            value: 'Under 12',
            child: Text('Under 12'),
          ),
          DropdownMenuItem<String>(
            value: '12 to 17',
            child: Text('12 to 17'),
          ),
          DropdownMenuItem<String>(
            value: '18 to 24',
            child: Text('18-24'),
          ),
          DropdownMenuItem<String>(
            value: '25-34',
            child: Text('25-34'),
          ),
          DropdownMenuItem<String>(
            value: '35 - 44',
            child: Text('35 - 44'),
          ),
          DropdownMenuItem<String>(
            value: '45 - 54',
            child: Text('45 - 54'),
          ),
          DropdownMenuItem<String>(
            value: '55 - 64',
            child: Text('55 - 64'),
          ),
          DropdownMenuItem<String>(
            value: '65 - 75',
            child: Text('65 - 74'),
          ),
          DropdownMenuItem<String>(
            value: 'Over 75',
            child: Text('Over 75'),
          ),
        ],
        onChanged: ((value) {
          setState(() {
            age_range = value.toString();
          });
        }));
  }

  //!Sign in method
  void handleSubmit() async {
    name = _nameController.text;
    email = _emailController.text;
    password = _passwordController.text;
    confirmPassword = _confirmPasswordController.text;
    mobile = _mobileController.text;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          const Center(child: CircularProgressIndicator.adaptive()),
    );

    data = await signUpAPI.signUp(
        name, email, mobile, gender, age_range, password, confirmPassword);
    Navigator.pop(context);

    final finalData = jsonDecode(data);
    print(data);
    if (finalData['success'] == true) {
      user = User.fromjson(finalData['data']);
      UserData.setUser(user);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DrawerApp()));
      showDialogs();
    } else {
      showDialog(
        context: context,
        builder: (context) => Platform.isAndroid
            ? AlertDialog(
                title: const Text('Error'),
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
                title: const Text('Error'),
                content: Text(finalData['data']),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
      );
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
