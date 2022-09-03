import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class MapMarkers extends StatefulWidget {
  @override
  _MapMarkersState createState() => _MapMarkersState();
}

class _MapMarkersState extends State<MapMarkers> {

  Completer<GoogleMapController> _controller = Completer();
  FlutterSecureStorage storage = FlutterSecureStorage();
  var _shopjson = [];
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/";
  void fetchPosts() async {
    print("shops");
    String token = await storage.read(key: "token");
    try {
      final response = await get(Uri.parse(url,),headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _shopjson = jsonData;
      });
      print(_shopjson);
      // print(_shopjson[1]['location']['coordinates'][0]);
    } catch (err) {}
  }

  Iterable markers = [];

  Iterable _markers = Iterable.generate(AppConstant.list.length, (index) {
    return Marker(
        markerId: MarkerId(AppConstant.list[index]['id']),
        position: LatLng(
          AppConstant.list[index]['lat'],
          AppConstant.list[index]['lon'],
        ),
        infoWindow: InfoWindow(title: AppConstant.list[index]["title"])
    );
  });



  @override
  void initState() {
    fetchPosts();
    setState(() {
      markers = _markers;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: LatLng(23.7985053,
              90.3842538), zoom: 13),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set.from(markers),
        ),
      ),
    );
  }
}

class AppConstant {

  static List<Map<String, dynamic>> list = [
    {"title": "one", "id": "1", "lat": 23.7985053, "lon": 90.3842538},
    {"title": "two", "id": "2", "lat": 23.802236, "lon": 90.3700},
    {"title": "three", "id": "3", "lat": 23.8061939, "lon": 90.3771193},
  ];
}