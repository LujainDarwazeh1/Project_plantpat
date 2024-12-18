// import 'package:another_flushbar/flushbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart' as geocoding;
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:async';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location;
// import 'package:plantpat/src/screen/order_details_user.dart';

// class OrderTrackingPage extends StatefulWidget {
//   @override
//   State<OrderTrackingPage> createState() => OrderTrackingPageState();
// }

// class OrderTrackingPageState extends State<OrderTrackingPage> {
//   GoogleMapController? gmc;
//   StreamSubscription<location.LocationData>? positionStream;

//   final LatLng sourceLocation = LatLng(32.2236, 35.2518); 
//   LatLng destinationLocation = LatLng(32.2209, 35.2507);

//   List<Marker> markers = [];
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints = PolylinePoints();
//   int polylineIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     updateStreetAddress();
//     markers = [
//       Marker(
//         markerId: MarkerId("src"),
//         position: sourceLocation,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//       ),
//       Marker(
//         markerId: MarkerId("dest"),
//         position: destinationLocation,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       ),
//     ];
//     setPolylines();
//   }

//   @override
//   void dispose() {
//     positionStream?.cancel();
//     super.dispose();
//   }

//   void updateStreetAddress() async {
//     if (OrderDetailsUserState.cityController.text == '') {
//       // Handle case when address is empty if needed
//     } else {
//       await cityToLatLng(OrderDetailsUserState.streetAddressController.text);
//     }
//   }

//   Future<void> cityToLatLng(String address) async {
//     try {
//       List<geocoding.Location> locations = await geocoding.locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         double latitude = locations[0].latitude;
//         double longitude = locations[0].longitude;
//         setState(() {
//           destinationLocation = LatLng(latitude, longitude);
//           markers[1] = Marker(
//             markerId: MarkerId("dest"),
//             position: destinationLocation,
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           );
//           setPolylines();
//         });
//       } else {
//         print("No locations found");
//       }
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }

//  Future<void> setPolylines() async {
//   final PolylineRequest request = PolylineRequest(
//     origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//     destination: PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
//     mode: TravelMode.driving,
//   );

//   try {
//     final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: "AIzaSyDna5Re2swo5RmpeNuTlAUwC9_tXts2Ys4",
//       request: request,
//     );

//     if (result.points.isNotEmpty) {
//       print("Polyline points received:");
//       result.points.forEach((point) {
//         print("Lat: ${point.latitude}, Lng: ${point.longitude}");
//       });

//       setState(() {
//         polylineCoordinates = result.points
//             .map((point) => LatLng(point.latitude, point.longitude))
//             .toList();
//         print("Polyline Coordinates: $polylineCoordinates");
//         animateMarker();
//       });
//     } else {
//       print("No route found");
//     }
//   } catch (e) {
//     print("Error fetching route: $e");
//   }
// }


//   void animateMarker() {
//     Timer.periodic(Duration(milliseconds: 1000), (timer) {
//       if (polylineIndex >= polylineCoordinates.length - 1) {
//         timer.cancel();
//         return;
//       }

//       setState(() {
//         final nextPosition = polylineCoordinates[polylineIndex++];
//         markers[0] = Marker(
//           markerId: MarkerId("src"),
//           position: nextPosition,
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         );
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.white,
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
//               'Tracking Order',
//               style: GoogleFonts.aBeeZee(
//                 textStyle: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green,
//       ),
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(32.224405, 35.2573),
//           zoom: 13.5,
//         ),
//         markers: markers.toSet(),
//         polylines: {
//           Polyline(
//             polylineId: PolylineId("route"),
//             points: polylineCoordinates,
//             color: Colors.green,
//             width: 6,
//           ),
//         },
//         onMapCreated: (controller) {
//           gmc = controller;
//         },
//       ),
//     );
//   }
// }




import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingPage extends StatefulWidget {
  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  GoogleMapController? _googleMapController;
  LatLng? sourceLocation;
  LatLng? destinationLocation;
  List<Marker> markers = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    fetchLocations(); 
    Timer timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchLocations());

  }

  @override
  void dispose() {
    timer?.cancel(); 
    super.dispose();
  }

  Future<void> checkLocationPermission() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      print("Location permission not granted. Requesting permission...");
      await Permission.location.request();
      final newStatus = await Permission.location.status;
      if (!newStatus.isGranted) {
        print("Location permission still not granted.");
      } else {
        print("Location permission granted.");
      }
    } else {
      print("Location permission already granted.");
    }
  }

  Future<void> fetchLocations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is currently signed in");
        return;
      }

      final userUid = 'sG6TUYBcAcSoeL0awNb7aLA0gED3'; 
      final currentUserUid = user.uid; 

      
      final sourceDoc = await FirebaseFirestore.instance.collection('userlocation').doc(userUid).get();
      final sourceData = sourceDoc.data();
      if (sourceData != null) {
        final sourceLat = sourceData['latitude'];
        final sourceLng = sourceData['longitude'];
        print("Source data retrieved: Latitude: $sourceLat, Longitude: $sourceLng");
        setState(() {
          sourceLocation = LatLng(sourceLat, sourceLng);
        });
      } else {
        print("Source location data not found.");
      }

      
      final destinationDoc = await FirebaseFirestore.instance.collection('userlocation').doc(currentUserUid).get();
      final destinationData = destinationDoc.data();
      if (destinationData != null) {
        final destinationLat = destinationData['latitude'];
        final destinationLng = destinationData['longitude'];
        print("Destination data retrieved: Latitude: $destinationLat, Longitude: $destinationLng");
        setState(() {
          destinationLocation = LatLng(destinationLat, destinationLng);
        });
      } else {
        print("Destination location data not found.");
      }

     
      if (sourceLocation != null && destinationLocation != null) {
        setState(() {
          markers = [
            Marker(
              markerId: MarkerId("deliveryLocation"),
              position: LatLng(sourceLocation!.latitude + 0.001, sourceLocation!.longitude), 
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow(title: 'Delivery Location'),
            ),
            Marker(
              markerId: MarkerId("destinationLocation"),
              position: LatLng(destinationLocation!.latitude - 0.001, destinationLocation!.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(title: 'Your Location'),
            ),
          ];
          print("Markers updated: $markers");
        });
        if (_googleMapController != null && sourceLocation != null) {
          _googleMapController!.animateCamera(
            CameraUpdate.newLatLngZoom(sourceLocation!, 12.0),
          );
        }
      }
    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Tracking Order',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(32.224405, 35.2573),
          zoom: 13.5,
        ),
        markers: markers.toSet(),
        onMapCreated: (controller) {
          _googleMapController = controller;
          print("Google Map Controller created.");
          if (sourceLocation != null) {
            _googleMapController!.animateCamera(
              CameraUpdate.newLatLngZoom(sourceLocation!, 12.0),
            );
          }
        },
      ),
    );
  }
}





















// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart' as geocoding;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:location/location.dart' as location;

// class OrderTrackingPage extends StatefulWidget {
//   @override
//   State<OrderTrackingPage> createState() => OrderTrackingPageState();
// }

// class OrderTrackingPageState extends State<OrderTrackingPage> {
//   GoogleMapController? gmc;
//   StreamSubscription<location.LocationData>? positionStream;
//   StreamSubscription<DocumentSnapshot>? collocationStream;

//   LatLng? sourceLocation;
//   LatLng? destinationLocation;

//   List<Marker> markers = [];
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints polylinePoints = PolylinePoints();

//   @override
//   void initState() {
//     super.initState();
//     fetchLocations();
//   }

//   @override
//   void dispose() {
//     positionStream?.cancel();
//     collocationStream?.cancel();
//     super.dispose();
//   }

//   Future<void> fetchLocations() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         print("No user is currently signed in");
//         return;
//       }

//       final userUid = 'sG6TUYBcAcSoeL0awNb7aLA0gED3'; // Replace with the actual source UID
//       final currentUserUid = user.uid; // Get the current user's UID

//       // Fetch source location from Firestore
//       final sourceDoc = await FirebaseFirestore.instance.collection('userlocation').doc(userUid).get();
//       final sourceData = sourceDoc.data();
//       if (sourceData != null) {
//         final sourceLat = sourceData['latitude'];
//         final sourceLng = sourceData['longitude'];
//         setState(() {
//           sourceLocation = LatLng(sourceLat, sourceLng);
//         });
//       }

//       // Fetch destination location from Firestore
//       final destinationDoc = await FirebaseFirestore.instance.collection('userlocation').doc(currentUserUid).get();
//       final destinationData = destinationDoc.data();
//       if (destinationData != null) {
//         final destinationLat = destinationData['latitude'];
//         final destinationLng = destinationData['longitude'];
//         setState(() {
//           destinationLocation = LatLng(destinationLat, destinationLng);
//         });
//       }

//       // Initialize markers and polylines
//       if (sourceLocation != null && destinationLocation != null) {
//         markers = [
//           Marker(
//             markerId: MarkerId("deliveryLocation"),
//             position: sourceLocation!,
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Green color
//             infoWindow: InfoWindow(title: 'Delivery Location'),
//           ),
//           Marker(
//             markerId: MarkerId("destinationLocation"),
//             position: destinationLocation!,
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Blue color
//             infoWindow: InfoWindow(title: 'Your Location'),
//           ),
//         ];
//         setPolylines();
//         listenToCollocationUpdates(userUid);
//       }
//     } catch (e) {
//       print("Error fetching locations: $e");
//     }
//   }

//   Future<void> listenToCollocationUpdates(String userUid) async {
//     collocationStream = FirebaseFirestore.instance
//         .collection('marker')
//         .doc(userUid)
//         .snapshots()
//         .listen((snapshot) {
//           if (snapshot.exists) {
//             final data = snapshot.data();
//             if (data != null) {
//               final latitude = data['latitude'] as double;
//               final longitude = data['longitude'] as double;
//               final newLocation = LatLng(latitude, longitude);
//               setState(() {
//                 sourceLocation = newLocation;
//                 markers = markers.map((marker) {
//                   if (marker.markerId.value == "deliveryLocation") {
//                     return marker.copyWith(positionParam: newLocation);
//                   }
//                   return marker;
//                 }).toList();
//               });
//               // Optionally, animate the camera to the new marker location
//               gmc?.animateCamera(CameraUpdate.newLatLng(newLocation));
//             }
//           }
//         });
//   }

//   Future<void> setPolylines() async {
//     if (sourceLocation == null || destinationLocation == null) return;

//     final PolylineRequest request = PolylineRequest(
//       origin: PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
//       destination: PointLatLng(destinationLocation!.latitude, destinationLocation!.longitude),
//       mode: TravelMode.driving,
//     );

//     try {
//       final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey: "AIzaSyDrgXyoZlKMUDQIet_5ywTkLwdPC4BEwYo", // Replace with your API key
//         request: request,
//       );

//       if (result.points.isNotEmpty) {
//         setState(() {
//           polylineCoordinates = result.points
//               .map((point) => LatLng(point.latitude, point.longitude))
//               .toList();
//         });
//       } else {
//         print("No route found");
//       }
//     } catch (e) {
//       print("Error fetching route: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.white,
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
//               'Tracking Order',
//               style: GoogleFonts.aBeeZee(
//                 textStyle: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green,
//       ),
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(32.224405, 35.2573),
//           zoom: 13.5,
//         ),
//         markers: markers.toSet(),
//         polylines: {
//           if (polylineCoordinates.isNotEmpty)
//             Polyline(
//               polylineId: PolylineId("route"),
//               points: polylineCoordinates,
//               color: Colors.green,
//               width: 6,
//             ),
//         },
//         onMapCreated: (controller) {
//           gmc = controller;
//         },
//       ),
//     );
//   }
// }
