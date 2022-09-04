import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map2 extends StatefulWidget {

  double lat;
  double long;
  String name;
  String address;
  Map2({Key key,this.lat,this.long,this.name,this.address}) : super(key: key);
  @override
  State<Map2> createState() => _Map2State();
}
const List<MapTypes> types = const <MapTypes>[
  const MapTypes(title: 'Normal'),
  const MapTypes(title: 'Hybrid'),
  const MapTypes(title: 'Satellite'),
  const MapTypes(title: 'Terrain'),
];
class _Map2State extends State<Map2> {
  @override
  GoogleMapController _mapController;
  MapType _type = MapType.normal;
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  double lat,long;
  double pos1,pos2;
  bool _nightMode = false;
  @override
  void initState() {
    lat=widget.lat;
    long=widget.long ;
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  Set<Marker> _markers={};
  BitmapDescriptor mapMarker;
  ///Change the Type of the map on selection
  void _select(MapTypes types) {
    // Causes the app to rebuild with the selected choice.
    setState(() {
      if (types.title == "Normal") {
        _type = MapType.normal;
      } else if (types.title == "Hybrid") {
        _type = MapType.hybrid;
      } else if (types.title == "Satellite") {
        _type = MapType.satellite;
      } else if (types.title == "Terrain") {
        _type = MapType.terrain;
      }
    });
  }

  ///Callback when map created
  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }
  void _onMapCreated(GoogleMapController controller){
    setState(() {
      _markers.add(
          Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(lat,long),
            icon:mapMarker,
            infoWindow: InfoWindow(
              title: '${widget.name}',
              snippet: '${widget.address}',

            ),
          )
      );
      // _markers.add(newyork1Marker);
      //_markers.add(newyork2Marker);
      // _markers.add(newyork3Marker);

    });
  }
  ///Get the night view json data for the night view.
  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: CustomFabLoc(),
       /* floatingActionButton: FloatingActionButton.extended(
          onPressed:() async{
            Fluttertoast.showToast(
              msg: "Unsuccessfull",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          },
          label: Text('lo'),
          icon: Icon(Icons.location_on),
        ),*/
      /*  drawer: Drawer(
          child: mapDrawer(),
        ),*/
        appBar: AppBar(
          title: const Text('Google Maps'),
          backgroundColor: Colors.lightGreen,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                _nightMode ? Icons.brightness_3 : Icons.brightness_5,
              ),
              onPressed: () => _nightModeToggle(),
            ),
            PopupMenuButton<MapTypes>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return types.map((MapTypes types) {
                  return PopupMenuItem<MapTypes>(
                    value: types,
                    child: Text(types.title),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
                initialCameraPosition:CameraPosition(
                  target:LatLng(lat,long),
                  zoom:15,),
                onMapCreated: _onMapCreated,
                mapType: _type,
                circles: Set<Circle>.of(circles.values),
                myLocationEnabled: true,
                polylines: Set<Polyline>.of(polyLines.values),
                markers:
                _markers
            ),
          ],
        )
    );
  }

  ///Toggles to night mode and back to day mode
  void _nightModeToggle() {
    Fluttertoast.showToast(
      msg: "Unsuccessfull",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    if (_nightMode) {
      setState(() {
        _nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData('asset/night_mode.json').then((style) {
        setState(() {
          _nightMode = true;
          _mapController.setMapStyle(style);
        });
      });
    }
  }

  ///Drawer list view
  mapDrawer() {
    return ListView(
      children: <Widget>[
        _createDrawerListTile("Add Marker", addMarker),
        _createDrawerListTile("Add Circle", addCircle),
        _createDrawerListTile("Add Polyline", addPolyline),
      ],
    );
  }

  //Create a Drawer widget list tile
  _createDrawerListTile(String listTitle, VoidCallback callback) {
    return ListTile(
      title: Text(listTitle),
      onTap: callback,
    );
  }

  ///Drop marker at the Ahmadabad
  void addMarker() {
    if (markers.isNotEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final Marker marker = Marker(
      markerId: MarkerId("1"),
      position: LatLng(5.9410,80.5638),
      infoWindow: InfoWindow(title: "Marker", snippet: 'Eliyakanda'),
      onTap: () {
        _onMarkerTapped(MarkerId("1"));
      },
    );
    setState(() {
      markers[MarkerId("1")] = marker;
      markers[MarkerId("2")] = marker;
    });
    Navigator.of(context).pop();
  }

  ///Draw circle at the Ahmadabad
  void addCircle() {
    if (circles.isNotEmpty) {
      Navigator.of(context).pop();
      return;
    }
    final Circle circle = Circle(
      circleId: CircleId("1"),
      consumeTapEvents: true,
      strokeColor: Colors.blueAccent.withOpacity(0.5),
      fillColor: Colors.lightBlue.withOpacity(0.5),
      center: LatLng(23.0225, 72.5714),
      strokeWidth: 5,
      radius: 5000,
      onTap: () {},
    );

    setState(() {
      circles[CircleId("1")] = circle;
    });

    Navigator.of(context).pop();
  }

  void addPolyline() {
    if (polyLines.isNotEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final Polyline polyline = Polyline(
      polylineId: PolylineId("1"),
      consumeTapEvents: true,
      color: Colors.blueAccent,
      width: 5,
      points: [
        LatLng(23.0225, 72.5714),
        LatLng(22.3072, 73.1812),
        LatLng(21.1702, 72.8311),
      ],
      onTap: () {
        _onPolylineTapped(PolylineId("1"));
      },
    );

    setState(() {
      polyLines[PolylineId("1")] = polyline;
    });

    Navigator.of(context).pop();
  }

  void _onMarkerTapped(MarkerId markerId) {
    print("Marker $markerId Tapped!");
  }

  void _onPolylineTapped(PolylineId polylineId) {
    print("Polyline $polylineId Tapped!");
  }
}

class MapTypes {
  const MapTypes({this.title});

  final String title;
}
