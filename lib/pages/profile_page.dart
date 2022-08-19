import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Profile/textFieds.dart';
import '../models/constants.dart';
import '../models/user.dart';
import '../services/page_service.dart';
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

  late User user;
  late String data;

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
    // TODO: implement initState
    super.initState();
    initControllers();

    switch (Provider.of<UserProvider>(context, listen: false).user!.gender) {
      case 'male':
        {
          isMale = true;
          break;
        }

      case 'female':
        {
          isFemale = true;
          break;
        }
      case 'none':
        {
          isOther = true;
          break;
        }
    }

    _nameController.text =
        Provider.of<UserProvider>(context, listen: false).user!.name;
    _emailController.text =
        Provider.of<UserProvider>(context, listen: false).user!.email;
    _countryController.text =
        Provider.of<UserProvider>(context, listen: false).user!.country!;

    _cityController.text =
        Provider.of<UserProvider>(context, listen: false).user!.city!;

    _phoneController.text =
        Provider.of<UserProvider>(context, listen: false).user!.mobile!;
    _ageController.text =
        Provider.of<UserProvider>(context, listen: false).user!.age_range!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                  child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        Provider.of<UserProvider>(context).user!.image!,
                      ),
                      radius: 80),
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
          ProfileTextField(
            controller: _ageController,
            hint: 'Age thingy',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Gender:'),
              ChoiceChip(
                backgroundColor: Colors.blueAccent.shade100,
                selectedColor: Color.fromARGB(255, 0, 0, 197),
                avatar: const Icon(
                  Icons.male,
                  color: Colors.white,
                ),
                label: const Text(
                  'male',
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
                    const Text('female', style: TextStyle(color: Colors.white)),
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
                label: const Text('none'),
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
          ProfileTextField(
            controller: _countryController,
            hint: 'Country',
          ),
          ProfileTextField(
            controller: _cityController,
            hint: 'City',
          ),
          _buildSignUpButton(context, 'UPDATE PROFILE'),
          ProfileTextField(
            controller: _currPassController,
            hint: 'Current Password',
          ),
          ProfileTextField(
            controller: _newPassController,
            hint: 'New Password',
          ),
          ProfileTextField(
            controller: _reNewPassController,
            hint: 'Re-enter New Password',
          ),
          _buildSignUpButton(context, 'CHANGE PASSWORD'),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
      child: GestureDetector(
        onTap: (text == 'UPDATE PROFILE')
            ? () => onUpdateProfile(context)
            : () => onChangePassword(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: MyColors.primaryColor,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }

//! Methods touching these is not recommended

  void onUpdateProfile(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Loading...'),
        content: CircularProgressIndicator.adaptive(),
      ),
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
      userProvider.user!.secret_key,
    );
    Navigator.pop(context);
    final finalData = jsonDecode(data)!;

    if (finalData['success'] == true) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'Success',
                  style: TextStyle(color: Colors.green),
                ),
                content: const Text("password updated"),
                actions: <Widget>[
                  FlatButton(
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
          builder: (context) => AlertDialog(
                title: const Text(
                  'Error',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(finalData['data']),
                actions: <Widget>[
                  FlatButton(
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
      builder: (context) => const AlertDialog(
        title: Text('Loading...'),
        content: CircularProgressIndicator.adaptive(),
      ),
    );

    data = await signUpAPI.updatePassword(
      userProvider.user!.id,
      _emailController.text,
      //_currPassController.text,
      _newPassController.text,
      _reNewPassController.text,
      userProvider.user!.secret_key,
    );
    Navigator.pop(context);

    final finalData = jsonDecode(data)!;

    if (finalData['success'] == true) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'Success',
                  style: TextStyle(color: Colors.green),
                ),
                content: const Text("Profile updated"),
                actions: <Widget>[
                  FlatButton(
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
          builder: (context) => AlertDialog(
                title: const Text(
                  'Error',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(finalData['data']),
                actions: <Widget>[
                  FlatButton(
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
    showCupertinoModalPopup(
        context: context,
        builder: ((context) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? photo =
                        await _picker.pickImage(source: ImageSource.camera);
                  },
                  child: const Text('Camera')),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? photo =
                        await _picker.pickImage(source: ImageSource.gallery);
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
        }));
  }
}
