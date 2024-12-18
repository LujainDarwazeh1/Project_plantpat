

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/verify_email.dart';
import 'package:plantpat/src/screen/ipaddress.dart';

class Signup extends StatefulWidget {
  static String EmailSignup = '';

  @override
  SignupScreen createState() => SignupScreen();
}

class SignupScreen extends State<Signup> {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String userType = 'Buyer'; // Example default user type

  GlobalKey<FormState> formKey = GlobalKey<FormState>();







  @override
  Widget build(BuildContext context) {
    return kIsWeb ? buildWebSignup() : buildMobileSignup();
  }




   Widget buildMobileSignup() {
 
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -265.0,
            left: 0.0,
            child: Image.asset(
              'assets/images/sign_up.png',
              width: 400.0,
              fit: BoxFit.fitWidth,
              height: 700.0,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.only(top: 150.0), 
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: firstName,
decoration: InputDecoration(
  labelText: 'First Name',
  labelStyle: TextStyle(color: Colors.black), 
  hintText: 'Enter your first name',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.5),
),


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
                          decoration: InputDecoration(
  labelText: 'Last Name',
  labelStyle: TextStyle(color: Colors.black), 
  hintText: 'Enter your last name',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.5),
),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                           decoration: InputDecoration(
  labelText: 'Email',
labelStyle: TextStyle(color: Colors.black), 
  hintText: 'Enter your email',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.5),
),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                           decoration: InputDecoration(
  labelText: 'Password',
  labelStyle: TextStyle(color: Colors.black), 
  hintText: 'Enter your password',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.5),
),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: address,
                           decoration: InputDecoration(
  labelText: 'Address',
labelStyle: TextStyle(color: Colors.black),  
  hintText: 'Enter your address',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.5),
),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                         
                          TextFormField(
                            controller: phoneNumber,
                            keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
  labelText: 'Phone Number',
 labelStyle: TextStyle(color: Colors.black),  
  hintText: 'Enter your phone number',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(color: Colors.black), 
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.5),
),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                signupback(
                                  firstName.text,
                                  lastName.text,
                                  email.text,
                                  password.text,
                                  address.text,
                                  //  birthday.text,
                                  phoneNumber.text,
                                  userType,
                                );
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF4B8E4B)),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.symmetric(
                                          horizontal: 150.0, vertical: 13.0)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 1.0),
                                ),
                              ),
                            ),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0, // Adjust the font size here
                                fontWeight:
                                    FontWeight.bold, // Make the text bold
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xFF4B8E4B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


 Widget buildWebSignup() {
 
    return Scaffold(
      body: Stack(
        children: [
       Positioned(
  top: 0.0,
  left: 0.0,
  child: Align(
 
    child: SizedBox(
      width: MediaQuery.of(context).size.width, 
      child: Image.asset(
        'assets/images/signweb.png',
        fit: BoxFit.cover, 
        height: 200,
      ),
    ),
  ),
),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.only(top: 150.0), 
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: firstName,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              hintText: 'Enter your first name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                            ),
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
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              hintText: 'Enter your last name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: address,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              hintText: 'Enter your address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                         
                          TextFormField(
                            controller: phoneNumber,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              hintText: 'Enter your phone number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
SizedBox(height: 20),
Center(
  child: ElevatedButton(
    onPressed: () {
      if (formKey.currentState?.validate() ?? false) {
        signupback(
          firstName.text,
          lastName.text,
          email.text,
          password.text,
          address.text,
          phoneNumber.text,
          userType,
        );
      }
    },
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4B8E4B)),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 150.0, vertical: 13.0)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.0),
        ),
      ),
    ),
    child: Text(
      'Sign up',
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.0, 
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xFF4B8E4B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




  




  Future<void> signupback(
    String first_name,
    String last_name,
    String email,
    String password,
    String address,
  
    String phone_number,
    String userType,
  ) async {
    final url = Uri.parse('http://$ip:3000/plantpat/user/signup');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'first_name': first_name,
          'last_name': last_name,
          'email': email,
          'password': password,
          'address': address,
    
          'phone_number': phone_number,
          'user_type': userType,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          UserCredential credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VerifyEmail()));
        print('Signup successful');
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email already in use."),
        ));
        print('Email already in use.');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to authenticate.'),
        ));
        print('Failed to authenticate. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
