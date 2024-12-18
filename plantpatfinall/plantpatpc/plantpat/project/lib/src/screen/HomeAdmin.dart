



import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/retry.dart';
import 'package:plantpat/src/screen/DashboardScreen.dart';
import 'package:plantpat/src/screen/chat_ad.dart';
import 'package:plantpat/src/screen/customer.dart';
import 'package:plantpat/src/screen/homechat.dart';
import 'package:plantpat/src/screen/ipaddress.dart';

import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/notification.dart';
import 'package:plantpat/src/screen/orderscreen.dart';
import 'package:plantpat/src/screen/prod_ad.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/contact.dart';  

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String? mtoken = " ";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
static List<Contact> contacts = [];


  @override
  void initState() {
    super.initState();
    FirebaseNotification.getDeviceToken();
    gettoken();

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userId = user.uid;
    print(userId);
    _fetchContacts();
  }

  
  // Future<void> _fetchContacts() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       print('User is not logged in');
  //       return;
  //     }

  //     String currentUserId = user.uid;
  //     print('Current user ID: $currentUserId');

  //     // Fetch contacts from Firestore
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('Theusers')
  //       .where('uid', isNotEqualTo: currentUserId)
  //       .get();

  //     // Print the number of documents fetched
  //     print('Number of documents fetched: ${querySnapshot.docs.length}');

  //     if (querySnapshot.docs.isEmpty) {
  //       print('No contacts found');
  //     }

  //     // Map documents to Contact objects
  //     List<Contact> fetchedContacts = querySnapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return Contact(
  //         name: '${data['first_name'] ?? 'Unknown'} ${data['last_name'] ?? ''}',
       
  //       );
  //     }).toList();

  //     // Update the state with the fetched contacts
  //     setState(() {
  //       contacts = fetchedContacts;
  //     });

  //     print('Contacts retrieved: ${contacts.length}');
  //   } catch (e) {
  //     print('Error fetching contacts: $e');
  //   }
  // }

Future<Map<String, dynamic>?> getImageOfUser(String name) async {
  print("Fetching image for user: $name");

  try {
    final response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/getProfileImagebyname?name=$name'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); 

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      
     
      print('Response data type: ${responseData.runtimeType}');
      print('Response data: $responseData');

      if (responseData is List && responseData.isNotEmpty) {
        final imageData = responseData[0]['profile_image'];
        if (imageData != null) {
          print('Image data found.');
          return imageData; 
        } else {
          print('Profile image not found in results.');
        }
      } else {
        print('Response data is not a list or is empty.');
      }
    } else {
      print('Failed to fetch user data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user image: $e');
  }
  return null;
}



Future<void> _fetchContacts() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not logged in');
      return;
    }

    String currentUserId = user.uid;
    print('Current user ID: $currentUserId');

   
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Theusers')
      .where('uid', isNotEqualTo: currentUserId)
      .get();

    print('Number of documents fetched: ${querySnapshot.docs.length}');

    if (querySnapshot.docs.isEmpty) {
      print('No contacts found');
    }

  
    List<Contact> fetchedContacts = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      String name = '${data['first_name'] ?? 'Unknown'} ${data['last_name'] ?? ''}';
      String id = data['uid'];
      
      
      Map<String, dynamic>? imageData = await getImageOfUser(name);
      print(imageData);
      
      fetchedContacts.add(Contact(
        name: name,
        id: id,
        imageData: imageData ?? {}, 
      ));
    }

   
    setState(() {
      contacts = fetchedContacts;
    });

    print('Contacts retrieved: ${contacts.length}');
  } catch (e) {
    print('Error fetching contacts: $e');
  }
}


















  

  void gettoken() async {
    print("helllllllllllllo");
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print(
            "**********************************************************************************8my token is $mtoken");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page Admin'),
        backgroundColor: Colors.green, 

      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/admin.gif',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
              ],
            ),
          ),
        ],
      ),
    );
  }

}





class AppDrawer extends StatelessWidget {
      
 
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'PlantPat',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          onTap: () {
             Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Orders'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OrderScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.report),
            title: Text('Customers'),
          onTap: () {
 Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CustomerScreen()),
              );},
          ),
ListTile(
  leading: Icon(Icons.chat),
  title: Text('Chat'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeChat(contacts: _HomeAdminState.contacts),
      ),
    );
  },
),

          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Products'),
onTap: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => ProductsScreen()),
  );
},



          ),
          Divider(),
          ListTile(
            title: Text('SUPPORT', style: TextStyle(color: Colors.grey)),
          ),
ListTile(
  leading: Icon(Icons.logout), 
  title: Text('Log Out'),
  onTap: () async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()), 
    );
  },
),

          ListTile(
            leading: Icon(Icons.help_center),
            title: Text('Help Center'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HelpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }




}












// class AppDrawer extends StatefulWidget {
//   @override
//   _AppDrawerState createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   List<Contact> contacts = [];




//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.green,
//             ),
//             child: Text(
//               'PlantPat',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 40,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.dashboard),
//             title: Text('Dashboard'),
//             onTap: () {
//               Navigator.pushReplacementNamed(context, '/dashboard');
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.shopping_bag),
//             title: Text('Orders'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => OrdersScreen()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.report),
//             title: Text('Customers'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => ReportsScreen()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.chat),
//             title: Text('Chat'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => HomeChat(contacts: contacts),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.inventory),
//             title: Text('Products'),
//             // Uncomment this if you need it
//             // onTap: () {
//             //   Navigator.pushReplacement(
//             //     context,
//             //     MaterialPageRoute(builder: (context) => ProductsScreen()),
//             //   );
//             // },
//           ),
//           Divider(),
//           ListTile(
//             title: Text('SUPPORT', style: TextStyle(color: Colors.grey)),
//           ),
//           ListTile(
//             leading: Icon(Icons.settings),
//             title: Text('Settings'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => SettingsScreen()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.help_center),
//             title: Text('Help Center'),
//             onTap: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => HelpScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }














// class DashboardScreen extends StatelessWidget {
//  double totalRevenue = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     fetchTotalRevenue(); // Fetch the revenue when the widget is initialized
//   }

//   Future<void> fetchTotalRevenue() async {
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           totalRevenue = (data['total_revenue'] as num).toDouble(); // Store revenue in the state variable
//         });
//       } else {
//         throw Exception('Failed to load total revenue');
//       }
//     } catch (e) {
//       print('Error fetching total revenue: $e');
//       setState(() {
//         totalRevenue = 0.0; // Default value on error
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//       ),
//       drawer: AppDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Dashboard',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 childAspectRatio: 3,
//                 children: [
//                   InfoCard(
//                     title: 'Total Revenue',
//                     value: '\$${totalRevenue.toStringAsFixed(2)}',
//                   ),
//                   InfoCard(
//                       title: 'Total Orders',
//                       value: ,
//                   ),
//                   InfoCard(
//                       title: 'Total Profit',
//                       value: '\$60,188',
//                   ),
//                   InfoCard(
//                       title: 'New Customers',
//                       value: '100+',
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Sales Performance',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Container(
//               height: 200,
//               color: Colors.grey[200],
//               child: Center(child: Text('Graph Placeholder')),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Top Selling Products',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   TopProduct(product: 'Samsung Watch', unitsSold: 800),
//                   TopProduct(product: 'Macbook Pro', unitsSold: 750),
//                   TopProduct(product: 'Samsung S24', unitsSold: 700),
//                   TopProduct(product: 'Iphone 15Pro', unitsSold: 650),
//                   TopProduct(product: 'Apple Ipad Gen2', unitsSold: 600),
//                   TopProduct(product: 'Boat Airdopes 121', unitsSold: 550),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

















// }

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
 

  InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            
          ],
        ),
      ),
    );
  }
}





























class TopProduct extends StatelessWidget {
  final String product;
  final int unitsSold;

  TopProduct({required this.product, required this.unitsSold});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product),
      trailing: Text('$unitsSold units sold'),
    );
  }
}



class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Content'),
      ),
    );
  }
}





class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Settings Content'),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Help Center Content'),
      ),
    );
  }
}














class Product {
  final int plantId;
  final String name;
  final String description;
  double price;
  double height;
  final int quantity;
  final int sectionId;
  final Map<String, dynamic> imageData;
  final String avgRate;
  final String size;

  Product({
    required this.plantId,
    required this.name,
    required this.description,
    required this.price,
    required this.height,
    required this.size,
    required this.quantity,
    required this.sectionId,
    required this.imageData,
    required this.avgRate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      plantId: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      height: json['height'].toDouble(),
      size: json['size'],
      quantity: json['quantity'],
      sectionId: json['sectionid'],
      imageData: json['image'],
      avgRate: json['average_rating'].toString(),
    );
  }
}