// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:plantpat/src/screen/home.dart';
// import 'package:plantpat/src/screen/ipaddress.dart';
// import 'package:plantpat/src/screen/login_screen.dart';

// class UserProfile extends StatefulWidget {
//   @override
//   UserProfileState createState() => UserProfileState();
// }

// class UserProfileState extends State<UserProfile> {

//   static String uu = Login.Email;
//   static String firstname = Login.first_name;
//   static String lastname = Login.last_name;

//   static File? imagee;
//   // static late Map<String, dynamic> imageUserLog;
//   void _imagePicker() async {
//     var imagePicker = ImagePicker();
//     XFile? pickedImage =
//         await imagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       setState(() {
//         imagee = File(
//             pickedImage.path); // Assign the selected image to the File variable
//       });
//       uploadProfile(imagee!);

//     //  HomePage.getImageOfUser(Login.idd);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getImageOfUser(Login.idd);
//   }

//   Future<void> getImageOfUser(int userId) async {
//     try {
//       final response = await http.get(Uri.parse(
//           'http://$ip:3000/plantpat/user/getProfileImage?userId=$userId'));
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final responseData = jsonDecode(response.body);
//         if (responseData is Map<String, dynamic> &&
//             responseData.containsKey('results')) {
//           setState(() {
//             // Handle image data as needed
//           });
//         } else {
//           print('Failed to fetch user image.');
//         }
//       } else {
//         print(
//             'Failed to fetch user image. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   static bool isPress = false;
//   static Future<void> uploadProfile(
//     File imageA,
//   ) async {
//     var request = http.MultipartRequest(
//       'PUT',
//       Uri.parse('http://$ip:3000/plantpat/user/addProfileImage'),
//     );

//     request.fields['email'] = Login.Email;
//     request.fields['userId'] = Login.idd.toString();

//     // for (int i = 0; i < imageA.length; i++) {
//     var stream =
//         http.ByteStream(imageA.openRead().cast()); // Convert image to bytes
//     var length = await imageA.length(); // Get image file length
//     var multipartFile = http.MultipartFile(
//       'image', // Consider using 'image' here, depends on your server-side implementation
//       stream,
//       length,
//       filename: imageA.path.split('/').last,
//     );
//     request.files.add(multipartFile);
//     //  }

//     try {
//       var response = await request.send();
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('Upload successful');
//         // Handle success
//       } else {
//         print('Upload failed with status: ${response.statusCode}');
//         // Handle error
//       }
//     } catch (e) {
//       print('Error: $e');
//       // Handle error
//     }
//   }
// /*
//   Future<Map<String, dynamic>?> getImageOfUser(int userId) async {
//     http.Response? response;
//     print('********* $userId');

//     try {
//       response = await http.get(Uri.parse(
//           'http://$ip:3000/tradetryst/user/getProfileImage?userId=$userId'));
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         dynamic responseData = jsonDecode(response.body);

//         if (responseData is Map<String, dynamic> &&
//             responseData.containsKey('results')) {
//           HomePageState.userDetails =
//               List<Map<String, dynamic>>.from(responseData['results:']);
//         } else {
//           print('Failed to fetch cart.');
//         }
//       } else {
//         print('Failed to fetch cart. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print(' Response body: '); //${response?.body}
//       // throw Exception('Failed to fetch data: $e');
//     }
//     return null;
//   }*/

//   updateFirstName() {
//     setState(() {
//       // Update the first_name variable in Login
//       // Login.first_name = ;
//       //   firstname = ;
//       //EditProfileScreen.callfun()
//       firstname = Login.first_name;
//     });
//   }

//   //void updateProfileInfo(Map<String, String> updatedInfo) {

//   //}
//   // email;
//   //Login.Email;
//   //   Login()
//   //LoginScreen.emailController;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: menu(),
//       body: SafeArea(
//         child: ListView(
//           children: [
//             CustemAppBar(
//               text: '8'.tr,
//               // child: Column()
//             ),

//             SizedBox(height: 50),
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 image(),
//                 /*
//         SizedBox(
//           width: 150, 
//           height: 150,
//           child: Stack(
//            // fit: 150,
//             alignment: Alignment.bottomRight,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: const Image(image: AssetImage('images/icon/userprofile.png')),
//               ),
//               IconButton(
//                 icon: Icon(Icons.edit, size: 30, // Adjust the size of the icon
//                color: Color.fromARGB(218, 3, 57, 52),),
//                 //size: 30, // Adjust the size of the icon
//               // color: Colors.blue,
//                // style: //width: 150,

//                 onPressed: () {
//                   // Implement the edit functionality here
//                 },
//               ),
//             ],
//           ),
//         ),*/
//               ],
//             ),
//             SizedBox(height: 10),

//             //  Text('Ibtisam Kharrosheh', style: Theme.of(context).textTheme.headline6,  ),
//             RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(
//                 style: TextStyle(
//                   color: Colors.black, // Default text color
//                   fontSize: 16, // Default font size
//                 ),
//                 //  SizedBox(height: 10),
//                 //  Text('Ibtisamkharrosheh@gmail.com', style: Theme.of(context).textTheme.headline6,  ),
//                 //  SizedBox(height: 10),

//                 children: [
//                   TextSpan(
//                     text: '$firstname $lastname\n',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold, // Make the first text bold
//                       fontSize: 20, // Larger font size
//                     ),
//                   ),
//                   TextSpan(
//                     //ibtisamkharrosheh@gmail.com
//                     text: '$uu\n', // Add a line break
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 79, 77, 77), // Light color
//                       fontSize: 16, // Smaller font size
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 20),
//             //  SizedBox(//height: 50,
//             //width: 200,
//             // width: double.infinity, // Make button take full width
//             Center(
//               child: ElevatedButton(
//                 onPressed: PrivacySecurity.Delete == 'delete'
//                     ? null
//                     : () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => editprofile()),
//                         ).then((updatedFirstName) {
//                           if (updatedFirstName != null) {
//                             setState(() {
//                               firstname = updatedFirstName;
//                             });
//                           }
//                         });
//                       },
//                 child: Text('7'.tr),
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//             ),
//             //  ),
//             SizedBox(height: 30),
//             const Divider(),
//             const SizedBox(height: 10),
//             buildListTile('1'.tr, Icons.language), // settings  'Multi Language'

//             /// adding
//             /* 
//      ListTile(
//      leading: Row(
//      mainAxisSize: MainAxisSize.min,
//     children: [
//       SizedBox(width: 40), // Add an empty space to increase the distance
//       Container(
//         width: 45,
//         height: 45,
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(100),
//           color: Color.fromARGB(255, 124, 137, 125).withOpacity(0.1),
//         ),
//         child: Icon(Icons.settings, color: Color.fromARGB(255, 2, 92, 123),),
//       ),
//     ],
//   ),
//            // title: Text('Settings', style:Theme.of(context).textTheme.bodyText1 ,  ),  
//             title: Text(
//     'Settings', 
//     style: Theme.of(context).textTheme.bodyText2?.copyWith(
//       fontSize: 18, // Set the font size as desired
//       //fontWeight: FontWeight.bold, // Set the font weight as desired
//       color: Colors.black, // Set the text color as desired
//     ),
//   ),  
//             trailing:  Row(
//                mainAxisSize: MainAxisSize.min, // Ensure the Row takes minimum space
//                  children: [
//              Container
//             (padding: EdgeInsets.all(10),
//              // width: 30,height: 30,
//               decoration: BoxDecoration(
//                 color: Colors.grey.withOpacity(0.1), // Specify the color with opacity
//                 borderRadius: BorderRadius.circular(100), // Adjust the border radius as needed
//               ),
//              // padding: EdgeInsets.all(8), // Adjust padding as needed
//               child: Icon(Icons.arrow_forward,size: 20, color: Colors.grey), // Add the icon
//          //  SizedBox(width: 40), 
//             ),
//             SizedBox(width: 20), 
//                  ],
//             ),
//          ),*/
//             // SizedBox(height: 10),
//             //const Divider(),
//             // listtt(),
//             SizedBox(height: 10),
//             //const Divider(),
//             // SizedBox(height: 10),
//             // listtt(),
//             buildListTile('6'.tr, Icons.info),
//             SizedBox(height: 10),
//             buildListTile('4'.tr, Icons.info_outline),
//             // SizedBox(height: 10),
//             //  buildListTile('Contact', Icons.info),
//             // SizedBox(height: 10),
//             SizedBox(
//               height: 10,
//             ),
//             buildListTile('5'.tr, Icons.exit_to_app),
//           ],
//         ),

// // SizedBox(height: 10),
//       ),
//       // list2

//       bottomNavigationBar: NavBar(
//         selectedIndex: selectedIndex,
//         onTabSelected: (index) {
//           setState(() {
//             selectedIndex = index;
//             switch (index) {
//               case 0:
//                 HomePageState.isPressTosearch = false;
//                 HomePageState.isPressTosearchButton = false;
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()),
//                 );
//                 break;
//               case 1:
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => AddProduct()),
//                 );
//                 break;
//               case 2:
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => WishlistPage()),
//                 );
//                 break;
//               case 3:
//                 CartState().resetCart();
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => CartShop()),
//                 );
//                 break;

//               case 4:
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => UserProfile()),
//                 );
//                 break;
//             }
//           });
//         },
//       ),
//     );
//   }

// // function refactor
//   listtt() {
//     return ListTile(
//       leading: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(width: 40), // Add an empty space to increase the distance
//           Container(
//             width: 45,
//             height: 45,
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(100),
//               color: Color.fromARGB(255, 124, 137, 125).withOpacity(0.1),
//             ),
//             child: Icon(
//               Icons.info,
//               color: Color.fromARGB(255, 2, 92, 123),
//             ),
//           ),
//         ],
//       ),
//       // title: Text('Settings', style:Theme.of(context).textTheme.bodyText1 ,  ),
//       title: Text(
//         'Informations',
//         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               fontSize: 18, // Set the font size as desired
//               //fontWeight: FontWeight.bold, // Set the font weight as desired
//               color: Colors.black, // Set the text color as desired
//             ),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min, // Ensure the Row takes minimum space
//         children: [
//           Container(
//             padding: EdgeInsets.all(10),
//             // width: 30,height: 30,
//             decoration: BoxDecoration(
//               color: Colors.grey
//                   .withOpacity(0.1), // Specify the color with opacity
//               borderRadius: BorderRadius.circular(
//                   100), // Adjust the border radius as needed
//             ),
//             // padding: EdgeInsets.all(8), // Adjust padding as needed
//             child: Icon(Icons.arrow_forward,
//                 size: 20, color: Colors.grey), // Add the icon
//             //  SizedBox(width: 40),
//           ),
//           SizedBox(width: 20),
//         ],
//       ),
//     );
//   }

//   /// function i need
//   Widget buildListTile(String title, IconData iconData) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to the About Us page here
//         if (title == "4".tr) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AboutUsPage()),
//           );
//         } else if (title == "6".tr) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => InformationsPage()),
//           );
//         } else if (title == "5".tr) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Login()),
//           );
//         }
//         // Multi Language
//         else if (title == "1".tr) {
//           // title == "1".tr  title == "Multi Language" || title == "تعدد اللغات"
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => MultiLanguage()),
//           );
//         }
//       },
//       child: ListTile(
//         leading: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(width: 40), // Add an empty space to increase the distance
//             Container(
//               width: 45,
//               height: 45,
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Color.fromARGB(255, 124, 137, 125).withOpacity(0.1),
//               ),
//               child: Icon(iconData, color: Color.fromARGB(255, 2, 92, 123)),
//             ),
//           ],
//         ),
//         title: Text(
//           title,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontSize: 18, // Set the font size as desired
//                 //fontWeight: FontWeight.bold, // Set the font weight as desired
//                 color: Colors.black, // Set the text color as desired
//               ),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           // Ensure the Row takes minimum space
//           children: [
//             Container(
//               padding: EdgeInsets.all(10),
//               // width: 30,height: 30,
//               decoration: BoxDecoration(
//                 color: Colors.grey.withOpacity(0.1),
//                 // Specify the color with opacity
//                 borderRadius: BorderRadius.circular(100),
//                 // Adjust the border radius as needed
//               ),
//               child: Icon(Icons.arrow_forward, size: 20, color: Colors.grey),
//               // Add the icon
//               //  SizedBox(width: 40),
//             ),
//             SizedBox(width: 20),
//           ],
//         ),
//       ),
//     );
//   }

// //// function image
//   ///
//   Widget image() {
//     final theproduct = HomePageState.userDetails[0];
//     final imageData = theproduct['profile_image'];
//     // imageUserLog = theproduct['profile_image'];
//     Uint8List? bytes;
//     if (imageData != null) {
//       bytes = Uint8List.fromList(List<int>.from(imageData['data']));
//     }

//     return SizedBox(
//       width: 160,
//       height: 160,
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           (bytes != null && bytes.isNotEmpty && !isPress)
//               ? CircleAvatar(
//                   radius: 200,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: SizedBox(
//                       width: 160,
//                       height: 160,
//                       child: Image.memory(
//                         bytes,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 )
//               : (imagesayyya == null)
//                   ? CircleAvatar(
//                       radius: 200,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(100),
//                         child: Image.asset(
//                           'images/icon/profile.jpg',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     )
//                   : CircleAvatar(
//                       radius: 200,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(100),
//                         child: SizedBox(
//                           width: 160,
//                           height: 160,
//                           child: Image.file(
//                             imagesayyya!,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                     ),
//           IconButton(
//             icon: Icon(
//               Icons.edit,
//               size: 30,
//               color: Color.fromARGB(218, 3, 57, 52),
//             ),
//             onPressed: () {
//               isPress = true;
//               _imagePicker(); // Call _imagePicker function to select an image
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }