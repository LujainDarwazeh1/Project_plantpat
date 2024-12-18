



import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:background_location/background_location.dart'; 
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:http/http.dart' as http;
import 'package:plantpat/src/screen/ipaddress.dart';
import 'package:plantpat/src/screen/userdetails.dart';


class GoogleMapsScreen extends StatefulWidget {
   final String userId;
  final String userEmail;
  final double amount;
  final String paymentMethod;

  GoogleMapsScreen({
    required this.userId,
    required this.userEmail,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  _GoogleMapsScreenState createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen>with WidgetsBindingObserver {
  GoogleMapController? _googleMapController;
  LatLng? _selectedLatLng;
  LatLng? _userLocationLatLng;
  final Set<Marker> _markers = {};

  bool _dialogShown = false;
  Timer? _moveTimer;
  bool _isMoving = false;

void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showLocationDialog());
    _loadUserLocation();
    _startBackgroundLocationService();
  }











  Future<void> _updateDeliveryStatus() async {
    final id = await getUserIdByEmail(widget.userEmail);
    if (id == null) {
      print('User ID not found.');
      return;
    }

    final String url = 'http://$ip:3000/plantpat/payment/updatestatus';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userid': id,
        'amount': widget.amount,
        'payment_method': widget.paymentMethod,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Delivery status updated successfully');
    } else {
      print('Failed to update delivery status');
    }
  }

  Future<int?> getUserIdByEmail(String email) async {
    final String url = 'http://$ip:3000/plantpat/user/getuserbyemail?email=$email';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final user = data[0] as Map<String, dynamic>;
          return user['user_id'] as int?;
        } else {
          print('No user data found for the provided email');
          return null;
        }
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user ID by email: $e');
      return null;
    }
  }




  @override
  void dispose() {
    _moveTimer?.cancel();
    BackgroundLocation.stopLocationService();
    super.dispose();
  }

  Future<void> _loadUserLocation() async {
    final userId = widget.userId;
    print("Loading user location for userId: $userId");

    if (userId.isNotEmpty) {
      try {
        final firestore = FirebaseFirestore.instance;
        final locationSnapshot = await firestore
            .collection('userlocation')
            .doc(userId)
            .get();

        if (locationSnapshot.exists) {
          final locationData = locationSnapshot.data();
          final latitude = locationData?['latitude'] as double?;
          final longitude = locationData?['longitude'] as double?;

          if (latitude != null && longitude != null) {
            if (mounted) {
              setState(() {
                _userLocationLatLng = LatLng(latitude, longitude);
                _markers.add(Marker(
                  markerId: MarkerId("user_location"),
                  position: _userLocationLatLng!,
                  infoWindow: InfoWindow(title: 'User Location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ));
                _googleMapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(_userLocationLatLng!, 12.0),
                );
              });
              print("User location loaded: $_userLocationLatLng");
            }
          } else {
            _zoomToPalestine();
          }
        } else {
          _zoomToPalestine();
        }
      } catch (e) {
        print("Error loading user location: $e");
        _zoomToPalestine();
      }
    } else {
      _zoomToPalestine();
    }
  }

  void _zoomToPalestine() {
    if (mounted) {
      setState(() {
        if (_googleMapController != null) {
          _googleMapController!.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(31.9454, 35.3026), 8.0),
          );
        }
      });
      print("Zoomed to Palestine");
    }
  }

  void _startBackgroundLocationService() async {
    print("Starting background location service");

    await BackgroundLocation.setAndroidNotification(
      title: 'Background service is running',
      message: 'Background location in progress',
      icon: '@mipmap/ic_launcher',
    );
    await BackgroundLocation.startLocationService(distanceFilter: 0);

    BackgroundLocation.getLocationUpdates((location) async {
      print("Received location update: $location");
      LatLng latLng = LatLng(location.latitude!, location.longitude!);
      await _saveLocationToFirestore(latLng);

    });
  }

  Future<void> _saveLocationToFirestore(LatLng latLng) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final firestore = FirebaseFirestore.instance;
      final userId = currentUser.uid;

      try {
        await firestore.collection('userlocation').doc(userId).set({
          'latitude': latLng.latitude,
          'longitude': latLng.longitude,
          'time': FieldValue.serverTimestamp(),
          'userId': userId,
        }, SetOptions(merge: true));
        print("Location saved to Firestore: $latLng");
      } catch (e) {
        print("Error updating location in Firestore: $e");
      }
    } else {
      print("No current user found");
    }
  }


  void _startMovingMarker() {
    if (_selectedLatLng != null && _userLocationLatLng != null) {
      if (mounted) {
        setState(() {
          _isMoving = true; // Set moving flag to true
        });
      }

      const stepDistance = 10.0; // Distance in meters per step
      const duration = Duration(milliseconds: 300); // Duration of each step

      LatLng startPosition = _selectedLatLng!;
      LatLng endPosition = _userLocationLatLng!;
      LatLng lastSavedPosition = startPosition;

      double totalDistance = _calculateDistance(startPosition, endPosition);
      int steps = (totalDistance / stepDistance).ceil();
      double stepLat = (endPosition.latitude - startPosition.latitude) / steps;
      double stepLng = (endPosition.longitude - startPosition.longitude) / steps;

      int currentStep = 0;

      _moveTimer = Timer.periodic(duration, (timer) async {
        if (currentStep < steps) {
          if (mounted) {
            setState(() {
              startPosition = LatLng(
                startPosition.latitude + stepLat,
                startPosition.longitude + stepLng,
              );

              _selectedLatLng = startPosition;

              _markers.removeWhere((marker) => marker.markerId.value == 'selected_location');
              _markers.add(Marker(
                markerId: MarkerId("selected_location"),
                position: _selectedLatLng!,
                infoWindow: InfoWindow(title: 'Selected Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              ));
              _updatePolyline();
            });

            // Save location to Firestore if distance from last saved position >= 10 meters
            double distanceFromLastSave = _calculateDistance(lastSavedPosition, _selectedLatLng!);
            if (distanceFromLastSave >= stepDistance) {
              await _saveLocationToFirestore(_selectedLatLng!);

              lastSavedPosition = _selectedLatLng!;
              await _updateDeliveryStatus();
            }

            currentStep++;
          }
        } else {
          timer.cancel();
          if (mounted) {
            setState(() {
              _selectedLatLng = endPosition;
              _markers.removeWhere((marker) => marker.markerId.value == 'selected_location');
              _markers.add(Marker(
                markerId: MarkerId("selected_location"),
                position: endPosition,
                infoWindow: InfoWindow(title: 'Selected Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              ));
              _updatePolyline();
              _isMoving = false; // Set moving flag to false
            });

            // Save final location to Firestore
            await _saveLocationToFirestore(_selectedLatLng!);
          }
        }
      });
    } else {
      print("Selected or user location is null");
    }
  }


  //
  // void _startMovingMarker() {
  //
  //
  //
  //
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Notification sent successfully'),
  //       backgroundColor: Colors.green,
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  //
  //
  //
  //
  //
  //
  //
  //
  //   if (_selectedLatLng != null && _userLocationLatLng != null) {
  //     if (mounted) {
  //       setState(() {
  //         _isMoving = true;
  //       });
  //     }
  //
  //     const stepDistance = 10.0;
  //     const duration = Duration(milliseconds: 300);
  //
  //     LatLng startPosition = _selectedLatLng!;
  //     LatLng endPosition = _userLocationLatLng!;
  //     LatLng lastSavedPosition = startPosition;
  //
  //     double totalDistance = _calculateDistance(startPosition, endPosition);
  //     int steps = (totalDistance / stepDistance).ceil();
  //     double stepLat = (endPosition.latitude - startPosition.latitude) / steps;
  //     double stepLng = (endPosition.longitude - startPosition.longitude) / steps;
  //
  //     int currentStep = 0;
  //
  //     _moveTimer = Timer.periodic(duration, (timer) async {
  //       if (currentStep < steps) {
  //         if (mounted) {
  //           setState(() {
  //             startPosition = LatLng(
  //               startPosition.latitude + stepLat,
  //               startPosition.longitude + stepLng,
  //             );
  //
  //             _selectedLatLng = startPosition;
  //
  //             _markers.removeWhere((marker) => marker.markerId.value == 'selected_location');
  //             _markers.add(Marker(
  //               markerId: MarkerId("selected_location"),
  //               position: _selectedLatLng!,
  //               infoWindow: InfoWindow(title: 'Selected Location'),
  //               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //             ));
  //             _updatePolyline();
  //           });
  //
  //
  //           double distanceFromLastSave = _calculateDistance(lastSavedPosition, _selectedLatLng!);
  //           if (distanceFromLastSave >= stepDistance) {
  //             await _saveLocationToFirestore(_selectedLatLng!);
  //
  //             lastSavedPosition = _selectedLatLng!;
  //             await _updateDeliveryStatus();
  //           }
  //
  //           currentStep++;
  //         }
  //       } else {
  //         timer.cancel();
  //         if (mounted) {
  //           setState(() {
  //             _selectedLatLng = endPosition;
  //             _markers.removeWhere((marker) => marker.markerId.value == 'selected_location');
  //             _markers.add(Marker(
  //               markerId: MarkerId("selected_location"),
  //               position: endPosition,
  //               infoWindow: InfoWindow(title: 'Selected Location'),
  //               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //             ));
  //             _updatePolyline();
  //             _isMoving = false;
  //           });
  //
  //
  //           await _saveLocationToFirestore(_selectedLatLng!);
  //         }
  //       }
  //     });
  //   } else {
  //     print("Selected or user location is null");
  //   }
  // }


// void _startMovingMarker() async {
//   if (_selectedLatLng != null && _userLocationLatLng != null) {
//     if (mounted) {
//       setState(() {
//         _isMoving = true;
//       });
//     }
//
//     try {
//       print("Fetching route from $_selectedLatLng to $_userLocationLatLng");
//       List<LatLng> path = await _fetchRoute(_selectedLatLng!, _userLocationLatLng!);
//
//       if (path.isEmpty) {
//         print("Path is empty. Generating path using _generatePath.");
//         path = _generatePath(_selectedLatLng!, _userLocationLatLng!, 100); // Generate path if fetching fails
//       } else {
//         print("Path fetched successfully. Path Length: ${path.length}");
//       }
//
//       // Proceed with moving marker using the path
//       const int durationMs = 300; // Duration for each step in milliseconds
//       int currentStep = 0;
//
//       _moveTimer = Timer.periodic(Duration(milliseconds: durationMs), (timer) {
//         if (currentStep < path.length) {
//           if (mounted) {
//             setState(() {
//               LatLng newPosition = path[currentStep];
//
//               _selectedLatLng = newPosition;
//
//               _markers.removeWhere((marker) => marker.markerId.value == 'selected_location');
//               _markers.add(Marker(
//                 markerId: MarkerId("selected_location"),
//                 position: _selectedLatLng!,
//                 infoWindow: InfoWindow(title: 'Selected Location'),
//                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//               ));
//
//               _updatePolyline();
//
//               // Perform save location and update delivery status without awaiting
//               if (currentStep % 10 == 0) {
//                 _saveLocationToFirestore(_selectedLatLng!);
//                 _updateDeliveryStatus();
//               }
//             });
//           }
//           currentStep++;
//         } else {
//           timer.cancel();
//           if (mounted) {
//             setState(() {
//               _selectedLatLng = _userLocationLatLng!;
//               _markers.removeWhere((marker) => marker.markerId.value == 'selected_location');
//               _markers.add(Marker(
//                 markerId: MarkerId("selected_location"),
//                 position: _selectedLatLng!,
//                 infoWindow: InfoWindow(title: 'Selected Location'),
//                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//               ));
//               _updatePolyline();
//               _isMoving = false;
//             });
//
//             _saveLocationToFirestore(_selectedLatLng!);
//             _updateDeliveryStatus();
//           }
//         }
//       });
//     } catch (e) {
//       print("Error fetching route: $e");
//       setState(() {
//         _isMoving = false;
//       });
//     }
//   } else {
//     print("Selected or user location is null");
//   }
// }


List<LatLng> _decodePolyline(String encoded) {
  List<LatLng> polyline = [];
  int index = 0;
  int len = encoded.length;
  int lat = 0;
  int lng = 0;

  while (index < len) {
    int b;
    int shift = 0;
    int result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
    lng += dlng;

    LatLng p = LatLng(
      (lat / 1E5),
      (lng / 1E5),
    );
    polyline.add(p);
  }

  print("Decoded Polyline: $polyline"); // Debugging line
  return polyline;
}

Future<List<LatLng>> _fetchRoute(LatLng start, LatLng end) async {
  final String url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=AIzaSyDna5Re2swo5RmpeNuTlAUwC9_tXts2Ys4';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("API Response: $data"); // Debugging line

    if (data['routes'] != null && data['routes'].isNotEmpty) {
      final route = data['routes'][0];
      if (route['overview_polyline'] != null && route['overview_polyline']['points'] != null) {
        final overviewPolyline = route['overview_polyline']['points'];
        final List<LatLng> points = _decodePolyline(overviewPolyline);
        return points;
      } else {
        print("Overview polyline points not found in the response.");
      }
    } else {
      print("No routes found in the response.");
    }
  } else {
    throw Exception('Failed to load route');
  }
  return [];
}

List<LatLng> _generatePath(LatLng start, LatLng end, int steps) {
  List<LatLng> path = [];
  for (int i = 0; i <= steps; i++) {
    double fraction = i / steps;
    double latitude = start.latitude + fraction * (end.latitude - start.latitude);
    double longitude = start.longitude + fraction * (end.longitude - start.longitude);
    LatLng point = LatLng(latitude, longitude);
    path.add(point);
  }
  print("Generated Path: $path");
  return path;
}









  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; 
    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLng = _degreesToRadians(end.longitude - start.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) * cos(_degreesToRadians(end.latitude)) *
        sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; 
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _updatePolyline() {
    if (_selectedLatLng != null && _userLocationLatLng != null) {
      if (mounted) {
        setState(() {
          _markers.removeWhere((marker) => marker.markerId.value == 'polyline');
          _markers.add(Marker(
            markerId: MarkerId("polyline"),
            position: _selectedLatLng!,
            infoWindow: InfoWindow(title: 'Path'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));
        });
      }
    }
  }

  Future<void> _showLocationDialog() async {
    if (!_dialogShown) {
      _dialogShown = true;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location'),
            content: Text('Please select your location on the map'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Google Maps Screen'),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            MoveToBackground.moveTaskToBack();
            Navigator.pop(context); 
          },
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
          
          },
        ),
      ],
    ),
    body: WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
              _startBackgroundLocationService();
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(31.9454, 35.3026),
              zoom: 8.0,
            ),
            markers: _markers,
            onTap: (LatLng latLng) {
              setState(() {
                _selectedLatLng = latLng;
                _markers.removeWhere((marker) => marker.markerId.value == 'selected_location');
                _markers.add(Marker(
                  markerId: MarkerId("selected_location"),
                  position: latLng,
                  infoWindow: InfoWindow(title: 'Selected Location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                ));
              });
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _startMovingMarker,
              child: Icon(Icons.directions_run),


            ),
          ),
        ],
      ),
    ),
  );
}

}
