import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFreePickUpPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Free Pick Up Point'),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(32.2262, 35.2237),
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('freePickUpPoint'),
            position: LatLng(32.2262, 35.2237),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), 
            infoWindow: InfoWindow(
              title: 'Free Pick Up Point for Plantpat',
              snippet: 'Coordinates: (32.2262, 35.2237)',
            ),
          ),
        },
        mapType: MapType.normal,
      ),
    );
  }
}
