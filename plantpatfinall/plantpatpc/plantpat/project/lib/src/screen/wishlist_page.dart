import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/findsimilar.dart';
import 'package:plantpat/src/screen/home.dart';
import 'dart:convert';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/prod_info.dart';
import 'package:plantpat/src/screen/search_page.dart';
import 'package:plantpat/src/screen/shopping_cart.dart'; 
import 'package:plantpat/src/screen/findsimilar.dart';

class WishlistPage extends StatefulWidget {
  @override
  WishlistPageState createState() => WishlistPageState();
}

class WishlistPageState extends State<WishlistPage> {
  static List<Map<String, dynamic>> planttDataWishList = [];
  static List<Map<String, dynamic>> productSimilar = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    await retriveFromWishList();
    setState(() {});
  }

 



int _selectedIndex = 2;
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
    
      break;
  }
}

  static final String baseUrl = 'http://$ip:3000/plantpat/plant';

  Future<void> addToWishList(int plantId, BuildContext context) async {
    try {
      final url = Uri.parse('$baseUrl/addToWishList');
      final response = await http.post(
        url,
        headers: <String, String>{
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    },
        body: jsonEncode(<String, dynamic>{
          'userId': Login.idd,
          'plantId': plantId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Added to wishlist successfully.');
    
      } else if (response.statusCode == 401) {
        print('Plant already in wishlist.');
       
      } else {
        print('Failed to add to wishlist. Status code: ${response.statusCode}');
    
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
     
    }
  }

  Future<void> deleteFromWishList(int plantId, BuildContext context) async {
    try {
      final url = Uri.parse(
          '$baseUrl/deleteFromWishList?plantId=$plantId&userId=${Login.idd}');


          var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Deleted from wishlist successfully.');
    
      } else {
        print(
            'Failed to delete from wishlist. Status code: ${response.statusCode}');
    
      }
    } catch (e) {
      print('Error deleting from wishlist: $e');
  
    }
  }

  static Future<void> retriveFromWishList() async {
    try {
      final response = await http.get(Uri.parse(
          'http://$ip:3000/plantpat/plant/retriveFromWishList?userId=${Login.idd}'));
          var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic responseData = jsonDecode(response.body);

      
        if (responseData is List) {
          planttDataWishList = List<Map<String, dynamic>>.from(responseData);
          print('Wishlist data fetched successfully.');
        
        } else {
          print('Failed to fetch wishlist data. Expected a List.');
        
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching wishlist data: $e');
 
    }
  }

  Future<void> findSimilar(int plantId, String name) async {
    try {
      final url = Uri.parse('$baseUrl/findSimilar?plantId=$plantId');
      var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('productSimilar')) {
          productSimilar =
              List<Map<String, dynamic>>.from(responseData['productSimilar']);
          print('Similar products found successfully.');
   
        } else {
          print('Failed to find similar products.');
       
        }
      } else {
        print(
            'Failed to find similar products. Status code: ${response.statusCode}');
      
      }
    } catch (e) {
      print('Error finding similar products: $e');
    
    }
  }







  
  @override
  Widget build(BuildContext context) {
    return kIsWeb ? buildWeblist() : buildMobilelist();
  }




   Widget buildMobilelist() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '66'.tr,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '67'.tr,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2 / 3,
                ),
                itemCount:
                    planttDataWishList.length, 
                itemBuilder: (context, index) {
                  final item = planttDataWishList[index];
                  return _buildWishlistItem(
                    item['name'] ?? 'Unknown',
                   '${item['price'] ?? '0.00'}\$',



                    item['image'] ?? '', 
                    index,
                  );
                },
              ),
            ),
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





Widget buildWeblist(){
      return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '66'.tr,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '67'.tr,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount:
                    planttDataWishList.length, 
                itemBuilder: (context, index) {
                  final item = planttDataWishList[index];
                  return _buildWishlistItemweb(
                    item['name'] ?? 'Unknown',
                   '${item['price'] ?? '0.00'}\$',



                    item['image'] ?? '', 
                    index,
                  );
                },
              ),
            ),
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


Widget _buildWishlistItemweb(
      String title, String price, Map<String, dynamic> imagePath, int index) {
   
    List<int> bytes = List<int>.from(imagePath['data'] ?? []);

 
    Widget displayImage = Image.memory(
      Uint8List.fromList(bytes),
       width: 350,
        height: 400,
      fit: BoxFit.cover,
    );

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  final item =
                      planttDataWishList[index];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        size: item['size']?.toString() ??
                            'Unknown', 
                        imagePaths: item['image'] ??
                            {}, 
                        price: item['price']?.toString() ??
                            '0.0', 
                        plantId: item['id'] ??
                            0, 
                        avgRate: item['average_rating']?.toString() ??
                            '0.0', 
                        height: double.tryParse(
                                item['height']?.toString() ?? '0.0') ??
                            0.0, 
                        sectionid: item['sectionid'] ?? 0, 
                        quantity: item['quantity'] ?? 0, 
                        name: item['name'] ?? 'Unknown', 
                        description: item['description'] ??
                            'No description', 
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: displayImage,
                ),
              ),
            ),
            SizedBox(height: 5),
         




Text(
  title.toLowerCase() == 'prickly pear' ? '21'.tr :
  title.toLowerCase() == 'echeveria' ? '20'.tr :
  title.toLowerCase() == 'boxwood' ? '24'.tr :
  title.toLowerCase() == 'dwarf spirea' ? '25'.tr :
  title.toLowerCase() == 'passionflower' ? '26'.tr :
  title.toLowerCase() == 'dwarf hydrangea' ? '27'.tr :
  title.toLowerCase() == 'clematis' ? '28'.tr :
  title.toLowerCase() == 'bougainvillea' ? '29'.tr :
  title.toLowerCase() == 'honeysuckle' ? '30'.tr :
  title.toLowerCase() == 'wisteria' ? '31'.tr :
  title.toLowerCase() == 'lavender' ? '32'.tr :
  title.toLowerCase() == 'peony' ? '33'.tr :
  title.toLowerCase() == 'hosta' ? '34'.tr :
  title.toLowerCase() == 'daylily' ? '35'.tr :
  title.toLowerCase() == 'daisy' ? '36'.tr :
  title.toLowerCase() == 'forsythia' ? '37'.tr :
  'Unknown'.tr,
  style: TextStyle(fontSize: 14),
  overflow: TextOverflow.ellipsis,
),







            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
                Container(
                  width: 90, 
                  height: 25, 
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Similar(plantId: planttDataWishList[index]['id']),
                        ),
                      );
                    },
                    child: Text(
                      '68'.tr,
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red, 
            ),
            onPressed: () {
              
              deleteFromWishList(planttDataWishList[index]['id'], context)
                  .then((_) {
                setState(() {
                  planttDataWishList.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed from wishlist.'),
                  ),
                );
              }).catchError((e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to remove from wishlist.'),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }














  Widget _buildWishlistItem(
      String title, String price, Map<String, dynamic> imagePath, int index) {
   
    List<int> bytes = List<int>.from(imagePath['data'] ?? []);

   
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
              child: GestureDetector(
                onTap: () {
                  final item =
                      planttDataWishList[index]; 

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        size: item['size']?.toString() ??
                            'Unknown', 
                        imagePaths: item['image'] ??
                            {}, 
                        price: item['price']?.toString() ??
                            '0.0',
                        plantId: item['id'] ??
                            0, 
                        avgRate: item['average_rating']?.toString() ??
                            '0.0', 
                        height: double.tryParse(
                                item['height']?.toString() ?? '0.0') ??
                            0.0, 
                        sectionid: item['sectionid'] ?? 0, 
                        quantity: item['quantity'] ?? 0, 
                        name: item['name'] ?? 'Unknown', 
                        description: item['description'] ??
                            'No description', 
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: displayImage,
                ),
              ),
            ),
            SizedBox(height: 5),
          






Text(
  title.toLowerCase() == 'prickly pear' ? '21'.tr :
  title.toLowerCase() == 'echeveria' ? '20'.tr :
  title.toLowerCase() == 'boxwood' ? '24'.tr :
  title.toLowerCase() == 'dwarf spirea' ? '25'.tr :
  title.toLowerCase() == 'passionflower' ? '26'.tr :
  title.toLowerCase() == 'dwarf hydrangea' ? '27'.tr :
  title.toLowerCase() == 'clematis' ? '28'.tr :
  title.toLowerCase() == 'bougainvillea' ? '29'.tr :
  title.toLowerCase() == 'honeysuckle' ? '30'.tr :
  title.toLowerCase() == 'wisteria' ? '31'.tr :
  title.toLowerCase() == 'lavender' ? '32'.tr :
  title.toLowerCase() == 'peony' ? '33'.tr :
  title.toLowerCase() == 'hosta' ? '34'.tr :
  title.toLowerCase() == 'daylily' ? '35'.tr :
  title.toLowerCase() == 'daisy' ? '36'.tr :
  title.toLowerCase() == 'forsythia' ? '37'.tr :
  'Unknown'.tr,
  style: TextStyle(fontSize: 14),
  overflow: TextOverflow.ellipsis,
),







            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: TextStyle(fontSize: 14, color: Colors.green),
                ),
                Container(
                  width: 90,
                  height: 25,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Similar(plantId: planttDataWishList[index]['id']),
                        ),
                      );
                    },
                    child: Text(
                      '68'.tr,
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red, 
            ),
            onPressed: () {
             
              deleteFromWishList(planttDataWishList[index]['id'], context)
                  .then((_) {
                setState(() {
                  planttDataWishList.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed from wishlist.'),
                  ),
                );
              }).catchError((e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to remove from wishlist.'),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
