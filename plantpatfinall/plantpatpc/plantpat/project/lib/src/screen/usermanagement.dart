// import 'dart:convert';
// import 'package:flutter/widgets.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart';
// import 'package:plantpat/src/screen/ipaddress.dart';

// class UserManagementPage extends StatefulWidget {
//   @override
//   _UserManagementPageState createState() => _UserManagementPageState();
// }

// class _UserManagementPageState extends State<UserManagementPage> {
//   List<Map<String, dynamic>> userss = [];
//   String emaill = '';
//   String pass = '';
//   String? erroremaill;
//   @override
//   void initState() {
//     super.initState();
//     getuserss();
//   }

//   Future<void> getuserss() async {
//     final url = Uri.parse('http://$ip:3000/plantpat/manage/AllUserName');
//     final response = await http.get(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       /* body: jsonEncode(<String, String>{
         
//         }),*/
//     );

//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 201 || response.statusCode == 200) {
//       try {
//         Map<String, dynamic> responseBody = json.decode(response.body);
//         List<dynamic> userData =
//             responseBody['message']; //json.decode(response.body);
//         setState(() {
//           userss = userData
//               .map((user) => {
//                     'first_name': user['first_name'],
//                     'last_name': user['last_name'],
//                     'email': user['email'],
//                     'user_type': user['user_type'],
//                     'user_id': user['user_id'],
//                   })
//               .toList();
//         });
//       } catch (e) {
//         print('Error parsing JSON: $e');
//       }
//     } else {
//       // Handle the error
//       print('Failed to load users');
//     }
//   }

//   /// update iiii

//   Future<void> updateuserfromadmin(Map<String, dynamic> user) async {
//     final url = Uri.parse('http://$ip:3000/plantpat/manage/updateadmin');
//     // user['first_name'] = namefirst.text;
//     // user['last_name'] = namelast.text;
//     // user['email'] = email.text;
//     // user['user_type'] = type.text;

//     //
//     final response = await http.put(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(user
//           /* <String, dynamic>{
//       'first_name': user['first_name'],
//       'last_name': user['last_name'],
//       'email': user['email'],
//       'user_type': user['user_type'],
//     }*/

//           ),
//     );

//     if (response.statusCode == 200 ||
//         response.statusCode == 201 ||
//         response.statusCode == 204) {
//       print('User updated successfully');
//     } else {
//       print('Failed to update user: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   }

// // data base
//   Future<void> adduserdatabase(Map<String, dynamic> user) async {
//     final url = Uri.parse('http://$ip:3000/plantpat/manage/adduseradmin');

//     final response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(user),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       print('User added successfully');
//       getuserss();
//     } else {
//       print('Failed to add user: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   }

// // delete user from adminnnnnn
//   Future<void> deletuserfromadmin(Map<String, dynamic> user) async {
//     final url = Uri.parse('http://$ip:3000/plantpat/mange/delete');

//     final response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(
//         //user
//         <String, String>{
//           'userId': user['user_id'].toString(),
//         },
//       ),
//     );
//     if (response.statusCode == 200 ||
//         response.statusCode == 201 ||
//         response.statusCode == 204) {
//       print('User deletedddd successfully');
//       setState(() {
//         print(' User deleted hhhh\n \n ');
//         getuserss();
//       });
//     } else {
//       print('Failed to deleteddd user: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   }
// }
