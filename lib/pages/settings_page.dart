import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Custom/AnimeVals.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showNotifications = false;
  bool beacons = false;
  bool checkContent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Provider.of<Anime>(context, listen: false).handleDrawer,
        ),
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Beacons Settings',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey),
            ),
          ),
          ListTile(
            title: const Text('Show notificatoions'),
            onTap: () {
              setState(() {
                showNotifications = !showNotifications;
              });
            },
            trailing: Switch.adaptive(
                value: showNotifications,
                onChanged: (newbBol) {
                  setState(() {
                    showNotifications = newbBol;
                  });
                }),
          ),
          const Divider(),
          ListTile(
            title: const Text('Scan for beacons near me'),
            onTap: () {
              setState(() {
                beacons = !beacons;
              });
            },
            trailing: Switch.adaptive(
                value: beacons,
                onChanged: (newbBol) {
                  setState(() {
                    beacons = newbBol;
                  });
                }),
          ),
          const Divider(),
          ListTile(
            title: const Text('check for updates'),
            onTap: () {
              setState(() {
                checkContent = !checkContent;
              });
            },
            trailing: Switch.adaptive(
                value: checkContent,
                onChanged: (newbBol) {
                  setState(() {
                    checkContent = newbBol;
                  });
                }),
            //trailing: Switch.adaptive(value: value, onChanged: onChanged),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'App Settings',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey),
            ),
          ),
          ListTile(
            textColor: Colors.red,
            title: const Text(
              'Redownload app contents',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              setState(() {});
            },
            trailing: const Icon(
              Icons.download,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
