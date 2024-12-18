import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AboutUsPage extends StatelessWidget {
  @override




Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        '107'.tr,
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: <Widget>[
          Text(
            '108'.tr,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '109'.tr,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '110'.tr,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 10.0),
          ProfileItem(
            imagePath: 'assets/images/luje.jpg',
            name: '111'.tr,
            onTap: () {
            
            },
          ),
          SizedBox(height: 20.0),
          ProfileItem(
            imagePath: 'assets/images/noor.jpg',
            name: '112'.tr,
          ),
        ],
      ),
    ),
  );
}
}

class ProfileItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final VoidCallback? onTap;

  ProfileItem({required this.imagePath, required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(width: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
