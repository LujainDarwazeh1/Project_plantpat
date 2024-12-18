import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/forget_password.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class NewPass extends StatefulWidget {
  @override
  NewPassword createState() => NewPassword();
}

class NewPassword extends State<NewPass> {
  bool valpass = false;
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser;

  bool _obscurePassword = true;

  void togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         // Background Image
  //         Positioned(
  //           top: -230.0,
  //           left: 0.0,
  //           child: Image.asset(
  //             'assets/images/y.jpg',
  //             width: 400.0,
  //             fit: BoxFit.fitWidth,
  //             height: 700.0,
  //           ),
  //         ),
  //         // Main content centered
  //         Center(
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //             child: SingleChildScrollView(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     SizedBox(height: 200.0),
  //                     // New Password Field
  //                     PasswordField(
  //                       controller: passwordController1,
  //                       obscureText: !valpass,
  //                       hintText: 'New Password',
  //                       toggleVisibility: () {
  //                         setState(() {
  //                           valpass = !valpass;
  //                         });
  //                       },
  //                     ),
  //                     SizedBox(height: 20),
  //                     // Confirm Password Field
  //                     PasswordField(
  //                       controller: passwordController2,
  //                       obscureText: !valpass,
  //                       hintText: 'Confirm Password',
  //                       toggleVisibility: () {
  //                         setState(() {
  //                           valpass = !valpass;
  //                         });
  //                       },
  //                     ),
  //                     SizedBox(height: 20),
  //                     // Update Password Button
  //                     ElevatedButton(
  //                       onPressed: () async {
  //                         if (formKey.currentState!.validate() &&
  //                             passwordController2.text ==
  //                                 passwordController1.text) {
  //                           String email = Login.Email.isNotEmpty
  //                               ? Login.Email
  //                               : ForgetPass.emailUser;
  //                           await updatePassword(
  //                               email, passwordController1.text);
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(builder: (context) => Login()),
  //                           );
  //                         } else {
  //                           ScaffoldMessenger.of(context)
  //                               .showSnackBar(const SnackBar(
  //                             content: Text("Passwords do not match"),
  //                           ));
  //                         }
  //                       },
  //                       style: ButtonStyle(
  //                         backgroundColor: MaterialStateProperty.all<Color>(
  //                             Color(0xFF4B8E4B)),
  //                         padding:
  //                             MaterialStateProperty.all<EdgeInsetsGeometry>(
  //                                 EdgeInsets.symmetric(
  //                                     horizontal: 50.0, vertical: 13.0)),
  //                         shape:
  //                             MaterialStateProperty.all<RoundedRectangleBorder>(
  //                           RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(10.0),
  //                             side: BorderSide(
  //                                 color: Colors.white.withOpacity(0.5),
  //                                 width: 1.0),
  //                           ),
  //                         ),
  //                       ),
  //                       child: Text(
  //                         'Update Password',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 18.0,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned(
//             top: -230.0,
//             left: 0.0,
//             child: Image.asset(
//               'assets/images/y.jpg',
//               width: 400.0,
//               fit: BoxFit.fitWidth,
//               height: 700.0,
//             ),
//           ),
//           // Main content centered
//           Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Text(
//                       //   'New Password',
//                       //   style: TextStyle(
//                       //     color: Colors.black,
//                       //     fontWeight: FontWeight.bold,
//                       //   ),
//                       // ),
//                       SizedBox(height: 7.0),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(10.0),
//                           border: Border.all(
//                             color: Colors.black.withOpacity(0.5),
//                             width: 1.0,
//                           ),
//                         ),
//                         child: TextFormField(
//                           controller: passwordController1,
//                           obscureText: _obscurePassword,


//                           decoration: InputDecoration(
//                             hintText: 'New Password',
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 16.0, vertical: 12.0),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
                                
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Theme.of(context).primaryColorDark,
//                               ),
//                               onPressed: togglePasswordVisibility,
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       // Text(
//                       //   'Confirm New Password',
//                       //   style: TextStyle(
//                       //     color: Colors.black,
//                       //     fontWeight: FontWeight.bold,
//                       //   ),
//                       // ),
//                       SizedBox(height: 7.0),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(10.0),
//                           border: Border.all(
//                             color: Colors.black.withOpacity(0.5),
//                             width: 1.0,
//                           ),
//                         ),
//                         child: TextFormField(
//                           controller: passwordController2,
//                           obscureText: _obscurePassword,
//                           decoration: InputDecoration(
//                             hintText: 'Confirm Password',
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 16.0, vertical: 12.0),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
                                
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Theme.of(context).primaryColorDark,
//                               ),
//                               onPressed: togglePasswordVisibility,
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       // Update Password Button
//                      Center(
//   child: ElevatedButton(
//     onPressed: () async {
//       if (formKey.currentState!.validate() &&
//           passwordController2.text == passwordController1.text) {
//         String email = Login.Email.isNotEmpty
//             ? Login.Email
//             : ForgetPass.emailUser;
//         await updatePassword(email, passwordController1.text);
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Login()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Passwords do not match"),
//           ),
//         );
//       }
//     },
//     style: ButtonStyle(
//       backgroundColor: MaterialStateProperty.all<Color>(
//         Color(0xFF4B8E4B),
//       ),
//       padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//         EdgeInsets.symmetric(horizontal: 40.0, vertical: 13.0),
//       ),
//       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           side: BorderSide(
//             color: Colors.white.withOpacity(0.5),
//             width: 1.0,
//           ),
//         ),
//       ),
//     ),
//     child: Text(
//       'Update Password',
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 18.0,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   ),
// )

//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        
          Positioned(
            top: -230.0,
            left: 0.0,
            child: Image.asset(
              'assets/images/y.jpg',
              width: 400.0,
              fit: BoxFit.fitWidth,
              height: 700.0,
            ),
          ),
        
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            child: TextFormField(
                              controller: passwordController1,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                             
                                labelStyle: TextStyle(color: Colors.black),
                                hintText: 'Enter your New Password',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.5),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: togglePasswordVisibility,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirm Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.5),
                                width: 1.0,
                              ),
                            ),
                            child: TextFormField(
                              controller: passwordController2,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                             
                                labelStyle: TextStyle(color: Colors.black),
                                hintText: 'Re-enter your password',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.5),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: togglePasswordVisibility,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please confirm your password"),
          ),
        );
                                
                                }
                                if (value != passwordController1.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
          ),
        );
                              
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: ElevatedButton(
  onPressed: () async {

    if (formKey.currentState!.validate()) {
     
      if (passwordController1.text == passwordController2.text) {
     
        String email = Login.Email.isNotEmpty
            ? Login.Email
            : ForgetPass.emailUser;
        await updatePassword(email, passwordController1.text);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
     
       
      }
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
          ),
        );
    }
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      Color(0xFF4B8E4B),
    ),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(horizontal: 40.0, vertical: 13.0),
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Colors.white.withOpacity(0.5),
          width: 1.0,
        ),
      ),
    ),
  ),
  child: Text(
    'Update Password',
    style: TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
  ),
)

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















  Future<void> updatePassword(String email, String newPassword) async {
    print(
        'Updating password for email: $email with new password: $newPassword');
    try {
      final response = await http.put(
        Uri.parse('http://$ip:3000/plantpat/edit/UpdatePass'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'newPassword': newPassword,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        
        print('Password updated successfully');
      } else {
        print('Failed to update password');
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update password. Please try again later.'),
      ));
    }
  }
}

//   Widget buildMobileNewPass() {
//     return Scaffold(
//       appBar: AppBar(title: Text('Update Password')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 PasswordField(
//                   controller: passwordController1,
//                   obscureText: !valpass,
//                   hintText: 'New Password',
//                   toggleVisibility: () {
//                     setState(() {
//                       valpass = !valpass;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 PasswordField(
//                   controller: passwordController2,
//                   obscureText: !valpass,
//                   hintText: 'Confirm Password',
//                   toggleVisibility: () {
//                     setState(() {
//                       valpass = !valpass;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (formKey.currentState!.validate() &&
//                         passwordController2.text == passwordController1.text) {
//                       String email = Login.Email.isNotEmpty
//                           ? Login.Email
//                           : ForgetPass.emailUser;
//                       await updatePassword(email, passwordController1.text);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Login()),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                         content: Text("Passwords do not match"),
//                       ));
//                     }
//                   },
//                   child: Text('Update Password'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> updatePassword(String email, String newPassword) async {
//     try {
//       final response = await http.put(
//         Uri.parse('http://$ip:3000/plantpat/user/UpdatePass'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           'email': email,
//           'newPassword': newPassword,
//         }),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // await changePassword(email, '123456', newPassword); // Assuming '123456' is the old password
//         print('Password updated successfully');
//       } else {

//         print('Failed to update password');
//       }
//     } catch (e) {
//       print('Exception: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to update password. Please try again later.'),
//       ));
//     }
//   }
// }

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final VoidCallback toggleVisibility;

  const PasswordField({
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}





//...................lujain

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:plantpat/src/screen/login_screen.dart';
// import 'package:plantpat/src/screen/ipaddress.dart';
// import 'package:plantpat/src/screen/forget_password.dart';

// class NewPass extends StatefulWidget {
//   @override
//   _NewPassState createState() => _NewPassState();
// }

// class _NewPassState extends State<NewPass> {
//   bool valpass = false;
//   TextEditingController passwordController1 = TextEditingController();
//   TextEditingController passwordController2 = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final currentUser = FirebaseAuth.instance.currentUser;

//   Future<void> changePassword(
//       String email, String oldPass, String newPass) async {
//     try {
//       var cred = EmailAuthProvider.credential(email: email, password: oldPass);
//       await currentUser!.reauthenticateWithCredential(cred).then((value) {
//         currentUser!.updatePassword(newPass);
//         print('Updated successfully in Firebase');
//       }).catchError((error) {
//         print('Error updating password in Firebase: $error');
//       });
//     } catch (e) {
//       print('Exception: $e');
//     }
//   }

//   Future<void> updatePassword(String email, String newPassword) async {
//     try {
//       final response = await http.put(
//         Uri.parse(
//             'http://$ip:3000/plantpat/user/UpdatePass'), // Replace with your actual server IP
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           'email': email,
//           'newPassword': newPassword,
//         }),
//       );

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Replace '123456' with the actual old password
//         await changePassword(email, '123456', newPassword);
//         print('Password updated successfully');
//       } else {
//         print('Failed to update password');
//       }
//     } catch (e) {
//       print('Exception: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Update Password')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 PasswordField(
//                   controller: passwordController1,
//                   obscureText: !valpass,
//                   hintText: 'New Password',
//                   toggleVisibility: () {
//                     setState(() {
//                       valpass = !valpass;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 PasswordField(
//                   controller: passwordController2,
//                   obscureText: !valpass,
//                   hintText: 'Confirm Password',
//                   toggleVisibility: () {
//                     setState(() {
//                       valpass = !valpass;
//                     });
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (formKey.currentState!.validate() &&
//                         passwordController2.text == passwordController1.text) {
//                       String email = Login.Email != ''
//                           ? Login.Email
//                           : ForgetPass.emailUser;
//                       await updatePassword(email, passwordController1.text);
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 Login()), // Adjust the route as necessary
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text("Passwords do not match"),
//                       ));
//                     }
//                   },
//                   child: Text('Update Password'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PasswordField extends StatelessWidget {
//   final TextEditingController controller;
//   final bool obscureText;
//   final String hintText;
//   final VoidCallback toggleVisibility;

//   const PasswordField({
//     required this.controller,
//     required this.obscureText,
//     required this.hintText,
//     required this.toggleVisibility,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         hintText: hintText,
//         suffixIcon: IconButton(
//           icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
//           onPressed: toggleVisibility,
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your password';
//         } else if (value.length < 6) {
//           return 'Password must be at least 6 characters';
//         }
//         return null;
//       },
//     );
//   }
// }
