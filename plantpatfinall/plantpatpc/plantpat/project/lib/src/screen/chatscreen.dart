import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/login_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> allUserName = [];
  String firstNameSender = '';
  String lastNameSender = '';
  String firstNameReceiver = '';
  String lastNameReceiver = '';

  @override
  void initState() {
    super.initState();
    buildUserList();
  }

  void buildUserList() async {
   
    await getProfileImageForChat(Login.idd, Login.FirstName);
    await getName(Login.Email);
  }

  Future<void> getProfileImageForChat(int userId, String first) async {
    try {
      final response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/getProfileImage?userId=$userId'));
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
          List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(responseData['results']);
          final myRes = result[0];
          final imageData = myRes['profile_image'];

          if (imageData != null) {
            Uint8List? bytes = Uint8List.fromList(List<int>.from(imageData['data']));
            bool nameExists = allUserName.any((userInfo) => userInfo['first_name'] == first);
            if (!nameExists) {
              setState(() {
                allUserName.add({
                  'first_name': first,
                  'image': bytes,
                });
              });
            }
          }
        } else {
          print('Failed to fetch profile image.');
        }
      } else {
        print('Failed to fetch profile image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile image: $e');
    }
  }

  Future<void> getName(String email) async {
    try {
      final response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/userName?email=$email'));
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        if (responseData is List && responseData.isNotEmpty) {
          dynamic user = responseData[0];
          setState(() {
            firstNameSender = user['first_name'];
            lastNameSender = user['last_name'];
          });
        } else {
          throw Exception('Empty or invalid response');
        }
      } else {
        throw Exception('Failed to fetch user name. Status code: ${response.statusCode}');
      }

      var snapshot = await FirebaseFirestore.instance
          .collection('Theusers')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
      
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: ListView.builder(
        itemCount: allUserName.length,
        itemBuilder: (context, index) {
          final user = allUserName[index];
          return ListTile(
            leading: user['image'] != null
                ? CircleAvatar(
                    backgroundImage: MemoryImage(user['image']),
                  )
                : CircleAvatar(child: Icon(Icons.person)),
            title: Text(user['first_name']),
          );
        },
      ),
    );
  }
}
