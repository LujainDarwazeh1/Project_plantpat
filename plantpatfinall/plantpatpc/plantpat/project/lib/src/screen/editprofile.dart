import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/ipaddress.dart';

class editprofile extends StatefulWidget {
  @override
  EditProfileScreen createState() => EditProfileScreen();
}

class EditProfileScreen extends State<editprofile> {
  static TextEditingController firstName = TextEditingController();
  static TextEditingController lastName = TextEditingController();
  static TextEditingController email = TextEditingController();
  static TextEditingController phoneA = TextEditingController();
  static TextEditingController address = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firstName.text = Login.first_name;
    lastName.text = Login.last_name;
    email.text = Login.Email;
    phoneA.text = Login.phonenumberr;
    address.text = Login.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    updateProfile();
                  }
                },
                child: Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    final url = Uri.parse('http://$ip:3000/plantpat/edit/editprofile');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': Login.idd,
          'firstName': firstName.text,
          'lastName': lastName.text,
          'email': email.text,
          'address': address.text,
          'phoneNumber': phoneA.text,
         
        }),
      );
      if (response.statusCode == 200) {
        
        print('Profile updated successfully');

        
        setState(() {
          print('Updated values:');
          print('First Name: ${firstName.text}');
          print('Last Name: ${lastName.text}');
          print('Email: ${email.text}');
          print('Address: ${address.text}');
          print('Phone Number: ${phoneA.text}');
          Login.first_name = firstName.text;
          Login.last_name = lastName.text;
          Login.Email = email.text;
          Login.address = address.text;
          Login.phonenumberr = phoneA.text;
         
        });

       
        Navigator.pop(context);
      } else {
       
        print('Failed to update profile');
      }
    } catch (e) {
     
      print('Error: $e');
    }
  }
}
