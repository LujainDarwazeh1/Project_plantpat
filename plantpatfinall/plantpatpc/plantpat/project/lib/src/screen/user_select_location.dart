// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:another_flushbar/flushbar.dart';

// class UserSelectLocation extends StatefulWidget {
//   @override
//   State<UserSelectLocation> createState() => UserSelectLocationState();
// }

// class UserSelectLocationState extends State<UserSelectLocation> {
//   GoogleMapController? gmc;
//   LatLng? selectedLatLng;
//   List<Marker> markers = [];
//   bool _dialogShown = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _showLocationDialog());
//   }

//   void _showLocationDialog() {
//     if (!_dialogShown) {
//       _dialogShown = true;
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(20.0)),
//             ),
//             title: Text(
//               'Select Your Location',
//               style: GoogleFonts.aBeeZee(
//                 textStyle: TextStyle(
//                   color: Color.fromARGB(255, 2, 92, 123),
//                   fontSize: 20,
//                   decorationThickness: 1,
//                 ),
//               ),
//             ),
//             content: Text(
//               'Tap on the map to select your location.',
//               style: GoogleFonts.aBeeZee(
//                 textStyle: TextStyle(
//                   color: Color.fromARGB(255, 1, 3, 4),
//                   fontSize: 14,
//                   decorationThickness: 1,
//                 ),
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 style: TextButton.styleFrom(
//                   foregroundColor: Colors.green,
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void _onDone() {
//     if (selectedLatLng != null) {
//       Navigator.of(context).pop(selectedLatLng);
//     } else {
//       Flushbar(
//         message: "Please select your location",
//         duration: Duration(seconds: 3),
//         backgroundColor: Colors.red,
//         margin: EdgeInsets.all(8),
//         borderRadius: BorderRadius.circular(8),
//       ).show(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Color.fromARGB(255, 255, 255, 255),
//             size: 24,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Location',
//               style: GoogleFonts.aBeeZee(
//                 textStyle: TextStyle(
//                   color: const Color.fromARGB(255, 255, 255, 255),
//                   fontSize: 22,
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 if (selectedLatLng == null) {
//                   Flushbar(
//                     message: "Please select your location",
//                     duration: Duration(seconds: 3),
//                     backgroundColor: Colors.red,
//                     margin: EdgeInsets.all(8),
//                     borderRadius: BorderRadius.circular(8),
//                   ).show(context);
//                 } else {
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: Color.fromARGB(255, 255, 255, 255), width: 2.0),
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Text(
//                   'Done',
//                   style: GoogleFonts.aBeeZee(
//                     textStyle: TextStyle(
//                       color: const Color.fromARGB(255, 255, 255, 255),
//                       fontSize: 22,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Color(0xFF0D6775),
//       ),
//       body: GoogleMap(
//         onTap: (LatLng latlng) {
//           setState(() {
//             markers.clear();
//             markers.add(Marker(
//               markerId: MarkerId("1"),
//               position: latlng,
//             ));
//             selectedLatLng = latlng;
//           });
//         },
//         mapType: MapType.normal,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(32.222, 35.262),
//           zoom: 13.5,
//         ),
//         markers: markers.toSet(),
//         onMapCreated: (controller) {
//           gmc = controller;
//         },
//       ),
//     );
//   }
// }





import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:another_flushbar/flushbar.dart';

class UserSelectLocation extends StatefulWidget {
  @override
  State<UserSelectLocation> createState() => UserSelectLocationState();
}

class UserSelectLocationState extends State<UserSelectLocation> {
  GoogleMapController? _googleMapController;
  LatLng? _selectedLatLng;
  List<Marker> _markers = [];
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showLocationDialog());
  }

  void _showLocationDialog() {
    if (!_dialogShown) {
      _dialogShown = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              'Select Your Location',
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 10, 143, 57),
                  fontSize: 20,
                  decorationThickness: 1,
                ),
              ),
            ),
            content: Text(
              'Tap on the map to select your location.',
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 1, 3, 4),
                  fontSize: 14,
                  decorationThickness: 1,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

//   void _onDone() {
//   if (_selectedLatLng != null) {
//     print("Selected LatLng: ${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude}");
//     Navigator.of(context).pop(_selectedLatLng);
//   } else {
//     Flushbar(
//       message: "Please select your location",
//       duration: Duration(seconds: 3),
//       backgroundColor: Colors.red,
//       margin: EdgeInsets.all(8),
//       borderRadius: BorderRadius.circular(8),
//     ).show(context);
//   }
// }

void _onDone() async {
  if (_selectedLatLng != null) {
 
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
     
      final firestore = FirebaseFirestore.instance;

     
      final locationRef = firestore
          .collection('userlocation')
          .doc(userId); 

      try {
       
        await locationRef.set({
          'latitude': _selectedLatLng!.latitude,
          'longitude': _selectedLatLng!.longitude,
          'time': Timestamp.now(),
          'userId': userId,
        });

       
        await Flushbar(
          message: "Location saved successfully",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          margin: EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
        ).show(context);

      
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(_selectedLatLng);
        });
      } catch (e) {
        print("Error saving location: $e");
        await Flushbar(
          message: "Error saving location",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
        ).show(context);
      }
    } else {
      await Flushbar(
        message: "No user ID found",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
      ).show(context);
    }
  } else {
    await Flushbar(
      message: "Please select your location",
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Location',
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            GestureDetector(
              onTap: _onDone,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor:Color.fromARGB(255, 10, 143, 57),
      ),
      body: GoogleMap(
        onTap: (LatLng latLng) {
          setState(() {
            _markers.clear();
            _markers.add(Marker(
              markerId: MarkerId("selected_location"),
              position: latLng,
            ));
            _selectedLatLng = latLng;
          });
        },
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(32.222, 35.262),
          zoom: 13.5,
        ),
        markers: _markers.toSet(),
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
      ),
    );
  }
}
