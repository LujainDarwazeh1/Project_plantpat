


// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:plantpat/src/screen/deliveryoption.dart';
// import 'package:plantpat/src/screen/ipaddress.dart';
// import 'package:plantpat/src/screen/login_screen.dart';
// import 'package:plantpat/src/screen/shopping_cart.dart';
// import 'package:plantpat/src/screen/user_select_location.dart';
// import 'package:http/http.dart' as http;



// class OrderDetailsUser extends StatefulWidget {
//   @override
//   OrderDetailsUserState createState() => OrderDetailsUserState();
// }

// class OrderDetailsUserState extends State<OrderDetailsUser> {
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   static final TextEditingController cityController = TextEditingController();
//   static final TextEditingController streetAddressController = TextEditingController();
//   String? selectedLocation;

  
//   LatLng? selectedLatLng;

// @override
// void initState() {
//   super.initState();
//   fetchLatestLocation();
// }



// Future<void> fetchLatestLocation() async {
//  final response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/location?userid=${Login.idd}'));


//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);

//     if (data != null) {
//       setState(() {
//         firstNameController.text = data['first_name'] ?? '';
//         lastNameController.text = data['last_name'] ?? '';
//         phoneNumberController.text = data['phone_number'] ?? '';
//         cityController.text = data['city'] ?? '';
//         streetAddressController.text = data['street_address'] ?? '';
//         selectedLocation = data['location'] ?? '';
//         selectedLatLng = LatLng(
//           data['latitude'] ?? 0.0,
//           data['longitude'] ?? 0.0,
//         );
//       });
//     }
//   } else {
//     // Handle the error if needed
//     print('Failed to load location');
//   }
// }



//  void openLocationPicker() async {
//   final LatLng? result = await Get.to(() => UserSelectLocation());
//   print("Result from UserSelectLocation: $result");
//   if (result != null) {
//     setState(() {
//       selectedLatLng = result;
      
//       // Perform reverse geocoding to get address details
//       _getAddressFromLatLng(result);
//     });
//   }
// }

// void _getAddressFromLatLng(LatLng latLng) async {
//   // Replace with your reverse geocoding function
//   List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
//   if (placemarks.isNotEmpty) {
//     Placemark placemark = placemarks[0];
//     setState(() {
//       cityController.text = placemark.locality ?? "";
//       streetAddressController.text = placemark.street ?? "";
//     });
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.green,
//             size: 24,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           'Shipping Address',
//           style: GoogleFonts.aBeeZee(
//             textStyle: TextStyle(
//               color: const Color.fromARGB(255, 0, 0, 0),
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//           DropdownButtonFormField<String>(
//   decoration: InputDecoration(
//     labelText: 'Location',
//     labelStyle: TextStyle(color: Colors.black),
//     border: OutlineInputBorder(),
//   ),
//   items: ['Palestine', 'Jordan', 'Lebanon', 'Syria']
//       .map((location) => DropdownMenuItem<String>(
//             value: location,
//             child: Text(location),
//           ))
//       .toList(),
//   onChanged: (value) {
//     setState(() {
//       selectedLocation = value;
//     });
//   },
//   value: selectedLocation, // Make sure this value exists in the items list or handle null
// ),

//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: firstNameController,
//               decoration: InputDecoration(
//                 labelText: 'First Name*',
//                 labelStyle: TextStyle(color: Colors.black),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: lastNameController,
//               decoration: InputDecoration(
//                 labelText: 'Last Name*',
//                 labelStyle: TextStyle(color: Colors.black),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: phoneNumberController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number*',
//                 labelStyle: TextStyle(color: Colors.black),
//                 hintText: 'PL +970',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               'Need Correct Phone Number for delivery.',
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//             TextFormField(
//               controller: cityController,
//               decoration: InputDecoration(
//                 labelText: 'City*',
//                 labelStyle: TextStyle(color: Colors.black),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: streetAddressController,
//               decoration: InputDecoration(
//                 labelText: 'Street Address*',
//                 labelStyle: TextStyle(color: Colors.black),

//                 hintText: 'Street Name, House No, Apt, suite etc.',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'OR you can choose your Location from the map',
//               style: TextStyle(
//                   color: const Color.fromARGB(255, 18, 18, 18), fontSize: 15),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(12)),
//                 ),
//               ),
//               child: Icon(
//                 FontAwesomeIcons.mapMarkerAlt,
//                 size: 30,
//                 color: Colors.green,
//               ),
//               onPressed: openLocationPicker,
//             ),
//             SizedBox(height: 32.0),
// ElevatedButton(
//   onPressed: () {
//     // Save the data or handle form submission
//     // Example: print values
//     print("First Name: ${firstNameController.text}");
//     print("Last Name: ${lastNameController.text}");
//     print("Phone Number: ${phoneNumberController.text}");
//     print("City: ${cityController.text}");
//     print("Street Address: ${streetAddressController.text}");

//     if (selectedLatLng != null) {
//       print("Selected Location: ${selectedLatLng!.latitude}, ${selectedLatLng!.longitude}");

//       // Show dialog to confirm saving the location
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Save Location'),
//             content: Text('Would you like to save this location for future use?'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                  onSave(); // Call the function to handle saving
//                 },
//                 child: Text('Yes'),
//                 style: TextButton.styleFrom(
//                   foregroundColor: Colors.green, // Color for 'Yes' button text
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                   onnotSave();
//                 },
//                 child: Text('No'),
//                 style: TextButton.styleFrom(
//                   foregroundColor: Colors.red, // Color for 'No' button text
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       // Show a snackbar if no location is selected
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             "No location selected",
//             style: TextStyle(color: Colors.white), // Text color
//           ),
//           backgroundColor: Colors.red, // Snackbar background color
//           duration: Duration(seconds: 3), // Duration for which the Snackbar is shown
//         ),
//       );
//     }
//   },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(50, 25),
//                 backgroundColor: Color.fromARGB(255, 10, 143, 57),
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 24.0,
//                   vertical: 12.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(1.0),
//                 ),
//               ),
//               child: Text(
//                 "Save",
//                 style: GoogleFonts.aBeeZee(
//                   textStyle: TextStyle(
//                     color: const Color.fromARGB(255, 255, 255, 255),
//                   ),
//                   fontSize: 21,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }


// void onSave() async {
//   final url = 'http://$ip:3000/plantpat/user/savelocation';

//   // Prepare data to send
//   final data = {
//     'userid': Login.idd, 
//     'location': selectedLocation, 
//     'first_name': firstNameController.text,
//     'last_name': lastNameController.text,
//     'phone_number': phoneNumberController.text,
//     'city': cityController.text,
//     'street_address': streetAddressController.text,
//   };

//   try {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(data),
//     );

//     if (response.statusCode == 200) {
//       // Handle success
//       final responseBody = jsonDecode(response.body);
//       print('Success: ${responseBody['message']}');
//     } else {
//       // Handle failure
//       print('Failed to save location: ${response.statusCode}');
//     }


//                         Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DeliveryOption(itemPrice: CartPageState.amount),
//       ),
//     );
//   } catch (e) {
//     // Handle error
//     print('Error: $e');
//   }




// }




//   onnotSave(){
//                         Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DeliveryOption(itemPrice: CartPageState.amount),
//       ),
//     );

//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plantpat/src/screen/user_select_location.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/login_screen.dart';



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plantpat/src/screen/deliveryoption.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/shopping_cart.dart';
import 'package:plantpat/src/screen/user_select_location.dart';
import 'package:http/http.dart' as http;

class OrderDetailsUser extends StatefulWidget {
  @override
  OrderDetailsUserState createState() => OrderDetailsUserState();
}

class OrderDetailsUserState extends State<OrderDetailsUser> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  static final TextEditingController cityController = TextEditingController();
  static final TextEditingController streetAddressController = TextEditingController();
  String? selectedLocation = 'Palestine'; 
  LatLng? selectedLatLng;

  @override
  void initState() {
    super.initState();
    fetchLatestLocation();
  }

  Future<void> fetchLatestLocation() async {
    final response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/location?userid=${Login.idd}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        setState(() {
          firstNameController.text = data['first_name'] ?? '';
          lastNameController.text = data['last_name'] ?? '';
          phoneNumberController.text = data['phone_number'] ?? '';
          cityController.text = data['city'] ?? '';
          streetAddressController.text = data['street_address'] ?? '';
          selectedLocation = data['location'] ?? 'Palestine'; 
          selectedLatLng = LatLng(
            data['latitude'] ?? 0.0,
            data['longitude'] ?? 0.0,
          );
        });
      }
    } else {
      print('Failed to load location');
    }
  }

  void openLocationPicker() async {
    final LatLng? result = await Get.to(() => UserSelectLocation());
    if (result != null) {
      setState(() {
        selectedLatLng = result;
        _getAddressFromLatLng(result);
      });
    }
  }

  void _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      setState(() {
        cityController.text = placemark.locality ?? "";
        streetAddressController.text = placemark.street ?? "";
      });
    }
  }
void onSave() async {
  final url = 'http://$ip:3000/plantpat/user/savelocation';

 
  final data = {
    'userid': Login.idd, 
    'location': selectedLocation, 
    'first_name': firstNameController.text,
    'last_name': lastNameController.text,
    'phone_number': phoneNumberController.text,
    'city': cityController.text,
    'street_address': streetAddressController.text,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      
      final responseBody = jsonDecode(response.body);
      print('Success: ${responseBody['message']}');
    } else {
     
      print('Failed to save location: ${response.statusCode}');
    }


                        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryOption(itemPrice: CartPageState.amount),
      ),
    );
  } catch (e) {
   
    print('Error: $e');
  }




}

  onnotSave(){
                        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryOption(itemPrice: CartPageState.amount),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.green,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '87'.tr,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
            
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: '88'.tr,
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              items: <String>['Palestine', 'Jordan', 'Lebanon', 'Syria']
                  .map((String location) => DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLocation = newValue;
                });
              },
              value: selectedLocation,
             
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: '89'.tr,
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: '90'.tr,
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: '91'.tr,
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'PL +970',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 8.0),
            Text(
              '92'.tr,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            TextFormField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: '93'.tr,
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: streetAddressController,
              decoration: InputDecoration(
                labelText: '94'.tr,
                labelStyle: TextStyle(color: Colors.black),
                hintText: '95'.tr,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '96'.tr,
              style: TextStyle(
                color: const Color.fromARGB(255, 18, 18, 18),
                fontSize: 15,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              child: Icon(
                FontAwesomeIcons.mapMarkerAlt,
                size: 30,
                color: Colors.green,
              ),
              onPressed: openLocationPicker,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                
                onSave();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(50, 25),
                backgroundColor: Color.fromARGB(255, 10, 143, 57),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.0),
                ),
              ),
              child: Text(
                "97".tr,
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  fontSize: 21,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
