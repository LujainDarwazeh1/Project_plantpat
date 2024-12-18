import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/notification_send_msg.dart';
import 'package:plantpat/src/screen/signup.dart';
import 'package:plantpat/src/screen/forget_password.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

// class Login extends StatefulWidget {
//   static String Email = '';
//   static String FirstName = '';
//   static String LastName = '';
//   static String first_name = '';
//   static String last_name = '';
//   static String address = '';
//   static String phonenumberr = '';
//   static int idd = 0;
//   static String birthdaylogin = '';
//   static String usertypee = '';
//   @override
//   LoginScreen createState() => LoginScreen();
// }

// class LoginScreen extends State<Login> {
//   static bool isUserLog = false;
//   bool valpass = false;
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool isemailvalid = false;
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool _obscurePassword = true;

//   void togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }

//   Future<void> validateAndSubmit() async {
//     if (_formKey.currentState!.validate()) {
//       String email = emailController.text;
//       String password = passwordController.text;
//       await loginnn(email, password);
//     }
//   }

//   Future<void> loginnn(String email, String password) async {
//     final url = Uri.parse('http://$ip:3000/plantpat/user/login');
//     try {
//       final response = await http.post(
//         url,
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           'email': email,
//           'password': password,
//         }),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         if (responseData.containsKey('user')) {
//           final user = responseData['user'];
//           setState(() {
//             Login.first_name = user['first_name'];
//             Login.last_name = user['last_name'];
//             Login.address = user['address'];
//             Login.phonenumberr = user['phone_number'];
//             Login.idd = user['user_id'];
//             Login.birthdaylogin = user['birthday'];
//             Login.usertypee = user['user_type'];
//           });
//         }
//         if (Login.usertypee == 'Admin') {
//           Navigator.of(context).pushReplacementNamed("homeadmin");
//         } else if (Login.usertypee == 'Delivery employee') {
//           Navigator.of(context).pushReplacementNamed("homedelivery");
//         } else if (Login.usertypee == 'Decorating employee') {
//           Navigator.of(context).pushReplacementNamed("homeDecorating");
//         } else {
//           Navigator.of(context).pushReplacementNamed("homepagee");
//         }
//       } else if (response.statusCode == 401) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Invalid email or password")));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Failed to authenticate.")));
//       }
//     } catch (e) {
//       print('Error: $e');
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   hintText: 'Enter your email',
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return 'Please enter a valid email address';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   hintText: 'Enter your password',
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                       color: Theme.of(context).primaryColorDark,
//                     ),
//                     onPressed: togglePasswordVisibility,
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: validateAndSubmit,
//                 child: Text('Login'),
//               ),
//               SizedBox(height: 10),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => Signup()),
//                   );
//                 },
//                 child: Text('Don\'t have an account? Sign Up'),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ForgetPassword()),
//                   );
//                 },
//                 child: Text(
//                   'Forgot Password?',
//                   style: TextStyle(
//                     color: Theme.of(context).primaryColor,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

///////////////////////////////////////noor first time
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/signup.dart';
import 'package:plantpat/src/screen/forget_password.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/home.dart';
import 'package:plantpat/src/mixins/valid_mixin.dart';

class Login extends StatefulWidget {
  static String Email = '';
  static String FirstName = '';
  static String LastName = '';
  static String first_name = '';
  static String last_name = '';
  static String address = '';
  static String phonenumberr = '';
  static int idd = 0;

  static String usertypee = '';

  @override
  LoginScreen createState() => LoginScreen();
}

class LoginScreen extends State<Login> with ValidationMixin {
//

//

  static bool isUserLog = false;
  bool valpass = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isemailvalid = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  void togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;

    });
  }

  Future<void> validateAndSubmit() async {
  if (_formKey.currentState!.validate()) {
    String email = emailController.text;
    Login.Email=email;
    String password = passwordController.text;

    
  
    await loginnn(email, password);


    
  }
}




// Future<void> loginnn(String email, String password) async {
//   final url = Uri.parse('http://$ip:3000/plantpat/user/login');
  
//   try {
//     // Backend login
//     final response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'email': email,
//         'password': password,
//       }),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final responseData = jsonDecode(response.body);
//       print('Backend response: $responseData'); // Debugging

//       if (responseData.containsKey('user')) {
//         final user = responseData['user'];
//         setState(() {
//           Login.first_name = user['first_name'];
//           Login.last_name = user['last_name'];
//           Login.address = user['address'];
//           Login.phonenumberr = user['phone_number'];
//           Login.idd = user['user_id'];
//           Login.birthdaylogin = user['birthday'];
//           Login.usertypee = user['user_type'];
//         });

//         // Firebase authentication
//         try {
//           UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//             email: email,
//             password: password,
//           );

//           await SignupScreen.firestore
//               .collection('Theusers')
//               .doc(credential.user!.uid)
//               .set({
//             'uid': credential.user!.uid,
//             'email': email,
//             'first_name': Login.first_name,
//             'last_name': Login.last_name,
//           }, SetOptions(merge: true));

//           // Navigate based on user type
//           if (Login.usertypee == 'Admin') {
//             Navigator.of(context).pushReplacementNamed("homeadmin");
//           } else if (Login.usertypee == 'Delivery employee') {
//             Navigator.of(context).pushReplacementNamed("homedelivery");
//           } else if (Login.usertypee == 'Decorating employee') {
//             Navigator.of(context).pushReplacementNamed("homeDecorating");
//           } else {
//             Navigator.of(context).pushReplacementNamed("homepagee");
//           }
//         } on FirebaseAuthException catch (e) {
//           if (e.code == 'user-not-found') {
//             print('No user found for that email.');
//           } else if (e.code == 'wrong-password') {
//             print('Wrong password provided for that user.');
//           } else {
//             print('Firebase Auth Error: ${e.message}');
//           }
//         }
//       }
//     } else if (response.statusCode == 401) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Invalid email or password")));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to authenticate.")));
//     }
//   } catch (e) {
//     print('Error: $e');
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text('Error: $e')));
//   }
// }



  // Future<void> loginnn(String email, String password) async {
  //   print("hello");
  //   final url = Uri.parse('http://$ip:3000/plantpat/user/login');
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'email': email,
  //         'password': password,
  //       }),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final responseData = jsonDecode(response.body);
  //       if (responseData.containsKey('user')) {
  //         final user = responseData['user'];
  //         setState(() {
  //           Login.first_name = user['first_name'];
  //           Login.last_name = user['last_name'];
  //           Login.address = user['address'];
  //           Login.phonenumberr = user['phone_number'];
  //           Login.idd = user['user_id'];
  //         //  Login.birthdaylogin = user['birthday'];
  //           Login.usertypee = user['user_type'];
  //         });

  //          print("hello2");
  //       }


  //              try {
  //               print("hello");
  //         UserCredential credential =
  //             await FirebaseAuth.instance.signInWithEmailAndPassword(
  //           email: emailController.text,
  //           password: passwordController.text,
  //         );
  //         SignupScreen.firestore
  //             .collection('Theusers')
  //             .doc(credential.user!.uid)
  //             .set({
  //           'uid': credential.user!.uid,
  //           'email': emailController.text,
  //           'first_name': Login.FirstName,
  //           'last_name': Login.LastName,
  //         }, SetOptions(merge: true));

  //         print("hello");
  //       }

  //       //aya
  //       on FirebaseAuthException catch (e) {
  //         if (e.code == 'user-not-found') {
  //           print('No user found for that email.');
  //         } else if (e.code == 'wrong-password') {
  //           print('Wrong password provided for that user.');
  //         }
  //       }
  //       scheduleNotifications();


  //       if (Login.usertypee == 'Admin') {
  //         Navigator.of(context).pushReplacementNamed("homeadmin");
  //       } else if (Login.usertypee == 'Delivery employee') {
  //         Navigator.of(context).pushReplacementNamed("homedelivery");
  //       } else if (Login.usertypee == 'Decorating employee') {
  //         Navigator.of(context).pushReplacementNamed("homeDecorating");
  //       } else {
  //         Navigator.of(context).pushReplacementNamed("homepagee");
  //       }
  //     } else if (response.statusCode == 401) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Invalid email or password")));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Failed to authenticate.")));
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error: $e')));
  //   }
  // }




  Future<void> loginnn(String email, String password) async {
    print("hello1");
    print(email);
    print(password);

  final url = Uri.parse('http://$ip:3000/plantpat/user/login');
  
  try {
    // Attempt login with custom backend
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),

    );
    print("response$response");
 


    if (response.statusCode == 200 || response.statusCode == 201) {
      print("hello1");
      final responseData = jsonDecode(response.body);
      if (responseData.containsKey('user')) {
        final user = responseData['user'];
        setState(() {
          Login.first_name = user['first_name'];
          Login.last_name = user['last_name'];
          Login.address = user['address'];
          Login.phonenumberr = user['phone_number'];
          Login.idd = user['user_id'];
          Login.usertypee = user['user_type'];
        });

        
        try {
          UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          print("hello2");

         
          await FirebaseFirestore.instance
              .collection('Theusers')
              .doc(credential.user!.uid)
              .set({
            'uid': credential.user!.uid,
            'email': email,
            'first_name': Login.first_name,
            'last_name': Login.last_name,
          }, SetOptions(merge: true));

          print("Firebase Authentication successful");
           isUserLog = true;
          
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          } else {
            print('FirebaseAuthException: $e');
          }
        }

        
        scheduleNotifications();

     
        if (Login.usertypee == 'Admin') {
          Navigator.of(context).pushReplacementNamed("homeadmin");
        } else if (Login.usertypee == 'Delivery employee') {
          Navigator.of(context).pushReplacementNamed("homedelivery");
        } else if (Login.usertypee == 'Decorating employee') {
          Navigator.of(context).pushReplacementNamed("homeDecorating");
        } else {
          Navigator.of(context).pushReplacementNamed("homepagee");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to get user data.")));
      }
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to authenticate.")));
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}




  @override
  void initState() {
    super.initState();
    // startCallApi();
    // fetchSectionss();
    // fetchPopularity();
    //fetchPlantsForAI(Login.idd);
   triggerNotificationFromPages("hello","lujain");
  

   
  }













  // void startCallApi() async {
  //   print("hrehyuijhyg");
  //   var client = http.Client();
  //   try {
  //     var url = Uri.http('192.168.7.110:3000',
  //         '/plantpat/shoppingcart/getCartItem', {'userId': '50'});
  //     var response = await client.get(url);
  //     var jsonResponse = json.decode(response.body);
  //     print("[Response] $jsonResponse");
  //   } catch (e) {
  //     print("[Ex] ${e.toString()}");
  //   } finally {
  //     client.close();
  //   }
  // }

  void fetchSectionss() async {
    ///////////////////////here
    var client = http.Client();

    print('Fetching Section ');
    try {
      var url = Uri.http('$ip:3000', '/plantpat/plant/Sections');
      var response = await client.get(url);
      print("[SuccessResponse] ${response.body}");
      // final response = await http.get(Uri.parse('http://$ip:3000/plantpat/plant/Sections'));
      if (response.statusCode == 200) {
        //  List<dynamic> jsonResponse = jsonDecode(response.body);
        // return jsonResponse.map((data) => Section.fromJson(data)).toList();
      } else {
        throw Exception(
            'Failed to load Sections. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching Sections: $e');
      throw Exception('Failed to load Sections: $e');
    } finally {
      client.close();
    }
  }

  // void fetchPopularity() async {
  //   print('fetch Popularity ');
  //   Dio dio = Dio();
  //   try {
  //     var response = await dio.getUri(
  //         Uri.parse("http://192.168.7.110:3000/plantpat/plant/Popularity"));
  //     print("[Populaity REsponse:: ${response.data.to}");
  //     if (response.statusCode == 200) {
  //     } else {}
  //   } catch (e) {
  //     print('Error during HTTP request: $e');
  //     throw Exception('Failed to fetch popularity: $e');
  //   }
  // }

  void fetchPlantsForAI(int userId) async {
    var client = http.Client();

    print('Fetching recommended plants for user ID $userId');

    try {
      // var url = Uri.http('$ip:3000',
      //     '/plantpat/plant/retriveplantHomeRecomendedSystem?userId=$userId');

      var url = Uri.http(
          '$ip:3000',
          '/plantpat/plant/retriveplantHomeRecomendedSystem',
          {'userId': '$userId'});

      var response = await client.get(url);
      print("[SuccessResponse] ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
      } else {
        throw Exception(
            'Failed to load recommended plants. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching recommended plants: $e');
      throw Exception('Failed to load recommended plants: $e');
    } finally {
      client.close(); // Close the client to release resources
    }
  }

  // @override
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
  //               child: Form(
  //                 key: _formKey,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     SizedBox(height: 200.0),
  //                     // Email TextField with label
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Email',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 0, 0, 0),
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         SizedBox(height: 7.0),
  //                         TextFormField(
  //                           controller: emailController,
  //                           keyboardType: TextInputType.emailAddress,
  //                           decoration: InputDecoration(
                            
  //                             labelStyle: TextStyle(color: Colors.black),
                             
  //                             border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(10.0),
  //                             ),
  //                             filled: true,
  //                             fillColor: Colors.white.withOpacity(0.5),
  //                           ),
  //                           validator: (value) {
  //                             if (value == null || value.isEmpty) {
  //                               return 'Please enter your email';
  //                             }
  //                             if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
  //                               return 'Please enter a valid email address';
  //                             }
  //                             return null;
  //                           },
  //                         ),
  //                         SizedBox(height: 20.0),
  //                       ],
  //                     ),
  //                     // Password TextField with label
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Password',
  //                           style: TextStyle(
  //                             color: Color.fromARGB(255, 0, 0, 0),
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         SizedBox(height: 7.0),
  //                         TextFormField(
  //                           controller: passwordController,
  //                           obscureText: _obscurePassword,
  //                           decoration: InputDecoration(
  //                             hintText: '',
  //                             border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(10.0),
  //                             ),
  //                             filled: true,
  //                             fillColor: Colors.white.withOpacity(0.5),
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
  //                         SizedBox(height: 20.0),
  //                       ],
  //                     ),
  //                     // Forgot Password Button
  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => ForgetPassword()),
  //                         );
  //                       },
  //                       child: Text(
  //                         'Forgot your password?',
  //                         style: TextStyle(
  //                           color: Color(0xFF4B8E4B),
  //                           decoration: TextDecoration.underline,
  //                         ),
  //                       ),
  //                       style: ButtonStyle(
  //                         overlayColor:
  //                             MaterialStateProperty.all(Colors.transparent),
  //                       ),
  //                     ),
  //                     SizedBox(height: 10.0), // Space between buttons
  //                     // Login Button
  //                     ElevatedButton(
  //                       onPressed: validateAndSubmit,
  //                       style: ButtonStyle(
  //                         backgroundColor: MaterialStateProperty.all<Color>(
  //                             Color(0xFF4B8E4B)),
  //                         padding:
  //                             MaterialStateProperty.all<EdgeInsetsGeometry>(
  //                                 EdgeInsets.symmetric(
  //                                     horizontal: 150.0, vertical: 13.0)),
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
  //                         'Log in',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 18.0, // Adjust the font size here
  //                           fontWeight: FontWeight.bold, // Make the text bold
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                         height:
  //                             20.0), // Space between login button and sign up label
  //                     // Sign up label
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Text(
  //                           "Don't have an account? ",
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                         TextButton(
  //                           onPressed: () {
  //                             Navigator.pushReplacement(
  //                               context,
  //                               MaterialPageRoute(
  //                                   builder: (context) => Signup()),
  //                             );
  //                           },
  //                           child: Text(
  //                             'Sign up',
  //                             style: TextStyle(
  //                               color: Color(0xFF4B8E4B),
  //                             ),
  //                           ),
  //                           style: ButtonStyle(
  //                             overlayColor: MaterialStateProperty.all(
  //                                 Colors.transparent), // Transparent button
  //                           ),
  //                         ),
  //                       ],
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







Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600; 

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: isWeb ? -300.0 : -230.0,
            left: 0.0,
            child: Image.asset(
              'assets/images/y.jpg',
              width: screenSize.width,
              fit: BoxFit.fitWidth,
              height: isWeb ? screenSize.height * 0.8 : 700.0,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? screenSize.width * 0.1 : 20.0,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isWeb ? 300.0 : 200.0),
                      _buildTextField(
                        label: 'Email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      _buildTextField(
                        label: 'Password',
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            
                            _obscurePassword ? Icons.visibility_off : Icons.visibility ,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: togglePasswordVisibility,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgetPassword()),
                          );
                        },
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: Color(0xFF4B8E4B),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: validateAndSubmit,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4B8E4B)),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: isWeb ? 200.0 : 150.0, vertical: 13.0)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Signup()),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(color: Color(0xFF4B8E4B)),
                            ),
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                            ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    required FormFieldValidator<String> validator,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 7.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              width: 1.0,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              suffixIcon: suffixIcon,
            ),
            keyboardType: keyboardType,
            validator: validator,
          ),
        ),
      ],
    );
  }



























  Future<void> fetchUserData() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var userData = snapshot.docs.first.data();
        print('User Data: $userData');
      } else {
        print('No user found.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  } else {
    print('User is not authenticated.');
  }
}



Future<Map<String, dynamic>?> getTheName(String email) async {
  http.Response? response;

  try {
   
    response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/userName?email=$email'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic responseData = jsonDecode(response.body);

      if (responseData is List && responseData.isNotEmpty) {
        dynamic user = responseData[0];

      
        Login.FirstName = user['first_name'];
        Login.LastName = user['last_name'];

        print(Login.FirstName);
        print(Login.LastName);
      } else {
        throw Exception('Empty or invalid response from API.');
      }
    } else {
      throw Exception('Failed to fetch user from API. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching from API: $e');
  
    return null;
  }

  try {
  
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    } else {
      print('No user found in Firestore.');
      return null;
    }
  } catch (e) {
    print('Error fetching from Firestore: $e');
    
    return null;
  }
}
}
