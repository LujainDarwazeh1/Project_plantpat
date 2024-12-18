import 'dart:convert'; 
import 'dart:typed_data'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; 
import 'package:plantpat/src/screen/aboutus.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/multiLanguage.dart';
import 'package:plantpat/src/screen/welcom.dart';
import 'profile.dart';
import 'change_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
 static ImageProvider? userImage; 
  String firstName = Login.FirstName; 
  String lastName = Login.LastName; 

  @override
  void initState() {
    super.initState();

     _fetchUserImage();
    
   
  }

    Future<void> _fetchUserImage() async {
  
    await getImageOfUser(Login.idd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '38'.tr,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundImage: userImage,
              ),
            ),
            title: Text("$firstName $lastName"),
          ),
          SizedBox(height: 25),
          Text('39'.tr, style: TextStyle(color: Colors.grey)),
          ListTile(
            title: Text('8'.tr), 
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            title: Text('6'.tr), 
            trailing: Icon(Icons.arrow_forward_ios),
           onTap: () {
        _showDeleteConfirmationDialog(context);
      },
          ),
          ListTile(
            title: Text('7'.tr),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              );
            },
          ),
          ListTile(
            title: Text('5'.tr), 
            trailing: Icon(Icons.arrow_forward_ios),

           
onTap: () async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Login()),
  );

}

          ),
        
           ListTile(
  title: Text('1'.tr), 
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiLanguage(), 
      ),
    );
  },
),

          SizedBox(height: 30),
          Text(('9'.tr), style: TextStyle(color: Colors.grey)),
          ListTile(
           title: Text('4'.tr), 
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
            

 Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AboutUsPage(), 
      ),
    );

            },
          ),
          ListTile(
            title: Text('10'.tr),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
            
            },
          ),
          ListTile(
            title: Text('11'.tr),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
            
            },
          ),
        ],
      ),
    );
  }



void _showDeleteConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          '113'.tr,
          style: TextStyle(
            fontSize: 18.0, 
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
           
              Navigator.of(context).pop();
            },
            child: Text(
              '114'.tr,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.0, 
              ),
            ),
          ),
          TextButton(
            onPressed: () {
           
              Navigator.of(context).pop();
            },
            child: Text(
              '115'.tr,
              style: TextStyle(
                color: Colors.green,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      );
    },
  );
}


  Future<void> getImageOfUser(int userId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://$ip:3000/plantpat/user/getProfileImage?userId=$userId')); 
      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('results')) {
          final userData = responseData['results'][0]; 
          final imageData = userData['profile_image'];

          if (imageData is Map<String, dynamic> &&
              imageData.containsKey('data')) {
            final byteData = imageData['data'];
            final imageBytes = Uint8List.fromList(List<int>.from(byteData));

            setState(() {
              userImage = MemoryImage(imageBytes);
            });
          } else {
            print('Image data not found in response.');
          }
        } else {
          print('Failed to fetch user data.');
        }
      } else {
        print('Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user image: $e');
    }
  }

  
}
