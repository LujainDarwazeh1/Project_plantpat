

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantpat/src/screen/home.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/notification_send_msg.dart';
import 'package:plantpat/src/screen/search_page.dart';
import 'package:plantpat/src/screen/section.dart';
import 'package:plantpat/src/screen/shopping_cart.dart'; 

class DetailPage extends StatefulWidget {
  final String size;
  final Map<String, dynamic> imagePaths;
  final String price;
  final int plantId;
  final String avgRate;
  final double height;
  final int sectionid;
  final int quantity;
  final String name;
  final String description;

  DetailPage({
    required this.size,
    required this.imagePaths,
    required this.price,
    required this.plantId,
    required this.avgRate,
    required this.height,
    required this.sectionid,
    required this.quantity,
    required this.name,
    required this.description,
  });

  @override
  DetailPageState createState() => DetailPageState();
}



Future<String> fetchSectionName(int sectionid) async {
  print('Fetching Section Name');
  try {
    final response = await http.get(
      Uri.parse('http://$ip:3000/plantpat/plant/Sectionname?id=$sectionid'),
    );
    if (response.statusCode == 200) {
      
      final jsonResponse = jsonDecode(response.body);
      final sectionName = jsonResponse['name'];
      return sectionName;
    } else {
     
      throw Exception('Failed to load section name');
    }
  } catch (e) {
   
    print('Error fetching Section name : $e');
    throw Exception('Failed to load section name: $e');
  }
}

class DetailPageState extends State<DetailPage> {



  



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
  bool isFavorite = false;
  String sectionName = ''; 
  int randomReviews =
      Random().nextInt(120) + 1; 

  @override
  void initState() {
    super.initState();
    fetchFavoriteStatus(widget.plantId).then((status) {
      setState(() {
        isFavorite = status;
      });
    }).catchError((error) {
      print('Error fetching favorite status: $error');
    });

    fetchSectionName(widget
            .sectionid) 
        .then((name) {
      setState(() {
        sectionName = name; 
      });
    }).catchError((error) {
      print('Error fetching section name: $error');
    });
  }

  Future<bool> fetchFavoriteStatus(int plantId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://$ip:3000/plantpat/plant/isFavorite?plantId=$plantId&userId=${Login.idd}'),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['isFavorite'] == 1; 
      } else {
        throw Exception('Failed to load favorite status');
      }
    } catch (e) {
      print('Error fetching favorite status: $e');
      throw Exception('Failed to load favorite status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<int> bytes = List<int>.from(
        widget.imagePaths['data']); 

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: () async {
              try {
                if (isFavorite) {
                  await deleteFromWishList(widget.plantId, context);
                } else {
                  await addToWishList(widget.plantId, context);

                   InteractionOfUser(Login.idd, widget.plantId, 0, 0, 0,1);

                }

                setState(() {
                  isFavorite = !isFavorite; 
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFavorite
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
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(
                    Uint8List.fromList(bytes), 
                    width: 350,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
       
 if (widget.name.toLowerCase() == 'prickly pear')
          Text(
            '21'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'echeveria')
          Text(
            '20'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'boxwood')
          Text(
            '24'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'dwarf spirea')
          Text(
            '25'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'passionflower')
          Text(
            '26'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'dwarf hydrangea')
          Text(
            '27'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'clematis')
          Text(
            '28'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'bougainvillea')
          Text(
            '29'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'honeysuckle')
          Text(
            '30'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'wisteria')
          Text(
            '31'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'lavender')
          Text(
            '32'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'peony')
          Text(
            '33'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'hosta')
          Text(
            '34'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'daylily')
          Text(
            '35'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'daisy')
          Text(
            '36'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.name.toLowerCase() == 'forsythia')
          Text(
            '37'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
              if (widget.name.toLowerCase() == 'olvera')
                Text(
                  '116'.tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),











              
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                   Icon(Icons.star, color: Colors.yellow),
             
                  SizedBox(width: 8),
   Text(
  '${widget.avgRate} (${randomReviews} ${'45'.tr})'), 
                ],
              ),
              SizedBox(height: 10),
Text(
  widget.description.toLowerCase() == 'resilient desert plant known for its paddle-shaped pads covered in spines and edible fruits called "tunas". prickly pear thrives in dry, arid climates and its vibrant flowers range from yellow to orange, adding ornamental value to gardens while providing habitat and food for wildlife.'
      ? '46'.tr
      : widget.description.toLowerCase() == 'a charming succulent plant with rosettes of fleshy, often colorful leaves that range from blue-gray to pink or purple. echeverias are prized for their compact, symmetrical growth and are popular in container gardens and rockeries. they thrive in bright sunlight and well-draining soil, making them ideal for low-maintenance and drought-tolerant landscaping..'
          ? '47'.tr
          : widget.description.toLowerCase() == 'a versatile evergreen shrub prized for its dense, compact foliage, ideal for creating formal hedges, borders, and topiaries. its dark green leaves provide year-round interest and structure in gardens and landscapes alike.'
              ? '48'.tr
              : widget.description.toLowerCase() == 'a compact shrub adorned with clusters of pink, red, or white flowers in spring and summer. ideal for borders or mass planting, it is easy to maintain and adds vibrant color to gardens.'
                  ? '49'.tr
                  : widget.description.toLowerCase() == 'a striking and exotic climbing vine known for its intricate, often fragrant flowers with unique structures. the blooms typically feature a prominent central crown surrounded by colorful, fringed filaments. passionflowers produce edible fruits and are valued in gardens for their ornamental beauty and as hosts for butterfly larvae, making them a fascinating addition to trellises and arbors.'
                      ? '50'.tr
                      : widget.description.toLowerCase() == 'a compact variety of hydrangea known for its large, showy clusters of flowers in shades of pink, blue, or white, depending on soil ph. this small shrub blooms abundantly from spring to summer, making it a delightful addition to gardens and containers, especially in smaller spaces.'
                          ? '51'.tr
                          : widget.description.toLowerCase() == 'a versatile and elegant climbing vine cherished for its profusion of vibrant flowers in a variety of colors, including shades of purple, blue, pink, and white. clematis blooms range from single to double forms, adding charm to trellises, fences, and garden structures throughout the growing season. with a preference for well-drained soil and sun-dappled shade, clematis is a favorite among gardeners for its beauty and ability to enhance vertical spaces.'
                              ? '52'.tr
                              : widget.description.toLowerCase() == 'a stunning and vigorous climbing plant celebrated for its vibrant and papery bracts that surround small, inconspicuous flowers. these bracts come in a range of colors including shades of pink, purple, red, orange, and white, creating a striking visual display. bougainvillea thrives in warm climates with full sun exposure and well-drained soil, making it a popular choice for adding color to walls, fences, and arbors in gardens and landscapes.'
                                  ? '53'.tr
                                  : widget.description.toLowerCase() == 'a fragrant and fast-growing climbing vine known for its sweet-scented, tubular flowers that attract hummingbirds and butterflies. honeysuckle blooms range in color from creamy white to yellow, pink, or orange-red, depending on the variety. this versatile plant thrives in various conditions, including sun to partial shade, and is ideal for covering trellises, fences, and pergolas. its ability to fill the air with a delightful fragrance and support local wildlife makes it a beloved addition to gardens.'
                                      ? '54'.tr
                                      : widget.description.toLowerCase() == 'a breathtaking climbing vine renowned for its cascading clusters of fragrant, pea-like flowers in shades of purple, blue, pink, or white. wisteria blooms appear in late spring to early summer, creating a picturesque display that drapes gracefully over arbors, pergolas, and trellises. its vigorous growth and lush foliage provide shade and privacy, making it a beloved ornamental plant in gardens. wisteria thrives in full sun and well-drained soil, rewarding gardeners with its stunning floral show.'
                                          ? '55'.tr
                                          : widget.description.toLowerCase() == 'a fragrant and versatile herbaceous plant known for its aromatic foliage and spikes of small, fragrant flowers in shades of purple, blue, or white. lavender is prized for its calming scent and is commonly used in aromatherapy, potpourri, and culinary recipes. it thrives in well-drained soil and full sunlight, making it a popular choice for gardens, borders, and containers. lavender also attracts pollinators like bees and butterflies, adding to its appeal in garden landscapes..'
                                              ? '56'.tr
                                              : widget.description.toLowerCase() == 'a luxurious herbaceous perennial prized for its large, showy flowers that bloom in late spring to early summer. peonies come in a variety of colors including shades of pink, white, red, and coral, with some varieties featuring double or single blooms. known for their fragrance and lush foliage, peonies are excellent as cut flowers and are cherished in gardens for their beauty and longevity. they prefer well-drained soil and full sun to partial shade, making them a stunning focal point in garden borders and flower beds.'
                                                  ? '57'.tr
                                                  : widget.description.toLowerCase() == 'a versatile and shade-loving herbaceous perennial prized for its attractive foliage and easy-care nature. hostas are known for their large, often heart-shaped leaves that come in shades of green, blue, yellow, and variegated patterns. some varieties also produce spikes of lavender or white flowers in summer. ideal for shady areas in gardens, hostas thrive in moist, well-drained soil and can be used as ground covers, edging plants, or in containers. their foliage adds texture and color variation to garden landscapes, making them a popular choice among gardeners.'
                                                      ? '58'.tr
                                                      : widget.description.toLowerCase() == 'a resilient and colorful herbaceous perennial known for its vibrant, trumpet-shaped flowers that bloom prolifically from spring to fall. daylilies come in a wide range of colors including yellow, orange, red, pink, and bi-colors, with some varieties featuring ruffled or fringed petals. each flower typically lasts only one day, but multiple blooms open successively on each stem. easy to grow and tolerant of various soil conditions, daylilies thrive in full sun to partial shade, making them versatile additions to borders, beds, and cottage gardens. their robust nature and continuous flowering make them popular among gardeners for adding bursts of color throughout the growing season.'
                                                          ? '59'.tr
                                                          : widget.description.toLowerCase() == 'cheerful herbaceous perennials known for their simple yet charming flowers with white petals and yellow centers. they bloom profusely from spring to fall and are loved for their resilience and ability to thrive in various conditions. daisies are often used in borders, rock gardens, and as cut flowers due to their long-lasting blooms and attractiveness to pollinators like bees and butterflies. they symbolize innocence, purity, and simplicity in garden landscapes..'
                                                              ? '60'.tr
                                                              : widget.description.toLowerCase() == 'is a deciduous shrub renowned for its early spring display of bright yellow flowers that adorn its arching branches, adding a vibrant burst of color to gardens and landscapes. it grows vigorously, reaching heights of 6 to 10 feet, and thrives in sunny to partially shaded areas with well-drained soil.'
                                                                  ? '61'.tr
                                                                  : widget.description, // Default to widget.description if none of the conditions match
  style: TextStyle(
    fontSize: 16,
  ),
),

              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
               
                },
                child: Text(
                  '40'.tr,
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '41'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
Text(
  widget.size.toLowerCase() == 'small'
      ? '22'.tr
      : widget.size.toLowerCase() == 'medium'
          ? '23'.tr
          : '', 
  style: TextStyle(
    fontSize: 16,
  ),
)




                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '42'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
Text(
  sectionName.toLowerCase() == 'small shrubs'
      ? '17'.tr
      : sectionName.toLowerCase() == 'climbing plants'
          ? '18'.tr
          : sectionName.toLowerCase() == 'herbaceous'
              ? '19'.tr
              : sectionName, 
  style: TextStyle(
    fontSize: 16,
  ),
)

                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '43'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.height.toString(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        if (widget.quantity != 0) {
                          if (widget.quantity == 1) {
                            Duration delay = Duration(minutes: 2);

                            Timer(delay, () async {
                              triggerNotificationFromPages('[Private Reminder]',
                                  "An item ${widget.name} in your cart is nearly out of stock. Shop it before it sells out.");
                            });
                          }
                         

                        InteractionOfUser(Login.idd, widget.plantId, 0, 1, 0,0);


                          await CartPageState.shoppingCartStore(
                              '1', '', widget.name, context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "plant SOLD OUT\nCan not add Item to Shoppimg Card",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                          ));
                        }
                      },
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      label: Text(
                        '44'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                     '${widget.price}\$',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final String baseUrl = 'http://$ip:3000/plantpat/plant';

  Future<void> addToWishList(int plantId, BuildContext context) async {
    try {
      final url = Uri.parse('$baseUrl/addToWishList');
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
