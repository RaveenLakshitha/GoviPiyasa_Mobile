import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'mymodel.dart';

class MapActivity extends StatefulWidget {
  const MapActivity({Key key}) : super(key: key);

  @override
  State<MapActivity> createState() => _MapActivityState();
}

class _MapActivityState extends State<MapActivity> {
  Future<List<Location>> getLocations() async {
    try {
      var url = 'http://10.0.2.2/Track_App/locations.php';
      final resp = await http.get(url);
      final responsebody = jsonDecode(resp.body);
      return responsebody; //this return a list
    } catch (e) {
      return [];
    }
  }

  List<Marker> allMarkers = [];

  loadLocations() async {
    List<Location> locations;
    locations = [];
    locations = await getLocations();
    for (var i = 0; i < locations.length; i++) {
      LatLng latlng;
      latlng = LatLng(
        double.parse(locations[i].locX),
        double.parse(locations[i].locY),
      );
      allMarkers.add(
        Marker(
          markerId: MarkerId(locations[i].locId.toString()),
          position: latlng,
        ),
      );
    }
    setState(() {});
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLocations();
 /*   Marker marker = Marker();
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{


    };
    setState(() {
      markers[markerId] = marker;
    });
*/
  }



  @override
  Widget build(BuildContext context) {



    return GoogleMap(
      // onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(-33.852, 151.211),
        zoom: 11.0,
      ),
    /*  markers: Set<Marker>.of(markers.values),*/
    );
  }
}
