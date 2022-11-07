import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:virtual_ranger/apis/permissionsapi.dart';
import 'package:virtual_ranger/pages/Profile/textFieds.dart';
import 'package:virtual_ranger/pages/prePage.dart';
import 'package:virtual_ranger/pages/splash_screen.dart';
import '../models/constants.dart';
import '../models/user.dart';
import '../services/page_service.dart';
import '../services/shared_preferences.dart';
import 'Custom/AnimeVals.dart';
import 'package:virtual_ranger/apis/In.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool isMale = false;
  late bool isFemale = false;
  late bool isOther = false;
  bool show = false;

  late User user;
  late String data;
  late File imageFile;
  late String dir;

  String makeGender() {
    if (isMale) {
      return 'male';
    } else if (isFemale) {
      return 'female';
    } else {
      return 'none';
    }
  }

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _ageController;

  late final TextEditingController _currPassController;
  late final TextEditingController _newPassController;
  late final TextEditingController _reNewPassController;

  @override
  void initState() {
    super.initState();
    initControllers();
    getApplicationDocumentsDirectory().then((directory) {
      final dir = directory;
      imageFile = File('${dir.path}/ProfilePhoto.jpg');
    });

    switch (Provider.of<UserProvider>(context, listen: false).user!.gender) {
      case 'male':
        {
          setState(() {
            isMale = true;
          });

          break;
        }

      case 'female':
        {
          setState(() {
            isFemale = true;
          });

          break;
        }
      case 'none':
        {
          setState(() {
            isOther = true;
          });

          break;
        }
      //default case
      default:
        {
          setState(() {
            isOther = true;
          });
        }
    }

    _nameController.text =
        Provider.of<UserProvider>(context, listen: false).user!.name;
    _emailController.text =
        Provider.of<UserProvider>(context, listen: false).user!.email;
    if ((Provider.of<UserProvider>(context, listen: false).user!.country ??
            "") ==
        'unknown') {
      _countryController.text = "";
    } else {
      _countryController.text =
          Provider.of<UserProvider>(context, listen: false).user!.country ?? "";
    }

    if ((Provider.of<UserProvider>(context, listen: false).user!.city ?? "")
            .toLowerCase() ==
        'other') {
      _cityController.text = "";
    } else {
      _cityController.text =
          Provider.of<UserProvider>(context, listen: false).user!.city ?? "";
    }

    if ((Provider.of<UserProvider>(context, listen: false).user!.mobile ??
            "") ==
        'unknown') {
      _phoneController.text = "";
    } else {
      _phoneController.text =
          Provider.of<UserProvider>(context, listen: false).user!.mobile ?? "";
    }

    _ageController.text =
        Provider.of<UserProvider>(context, listen: false).user!.age_range ?? "";
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        title: const Text("My Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: ListView(children: [
          Center(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child:
                      (Provider.of<UserProvider>(context).user!.isImageNull())
                          ? const CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  AssetImage('lib/assets/noPro.jpg'),
                            )
                          : Provider.of<UserProvider>(context).user!.image == ''
                              ? const CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      AssetImage('lib/assets/noPro.jpg'),
                                )
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.green,
                                  backgroundImage: CachedNetworkImageProvider(
                                      Provider.of<UserProvider>(context)
                                              .user!
                                              .image ??
                                          'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'),
                                ),
                ),
                GestureDetector(
                  onTap: () {
                    handleImagePicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            // style: BorderStyle.s,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 5),
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(1)),
                    child: const Icon(CupertinoIcons.pencil,
                        size: 30, color: Colors.amber),
                  ),
                )
              ],
            ),
          ),
          ProfileTextField(
            controller: _nameController,
            hint: 'Name',
          ),
          ProfileTextField(
            controller: _emailController,
            hint: 'Email',
          ),
          ProfileTextField(
            controller: _phoneController,
            hint: 'phone Number',
          ),
          CupertinoTextField(
            onTap: () {
              show = true;
              setState(() {});
            },
            style: TextStyle(
              color: Colors.grey.shade600,
              //fontSize: 14,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            controller: _ageController,
            placeholder: 'Age Range',
          ),
          show ? buildAgeRange(context) : SizedBox(),
          ProfileTextField(
            controller: _countryController,
            hint: 'Country',
          ),
          ProfileTextField(
            controller: _cityController,
            hint: 'City',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Gender:', style: TextStyle(fontSize: 18)),
              ChoiceChip(
                backgroundColor: Colors.blueAccent.shade100,
                selectedColor: Color.fromARGB(255, 0, 0, 197),
                avatar: const Icon(
                  Icons.male,
                  color: Colors.white,
                ),
                label: const Text(
                  'Male',
                  style: TextStyle(color: Colors.white),
                ),
                selected: isMale,
                onSelected: (value) {
                  setState(() {
                    if (!isMale) {
                      isMale = value;
                      isFemale = false;
                      isOther = false;
                    }
                  });
                },
              ),
              ChoiceChip(
                backgroundColor: Colors.pinkAccent.shade100,
                selectedColor: Colors.pink,
                avatar: const Icon(
                  Icons.female,
                  color: Colors.white,
                ),
                label:
                    const Text('Female', style: TextStyle(color: Colors.white)),
                selected: isFemale,
                onSelected: (value) {
                  setState(() {
                    if (!isFemale) {
                      isFemale = value;
                      isMale = false;
                      isOther = false;
                    }
                  });
                },
              ),
              ChoiceChip(
                backgroundColor: Colors.greenAccent.shade100,
                selectedColor: Colors.green,
                label: const Text('None'),
                selected: isOther,
                onSelected: (value) {
                  setState(() {
                    if (!isOther) {
                      isFemale = false;
                      isMale = false;
                      isOther = value;
                    } else {
                      if (!isFemale && !isMale) {
                        isOther = true;
                      }
                    }
                  });
                },
              ),
            ],
          ),
          _buildSignUpButton(context, 'UPDATE PROFILE'),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'CHANGE PASSWORD',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ProfileTextField(
            controller: _currPassController,
            hint: 'Current Password',
            obscureText: true,
          ),
          ProfileTextField(
            controller: _newPassController,
            hint: 'New Password',
            obscureText: true,
          ),
          ProfileTextField(
            controller: _reNewPassController,
            hint: 'Re-enter New Password',
            obscureText: true,
          ),
          _buildSignUpButton(context, 'CHANGE PASSWORD'),
          deleteAccount(context),
        ]),
      ),
    );
  }

//! widgets
  Widget _buildSignUpButton(
    BuildContext context,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: GestureDetector(
        onTap: (text == 'UPDATE PROFILE')
            ? () => onUpdateProfile(context)
            : () => onChangePassword(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: MyColors.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget deleteAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return Platform.isAndroid
                    ? AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                            'Are you sure you want to delete your account?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  clipBehavior: Clip.hardEdge,
                                  context: context,
                                  builder: ((context) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //header
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Delete Account',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey.shade200,
                                                  ),
                                                  child: IconButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      icon: Icon(Icons.close)),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Text(
                                              textAlign: TextAlign.start,
                                              '~This action cannot be undone.',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blueGrey),
                                            ),
                                            const Text(
                                              textAlign: TextAlign.start,
                                              '~All your data will be deleted.',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blueGrey),
                                            ),
                                            const Text(
                                              textAlign: TextAlign.start,
                                              '~Sightings you have added will remain untill they time out, since they are not linked to your account.',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blueGrey),
                                            ),
                                            const Text(
                                              textAlign: TextAlign.start,
                                              '~You will be logged out.',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blueGrey),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SlideAction(
                                                outerColor: CupertinoColors
                                                    .destructiveRed,
                                                sliderButtonIcon:
                                                    Icon(CupertinoIcons.delete),
                                                elevation: 0,
                                                child: const Text(
                                                  'Slide to Delete',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onSubmit: () {
                                                  //TODO: Implement a method to delete the user
                                                  final userProvider =
                                                      Provider.of<UserProvider>(
                                                          context,
                                                          listen: false);

                                                  signUpAPI
                                                      .deleteAccount(
                                                          UserData.user.id,
                                                          userProvider.user!
                                                                  .secret_key ??
                                                              '')
                                                      .then(
                                                    (value) {
                                                      final data =
                                                          jsonDecode(value);
                                                      data['success']
                                                          ? {
                                                              Navigator.pop(
                                                                  context),
                                                              Navigator.pop(
                                                                  context),
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                    return const PrepPage();
                                                                  },
                                                                ),
                                                              )
                                                            }
                                                          : showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  CupertinoAlertDialog(
                                                                    title: Text(
                                                                        'Error'),
                                                                    content: Text(
                                                                        'Something went wrong, please try again later'),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context),
                                                                          child:
                                                                              Text('Ok'))
                                                                    ],
                                                                  ));
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              )),
                        ],
                      )
                    : CupertinoAlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                            'Are you sure you want to delete your account?'),
                        actions: [
                          CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          CupertinoDialogAction(
                              onPressed: () {
                                // Provider.of<UserProvider>(context, listen: false)
                                //     .deleteUser();
                                //areYousure(context);

                                Navigator.pop(context);
                                showCupertinoModalPopup(
                                    barrierColor: Colors.black.withOpacity(.3),
                                    context: context,
                                    builder: (context) {
                                      return CupertinoActionSheet(
                                        title: const Text(
                                          'Final confirmation',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        message: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                textAlign: TextAlign.start,
                                                '~This action cannot be undone.',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              const Text(
                                                textAlign: TextAlign.start,
                                                '~All your data will be deleted.',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              const Text(
                                                textAlign: TextAlign.start,
                                                '~Sightings you have added will remain untill they time out, since they are not linked to your account.',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              const Text(
                                                textAlign: TextAlign.start,
                                                '~You will be logged out.',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SlideAction(
                                                  outerColor: CupertinoColors
                                                      .destructiveRed,
                                                  sliderButtonIcon: Icon(
                                                      CupertinoIcons.delete),
                                                  elevation: 0,
                                                  child: const Text(
                                                    'Slide to Delete',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onSubmit: () {
                                                    final userProvider =
                                                        Provider.of<
                                                                UserProvider>(
                                                            context,
                                                            listen: false);
                                                    signUpAPI
                                                        .deleteAccount(
                                                            UserData.user.id,
                                                            UserData.user
                                                                    .secret_key ??
                                                                '')
                                                        .then((value) {
                                                      final data =
                                                          jsonDecode(value);
                                                      data['success']
                                                          ? {
                                                              Navigator.pop(
                                                                  context),
                                                              Navigator.pop(
                                                                  context),
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                    return const PrepPage();
                                                                  },
                                                                ),
                                                              )
                                                            }
                                                          : showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  CupertinoAlertDialog(
                                                                    title: const Text(
                                                                        'Error',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red)),
                                                                    content:
                                                                        Text(
                                                                      data[
                                                                          'data'],
                                                                    ),
                                                                    actions: [
                                                                      CupertinoDialogAction(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('Ok'))
                                                                    ],
                                                                  ));
                                                    });
                                                  },
                                                ),
                                              ),
                                            ]),
                                        actions: [
                                          CupertinoActionSheetAction(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              )),
                        ],
                      );
                ;
              });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          child: const Text(
            'DELETE MY ACCOUNT',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
//! Methods, touching these is not recommended

  void onUpdateProfile(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          const Center(child: CircularProgressIndicator.adaptive()),
    );

    data = await signUpAPI.updateProfile(
      userProvider.user!.id,
      _nameController.text,
      _emailController.text,
      _phoneController.text,
      _ageController.text,
      makeGender(),
      _countryController.text,
      _cityController.text,
      userProvider.user!.secret_key!,
    );
    Navigator.pop(context);
    final finalData = jsonDecode(data)!;

    if (finalData['success'] == true) {
      Provider.of<UserProvider>(context, listen: false)
          .setUser(User.fromjson(finalData['data']));
      UserData.setUser(User.fromjson(finalData['data']));
      showDialog(
          context: context,
          builder: (context) => Platform.isAndroid
              ? AlertDialog(
                  title: const Text(
                    'Success',
                    style: TextStyle(color: Colors.green),
                  ),
                  content: const Text("profile updated"),
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
                    'Success',
                    style: TextStyle(color: Colors.green),
                  ),
                  content: const Text("profile updated"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ));
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
    }
  }

  void onChangePassword(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          const Center(child: CircularProgressIndicator.adaptive()),
    );

    data = await signUpAPI.updatePassword(
      userProvider.user!.id,
      _emailController.text,
      //_currPassController.text,
      _newPassController.text,
      _reNewPassController.text,
      userProvider.user!.secret_key!,
    );
    Navigator.pop(context);

    final finalData = jsonDecode(data)!;

    if (finalData['success'] == true) {
      showDialog(
        context: context,
        builder: (context) => Platform.isAndroid
            ? AlertDialog(
                title: const Text(
                  'Success',
                  style: TextStyle(color: Colors.green),
                ),
                content: const Text("Profile updated"),
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
                  'Success',
                  style: TextStyle(color: Colors.green),
                ),
                content: const Text("Profile updated"),
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
    }
  }

//! initControllers
  void initControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _countryController = TextEditingController();
    _cityController = TextEditingController();
    _currPassController = TextEditingController();
    _newPassController = TextEditingController();
    _reNewPassController = TextEditingController();
    _ageController = TextEditingController();
  }

  void disposeControllers() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _currPassController.dispose();
    _newPassController.dispose();
    _reNewPassController.dispose();
    _ageController.dispose();
  }

  void handleImagePicker() {
    Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: ((context) {
              return CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                  child: CircularProgressIndicator.adaptive());
                            });

                        final ImagePicker _picker = ImagePicker();
                        final File? photo = await _picker
                            .pickImage(source: ImageSource.camera)
                            .then((image) async {
                          if (image != null) {
                            Dio dio = Dio();
                            //FormData formData = FormData.fromMap({});

                            final response = dio.post(
                              "http://dinokengapp.co.za/edit_profile",
                              data: FormData.fromMap({
                                "profile_image":
                                    await MultipartFile.fromFile(image.path),
                                "id": Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .id,
                                "email": Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .email,
                                "user_role": "Attendee",
                                "secret_key": Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user!
                                        .secret_key ??
                                    ' ',
                              }),
                            );
                            await response.then((value) {
                              final data = value.data;
                              print(data);
                              User UserToBe = User.fromjson(data['data']);
                              UserData.setUser(UserToBe);
                              Provider.of<UserProvider>(context, listen: false)
                                  .setUser(UserToBe);
                            });

                            Navigator.pop(context);
                          }
                          Navigator.pop(context);
                          return;
                        });
                      },
                      child: const Text('Camera')),
                  CupertinoActionSheetAction(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? photo = await _picker
                            .pickImage(source: ImageSource.gallery)
                            .then((Image) async {
                          if (Image != null) {
                            Dio dio = Dio();
                            FormData formData = FormData.fromMap({});
                            final response = dio.post(
                              "http://dinokengapp.co.za/edit_profile",
                              data: FormData.fromMap({
                                "profile_image":
                                    await MultipartFile.fromFile(Image.path),
                                "id": Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .id,
                                "email": Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .email,
                                "user_role": "Attendee",
                                "secret_key": Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user!
                                        .secret_key ??
                                    ' ',
                              }),
                            );

                            //showDialog
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                });

                            await response.then((value) {
                              final data = value.data;
                              print(data);
                              User UserToBe = User.fromjson(data['data']);
                              //set user to shared prefs
                              UserData.setUser(UserToBe);
                              print(UserToBe.name);
                              Provider.of<UserProvider>(context, listen: false)
                                  .setUser(UserToBe);
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }

                          return;
                        });
                      },
                      child: const Text('Gallery')),
                ],
                cancelButton: CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
              );
            }))
        : showModalBottomSheet(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            builder: (BuildContext context) {
              return Container(
                  child: ListView(
                      padding: EdgeInsets.only(bottom: 50),
                      shrinkWrap: true,
                      children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Camera'),
                      onTap: () async {
                        Permissionsapi.askCameraPermission();
                        final ImagePicker _picker = ImagePicker();
                        final File? photo = await _picker
                            .pickImage(source: ImageSource.camera)
                            .then((image) async {
                          if (image != null) {
                            Dio dio = Dio();
                            FormData formData = FormData.fromMap({});
                            final response = dio.post(
                              "http://dinokengapp.co.za/edit_profile",
                              data: FormData.fromMap({
                                "profile_image":
                                    await MultipartFile.fromFile(image.path),
                                "id": Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .id,
                                "email": Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .email,
                                "user_role": "Attendee",
                                "secret_key": Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user!
                                        .secret_key ??
                                    ' ',
                              }),
                            );

                            //showDialog
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                });

                            await response.then((value) {
                              final data = value.data;
                              print(data);
                              User UserToBe = User.fromjson(data['data']);
                              //set user to shared prefs
                              UserData.setUser(UserToBe);
                              print(UserToBe.name);
                              Provider.of<UserProvider>(context, listen: false)
                                  .setUser(UserToBe);
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }

                          return;
                        });
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo),
                      title: Text('Gallery'),
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        final File? photo = await _picker
                            .pickImage(source: ImageSource.gallery)
                            .then((Image) async {
                          if (Image != null) {
                            Dio dio = Dio();
                            FormData formData = FormData.fromMap({});
                            final response = dio.post(
                              "http://dinokengapp.co.za/edit_profile",
                              data: FormData.fromMap({
                                "profile_image":
                                    await MultipartFile.fromFile(Image.path),
                                "id": Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .id,
                                "email": Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .email,
                                "user_role": "Attendee",
                                "secret_key": Provider.of<UserProvider>(context,
                                            listen: false)
                                        .user!
                                        .secret_key ??
                                    ' ',
                              }),
                            );

                            //showDialog
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                });

                            await response.then((value) {
                              final data = value.data;
                              print(data);
                              User UserToBe = User.fromjson(data['data']);
                              //set user to shared prefs
                              UserData.setUser(UserToBe);
                              print(UserToBe.name);
                              Provider.of<UserProvider>(context, listen: false)
                                  .setUser(UserToBe);
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }

                          return;
                        });
                      },
                    )
                    //cancel button
                    ,
                    TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.red,
                            textStyle: const TextStyle(fontSize: 20)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'))
                  ]));

              //end
            },
//ends here
          );
  }

//!dropdown
  Widget buildAgeRange(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField(
          decoration: const InputDecoration(
            hintText: 'Edit age range',
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
              _ageController.text = value.toString();
              show = !show;
            });
          })),
    );
  }
}
