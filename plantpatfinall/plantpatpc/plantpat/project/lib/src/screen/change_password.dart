import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantpat/src/screen/forget_password.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/login_screen.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  static ImageProvider? userImage; 

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    getImageOfUser(Login.idd); 
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

  Future<void> updatePassword(String email, String newPassword) async {
    try {
      final response = await http.put(
        Uri.parse('http://$ip:3000/plantpat/user/UpdatePass'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Password updated successfully in backend');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        
      } else {
        print('Failed to update password in backend');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update password '),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  // Future<void> changePassword(String email, String oldPass, String newPass) async {
  //   try {
  //     print("pld pass:");
  //         print(oldPass);
  //         print("new pass:");
  //         print(newPass);

  //     var cred = EmailAuthProvider.credential(email: email, password: oldPass);
  //     await currentUser!.reauthenticateWithCredential(cred)
  //       .then((value) async {
  //         await currentUser!.updatePassword(newPass);
  //         print('Password updated successfully in Firebase');

  //       })
  //       .catchError((error) {
  //         print('Error updating password in Firebase: ${error.toString()}');
  //       });
  //   } catch (e) {
  //     print('Error during password change: $e');
  //   }
  // }

  Future<bool> checkOldPassword(String email, String oldPassword) async {
    try {
      final response = await http.post(
        Uri.parse('http://$ip:3000/plantpat/user/oldpassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'oldPassword': oldPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Old password verification failed');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Old password verification failed'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      print('Error checking old password: $e');
      return false;
    }
  }

  void handleConfirm() async {
    final email = Login.Email; 
    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      print('New password and confirmation do not match');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New password and confirmation do not match'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final isOldPasswordCorrect = await checkOldPassword(email, oldPassword);

    if (isOldPasswordCorrect) {
      await updatePassword(email, newPassword);
    } else {
      print('Old password is incorrect');
    }
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
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        userImage ?? AssetImage('assets/images/nohuman.png'),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${Login.FirstName} ${Login.LastName}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '81'.tr,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 20),
              TextField(
                controller: oldPasswordController,
                decoration: InputDecoration(
                  labelText: '82'.tr,
                  labelStyle: TextStyle(color: Colors.black), 
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .green), 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .grey), 
                  ),
                ),
                obscureText: true, 
              ),
              SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: '83'.tr,
                  labelStyle: TextStyle(color: Colors.black), 
                  border: OutlineInputBorder(), 
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .green), 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .grey), 
                  ),
                ),
                obscureText: true, 
              ),
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: '84'.tr,
                  labelStyle: TextStyle(color: Colors.black), 
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .green), 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .grey), 
                  ),
                ),
                obscureText: true, 
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgetPassword()),
                    );
                  },
                  child: Text(
                    '85'.tr,
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '86'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
