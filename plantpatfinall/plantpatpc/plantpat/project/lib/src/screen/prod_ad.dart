import 'dart:async';
import 'dart:convert';
import 'dart:io'; // Import this to work with File
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:plantpat/src/screen/HomeAdmin.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/ipaddress.dart';
import 'dart:html' as html;


// Product class definition with sectionName attribute


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





  //  final String baseUrl = 'http://$ip:3000/plantpat/plant';

  // Future<void> addplant(int plantId, BuildContext context) async {
  //   try {
  //     final url = Uri.parse('$baseUrl/AddPlant');
  //     var headers = {
  //     'Content-Type': 'application/json',
  //     'Connection': 'keep-alive',
  //     'Cache-Control': 'no-cache, private',
  //     'X-RateLimit-Limit': '60',
  //     'X-RateLimit-Remaining': '59',
  //     'Access-Control-Allow-Origin': '*',
  //   };
  //     final response = await http.post(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, dynamic>{
  //         'name': Login.idd,
  //         'description': plantId,
  //         'size':
  //         'height':
  //         'price':
  //         'sectionId':
  //       }),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print('Added to wishlist successfully.');
  //       // Optionally show a notification or update UI
  //     } else if (response.statusCode == 401) {
  //       print('Plant already in wishlist.');
  //       // Optionally show a notification or update UI
  //     } else {
  //       print('Failed to add to wishlist. Status code: ${response.statusCode}');
  //       // Optionally show a notification or update UI
  //     }
  //   } catch (e) {
  //     print('Error adding to wishlist: $e');
  //     // Optionally show a notification or update UI
  //   }
  // }












  

// ProductDetailScreen widget
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String _name;
  late double _price;
  late String _description;
  late int _plantId;
  late double _height;
  late int _sectionId;
  late Map<String, dynamic> _imageData;
  late String _avgRate;
  late String _size;
  String? _sectionName;
  late int  _quantity;

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _price = widget.product.price;
    _description = widget.product.description;
    _plantId = widget.product.plantId;
    _height = widget.product.height;
    _sectionId = widget.product.sectionId;
    _imageData = widget.product.imageData;
    _avgRate = widget.product.avgRate;
    _size = widget.product.size;
    _quantity=widget.product.quantity;
    fetchSectionName(_sectionId);

    //checkFileExists('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/1.jpg');

  }


  Future<void> fetchSectionName(int sectionId) async {
    print('Fetching Section Name');
    try {
      final response = await http.get(
        Uri.parse('http://$ip:3000/plantpat/plant/Sectionname?id=$sectionId'),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          _sectionName = jsonResponse['name'];
        });
      } else {
        throw Exception('Failed to load section name');
      }
    } catch (e) {
      print('Error fetching Section name: $e');
    }
  }


Future<void> updatename(String newname) async {
  try {
    final response = await http.put(
      Uri.parse('http://$ip:3000/plantpat/plant/updateplantnamebyid?id=$_plantId&name=$newname'),
    );

    print('Request URL: http://$ip:3000/plantpat/plant/updateplantnamebyid?id=$_plantId&name=$_name');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('Plant name updated successfully');
      // Optionally, parse and use the response body
      // var data = jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      print('Plant not found');
      // Optionally, show an error message to the user
    } else {
      print('Failed to update plant name: ${response.reasonPhrase}');
      // Optionally, show an error message to the user
    }
  } catch (e) {
    print('Error occurred: $e');
    // Optionally, show an error message to the user
  }
}



Future<void> updatePrice(double newPrice) async {
  try {
    final response = await http.put(
      Uri.parse('http://$ip:3000/plantpat/plant/updateplantpricebyid?id=$_plantId&price=$newPrice'),
    );

    print('Request URL: http://$ip:3000/plantpat/plant/updateplantpricebyid?id=$_plantId&price=$newPrice');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('Plant price updated successfully');
      // Optionally, parse and use the response body
      // var data = jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      print('Plant not found');
      // Optionally, show an error message to the user
    } else {
      print('Failed to update plant price: ${response.reasonPhrase}');
      // Optionally, show an error message to the user
    }
  } catch (e) {
    print('Error occurred: $e');
    // Optionally, show an error message to the user
  }
}


Future<void> updateQuantity(int newQuantity) async {
  try {
    final response = await http.put(
      Uri.parse('http://$ip:3000/plantpat/plant/updateplantquantitybyid?id=$_plantId&quantity=$newQuantity'),
    );

    print('Request URL: http://$ip:3000/plantpat/plant/updateplantquantitybyid?id=$_plantId&quantity=$newQuantity');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('Plant quantity updated successfully');
      // Optionally, parse and use the response body
      // var data = jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      print('Plant not found');
      // Optionally, show an error message to the user
    } else {
      print('Failed to update plant quantity: ${response.reasonPhrase}');
      // Optionally, show an error message to the user
    }
  } catch (e) {
    print('Error occurred: $e');
    // Optionally, show an error message to the user
  }
}


 Future<bool> deletePlant(int plantId) async {

    final Uri url = Uri.parse('http://$ip:3000/plantpat/plant/deletePlant?plantId=$plantId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Successful deletion
        return true;
      } else {
        // Server returned an error response
        print('Failed to delete plant: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error deleting plant: $e');
      return false;
    }
  }



 static File? imageeee;
 ImageProvider? plantImage;




void _imagePicker() async {
  print("hellllllllllo1");
  
  // Create an input element to select the file
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*'; // Accept image files only
  uploadInput.click(); // Open the file picker dialog

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;
    if (files == null || files.isEmpty) return;

    final file = files[0];
    print("File picked: ${file.name}");

    // Upload the new profile image
    bool uploadSuccess = await uploadPlantImage(file);

    if (uploadSuccess) {
      // Fetch and update the image data after uploading
      await fetchPlantImageData();
      setState(() {
     _ProductsScreenState. _productsFuture = _ProductsScreenState.fetchPlants();
    });
        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductsScreen(),
  ),
).then((result) {
  if (result == true) {
    // Call refreshProducts method to update the list
    setState(() {
     _ProductsScreenState. _productsFuture = _ProductsScreenState.fetchPlants();
    });
  }
});
    
    } else {
      print('Image upload failed, not fetching image data.');
    }
  });
}

Future<bool> uploadPlantImage(html.File imageFile) async {
  print("Starting image upload...");

  final reader = html.FileReader();

  // Read the file as ArrayBuffer
  reader.readAsArrayBuffer(imageFile);

  // Use a Completer to wait for the upload completion
  final completer = Completer<bool>();

  reader.onLoadEnd.listen((e) async {
    final bytes = reader.result as Uint8List;

    // Prepare the multipart request
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('http://$ip:3000/plantpat/plant/addplantImage'),
    );

    // Add fields and files to the request
    request.fields['plantid'] = _plantId.toString(); // Replace with your plant ID
    var stream = http.ByteStream.fromBytes(bytes);
    var length = bytes.length;
    var multipartFile = http.MultipartFile(
      'image', // Ensure this matches the server-side field name
      stream,
      length,
      filename: imageFile.name,
    );
    request.files.add(multipartFile);

    try {
      // Send the request
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Upload successful');
        completer.complete(true);
      } else {
        print('Upload failed with status: ${response.statusCode}');
        completer.complete(false);
      }
    } catch (e) {
      print('Error during file upload: $e');
      completer.complete(false);
    }
  });

  return completer.future;
}

Future<void> fetchPlantImageData() async {
  print('Fetching updated image data');
  try {
    final response = await http.get(
      Uri.parse('http://$ip:3000/plantpat/plant/getplantimage?id=$_plantId'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse != null && jsonResponse['image'] != null) {
        setState(() {
          _imageData = jsonResponse['image']; // Update _imageData with the new image data
        });
      } else {
        print('Image data is null or missing in the response');
      }
    } else {
      throw Exception('Failed to load updated image data');
    }
  } catch (e) {
    print('Error fetching updated image data: $e');
  }
}







//  Future<void> getplantimage(int plantid) async {
//     try {
//       final response = await http.get(Uri.parse('http://$ip:3000/plantpat/plant/getplantImage?plantId=$plantid'));
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         dynamic responseData = jsonDecode(response.body);

//         if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
//           final plantData = responseData['results'][0];
//           final imageData = plantData['image'];

//           if (imageData is Map<String, dynamic> && imageData.containsKey('data')) {
//             final byteData = imageData['data'];
//             final imageBytes = Uint8List.fromList(List<int>.from(byteData));

//             setState(() {
//               _imageData = MemoryImage(imageBytes);
//             });
//           } else {
//             print('Image data not found in response.');
//           }
//         } else {
//           print('Failed to fetch user data.');
//         }
//       } else {
//         print('Failed to fetch user data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching user image: $e');
//     }
//   }














Future<String?> _editInfoDialog(String title, String initialValue) async {
  TextEditingController controller = TextEditingController(text: initialValue);
  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: title),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Handle async operations here
              // If you need to update the name or perform other actions before closing the dialog
              if (title == 'Edit Name') {
                // Perform any additional operations here if needed
                await updatename(controller.text); // Ensure this function doesn't impact the dialog closing
              }

                 if (title == 'Edit Price') {
                // Perform any additional operations here if needed
 double newPrice = double.parse(controller.text);
                  await updatePrice(newPrice);            
                  
                    }
                    if (title == 'Edit Quantity') {
                   int newQuantity = int.parse(controller.text);
                  await updateQuantity(newQuantity);
                    }



              Navigator.of(context).pop(controller.text);
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.product.name),
      backgroundColor: Color.fromARGB(255, 61, 155, 40),
      actions: [
        IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            // Implement delete action
          },
        ),
      ],
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image if imageData is not null
            Expanded(
              child: _imageData.isNotEmpty
                  ? Image.memory(
                      Uint8List.fromList(
                        (_imageData['data'] as List<dynamic>).cast<int>(),
                      ),
                      fit: BoxFit.contain,
                    )
                  : Container(), // Show a placeholder or empty container if no image data
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           'Name: $_name',
//                           style: TextStyle(
//                             fontSize: 28.0,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.edit),
//                       onPressed: () async {

//   final newName = await _editInfoDialog('Edit Name', _name);
//   if (newName != null) {
//     setState(() {
//       _name = newName;
//     });
//   }
// }
//                       ),
//                     ],
//                   ),




Row(
  children: [
    Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Name: $_name ',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: '(ID: ${widget.product.plantId})',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ),
    IconButton(
      icon: Icon(Icons.edit),
      onPressed: () async {
        final newName = await _editInfoDialog('Edit Name', _name);
        if (newName != null) {
          setState(() {
            _name = newName;
          });
        }
      },
    ),
  ],
),
      







             
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                         'Price: \$${_price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final newPrice = await _editInfoDialog('Edit Price', _price.toString());
                          if (newPrice != null) {
                            setState(() {
                              _price = double.parse(newPrice);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),


                           Row(
                    children: [
                      Expanded(
                        child: Text(
                        'Size: $_size',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final newsize = await _editInfoDialog('Edit Size', _size.toString());
                          if (newsize != null) {
                            setState(() {
                              _size=newsize;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),



                  
                           Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Height: ${_height.toString()}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final newheight = await _editInfoDialog('Edit Height', _height.toString());
                          if (newheight != null) {
                            setState(() {
                            _height = double.tryParse(newheight) ?? 0.0;
                            });
                          }
                        },
                      ),
                    ],
                  ),
           

                   SizedBox(height: 16.0),
                                     Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Section Name: ${_sectionName ?? ''}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final newsectionname = await _editInfoDialog('Edit Section Name', _sectionName ?? '');
                          if (newsectionname != null) {
                            setState(() {
                             _sectionName = newsectionname;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),


                  
                                     Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Quantity: $_quantity',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final newquantity = await _editInfoDialog('Edit Quantity', _quantity.toString());
                          if (newquantity != null) {
                            setState(() {
                             _quantity = int.parse(newquantity);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),





                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Description: $_description',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final newDescription = await _editInfoDialog('Edit Description', _description);
                          if (newDescription != null) {
                            setState(() {
                              _description = newDescription;
                            });
                          }
                        },
                      ),
                    ],
                  ),


//  Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                      'Section Name: ${_sectionName ?? ''}',
//                       style: TextStyle(
//                         fontSize: 28.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.edit),
//                     onPressed: () async {
//                       final newsectionname = await _editInfoDialog('Edit Section Name', _sectionName ?? '');
//                       if (newsectionname != null) {
//                         setState(() {
//                           _sectionName = newsectionname;
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.0),


                SizedBox(height: 50.0), // Space above the row of buttons
Row(
  mainAxisAlignment: MainAxisAlignment.center, // Centers buttons horizontally
  children: <Widget>[
    ElevatedButton(
      onPressed: _imagePicker,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Added horizontal padding for better spacing
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        'Change Image',
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
      ),
    ),
    SizedBox(width: 20.0), // Space between the two buttons
    ElevatedButton(
     
onPressed: () async {
  bool success = true;

  if (success) {
    await deletePlant(_plantId);
//Navigator.pop(context, true);


     setstate(){
    _ProductsScreenState. _productsFuture = _ProductsScreenState.fetchPlants();
    }
    Navigator.pop(context, true);
        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductsScreen(),
  ),
).then((result) {
  if (result == true) {
    // Call refreshProducts method to update the list
    setState(() {
     _ProductsScreenState. _productsFuture = _ProductsScreenState.fetchPlants();
    });
  }
});

    // Show a success Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Plant deleted successfully'),
        backgroundColor: Colors.green,
      ),
    );
    

    // Navigate back to the previous screen
    
  } else {
    // Show an error Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete plant'),
        backgroundColor: Colors.red,
      ),
    );
  }
},

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Added horizontal padding for better spacing
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        'Delete',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
    ),
  ],
),
SizedBox(height: 50.0), // Space below the row of buttons

                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

    @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(widget.product.name),
//       backgroundColor: Color.fromARGB(255, 61, 155, 40),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.delete),
//           color: Colors.red,
//           onPressed: () {
//             // Implement delete action
//           },
//         ),
//       ],
//     ),
//     body: Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display image if imageData is not null
//             Expanded(
//               child: _imageData.isNotEmpty
//                   ? Image.memory(
//                       Uint8List.fromList(
//                         (_imageData['data'] as List<dynamic>).cast<int>(),
//                       ),
//                       fit: BoxFit.contain,
//                     )
//                   : Container(), // Show a placeholder or empty container if no image data
//             ),
//             SizedBox(width: 16.0),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: RichText(
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: 'Name: $_name ',
//                                         style: TextStyle(
//                                           fontSize: 28.0,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: '(ID: ${widget.product.plantId})',
//                                         style: TextStyle(
//                                           fontSize: 28.0,
//                                           fontWeight: FontWeight.normal,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.edit),
//                                 onPressed: () async {
//                                   final newName = await _editInfoDialog('Edit Name', _name);
//                                   if (newName != null && newName.isNotEmpty) {
//                                     setState(() {
//                                       _name = newName;
//                                     });
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Price: \$${_price.toStringAsFixed(2)}',
//                                   style: TextStyle(
//                                     fontSize: 22.0,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.edit),
//                                 onPressed: () async {
//                                   final newPrice = await _editInfoDialog('Edit Price', _price.toString());
//                                   if (newPrice != null) {
//                                     setState(() {
//                                       _price = double.parse(newPrice);
//                                     });
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Size: $_size',
//                                   style: TextStyle(
//                                     fontSize: 22.0,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.edit),
//                                 onPressed: () async {
//                                   final newSize = await _editInfoDialog('Edit Size', _size);
//                                   if (newSize != null) {
//                                     setState(() {
//                                       _size = newSize;
//                                     });
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Height: ${_height.toString()}',
//                                   style: TextStyle(
//                                     fontSize: 22.0,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.edit),
//                                 onPressed: () async {
//                                   final newHeight = await _editInfoDialog('Edit Height', _height.toString());
//                                   if (newHeight != null) {
//                                     setState(() {
//                                       _height = double.tryParse(newHeight) ?? 0.0;
//                                     });
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Section Name: ${_sectionName ?? ''}',
//                                   style: TextStyle(
//                                     fontSize: 22.0,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.edit),
//                                 onPressed: () async {
//                                   final newSectionName = await _editInfoDialog('Edit Section Name', _sectionName ?? '');
//                                   if (newSectionName != null) {
//                                     setState(() {
//                                       _sectionName = newSectionName;
//                                     });
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Quantity: $_quantity',
//                                   style: TextStyle(
//                                     fontSize: 22.0,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.edit),
//                                 onPressed: () async {
//                                   final newQuantity = await _editInfoDialog('Edit Quantity', _quantity.toString());
//                                   if (newQuantity != null) {
//                                     setState(() {
//                                       _quantity = int.parse(newQuantity);
//                                     });
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16.0),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Description: $_description',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.edit),
//                                 onPressed: () async {
//                                   final newDescription = await _editInfoDialog('Edit Description', _description);
//                                   if (newDescription != null) {
//                                     setState(() {
//                                       _description = newDescription;
//                                     });
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 50.0),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               ElevatedButton(
//                                 onPressed: _imagePicker,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'Change Image',
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 20.0),
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   bool success = await deletePlant(_plantId);
//                                   if (success) {
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(builder: (context) => ProductsScreen()),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('Failed to delete plant'),
//                                         backgroundColor: Colors.red,
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                   padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   'Delete Plant',
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


  



class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {


 static late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
  
    _productsFuture = fetchPlants();
  }
  

  void refreshProducts() {
    setState(() {
      _productsFuture = fetchPlants();
    });
  }




  

  


 static Future<List<Product>> fetchPlants() async {
    var client = RetryClient(http.Client());
    print("hello from fetchplants1");
    try {
      var url = Uri.http('$ip:3000', '/plantpat/plant/plants');
      var headers = {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
        'Cache-Control': 'no-cache, private',
        'X-RateLimit-Limit': '60',
        'X-RateLimit-Remaining': '59',
        'Access-Control-Allow-Origin': '*',
      };
      var response = await client.get(url, headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Product> products =
            jsonResponse.map((data) => Product.fromJson(data)).toList();
         //   print(jsonResponse);
            print("hello from fetchplants2");
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
      return [];
    } finally {
      client.close(); // Close the client to release resources
    }
  }

  void _addProduct(Product product) {
    // You need to manage state in a way that supports adding new products
    setState(() {
      // Re-fetch the products if necessary or add the product to a local list
    });
  }



    void _addSection(Product product) {
    // You need to manage state in a way that supports adding new products
    setState(() {
      // Re-fetch the products if necessary or add the product to a local list
    });
  }

  void _deleteProduct(Product product) {
    // Implement logic to delete a product
    setState(() {
      // Re-fetch the products if necessary or remove the product from a local list
    });
  }








  //   void _addSection() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Add New Section'),
  //         content: TextField(
  //           autofocus: true,
  //           decoration: InputDecoration(labelText: 'Section Name'),
  //           onSubmitted: (value) {
  //             setState(() {
  //               if (!sectionNames.contains(value) && value.isNotEmpty) {
  //                 sectionNames.add(value);
  //               }
  //               Navigator.of(context).pop();
  //             });
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               final sectionName = (context as Element)
  //                   .findAncestorWidgetOfExactType<TextField>()
  //                   ?.controller
  //                   ?.text;
  //               if (sectionName != null && sectionName.isNotEmpty) {
  //                 setState(() {
  //                   if (!sectionNames.contains(sectionName)) {
  //                     sectionNames.add(sectionName);
  //                   }
  //                   Navigator.of(context).pop();
  //                 });
  //               }
  //             },
  //             child: Text('Add'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _deleteSection() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Delete Section'),
  //         content: DropdownButton<String>(
  //           value: sectionNames.isNotEmpty ? sectionNames.first : null,
  //           items: sectionNames.map((section) {
  //             return DropdownMenuItem<String>(
  //               value: section,
  //               child: Text(section),
  //             );
  //           }).toList(),
  //           onChanged: (value) {
  //             setState(() {
  //               if (value != null) {
  //                 sectionNames.remove(value);
  //                 products
  //                     .removeWhere((product) => product.sectionName == value);
  //               }
  //               Navigator.of(context).pop();
  //             });
  //           },
  //           hint: Text('Select Section'),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Delete'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Color.fromARGB(255, 32, 154, 69),
      ),
      drawer: AppDrawer(), // Ensure you have defined AppDrawer widget
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          } else {
            List<Product> products = snapshot.data!;
           return GridView.builder(
  padding: EdgeInsets.all(8.0),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 6,
    childAspectRatio: 0.75,
    crossAxisSpacing: 8.0,
    mainAxisSpacing: 5.0,
  ),
  itemCount: products.length + 2, // +2 for the add button cards
  itemBuilder: (context, index) {
    if (index == 0) {
      return AddProductCard(onProductAdded: _addProduct);
    } else if (index == 1) {
      return AddSectionCard(onSectionAdded: _addSection);
    } else {
      final productIndex = index - 2; // Adjust index for product list
      if (productIndex < products.length) {
        return ProductCard(
          product: products[productIndex],
          onDelete: () => _handleDelete(context, products[productIndex]),
        );
      } else {
        // Handle case where index is out of range
        return SizedBox.shrink(); // or some placeholder widget
      }
    }
  },
);
          }
        },
      ),
    );
  }



  void _handleDelete(BuildContext context, Product product) async {
  // Show confirmation dialog with the plant's name
  bool? confirmDelete = await _showConfirmationDialog(context, product.name);

  if (confirmDelete == true) {
    // Call your delete function and then refresh the product list
    bool success = true;
    //await deletePlant(product.id);

    if (success) {
      refreshProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plant deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete plant'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
Future<bool?> _showConfirmationDialog(BuildContext context, String plantName) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Confirm Deletion',
          style: TextStyle(color: Colors.green), // Title color
        ),
        content: Text(
          'Are you sure you want to delete the plant "$plantName"?',
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.green), // Button text color
            ),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false if canceled
            },
          ),
          TextButton(
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.green), // Button text color
            ),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true if confirmed
            },
          ),
        ],
      );
    },
  );
}


}



class AddSectionCard extends StatelessWidget {
  final Function(Product) onSectionAdded;

  AddSectionCard({required this.onSectionAdded});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddSectionDialog(onSectionAdded: onSectionAdded);
          },
        );
      },
      child: SizedBox(
        height: 250, // Match the height of other product cards
        width: 250, // Match the width of other product cards
        child: Card(
          elevation: 8.0, // Higher elevation for prominence
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Different border radius
          ),
          color: Colors.green.shade100, // Light green background color
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 80.0, // Larger icon size
                  color: Colors.green,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Add Section',
                  style: TextStyle(
                    fontSize: 20.0, // Larger font size
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// AddProductCard widget with callback
class AddProductCard extends StatelessWidget {
  final Function(Product) onProductAdded;

  AddProductCard({required this.onProductAdded});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddProductDialog(onProductAdded: onProductAdded);
          },
        );
      },
      child: SizedBox(
        height: 250, // Match the height of other product cards
        width: 250, // Match the width of other product cards
        child: Card(
          elevation: 8.0, // Higher elevation for prominence
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Different border radius
          ),
          color: Colors.green.shade100, // Light green background color
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 80.0, // Larger icon size
                  color: Colors.green,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Add Product',
                  style: TextStyle(
                    fontSize: 20.0, // Larger font size
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// AddProductDialog widget with callback
class AddProductDialog extends StatefulWidget {
  final Function(Product) onProductAdded;

  AddProductDialog({required this.onProductAdded});

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController=TextEditingController();
  final _quantityController=TextEditingController();
  final _heightController=TextEditingController();
  final _desctController=TextEditingController();

  String? _imagePath;
static List<String> _sectionNames = [];

  String? _selectedSectionName; // Change to String?
  int? sectionid;
    String? _selectedsize;
  final ImagePicker _picker = ImagePicker();
Map<String, dynamic>? _imageData;


Future<int> getsectionid(String sectionName) async {
  try {
    final response = await http.get(Uri.parse('http://$ip:3000/plantpat/plant/Sectionidbyname?sectionname=$sectionName'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['sectionid'] as int;
    } else {
      throw Exception('Failed to fetch section ID');
    }
  } catch (e) {
    // Handle network or other errors
    print('Error fetching section ID: $e');
    rethrow;
  }
}



Future<void> addplant() async {
  if (_formKey.currentState?.validate() ?? false) {
    final Uri url = Uri.parse('http://$ip:3000/plantpat/plant/AddPlant');
    final request = http.MultipartRequest('POST', url)
      ..fields['name'] = _nameController.text
      ..fields['description'] = _desctController.text
      ..fields['size'] = _selectedsize ?? ''
      ..fields['height'] = _heightController.text
      ..fields['price'] = _priceController.text
      ..fields['quantity'] = _quantityController.text
      ..fields['sectionId'] = sectionid?.toString() ?? ''; // Ensure sectionId is not null

    if (_imageData != null) {
      final imageBytes = _imageData!['data'] as Uint8List;
      final imageName = _imageData!['name'] as String;

      // Determine the correct content type based on the file extension
      final contentType = imageName.endsWith('.png') ? 'image/png' : 'image/jpeg';

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
          contentType: MediaType.parse(contentType),
        ),
      );
    }

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        // Plant added successfully
        print('Plant added successfully');
        Navigator.of(context).pop(true); // Notify that the plant was added successfully
      } else {
        // Handle server error
        print('Failed to add plant: ${response.statusCode}');
        Navigator.of(context).pop(false); // Notify that the plant addition failed
      }
    } catch (e) {
      // Handle network or other errors
      print('Error adding plant: $e');
      Navigator.of(context).pop(false); // Notify that the plant addition failed
    }
  }
}




void _imagePicker() async {
  print("Opening file picker");
  
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;
    if (files == null || files.isEmpty) return;

    final file = files[0];
    print("File picked: ${file.name}");

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);

    reader.onLoadEnd.listen((e) {
      final bytes = reader.result as Uint8List?;
      if (bytes != null) {
        setState(() {
          _imageData = {
            'data': bytes,
            'name': file.name,
          };
        });
        print("Image data set: ${_imageData?['name']}");
      }
    });
  });
}


  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    try {
      final sections = await getsections();
      setState(() {
        _sectionNames = sections;
      });
    } catch (e) {
      // Handle error
      print('Error fetching sections: $e');
    }
  }


static Future<List<String>> getsections() async {
  final Uri url = Uri.parse('http://$ip:3000/plantpat/plant/allSectionname');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((section) => section['name'] as String).toList();
  } else {
    throw Exception('Failed to load sections');
  }
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _desctController,
                decoration: InputDecoration(labelText: 'Product Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the height';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Select Size'),
              DropdownButtonFormField<String>(
                value: _selectedsize,
                items: [
                  'small',
                  'medium',
                  'large',
                ].map((size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedsize = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a size';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Select Section'),
DropdownButtonFormField<String>(
      value: _selectedSectionName,
      items: _sectionNames.map((section) {
        return DropdownMenuItem<String>(
          value: section,
          child: Text(section),
        );
      }).toList(),
      onChanged: (value) async {
        if (value != null) {
          setState(() {
            _selectedSectionName = value;
          });

          try {
            final id = await getsectionid(value);
            print("id: $id");

            setState(() {
              sectionid = id; // Update the section ID
            });
          } catch (e) {
            // Handle error if needed
            print('Error fetching section ID: $e');
          }
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a section';
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
    ),




             SizedBox(height: 16.0),
_imageData == null
    ? Text('No image selected')
    : Image.memory(
        _imageData!['data'] as Uint8List,
        height: 100,
        fit: BoxFit.cover,
      ),
ElevatedButton(
  onPressed: _imagePicker,
  child: Text('Select Image'),
),

            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
       TextButton(
  onPressed: () async {
      if (_imageData != null) {

    await addplant(); // Add your plant
    //Navigator.of(context).pop(); 
    // Assuming you have access to the context of ProductsScreen
    setstate(){
    _ProductsScreenState. _productsFuture = _ProductsScreenState.fetchPlants();
    }



    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductsScreen(),
  ),
).then((result) {
  if (result == true) {
    // Call refreshProducts method to update the list
    setState(() {
     _ProductsScreenState. _productsFuture = _ProductsScreenState.fetchPlants();
    });
  }
});

    // Close the current screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Plant added successfully'), backgroundColor: Colors.green),
    );

    

//     // Refresh ProductsScreen
//     Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => ProductsScreen(onRefresh: () {
//       // Call this callback to refresh
//     }),
//   ),
// ); // Assuming you have a static method to refresh
  } else {
      print("Image data is null");
    }
  },
  child: Text('Add Product'),
)

      ],
    );
  }

}
















class AddSectionDialog extends StatefulWidget {
  final Function(Product) onSectionAdded;

  AddSectionDialog({required this.onSectionAdded});

  @override
  _AddSectionDialogState createState() => _AddSectionDialogState();
}

class _AddSectionDialogState extends State<AddSectionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _desctController=TextEditingController();

  String? _imagePath;

  final ImagePicker _picker = ImagePicker();
Map<String, dynamic>? _imageData;






Future<void> addsection() async {
  if (_formKey.currentState?.validate() ?? false) {
    final Uri url = Uri.parse('http://$ip:3000/plantpat/plant/AddSection');
    final request = http.MultipartRequest('POST', url)
      ..fields['name'] = _nameController.text
      ..fields['description'] = _desctController.text;

    if (_imageData != null) {
      final imageBytes = _imageData!['data'] as Uint8List;
      final imageName = _imageData!['name'] as String;

      // Determine the correct content type based on the file extension
      final contentType = imageName.endsWith('.png') ? 'image/png' : 'image/jpeg';

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
          contentType: MediaType.parse(contentType),
        ),
      );
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Section added successfully");
        print('Name: ${_nameController.text}');
        print('Description: ${_desctController.text}');
        Navigator.of(context).pop(true); 
      } else {
        // Handle server error
        print('Failed to add section: ${response.statusCode}');
        Navigator.of(context).pop(false); 
      }
    } catch (e) {
      // Handle network or other errors
      print('Error adding section: $e');
      Navigator.of(context).pop(false); 
    }
  }
}





void _imagePicker() async {
  print("Opening file picker");
  
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;
    if (files == null || files.isEmpty) return;

    final file = files[0];
    print("File picked: ${file.name}");

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);

    reader.onLoadEnd.listen((e) {
      final bytes = reader.result as Uint8List?;
      if (bytes != null) {
        setState(() {
          _imageData = {
            'data': bytes,
            'name': file.name,
          };
        });
        print("Image data set: ${_imageData?['name']}");
      }
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Section'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Section Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the section name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _desctController,
                decoration: InputDecoration(labelText: 'Section Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the section description';
                  }
                  return null;
                },
              ),


_imageData == null
    ? Text('No image selected')
    : Image.memory(
        _imageData!['data'] as Uint8List,
        height: 100,
        fit: BoxFit.cover,
      ),
ElevatedButton(
  onPressed: _imagePicker,
  child: Text('Select Image'),
),

            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
       TextButton(
  onPressed: () async {
      if (_imageData != null) {

    await addsection(); // Add your plant
print("doneee");
    // final sections = await _AddProductDialogState.getsections();
    // setstate(){
      
    //   _AddProductDialogState._sectionNames=sections;
  
    // }



    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductsScreen(),
  ),
).then((result) {
  if (result == true) {
    // Call refreshProducts method to update the list
    setState(() {
     _ProductsScreenState. _productsFuture = _ProductsScreenState.fetchPlants();
    });
  }
});

    // Close the current screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Section added successfully'), backgroundColor: Colors.green),
    );

    

//     // Refresh ProductsScreen
//     Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => ProductsScreen(onRefresh: () {
//       // Call this callback to refresh
//     }),
//   ),
// ); // Assuming you have a static method to refresh
  } else {
      print("Image data is null");
    }
  },
  child: Text('Add Section'),
)

      ],
    );
  }

}









//  @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Add New Product'),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Product Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the product name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _desctController,
//                 decoration: InputDecoration(labelText: 'Product Description'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the product description';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the price';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Please enter a valid number';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _quantityController,
//                 decoration: InputDecoration(labelText: 'Quantity'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the quantity';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _heightController,
//                 decoration: InputDecoration(labelText: 'Height'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the height';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//               Text('Select Size'),
//               DropdownButtonFormField<String>(
//                 value: _selectedsize,
//                 items: [
//                   'small',
//                   'medium',
//                   'large',
//                 ].map((size) {
//                   return DropdownMenuItem<String>(
//                     value: size,
//                     child: Text(size),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedsize = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Please select a size';
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               Text('Select Section'),
//               DropdownButtonFormField<String>(
//                 value: _selectedSectionName,
//                 items: [
//                   'Section 1',
//                   'Section 2',
//                   'Section 3',
//                   'Section 4',
//                 ].map((section) {
//                   return DropdownMenuItem<String>(
//                     value: section,
//                     child: Text(section),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedSectionName = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Please select a section';
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               _imagePath == null
//                   ? Text('No image selected')
//                   : Image.file(
//                       File(_imagePath!),
//                       height: 100,
//                       fit: BoxFit.cover,
//                     ),
//               ElevatedButton(
//                 onPressed: () async {
//                   final pickedFile =
//                       await _picker.pickImage(source: ImageSource.gallery);
//                   if (pickedFile != null) {
//                     setState(() {
//                       _imagePath = pickedFile.path;
//                     });
//                   }
//                 },
//                 child: Text('Select Image'),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {


//             await addplant();
//             if (_formKey.currentState?.validate() ?? false) {
//               // Handle form submission
//               Navigator.of(context).pop();
//             }
//           },
//           child: Text('Add Product'),
//         ),
//       ],
//     );
//   }



// ProductCard widget with delete icon
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete; // Callback for deletion

  ProductCard({required this.product, required this.onDelete});



  @override
Widget build(BuildContext context) {
    // Convert imageData to Uint8List
    Uint8List imageBytes;
    try {
      // Check if imageData contains base64 encoded data
      if (product.imageData['data'] is String) {
        imageBytes = base64Decode(product.imageData['data']);
      } else if (product.imageData['data'] is List<dynamic>) {
        // Convert List<dynamic> to List<int> and then to Uint8List
        List<int> bytesList = List<int>.from(product.imageData['data']);
        imageBytes = Uint8List.fromList(bytesList);
      } else {
        // Default empty image if there's an error or unsupported format
        imageBytes = Uint8List(0);
      }
    } catch (e) {
      // Handle any potential errors in processing
      imageBytes = Uint8List(0); // Empty image if there's an error
      print('Error processing image data: $e');
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: SizedBox(
        height: 250,
        width: 250,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                    child: Image.memory(
                      imageBytes,
                      width: double.infinity,
                      height: 210,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                          child: Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        // Uncomment and use if needed
                        // Text(
                        //   product.sectionName,
                        //   style: TextStyle(
                        //     fontSize: 12.0,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
