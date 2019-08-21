import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(22.734095, 120.283738);
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('請選擇地點'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        // mapType: MapType.satellite,
        rotateGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 13.0,
        ),
      ),
    );
  }
}

// void _add() {
//     var markerIdVal = MyWayToGenerateId();
//     final MarkerId markerId = MarkerId(markerIdVal);

//     // creating a new MARKER
//     final Marker marker = Marker(
//       markerId: markerId,
//       position: LatLng(
//         center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
//         center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
//       ),
//       infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
//       onTap: () {
//         _onMarkerTapped(markerId);
//       },
//     );

//     setState(() {
//       // adding a new marker to map
//       markers[markerId] = marker;
//     });
// }
