import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Profile/textFieds.dart';
import '../models/constants.dart';
import '../services/page_service.dart';
import 'Custom/AnimeVals.dart';
import 'package:virtual_ranger/apis/In.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                Container(
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
  Widget _buildSignUpButton(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
      child: GestureDetector(
        onTap: () => onUpdateProfile(context),
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

  void onUpdateProfile(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    signUpAPI.updateProfile(
      _nameController.text,
      _emailController.text,
      _phoneController.text,
      _countryController.text,
      _cityController.text,
      //_ageController.text,
      _newPassController.text,
      _reNewPassController.text,
    );
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
}
