import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/pages/Profile/textFieds.dart';

import 'Custom/AnimeVals.dart';

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

  late final TextEditingController _currPassController;
  late final TextEditingController _newPassController;
  late final TextEditingController _reNewPassController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initControllers();
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
        padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
        child: ListView(children: [
          const Hero(
            tag: 'pic',
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
              radius: 100,
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
            controller: _nameController,
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
        ]),
      ),
    );
  }

//! Methods touching these is not recommended
  void initControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _countryController = TextEditingController();
    _cityController = TextEditingController();
    _currPassController = TextEditingController();
    _newPassController = TextEditingController();
    _reNewPassController = TextEditingController();
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
  }
}
