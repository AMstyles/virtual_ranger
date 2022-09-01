import 'package:flutter/material.dart';
import 'package:virtual_ranger/models/animalforSIGHT.dart';

class LegendWidget extends StatelessWidget {
  LegendWidget({Key? key, required this.animalSight, required this.callback})
      : super(key: key);
  AnimalSight animalSight;
  VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: animalSight.color,
        radius: 20,
      ),
      title: Text(animalSight.name, style: TextStyle(fontSize: 20)),
      trailing: IconButton(
          onPressed: () {
            callback();
          },
          icon: Icon(
            Icons.remove_red_eye,
            color: Colors.blue,
          )),
    );
  }
}

class ChooseWidget extends StatelessWidget {
  ChooseWidget({Key? key, required this.animalSight, required this.callback})
      : super(key: key);
  AnimalSight animalSight;
  VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Colors.green,
      onTap: () {
        callback();
      },
      title: Text(animalSight.name, style: TextStyle(fontSize: 20)),
    );
  }
}
