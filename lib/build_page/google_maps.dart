import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import './build_page.dart';

const kGoogleApiKey = "AIzaSyANlj9bRiKl_KlQ3E2MBCfReY2Pdf-5BSg";

String _address = "";
String _locatesArea = '';
String _locatesLocal = '';
Position _userPosition;
Future<Position> getLocation() async {
  // GeolocationStatus geolocationStatus =
  //     await Geolocator().checkGeolocationPermissionStatus();
  _userPosition = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return _userPosition;
}

LatLng _center = LatLng(22.734095, 120.283738);

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

// 地圖頁面
class GoogleMaps extends StatefulWidget {
  GoogleMaps(this.userId);
  final String userId;

  @override
  _GoogleMapsState createState() => _GoogleMapsState(userId);
}

class _GoogleMapsState extends State<GoogleMaps> {
  _GoogleMapsState(this.userId);
  final String userId;
  final Set<Marker> _markers = {};
  String searchAddr;
  List _result = [];
  String _title = "";
  List _placeName = [];
  Position _location;
  bool _addressPick = false;
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    setState(() {
      mapController = controller;
    });
  }

  _dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('請選擇地址'),
      //   backgroundColor: Colors.green[700],
      // ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            // mapType: MapType.satellite,
            onTap: _mapTapped,
            rotateGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            child: new BackButton(
              color: Colors.black54,
            ),
          ),
          Positioned(
            top: 40.0,
            right: 15.0,
            left: 70.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: TextField(
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(
                    hintText: '搜尋',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          this._dismissKeyboard(context);
                          searchandNavigate();
                        },
                        iconSize: 30.0)),
                onChanged: (val) async {
                  // Prediction p = await PlacesAutocomplete.show(
                  //   context: context,
                  //   apiKey: kGoogleApiKey,
                  // );
                  // print(p);
                  setState(() {
                    searchAddr = val;
                  });
                },
              ),
            ),
          ),
          Positioned(
            top: 100.0,
            right: 15.0,
            child: IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () async {
                getLocation();
                if (_userPosition != null) {
                  Coordinates coordinates = new Coordinates(
                      _userPosition.latitude, _userPosition.longitude);
                  _placeName = await Geocoder.local
                      .findAddressesFromCoordinates(coordinates);
                  setState(() {
                    Geolocator()
                        .placemarkFromCoordinates(
                            _userPosition.latitude, _userPosition.longitude)
                        .then((result) {
                      _locatesArea = result[0].administrativeArea;
                      _locatesLocal = result[0].locality;
                    });
                    _markers.clear();
                    _markers.add(Marker(
                      markerId: MarkerId(_markers.toString()),
                      position: LatLng(
                          _userPosition.latitude, _userPosition.longitude),
                      infoWindow: InfoWindow(
                        title: "你的位置",
                        snippet: _placeName.first.addressLine,
                      ),
                      icon: BitmapDescriptor.defaultMarker,
                    ));
                    mapController.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            tilt: 50.0,
                            bearing: 45.0,
                            target: LatLng(_userPosition.latitude,
                                _userPosition.longitude),
                            zoom: 17.0)));
                    _title = "你的地點";
                    _center =
                        LatLng(_userPosition.latitude, _userPosition.longitude);
                    _address = _placeName.first.addressLine;
                    _addressPick = true;
                  });
                }
              },
            ),
          ),
          Positioned(
            bottom: 30.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 113,
              child: new ListView.builder(
                scrollDirection: Axis.horizontal,
                // itemCount: _result.length,
                itemCount: _addressPick == false ? 0 : 1,
                itemBuilder: (context, rownumber) {
                  return new Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      // constraints: BoxConstraints(maxWidth: 500),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(_title),
                          new Text(_address),
                          new FlatButton(
                            child: Text(
                              "確認地址",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BuildActivity(
                                          address: _address,
                                          userId: userId,
                                          center: _center,
                                          locateArea: _locatesArea,
                                          locateLocal: _locatesLocal,
                                        )),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //地圖頁面_點擊地圖
  _mapTapped(LatLng location) async {
    _markers.clear();
    Coordinates coordinates =
        new Coordinates(location.latitude, location.longitude);
    _placeName = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Geolocator()
        .placemarkFromCoordinates(location.latitude, location.longitude)
        .then((result) {
      setState(() {
        _locatesArea = result[0].administrativeArea;
        _locatesLocal = result[0].locality;
      });
    });
    print(location);
    setState(() {
      _title = "你所點擊的地點";
      _center = location;
      _address = _placeName.first.addressLine;
      _addressPick = true;
      _result.clear();
      _markers.add(Marker(
        markerId: MarkerId(_markers.toString()),
        position: location,
        infoWindow: InfoWindow(
          title: "你所點擊的地點",
          snippet: _address,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  // 地圖頁面_搜尋地點
  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          tilt: 50.0,
          bearing: 45.0,
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 17.0)));
      setState(() async {
        _markers.clear();
        Coordinates coordinates = new Coordinates(
            result[0].position.latitude, result[0].position.longitude);
        _placeName =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        _locatesArea = result[0].administrativeArea;
        _locatesLocal = result[0].locality;
        _result = result;
        _location = result[0].position;
        _address = _placeName.first.addressLine;
        _title = searchAddr;
        _addressPick = true;
        _center =
            LatLng(result[0].position.latitude, result[0].position.longitude);
        print(_address);
        print(_location);
        _markers.add(Marker(
          markerId: MarkerId(_markers.toString()),
          position:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          infoWindow: InfoWindow(
            title: _title,
            snippet: _placeName.first.addressLine,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    });
  }
}

// 地圖小視窗+地址+地點補充
class MapWindow extends StatefulWidget {
  @override
  _MapWindowState createState() => _MapWindowState();
}

class _MapWindowState extends State<MapWindow> {
  // Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  String searchAddr;
  String _title = "選取的地址";
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    // _controller.complete(controller);
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 300,
          padding: EdgeInsets.all(10),
          child: Card(
            child: GoogleMap(
              // mapType: MapType.satellite,
              rotateGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              markers: {
                Marker(
                  markerId: MarkerId(_markers.toString()),
                  position: _center,
                  infoWindow: InfoWindow(
                    title: _title,
                    snippet: _address,
                  ),
                )
              },
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
