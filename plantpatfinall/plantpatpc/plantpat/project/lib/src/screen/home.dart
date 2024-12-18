import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/retry.dart';
import 'package:plantpat/src/screen/chatscreen.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/Notification_page.dart';
import 'dart:typed_data';

import 'package:plantpat/src/screen/notification.dart';
import 'package:plantpat/src/screen/notification_send_msg.dart';
import 'package:plantpat/src/screen/prod_info.dart';
import 'package:plantpat/src/screen/section.dart';
import 'package:plantpat/src/screen/settings.dart';
import 'package:plantpat/src/screen/shopping_cart.dart';
import 'package:plantpat/src/screen/wishlist_page.dart';
import 'dart:convert';
import 'dart:io';
import'package:plantpat/src/screen/search_page.dart';
import'package:plantpat/src/screen/chatscreen.dart';
import'package:plantpat/src/screen/chat.dart';


class Server {
  static final Map<String, String> httpHeaders = {
    HttpHeaders.contentTypeHeader: "application/json",
    "Connection": "Keep-Alive",
    "Keep-Alive": "timeout=5, max=1000"
  };
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Server server = Server();
  List<Plant> plants = [];
  List<Plant> allPlants = [];
  List<Plant> plantsThisMonth = [];
  List<bool> isFavorite = [false, false, false, false]; 
  ValueNotifier<bool> isInWishlist = ValueNotifier<bool>(false);

  

  String? mtoken = " ";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<String> recommendations = [
    'assets/images/1.jpg',
    'assets/images/2.jpg',
    'assets/images/3.jpg',
    'assets/images/4.jpg'
  ];





int _selectedIndex = 0;
void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

  switch (index) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      break;
    case 1:  
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
      break;
    case 2:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
      break;
    case 3:
 Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ChatPage()),
);

    

      break;
  }
}

  @override
  void initState() {

    super.initState();
    triggerNotification();
    
    FirebaseNotification.getDeviceToken();
    
    getuserbyemail(Login.Email);

    requestpermission();
    gettoken();
    fetchProducts();
    
    

  }

  void fetchCartItems(int userId) async {
    print("user id is :");
    print(userId);

    print("hello from fetch cart item ...............................");
    final String url =
        'http://$ip:3000/plantpat/shoppingcart/getCartItem?userId=$userId';
        var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };
    try {
      http.Response response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('results') &&
            responseData.containsKey('allProductData')) {
   
          setState(() {
          
          });
       
          print(
              "cartShopContain............................................................");
        }
      } else {
        print('Failed to fetch cart. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('ClientException during HTTP request: $e');
    } on TimeoutException catch (e) {
      print('Timeout during HTTP request: $e');
    } catch (e) {
      print('General error during HTTP request: $e');
    }
  }

  void requestpermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional");
    } else {
      print("User declined or has not accepted permisson");
    }
  }

  void gettoken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print(
            "**********************************************************************************8my token is $mtoken");
      });
    });
  }


void getuserbyemail(String email) async {
  var client = http.Client();
  print('Fetching user data for email: $email');
  
  try {
    var url = Uri.http('$ip:3000', 'plantpat/user/getuserbyemail', {'email': email});
    var response = await client.get(url);
    


    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
   //   print("[Decoded Response] ${responseData}");

   
      if (responseData.isNotEmpty) {
        final user = responseData[0];

        setState(() {
          Login.Email = user['email'] ?? '';
          Login.FirstName = user['first_name'] ?? '';
          Login.LastName = user['last_name'] ?? '';
          Login.address = user['address'] ?? '';
          Login.phonenumberr = user['phone_number'] ?? '';
       
          Login.usertypee = user['user_type'] ?? '';
        });
      } else {
        print('User data not found in response.');
        throw Exception('User data not found in response.');
      }
    } else {
      print('Failed to load user data. Status code: ${response.statusCode}');
      throw Exception('Failed to load user data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user data: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching user data: $e')));
  } finally {
    client.close();
  }
}



  Future<void> getImageOfUser(int userId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://$ip:3000/plantpat/user/getProfileImage?userId=$userId'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('results')) {
          setState(() {
           
          });
        } else {
          print('Failed to fetch user image.');
        }
      } else {
        print(
            'Failed to fetch user image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  static Future<void> InteractionOfUser(int userId, int plantId, int view,
      int addToCart, int purchased, int wishlist) async {
    print(plantId);
    final response = await http.put(
      Uri.parse('http://$ip:3000/plantpat/user/Interaction'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'userId': userId,
        'plantId': plantId,
        'view': view,
        'addToCart': addToCart,
        'purchased': purchased,
        'wishlist': wishlist,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('interaction of user saved');
    } else {
      print('Failed to save interaction of user');
    }
  }

  Future<void> fetchProducts() async {
    try {
     
      setState(() {
        fetchCartItems(Login.idd);

      
      });
    } catch (e) {
      print('Failed to fetch products: $e');
      
    }
  }



@override
  Widget build(BuildContext context) {
    return kIsWeb ? buildWebHome() : buildMobileHome();
  }



 
   Widget buildMobileHome() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth:
            110, 
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo2.png', 
                width: 80, 
                height: 80,
              ),
            ],
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 40,
            width: 150,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSections(),
            _buildPopularitySection(), 
              _buildSuggestions(),
         
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.green), // Home icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black), // Search icon
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.black), // Cart icon
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black), // Chat icon
            label: 'Chat',
          ),
        ],
        selectedItemColor: Colors.green,
      ),
    );
  }


Widget buildWebHome() {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 500, // Increase for more space on web
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Builder(
          builder: (context) {
           
           final screenWidth = MediaQuery.of(context).size.width;
           
            final logoWidth = screenWidth * 0.2;
            final logoHeight = logoWidth * 0.8; 

            return Row(
              children: [
                Image.asset(
                  'assets/images/logo2.png',
                  width: logoWidth,
                  height: logoHeight,
                ),
              ],
            );
          },
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: 40,
          width: 300, 
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.settings, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderWeb(),
          _buildSectionsWeb(),
          _buildPopularitySectionWeb(),
          _buildSuggestionsWeb(),
        ],
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.green),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: Colors.black),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart, color: Colors.black),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat, color: Colors.black),
          label: 'Chat',
        ),
      ],
      selectedItemColor: Colors.green,
    ),
  );
}























  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Image.asset('assets/images/add.png'),
        ],
      ),
    );
  }


Widget _buildHeaderWeb() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
     
        LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            
            final headerWidth = screenWidth; 
            final headerHeight = 390.0; 

            return Image.asset(
              'assets/images/add.png', 
              width: headerWidth,
              height: headerHeight,
              fit: BoxFit.cover, 
            );
          },
        ),
      ],
    ),
  );
}















  Widget _buildSections() {
    return FutureBuilder<List<Section>>(
      future: fetchSectionss(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Section> Sections = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('14'.tr,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 13),
                SizedBox(
                  height: 160, 
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Sections.length,
                    itemBuilder: (context, index) {
                      Section plant = Sections[index];
                      return _buildSectionItem(
                        context,
                        plant.name,



                        plant.imageData,
                        plant.sectionId,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }






  Widget _buildSectionsWeb() {

  return FutureBuilder<List<Section>>(
    future: fetchSectionss(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        List<Section> sections = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('14'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
              SizedBox(height: 20),
             
              SizedBox(
                height: 250, 
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20.0, 
                    mainAxisSpacing: 20.0, 
                  ),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    Section section = sections[index];
                    return _buildSectionItemweb(
                      context,
                      section.name,
                      section.imageData,
                      section.sectionId,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Center(child: Text('No data available'));
      }
    },
  );
}




  Widget _buildSectionItemweb(BuildContext context, String title,
      Map<String, dynamic> imagePath, int sectionid) {
    List<int> bytes = List<int>.from(imagePath['data']);

    Widget displayImage = Image.memory(
      Uint8List.fromList(bytes),
      width: 300,
      height: 300,
      fit: BoxFit.cover,
    );
    print("sectionid");
    print(sectionid);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SectionPage(sectionId: sectionid),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            Container(
              height: 200, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: displayImage,
              ),
            ),
            SizedBox(height: 5),
      if (title.toLowerCase() == 'small shrubs')
          Text('17'.tr, style: TextStyle(fontSize: 20)),
        if (title.toLowerCase() == 'climbing plants')
          Text('18'.tr, style: TextStyle(fontSize: 20)),
        if (title.toLowerCase() == 'herbaceous')
          Text('19'.tr, style: TextStyle(fontSize: 20)),
            if (title.toLowerCase() == 'ornamental grasses')
          Text('117'.tr, style: TextStyle(fontSize: 20)),

          

          

          ],
        ),
      ),
    );
  }


  Future<List<Section>> fetchSectionss() async {

    var client = RetryClient(http.Client(), retries:3);

    print('Fetching Section ');
    try {
      var url = Uri.http('$ip:3000', '/plantpat/plant/Sections');


      var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };



      var response = await client.get(url);
      print("[SuccessResponse] ${response.body}");
      // final response = await http.get(Uri.parse('http://$ip:3000/plantpat/plant/Sections'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => Section.fromJson(data)).toList();
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

  Future<List<Plant>> fetchPopularity() async {
   // var client = http.Client();
   var client = RetryClient(http.Client(), retries:3);

    //final String url = 'http://$ip:3000/plantpat/plant/Popularity';

    //http.Client? client;
    try {
      var url = Uri.http('$ip:3000', '/plantpat/plant/Popularity');
      var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };
      var response = await client.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Plant> plants =
            jsonResponse.map((data) => Plant.fromJson(data)).toList();
        return plants;
      } else {
        return [];
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      throw Exception('Failed to fetch popularity: $e');
    } finally {
      client.close(); // Close the client to release resources
    }
  }

  // Widget _buildSectionItem(String title, Map<String, dynamic> imagePath) {
  //   List<int> bytes = List<int>.from(imagePath['data']);

  //   Widget displayImage = Image.memory(
  //     Uint8List.fromList(bytes),
  //     width: 120,
  //     fit: BoxFit.cover,
  //   );

  //   return Padding(
  //     padding: const EdgeInsets.only(right: 16.0),
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 120, 
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(8.0),
  //             child: displayImage,
  //           ),
  //         ),
  //         SizedBox(height: 5),
  //         Text(title, style: TextStyle(fontSize: 14)),
  //       ],
  //     ),
  //   );

  // }

  Widget _buildSectionItem(BuildContext context, String title,
      Map<String, dynamic> imagePath, int sectionid) {
    List<int> bytes = List<int>.from(imagePath['data']);

    Widget displayImage = Image.memory(
      Uint8List.fromList(bytes),
      width: 120,
      fit: BoxFit.cover,
    );
    print("sectionid");
    print(sectionid);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SectionPage(sectionId: sectionid),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            Container(
              height: 120, // Adjust this height to fit your design
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: displayImage,
              ),
            ),
            SizedBox(height: 5),
      if (title.toLowerCase() == 'small shrubs')
          Text('17'.tr, style: TextStyle(fontSize: 14)),
        if (title.toLowerCase() == 'climbing plants')
          Text('18'.tr, style: TextStyle(fontSize: 14)),
        if (title.toLowerCase() == 'herbaceous')
          Text('19'.tr, style: TextStyle(fontSize: 14)),
            if (title.toLowerCase() == 'ornamental grasses')
          Text('117'.tr, style: TextStyle(fontSize: 14)),

           // Text(title, style: TextStyle(fontSize: 14)),

          ],
        ),
      ),
    );
  }

  Widget _buildPopularitySection() {
    return FutureBuilder<List<Plant>>(
      future: fetchPopularity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Plant> plants = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('15'.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  Plant plant = plants[index];
                  return _buildPopularityItem(
                    plant.name,
                    plant.size,
                    '${plant.price} \$',
                    plant.imageData,
                    double.parse(plant.avgRate),
                    context,
                    plant, 
                  );
                },
              ),
              SizedBox(height: 10),
            ],
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }




    Widget _buildPopularitySectionWeb() {

     return FutureBuilder<List<Plant>>(
      future: fetchPopularity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Plant> plants = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('15'.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  Plant plant = plants[index];
                  return _buildPopularityItemweb(
                    plant.name,
                    plant.size,
                    '${plant.price} \$',
                    plant.imageData,
                    double.parse(plant.avgRate),
                    context,
                    plant, 
                  );
                },
              ),
              SizedBox(height: 10),
            ],
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );

  }



   Widget _buildPopularityItemweb(
  String name,
  String size,
  String price,
  Map<String, dynamic> imagePath,
  double rating,
  BuildContext context,
  Plant plant,
) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(
            name: name,
            size: size,
            price: price,
            imagePaths: imagePath,
            avgRate: rating.toString(),
            plantId: plant.plantId,
            height: plant.height,
            sectionid: plant.sectionId,
            quantity: plant.quantity,
            description: plant.description,
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.memory(
              Uint8List.fromList(List<int>.from(imagePath['data'])),
              width: 150,  
              height: 150, 
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15), 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name.toLowerCase() == 'echeveria')
                  Text('20'.tr, style: TextStyle(fontSize: 18)), 
                if (name.toLowerCase() == 'prickly pear')
                  Text('21'.tr, style: TextStyle(fontSize: 18)), 

                if (size.toLowerCase() == 'small')
                  Text('22'.tr, style: TextStyle(fontSize: 16, color: Colors.grey)), 
                if (size.toLowerCase() == 'medium')
                  Text('23'.tr, style: TextStyle(fontSize: 16, color: Colors.grey)), 

                Text(price, style: TextStyle(fontSize: 16, color: Colors.green)), 
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 20), 
                    Text(rating.toString(), style: TextStyle(fontSize: 16)), 
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}














  Widget _buildPopularityItem(
      String name,
      String size,
      String price,
      Map<String, dynamic> imagePath,
      double rating,
      BuildContext context,
      Plant plant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              name: name,
              size: size,
              price: price,
              imagePaths: imagePath,
              avgRate: rating.toString(),
              plantId: plant.plantId,
              height: plant.height,
              sectionid: plant.sectionId,
              quantity: plant.quantity,
              description: plant.description,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                Uint8List.fromList(List<int>.from(imagePath['data'])),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


          if (name.toLowerCase() == 'echeveria')
         Text('20'.tr, style: TextStyle(fontSize: 16)),
        if (name.toLowerCase() == 'prickly pear')
         Text('21'.tr, style: TextStyle(fontSize: 16)),


     if (size.toLowerCase() == 'small')
          Text('22'.tr,
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
        if (size.toLowerCase() == 'medium')
             Text('23'.tr,
                      style: TextStyle(fontSize: 14, color: Colors.grey)),

                  
                 // Text(name, style: TextStyle(fontSize: 16)),
                  // Text(size,
                  //     style: TextStyle(fontSize: 14, color: Colors.grey)),


                  Text(price,
                      style: TextStyle(fontSize: 14, color: Colors.green)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 16),
                      Text(rating.toString(), style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//lujain ****
  // Future<List<Plant>> fetchPlantsForAI(int userId) async {
  //   print('Fetching recommended plants for user ID $userId');
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://$ip:3000/plantpat/plant/retriveplantHomeRecomendedSystem?userId=$userId'));

  //         var headers = {
  //     'Content-Type': 'application/json',
  //     'Connection': 'keep-alive',
  //     'Cache-Control': 'no-cache, private',
  //     'X-RateLimit-Limit': '60',
  //     'X-RateLimit-Remaining': '59',
  //     'Access-Control-Allow-Origin': '*',
  //   };

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       List<dynamic> jsonResponse = jsonDecode(response.body);
  //       return jsonResponse.map((data) => Plant.fromJson(data)).toList();


        
  //     } else {
  //       throw Exception(
  //           'Failed to load recommended plants. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching recommended plants: $e');
  //     throw Exception('Failed to load recommended plants: $e');
  //   }
  // }


  Future<List<Plant>> fetchPlantsForAI(int userId) async {
  print('Fetching recommended plants for user ID $userId');
  final String url = 'http://$ip:3000/plantpat/plant/retriveplantHomeRecomendedSystem?userId=$userId';

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    });

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Plant.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load recommended plants. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching recommended plants: $e');
    throw Exception('Failed to load recommended plants: $e');
  }
}

    Future<bool> fetchFavoriteStatus(int plantId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://$ip:3000/plantpat/plant/isFavorite?plantId=$plantId&userId=${Login.idd}'),
      );

       var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['isFavorite'] == 1; // Check if favorite
      } else {
        throw Exception('Failed to load favorite status');
      }
    } catch (e) {
      print('Error fetching favorite status: $e');
      throw Exception('Failed to load favorite status: $e');
    }
  }

  // Widget _buildSuggestions() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text('Recommended',
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //         SizedBox(height: 10),
  //         FutureBuilder<List<Plant>>(
  //           future: 
  //               fetchPlantsForAI(Login.idd), // Replace with your user ID logic
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return Center(child: CircularProgressIndicator());
  //             } else if (snapshot.hasError) {
  //               return Center(child: Text('Error: ${snapshot.error}'));
  //             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //               return Center(child: Text('No recommendations available'));
  //             } else {
  //               List<Plant> recommendations = snapshot.data!;
  //               return GridView.builder(
  //                 shrinkWrap: true,
  //                 physics: NeverScrollableScrollPhysics(),
  //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 2,
  //                   mainAxisSpacing: 10,
  //                   crossAxisSpacing: 10,
  //                   childAspectRatio: 2 / 3,
  //                 ),
  //                 itemCount: recommendations.length,
  //                 itemBuilder: (context, index) {
  //                   Plant plant = recommendations[index];
  //                   return _buildSuggestionItem(
  //                     plant.name,
  //                     '${plant.price} \$',
  //                     plant.imageData,
  //                     index, // Pass index for favorite toggle
  //                   );
  //                 },
  //               );
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }


 Widget _buildSuggestions() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('16'.tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        FutureBuilder<List<Plant>>(
          future: fetchPlantsForAI(Login.idd), // Replace with your user ID logic
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No recommendations available'));
            } else {
              List<Plant> recommendations = snapshot.data!;

              // Fetch favorite status for each plant
              return FutureBuilder<List<bool>>(
                future: Future.wait(
                  recommendations.map((plant) => fetchFavoriteStatus(plant.plantId)),
                ),
                builder: (context, favoriteSnapshot) {
                  if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (favoriteSnapshot.hasError) {
                    return Center(child: Text('Error: ${favoriteSnapshot.error}'));
                  } else if (!favoriteSnapshot.hasData || favoriteSnapshot.data!.isEmpty) {
                    return Center(child: Text('No recommendations available'));
                  } else {
                    List<bool> favorites = favoriteSnapshot.data!;
                    isFavorite = favorites;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        Plant plant = recommendations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  imagePaths: plant.imageData,
                                  price: plant.price.toString(),
                                  plantId: plant.plantId,
                                  avgRate: plant.avgRate,
                                  height: plant.height,
                                  sectionid: plant.sectionId,
                                  quantity: plant.quantity,
                                  name: plant.name,
                                  description: plant.description,
                                  size:plant.size,
                                ),
                              ),
                            );

                            InteractionOfUser(Login.idd, plant.plantId, 1, 0, 0,0);
                          },
                          child: _buildSuggestionItem(
                            plant.name,
                            '${plant.price} \$',
                            plant.imageData,
                            index,
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ],
    ),
  );
}



Widget _buildSuggestionsWeb() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('16'.tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        FutureBuilder<List<Plant>>(
          future: fetchPlantsForAI(Login.idd), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No recommendations available'));
            } else {
              List<Plant> recommendations = snapshot.data!;

             
              return FutureBuilder<List<bool>>(
                future: Future.wait(
                  recommendations.map((plant) => fetchFavoriteStatus(plant.plantId)),
                ),
                builder: (context, favoriteSnapshot) {
                  if (favoriteSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (favoriteSnapshot.hasError) {
                    return Center(child: Text('Error: ${favoriteSnapshot.error}'));
                  } else if (!favoriteSnapshot.hasData || favoriteSnapshot.data!.isEmpty) {
                    return Center(child: Text('No recommendations available'));
                  } else {
                    List<bool> favorites = favoriteSnapshot.data!;
                    isFavorite = favorites;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        Plant plant = recommendations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  imagePaths: plant.imageData,
                                  price: plant.price.toString(),
                                  plantId: plant.plantId,
                                  avgRate: plant.avgRate,
                                  height: plant.height,
                                  sectionid: plant.sectionId,
                                  quantity: plant.quantity,
                                  name: plant.name,
                                  description: plant.description,
                                  size:plant.size,
                                ),
                              ),
                            );

                            InteractionOfUser(Login.idd, plant.plantId, 1, 0, 0,0);
                          },
                          child: _buildSuggestionItemWeb(
                            plant.name,
                            '${plant.price} \$',
                            plant.imageData,
                            index,
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ],
    ),
  );
}


Widget _buildSuggestionItemWeb(
  String title,
  String price,
  Map<String, dynamic> imagePath,
  int index,
) {
  List<int> bytes = List<int>.from(imagePath['data']);

 
  Widget displayImage = Image.memory(
    Uint8List.fromList(bytes),
    fit: BoxFit.cover,  
  );

  return Stack(
    children: [
    
      SizedBox(
        width: 350,
        height: 400,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: displayImage,
        ),
      ),
     
      Positioned(
        top: 8,
        right: 8,  
        child: IconButton(
          icon: Icon(
            isFavorite[index] ? Icons.favorite : Icons.favorite_border,
            color: isFavorite[index] ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isFavorite[index] = !isFavorite[index];
            });
          },
        ),
      ),
    
      Positioned(
        bottom: 8, 
        left: 8, 
        right: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
          ],
        ),
      ),
    ],
  );
}










  // Widget _buildSuggestionItem(
  //     String title, String price, Map<String, dynamic> imagePath, int index) {
  //   List<int> bytes = List<int>.from(imagePath['data']);

  //   Widget displayImage = Image.memory(
  //     Uint8List.fromList(bytes),
  //     width: double.infinity,
  //     fit: BoxFit.cover,
  //   );

  //   return Stack(
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(8.0),
  //               child: displayImage,
  //             ),
  //           ),
  //           SizedBox(height: 5),
  //           Text(title, style: TextStyle(fontSize: 14)),
  //           Text(price, style: TextStyle(fontSize: 14, color: Colors.green)),
  //         ],
  //       ),
  //       Positioned(
  //         top: 8,
  //         right: 8,
  //         child: IconButton(
  //           icon: Icon(
  //             isFavorite[index] ? Icons.favorite : Icons.favorite_border,
  //             color: isFavorite[index] ? Colors.red : Colors.grey,
  //           ),
  //           onPressed: () {
  //             setState(() {
  //               isFavorite[index] = !isFavorite[index];
  //             });
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

//lujain old
  // Widget _buildSuggestionItem(
  //     String title, String price, Map<String, dynamic> imagePath, int index) {
  //   List<int> bytes = List<int>.from(imagePath['data']);

  //   Widget displayImage = Image.memory(
  //     Uint8List.fromList(bytes),
  //     width: double.infinity,
  //     fit: BoxFit.cover,
  //   );

  //   return Stack(
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(8.0),
  //               child: displayImage,
  //             ),
  //           ),
  //           SizedBox(height: 5),
  //           Text(title, style: TextStyle(fontSize: 14)),
  //           Text(price, style: TextStyle(fontSize: 14, color: Colors.green)),
  //         ],
  //       ),
  //       Positioned(
  //         top: 8,
  //         right: 8,
  //         child: IconButton(
  //           icon: Icon(
  //             isFavorite[index] ? Icons.favorite : Icons.favorite_border,
  //             color: isFavorite[index] ? Colors.red : Colors.grey,
  //           ),
  //           onPressed: () {
  //             setState(() {
  //               isFavorite[index] = !isFavorite[index];
  //             });
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }





  Widget _buildSuggestionItem(
  String title,
  String price,
  Map<String, dynamic> imagePath,
  int index,
) {
  List<int> bytes = List<int>.from(imagePath['data']);

  Widget displayImage = Image.memory(
    Uint8List.fromList(bytes),
    width: double.infinity,
    fit: BoxFit.cover,
  );

  return Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: displayImage,
            ),
          ),
          SizedBox(height: 5),

 if (title.toLowerCase() == 'prickly pear')
          Text(
            '21'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'echeveria')
          Text(
            '20'.tr,
            style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'boxwood')
          Text(
            '24'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'dwarf spirea')
          Text(
            '25'.tr,
            style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'passionflower')
          Text(
            '26'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'dwarf hydrangea')
          Text(
            '27'.tr,
            style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'clematis')
          Text(
            '28'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'bougainvillea')
          Text(
            '29'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'honeysuckle')
          Text(
            '30'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'wisteria')
          Text(
            '31'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'lavender')
          Text(
            '32'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'peony')
          Text(
            '33'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'hosta')
          Text(
            '34'.tr,
           style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'daylily')
          Text(
            '35'.tr,
        style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'daisy')
          Text(
            '36'.tr,
            style: TextStyle(fontSize: 14)
          ),
        if (title.toLowerCase() == 'forsythia')
          Text(
            '37'.tr,
           style: TextStyle(fontSize: 14)
          ),










      //    Text(title, style: TextStyle(fontSize: 14)),
          Text(price, style: TextStyle(fontSize: 14, color: Colors.green)),
        ],
      ),
      Positioned(
        top: 8,
        right: 8,
        child: IconButton(
          icon: Icon(
            isFavorite[index] ? Icons.favorite : Icons.favorite_border,
            color: isFavorite[index] ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isFavorite[index] = !isFavorite[index];
            });
          },
        ),
      ),
    ],
  );
}


  //lujain new

  // Widget _buildSuggestionItem(
  //     String title, String price, Map<String, dynamic> imagePath, int index) {
  //   List<int> bytes = List<int>.from(imagePath['data']);
  //   Widget displayImage = Image.memory(
  //     Uint8List.fromList(bytes),
  //     width: double.infinity,
  //     fit: BoxFit.cover,
  //   );

  //   return Stack(
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(8.0),
  //               child: displayImage,
  //             ),
  //           ),
  //           SizedBox(height: 5),
  //           Text(title, style: TextStyle(fontSize: 14)),
  //           Text(price, style: TextStyle(fontSize: 14, color: Colors.green)),
  //         ],
  //       ),
  //       Positioned(
  //         top: 8,
  //         right: 8,
  //         child: ValueListenableBuilder<bool>(
  //           valueListenable: isInWishlist,
  //           builder: (context, value, child) {
  //             return GestureDetector(
  //               onTap: () async {
  //                 if (value) {
  //                   await WishlistPageState.deleteFromWishList(
  //                       productId, context);
  //                 } else {
  //                   await WishlistPageState.addToWishList(productId, context);
  //                 }
  //                 isInWishlist.value = !isInWishlist.value;
  //               },
  //               child: Icon(
  //                 value ? Icons.favorite : Icons.favorite_border,
  //                 color: value ? Colors.red : Color.fromARGB(255, 2, 46, 82),
  //                 size: 20,
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // void _showMore() {
  //   setState(() {
  //     recommendations.addAll([
  //       'assets/images/1.jpg',
  //       'assets/images/2.jpg',
  //       'assets/images/3.jpg',
  //       'assets/images/4.jpg'
  //     ]);
  //     isFavorite.addAll([false, false, false, false]);
  //   });
  // }
}

class Plant {
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

  Plant({
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

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
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

class Section {
  final int sectionId;
  final String name;
  final String description;
  final Map<String, dynamic> imageData;

  Section({
    required this.sectionId,
    required this.name,
    required this.description,
    required this.imageData,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      sectionId: json['sectionid'],
      name: json['name'],
      description: json['description'],
      imageData: json['image'],
    );
  }
}

//

//
// Future<List<Plant>> fetchPlants() async {
//   try {
//     final response =
//         await http.get(Uri.parse('http://$ip:3000/plantpat/home/plants'));
//     if (response.statusCode == 200) {
//       List<dynamic> jsonResponse = jsonDecode(response.body);
//       return jsonResponse.map((data) => Plant.fromJson(data)).toList();
//     } else {
//       throw Exception(
//           'Failed to load plants. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching plants: $e');
//     throw Exception('Failed to load plants: $e');
//   }
// }

// Future<List<Plant>> fetchPlants() async {comment now
//   try {
//     final response = await http
//         .get(Uri.parse('http://$ip:3000/plantpat/home/plants'))
//         .timeout(Duration(seconds: 60)); // Set a timeout of 60 seconds

//     if (response.statusCode == 200) {
//       List<dynamic> jsonResponse = jsonDecode(response.body);
//       return jsonResponse.map((data) => Plant.fromJson(data)).toList();
//     } else {
//       throw Exception(
//           'Failed to load plants. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching plants: $e');
//     throw Exception('Failed to load plants: $e');
//   }
// }

// Future<List<Plant>> fetchPlantsThisMonth() async {
//   print('Fetching plants for this month');
//   try {
//     final response = await http
//         .get(Uri.parse('http://$ip:3000/plantpat/plant/plantThisMonth'));
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       List<dynamic> jsonResponse = jsonDecode(response.body);
//       return jsonResponse.map((data) => Plant.fromJson(data)).toList();
//     } else {
//       throw Exception(
//           'Failed to load plants for this month. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching plants for this month: $e');
//     throw Exception('Failed to load plants for this month: $e');
//   }
// }

// Future<String> fetchPricePlant(int plantId) async {comment now
//   try {
//     final response = await http
//         .get(Uri.parse('http://$ip:3000/plantpat/plant/price?id=$plantId'));
//     if (response.statusCode == 200) {
//       dynamic responseData = jsonDecode(response.body);
//       if (responseData is List && responseData.isNotEmpty) {
//         dynamic firstItem = responseData.first;
//         if (firstItem is Map<String, dynamic> &&
//             firstItem.containsKey('price')) {
//           return firstItem['price'].toString();
//         } else {
//           throw Exception('Invalid response data format for price');
//         }
//       } else {
//         throw Exception('Empty or invalid response data format for price');
//       }
//     } else {
//       throw Exception(
//           'Failed to fetch price for product $plantId. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error: $e');
//     throw Exception('Failed to fetch price for product $plantId: $e');
//   }
// }
