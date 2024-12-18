import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:plantpat/src/screen/order_details_user.dart';
import 'package:plantpat/src/screen/wishlist_page.dart';
import'package:plantpat/src/screen/search_page.dart';
import 'package:plantpat/src/screen/home.dart';
import'package:plantpat/src/screen/notification_send_msg.dart';

class CartPage extends StatefulWidget {
  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
   static double amount = 0.0;
  static List<Map<String, dynamic>> cartItems = [];
  

  static List<int> ids = [];
  static List<int> idsplant = [];
  static List<int> countplant = [];



  static List<Map<String, dynamic>> cartShopContain = [];
  static List<int> productCount = [];
  static List<int> productQuantity = [];
  static List<bool> selectedCheckboxes = [];


  static int plantidd = 1;

  @override
  void initState() {
    super.initState();



    fetchCart();
  }

  void refreshCart() {
    fetchCart();
  }


  final Map<String, String> plantTranslations = {
  'prickly pear': '21',
  'echeveria': '20',
  'boxwood': '24',
  'dwarf spirea': '25',
  'passionflower': '26',
  'dwarf hydrangea': '27',
  'clematis': '28',
  'bougainvillea': '29',
  'honeysuckle': '30',
  'wisteria': '31',
  'lavender': '32',
  'peony': '33',
  'hosta': '34',
  'daylily': '35',
  'daisy': '36',
  'forsythia': '37',
};

Text getPlantTranslationText(String title) {
  final translationKey = plantTranslations[title.toLowerCase()];
  return Text(
    translationKey != null ? translationKey.tr : '', 
 
  );
}

 
 
  void fetchCart() async {
    await fetchCartItems(Login.idd);

    setState(() {
      if (productCount == null ||
          productCount.isEmpty ||
          productCount.length != cartItems.length) {
        productCount = List.filled(cartItems.length, 1);
      }

      selectedCheckboxes = List.generate(cartItems.length, (index) => false);
    });

    //   if (selectedCheckboxes.isEmpty) {
    //     allCheckboxChecked = false;
    //   }
    //   if (allCheckboxChecked && Payment.isPay) {
    //     //for (int i = 0; i < selectedCheckboxes.length; i++) {
    //     // deleteProduct(i);
    //     // }
    //     Payment.isPay = false;
    //     allCheckboxChecked = false;
    //     deleteProductAll(0, selectedCheckboxes.length);
    //   }
    //   if (selectedCheckboxes.isEmpty ||
    //       selectedCheckboxes.length != productInCart.length) {
    //     selectedCheckboxes =
    //         List.generate(productInCart.length, (index) => false);
    //   }

    //   if (productCount == null ||
    //       productCount.isEmpty ||
    //       productCount.length != productInCart.length) {
    //     productCount = List.filled(productInCart.length, 1);
    //   }

    //   selectedCheckboxes = List.from(selectedCheckboxes, growable: true);

    //   while (selectedCheckboxes.length < productInCart.length) {
    //     selectedCheckboxes.add(false);
    //   }

    //   for (int i = 0; i < selectedCheckboxes.length; i++) {
    //     if (i >= productCount.length || selectedCheckboxes[i] == null) {
    //       selectedCheckboxes[i] = false;
    //     }
    //   }
    //   //// new 8_MAY
    //   if (selectedListOfUserToPay.isEmpty ||
    //       selectedListOfUserToPay.length != productInCart.length) {
    //     selectedListOfUserToPay =
    //         List.generate(productInCart.length, (index) => 0);
    //   }
    //   selectedListOfUserToPay =
    //       List.from(selectedListOfUserToPay, growable: true);

    //   while (selectedListOfUserToPay.length < selectedCheckboxes.length) {
    //     selectedListOfUserToPay.add(0);
    //   }

    //   for (int i = 0; i < selectedCheckboxes.length; i++) {
    //     if (i >= selectedListOfUserToPay.length ||
    //         selectedListOfUserToPay[i] == null) {
    //       selectedListOfUserToPay[i] = 0;
    //     }
    //   }

    //   // }
    // });
  }

  static Future<void> shoppingCartStore(
    String numberItem,
    String date,
    String name,
    BuildContext context,
  ) async {
    final url =
        Uri.parse('http://$ip:3000/plantpat/shoppingcart/addToShopCart');
         var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    };
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, dynamic>{
          'id': Login.idd,
          'Number_Item': numberItem,
          'date': date,
          'name': name,
        }),
      );
     
      if (response.statusCode == 200 || response.statusCode == 201) {
         final responseData = jsonDecode(response.body);
         final cartId = int.parse(responseData['cart_id'].toString());
         print("responseData['cart_id'] type: ${responseData['cart_id'].runtimeType}");



        
        Flushbar(
          message: "This plant added to shopping cart.",
          duration: Duration(seconds: 3),
         
          margin: EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
        ).show(context);
        print('store to cart  successful');

       
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("not store"),
        ));
       
        print('not store');
      } else {
      
        Flushbar(
          message:
              "This plant is already in your shopping cart and cannot be added again.",
          duration: Duration(seconds: 3),
        
          margin: EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
        ).show(context);
      
        print('failed to store Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchCartItems(int userId) async {
    print("hello from fetch cart item");
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
          print(response.body);
          setState(() {

            
            cartShopContain =
                List<Map<String, dynamic>>.from(responseData['results']);
             

                print("idsssssssssss");
                print(ids);
            cartItems =
                List<Map<String, dynamic>>.from(responseData['allProductData']);
          });
          print("Cart items:");
          print(cartItems);
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

  void _incrementQuantity(int index, int id) {
    setState(() {
     
      if (productCount[index] < cartItems[index]['quantity']) {
        incrementItemOnShopCart(Login.idd, id);
       

        productCount[index]++;
      } else {
       
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Sorry, the plant is SOLD OUT.",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red, 
          ),
        );
      }
    });
  }

  void _removeItem(int index, int id) {
    setState(() {
      cartItems.removeAt(index);
      deleteProductCart(
        id,
        Login.idd,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "plant remove successfully.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black, 
        ),
      );
    });
  }

  void _decrementQuantity(int index, int id) {
    setState(() {
      if (productCount[index] == 0) {
        _removeItem(index, id);
      }
      if (productCount[index] > 1) {
        decrementItemOnShopCart(Login.idd, id);
        productCount[index]--;
      
      }
    });
  }


// void updateSelectedPlantIds() {
//   ids.clear(); // Clear the list before adding new IDs

//   if (cartItems != null &&
//       selectedCheckboxes != null &&
//       productCount != null) {
//     for (int i = 0; i < cartItems.length; i++) {
//       // Print the current cart item for debugging
//       print("Inspecting cart item at index $i: ${cartItems[i]}");

//       if (i < selectedCheckboxes.length &&
//           selectedCheckboxes[i] &&
//           i < productCount.length) {
//         // Safely retrieve and cast the plant_id
//         var plantId = cartItems[i]['plant_id'];
//         print("Retrieved plant_id: $plantId");

//         if (plantId != null && plantId is int) {
//           ids.add(plantId);
//         } else {
//           print("Warning: plant_id is null or not an int at index $i");
//         }
//       }
//     }
//   } else {
//     print("Error: cartItems, selectedCheckboxes, or productCount is null");
//   }

//   print("Selected Plant IDs: $ids");
// }





double calculateTotalPrice() {
  double total = 0.0; 
  ids.clear(); 
  countplant.clear();
 

  if (cartItems != null &&
      selectedCheckboxes != null &&
      productCount != null) {
    print("nothing null");
    print("cartItems.length: ${cartItems.length}");
    print("selectedCheckboxes.length: ${selectedCheckboxes.length}");

    for (int i = 0; i < cartItems.length; i++) {
      if (i < selectedCheckboxes.length &&
          i < productCount.length &&
          selectedCheckboxes[i]) {
        print("selectedCheckboxes[i]: ${selectedCheckboxes[i]}");
        print("productCount[i]: ${productCount[i]}");
        print("cartItems[index]['price']: ${cartItems[i]['price']}");

        if (productCount[i] != null) {
          double price = cartItems[i]['price'] ?? 0.0; 
          int count = productCount[i] ?? 0; 
          total += price * count;

       
          var plantId = cartShopContain[i]['cart_id'];
          var newplantid=cartItems[i]['id'];
        var plantCount = productCount[i];
          
          if (plantId != null && plantId is int) {
            ids.add(plantId);
            idsplant.add(newplantid);
            countplant.add(plantCount);
          } else {
            print("Warning: plant_id is null or not an int at index $i");
          }
        }
      }
    }
  }
  print("plantid:::::::::::::::");
  print(idsplant);

  print("plant count");
   print(countplant);

  print("Selected Plant IDs: $ids");
  print("Total Price: $total");
  return total;
}

  // void deleteProduct(int index, int idproduct) {
  //   print(' in delete product from fronend id: $idproduct');
  //   setState(() {
  //     if (index < cartItems.length) cartItems.removeAt(index);

  //     if (index < cartShopContain.length) cartShopContain.removeAt(index);
  //     if (index < selectedListOfUserToPay.length)
  //       selectedListOfUserToPay.removeAt(index);
  //     if (index < selectedCheckboxes.length) selectedCheckboxes.removeAt(index);

  //   });
  // }

  int getQuantity(int index) {
    return 1;
  }

  // double _calculateTotal() {
  //   double total = 0;
  //   for (var item in cartItems) {
  //     total += item['price'] * item['quantity'];
  //   }
  //   return total;
  // }

  // double calculateTotalPrice() {
  //   double total = 0.0;
  //   if (cartItems != null &&
  //       productCount != null) {
  //     for (int i = 0; i < cartShopContain.length; i++) {
  //       if (i < selectedCheckboxes.length &&
  //           i < productCount.length &&
  //           selectedCheckboxes[i]) {
  //         if (i < cartShopContain.length && productCount[i] != null) {
  //           Map<String, dynamic> details = cartShopContain[i];
  //           double price = double.tryParse(details['price'] ?? '0.0') ?? 0.0;

  //           int count = productCount[i] ?? 0;
  //           total += price * count;
  //         }
  //       }
  //     }
  //   }
  //   return total;
  // }

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

  void _navigateToWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WishlistPage()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    amount = calculateTotalPrice();
    print('***************productInCart: $cartItems');
    return Scaffold(
      appBar: AppBar(
        title: Text('62'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.green), 
            onPressed: _navigateToWishlist,
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 100, color: Colors.grey),
                  Text('63'.tr),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      if (index >= cartItems.length ||
                          index >= cartShopContain.length) {
                        return Container();
                      }

                      final plant = cartItems[index];
                      final details = cartShopContain[index];
                      final plantidd = plant['id'];

                      if (details == null || plant == null) {
                        return Container(); 
                      }

                      //     final imageData = details['image'];
                      final pricee = details['price'];

                      //   List<int> bytes = List<int>.from(imageData['data']);

                      // if (bytes.isEmpty) {
                      //   return Container(); // Handle no image data
                      // }
                      print("cartItems[price]");
                      print(cartItems[index]['price']);

                      final plantname = details['name'];
                      final quantity1 = plant['item'];
                      //plantidd = cartShopContain[index]['plant_id'];
                      print("hello from build.......");
                      print(plantidd);

                      // productCount[index] =
                      //     int.parse(cartShopContain[index]['item']);

                      print("hello from build.......");
                      print(productCount[index]);

                      // print("hello from build.......");
                      // print(cartShopContain[index]['item']);

                      // while (productQuantity.length <= index) {
                      //   productQuantity[index] =
                      //       int.parse(cartItems[index]['quantity']);
                      // }

                      // while (productQuantity.length <= index) {
                      //   productQuantity[index] = cartItems[index]['quantity'];
                      // }

                      // Widget displayImage = Image.memory(
                      //   Uint8List.fromList(bytes),
                      //   width: 100,
                      //   height: 100,
                      //   fit: BoxFit.cover,
                      // );

                      final imageData = plant[
                          'image']; 
                      List<int> bytes = imageData != null
                          ? List<int>.from(imageData['data'])
                          : [];

                      return Card(
                        margin: EdgeInsets.all(10.0),
                        child: ListTile(
                          leading: bytes.isNotEmpty
                              ? Image.memory(
                                  Uint8List.fromList(bytes),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                  child: Icon(Icons.image_not_supported),
                                ),


                        

title: getPlantTranslationText(cartItems[index]['name']),







                              
                              
                              
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${cartItems[index]['price']} \$'),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        _decrementQuantity(index, plant['id']),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.remove,
                                        size: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    // fetchCartItems();

                                    productCount[index].toString(),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () =>
                                        _incrementQuantity(index, plant['id']),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add,
                                        size: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: selectedCheckboxes[index] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedCheckboxes[index] = value ?? false;
                                   
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle,
                                    color: Colors.red),
                                onPressed: () =>
                                    _removeItem(index, plant['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '64'.tr,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${amount.toStringAsFixed(2)} \$',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            cartItems.isNotEmpty ? Colors.green : Colors.grey,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(double.infinity, 50),
                          ),
                        ),
                     onPressed: cartItems.isNotEmpty
    ? () {
   //    updateSelectedPlantIds(); 

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderDetailsUser()), 
        );
      }
    : null, 

                        child: Text(
                          '65'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? Colors.green : Colors.black,
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _selectedIndex == 1 ? Colors.green : Colors.black,
            ),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: _selectedIndex == 2 ? Colors.green : Colors.black,
            ),
            label: 'cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: _selectedIndex == 3 ? Colors.green : Colors.black,
            ),
            label: 'chat',
          ),
        ],
        selectedItemColor: Colors.green,
      ),
    );
  }
}

Future<void> incrementItemOnShopCart(int userid, int plantId) async {
  print("hellllllllllllllllllllllllllllllllllo increment  plant id is ");
  print(plantId);

  final response = await http.put(
    Uri.parse('http://$ip:3000/plantpat/shoppingcart/incrementshopcart'),
    
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, int>{
      'user_id': userid,
      'plant_id': plantId,
    }),
  );
  print("response.statusCode");
  print(response.statusCode);
  if (response.statusCode == 200 || response.statusCode == 201) {
    print('item number increment successfully');
  } else {
    print('Failed to increment item number ');
  }
}

Future<void> decrementItemOnShopCart(int userid, int plantId) async {
  print("hellllllllllllllllllllllllllllllllllo decrement  plant id is ");
  print(plantId);
  final response = await http.put(
    Uri.parse('http://$ip:3000/plantpat/shoppingcart/decrementshopcart'),
   headers: <String, String>{
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, int>{
      'user_id': userid,
      'plant_id': plantId,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('item number decrement successfully');
  } else {
    print('Failed to decrement item number ');
  }
}

////////////////////// delete === getproductstate
Future<Map<String, dynamic>?> deleteProductCart(int plantid, int userId) async {
  print('DELETE FROM SHOPPING CART WITH ID : $plantid');
  http.Response? response;

  try {
    response = await http.delete(
      Uri.parse(
          'http://$ip:3000/plantpat/shoppingcart/deleteCartItem?plantId=$plantid&userId=$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

    CartPageState. ids.remove(plantid);

      print('Deleted cart item');
    } else {
      print('Failed to delete data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception occurred: $e');
    throw Exception('Failed to delete data: $e');
  }
  return null;
}

Future<void> updateItemOnShopCart(int item, int plantId) async {
  print(item);
  print(plantId);
  final response = await http.put(
    Uri.parse('http://$ip:3000/plantpat/shoppingcart/updateItemOnShopCart'),
   headers: <String, String>{
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, int>{
      'item': item,
      'plantId': plantId,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('item number updated successfully');
  } else {
    print('Failed to update item number ');
  }
}

Future<void> calculateallprice(int item, int plantId) async {
  print(item);
  print(plantId);
  final response = await http.put(
    Uri.parse('http://$ip:3000/plantpat/shoppingcart/calculateallprice'),
   headers: <String, String>{
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache, private',
      'X-RateLimit-Limit': '60',
      'X-RateLimit-Remaining': '59',
      'Access-Control-Allow-Origin': '*',
    },
    body: jsonEncode(<String, int>{
      'item': item,
      'plantId': plantId,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('item number updated successfully');
  } else {
    print('Failed to update item number ');
  }
}
