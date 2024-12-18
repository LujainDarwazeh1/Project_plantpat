import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/home.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/prod_info.dart';
import 'package:plantpat/src/screen/search_page.dart';
import 'package:plantpat/src/screen/shopping_cart.dart'; 

class Similar extends StatefulWidget {
  final int plantId;
  Similar({required this.plantId});

  @override
  SimilarPageState createState() => SimilarPageState();
}

class SimilarPageState extends State<Similar> {
  final String baseUrl = 'http://$ip:3000/plantpat/plant';

  List<Plant> plants = [];
  List<bool> isFavorite = [];

  @override
  void initState() {
    super.initState();
    findSimilar(widget.plantId);
  }

  Future<void> findSimilar(int plantId) async {
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
      print("Request URL: $url");

      final response = await http.get(url);

     
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        
        print("Parsed response data: $responseData");

        
        if (responseData is List) {
          setState(() {
            plants = List<Plant>.from(
              responseData.map((item) => Plant.fromJson(item)),
            );
            isFavorite = List.generate(plants.length, (index) => false);
          });
          
          for (int i = 0; i < plants.length; i++) {
            bool favoriteStatus = await fetchFavoriteStatus(plants[i].plantId);
            setState(() {
              isFavorite[i] = favoriteStatus;
            });
          }
        } else {
          print(
              'Failed to find similar products. Response data is not a list.');
        }
      } else {
        print(
            'Failed to find similar products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error finding similar products: $e');
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
        return jsonResponse['isFavorite'] == 1;
      } else {
        throw Exception('Failed to load favorite status');
      }
    } catch (e) {
      print('Error fetching favorite status: $e');
      return false;
    }
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
    case 1:  // This case handles the navigation to SearchPage
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






  @override
  Widget build(BuildContext context) {
    return kIsWeb ? buildWebSimilar() : buildMobileSimilar();
  }




   Widget buildMobileSimilar() {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:
            Text('69'.tr, style: TextStyle(color: Colors.black)),
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
            Text("70".tr,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  return _buildSuggestionItem(
                    plants[index].name,
                    plants[index].price.toString(),
                    plants[index].imageData,
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




  Widget buildWebSimilar() {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:
            Text('69'.tr, style: TextStyle(color: Colors.black)),
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
            Text("70".tr,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  return _buildSuggestionItemweb(
                    plants[index].name,
                    plants[index].price.toString(),
                    plants[index].imageData,
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



  Widget _buildSuggestionItemweb(
      String title, String price, Map<String, dynamic> imagePath, int index) {
    List<int> bytes = List<int>.from(imagePath['data']);
    Widget displayImage = Image.memory(Uint8List.fromList(bytes),
         width: 350,
        height: 400, fit: BoxFit.cover);

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        size: plants[index].size,
                        imagePaths: plants[index].imageData,
                        price: plants[index].price.toString(),
                        plantId: plants[index].plantId,
                        avgRate: plants[index].avgRate,
                        height: plants[index].height,
                        sectionid: plants[index].sectionId,
                        quantity: plants[index].quantity,
                        name: plants[index].name,
                        description: plants[index].description,
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



       //     Text(title, style: TextStyle(fontSize: 14)),


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
  style: TextStyle(fontSize: 14)
),



            Text('${price}\$', style: TextStyle(fontSize: 14, color: Colors.green)),

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
            onPressed: () async {
              try {
                if (isFavorite[index]) {
                  await deleteFromWishList(plants[index].plantId, context);
                } else {
                  await addToWishList(plants[index].plantId, context);
                  InteractionOfUser(Login.idd, widget.plantId, 0, 0, 0,1);
                }

                setState(() {
                  isFavorite[index] = !isFavorite[index];
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFavorite[index]
                        ? 'Added to favorites'
                        : 'Removed from favorites'),
                  ),
                );
              } catch (e) {
                print('Error updating favorite status: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update favorite status')),
                );
              }
            },
          ),
        ),
      ],
    );
  }



  Widget _buildSuggestionItem(
      String title, String price, Map<String, dynamic> imagePath, int index) {
    List<int> bytes = List<int>.from(imagePath['data']);
    Widget displayImage = Image.memory(Uint8List.fromList(bytes),
        width: double.infinity, fit: BoxFit.cover);

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        size: plants[index].size,
                        imagePaths: plants[index].imageData,
                        price: plants[index].price.toString(),
                        plantId: plants[index].plantId,
                        avgRate: plants[index].avgRate,
                        height: plants[index].height,
                        sectionid: plants[index].sectionId,
                        quantity: plants[index].quantity,
                        name: plants[index].name,
                        description: plants[index].description,
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



       //     Text(title, style: TextStyle(fontSize: 14)),


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
  style: TextStyle(fontSize: 14)
),



            Text('${price}\$', style: TextStyle(fontSize: 14, color: Colors.green)),

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
            onPressed: () async {
              try {
                if (isFavorite[index]) {
                  await deleteFromWishList(plants[index].plantId, context);
                } else {
                  await addToWishList(plants[index].plantId, context);
                  InteractionOfUser(Login.idd, widget.plantId, 0, 0, 0,1);
                }

                setState(() {
                  isFavorite[index] = !isFavorite[index];
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFavorite[index]
                        ? 'Added to favorites'
                        : 'Removed from favorites'),
                  ),
                );
              } catch (e) {
                print('Error updating favorite status: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update favorite status')),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> addToWishList(int plantId, BuildContext context) async {
    try {
      final url = Uri.parse('$baseUrl/addToWishList');
      var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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





}





  // static Future<void> retriveFromWishList() async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'http://$ip:3000/plantpat/plant/retriveFromWishList?userId=${Login.idd}'));

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       dynamic responseData = jsonDecode(response.body);

  //       // Check if responseData is a List
  //       if (responseData is List) {
  //         planttDataWishList = List<Map<String, dynamic>>.from(responseData);
  //         print('Wishlist data fetched successfully.');
  //         // Optionally update UI or notify listeners
  //       } else {
  //         print('Failed to fetch wishlist data. Expected a List.');
  //         // Optionally show a notification or update UI
  //       }
  //     } else {
  //       print('Failed to fetch data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching wishlist data: $e');
  //     // Optionally show a notification or update UI
  //   }
  // }








//


// class SectionPage extends StatefulWidget {
//   final int sectionId;

//   SectionPage({required this.sectionId});

//   @override
//   _SectionPageState createState() => _SectionPageState();
// }

// class _SectionPageState extends State<SectionPage> {
//   late Future<String> sectionName;
//   late Future<List<Plant>> plants;

//   @override
//   void initState() {
//     super.initState();
//     sectionName = fetchSectionName(widget.sectionId);
//     plants = fetchPlantsForSection(widget.sectionId);
//   }

//   Future<String> fetchSectionName(int sectionId) async {
//     print('Fetching Section Name');
//     try {
//       final response = await http.get(
//         Uri.parse('http://$ip:3000/plantpat/plant/Sectionname?id=$sectionId'),
//       );
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         final sectionName = jsonResponse['name'];
//         return sectionName;
//       } else {
//         throw Exception('Failed to load section name');
//       }
//     } catch (e) {
//       print('Error fetching Section name : $e');
//       throw Exception('Failed to load section name: $e');
//     }
//   }

//   Future<List<Plant>> fetchPlantsForSection(int sectionId) async {
//     print('Fetching Plants for Section');
//     try {
//       final response = await http.get(
//         Uri.parse('http://$ip:3000/plantpat/home/plant?id=$sectionId'),
//       );
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonResponse = jsonDecode(response.body);
//         List<Plant> plants =
//             jsonResponse.map((json) => Plant.fromJson(json)).toList();
//         return plants;
//       } else {
//         throw Exception('Failed to load plants for section');
//       }
//     } catch (e) {
//       print('Error fetching plants for Section : $e');
//       throw Exception('Failed to load plants for section : $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'All plants',
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FutureBuilder<String>(
//               future: sectionName,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else {
//                   return Text(
//                     snapshot.data ?? 'Section Name',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   );
//                 }
//               },
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: FutureBuilder<List<Plant>>(
//                 future: plants,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else {
//                     return GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 10,
//                         crossAxisSpacing: 10,
//                         childAspectRatio: 2 / 3,
//                       ),
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         return _buildPlantItem(snapshot.data![index]);
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 1, // Set index according to your need
//         onTap: _onItemTapped,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: Colors.green), // Home icon
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search, color: Colors.black), // Search icon
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart, color: Colors.black), // Cart icon
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat, color: Colors.black), // Chat icon
//             label: 'Chat',
//           ),
//         ],
//         selectedItemColor: Colors.green,
//       ),
//     );
//   }

//   Widget _buildPlantItem(Plant plant) {
//     return Stack(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 // onTap: () {
//                 //   // Navigate to product info page or detailed view
//                 //   Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //       builder: (context) =>DetailPage(
//                 //         size: plant.size,
//                 //         imagePaths: plant.imagePaths,
//                 //         price: plant.price,
//                 //         plantId: plant.plantId,
//                 //         avgRate: plant.avgRate,
//                 //         height: plant.height,
//                 //         sectionid: plant.sectionid,
//                 //         quantity: plant.quantity,
//                 //         name: plant.name,
//                 //         description: plant.description,
//                 //       ),
//                 //     ),
//                 //   );
//                 // },
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Image.network(
//                     // Assuming you have imageURL in Plant model or use AssetImage if local image
//                     plant.imageData['url'],
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(plant.name, style: TextStyle(fontSize: 14)),
//             Text('\$${plant.price}',
//                 style: TextStyle(fontSize: 14, color: Colors.green)),
//           ],
//         ),
//         Positioned(
//           top: 8,
//           right: 8,
//           child: IconButton(
//             icon: Icon(
//               Icons.favorite_border,
//               color: Colors.grey,
//             ),
//             onPressed: () {
//               // Handle favorite functionality here
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   void _onItemTapped(int index) {
//     // Implement navigation logic here
//     switch (index) {
//       case 0:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => CartPage()),
//         );
//         break;
//       case 3:
//         // Navigate to chat page (if available)
//         break;
//     }
//   }
// }
