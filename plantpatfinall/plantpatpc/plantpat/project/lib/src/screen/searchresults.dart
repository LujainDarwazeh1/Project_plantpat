import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/home.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/prod_info.dart';
import 'package:plantpat/src/screen/search_page.dart';
import 'package:plantpat/src/screen/shopping_cart.dart'; 

class Searchresults extends StatefulWidget {
  final String name;

  Searchresults({required this.name});

  @override
  Searchresultsstate createState() => Searchresultsstate();
}

class Searchresultsstate extends State<Searchresults> {
  List<Plant> plants = [];
  List<bool> isFavorite = []; 

  @override
  void initState() {
    super.initState();
    serachGetTheProduct(widget.name); 
  }



  

 Future<void> serachGetTheProduct(String name) async {
  print("nameeeeeeeeeeeeeeeeee:::::::::::::::::");
  print(name);
  http.Response? response;

  try {
    String encodedName = Uri.encodeComponent(name);
    response = await http.get(Uri.parse(
        'http://$ip:3000/plantpat/search/retriveProductOfsearch?name=$encodedName'));
        var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic responseData = jsonDecode(response.body);

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('results')) {
        List<dynamic> results = responseData['results'];

        if (results is List) {
          setState(() {
            plants = results.map((data) => Plant.fromJson(data)).toList();
            isFavorite = List.generate(plants.length, (index) => false);
            _updateFavorites();
          });
        } else {
          print('Failed to fetch data. Unexpected response format.');
        }
      } else {
        print('Failed to fetch data. Response does not contain "results" key.');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  Future<void> _updateFavorites() async {
    for (int i = 0; i < plants.length; i++) {
      isFavorite[i] = await fetchFavoriteStatus(plants[i].plantId);
    }
    setState(() {});
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

 



int _selectedIndex = 1;
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
    return kIsWeb ? buildWebSearch() : buildMobileSearch();
  }






   Widget buildMobileSearch() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Results',
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
              "Results",
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
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  return _buildSuggestionItem(
                    plants[index].name,
                    '${plants[index].price}\$',

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


Widget buildWebSearch() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Results',
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
              "Results",
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
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  return _buildSuggestionItemweb(
                    plants[index].name,
                    '${plants[index].price}\$',

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
                            )),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: displayImage,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 14)),
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
            onPressed: () async {
              try {
                if (isFavorite[index]) {
                  await deleteFromWishList(plants[index].plantId, context);
                } else {
                  await addToWishList(plants[index].plantId, context);
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
                  SnackBar(
                    content: Text('Failed to update favorite status'),
                  ),
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
                            )),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: displayImage,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(title, style: TextStyle(fontSize: 14)),
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
            onPressed: () async {
              try {
                if (isFavorite[index]) {
                  await deleteFromWishList(plants[index].plantId, context);
                } else {
                  await addToWishList(plants[index].plantId, context);
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
                  SnackBar(
                    content: Text('Failed to update favorite status'),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  static final String baseUrl = 'http://$ip:3000/plantpat/plant';

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
        print('Failed to delete from wishlist. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting from wishlist: $e');
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
