
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
class googlemap extends StatefulWidget {

  double lat;
  double long;
  googlemap({Key key,this.lat,this.long}) : super(key: key);
  @override
  _googlemapState createState() => _googlemapState();
}

class _googlemapState extends State<googlemap> {
  Set<Marker> _markers={};
  BitmapDescriptor mapMarker;
  GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};
  double lat,long;
  double pos1,pos2;

  void initState(){
    fetchPosts();
    super.initState();

    setCustomMarker();
    lat=widget.lat;
    long=widget.long ;

  }

  Completer<GoogleMapController> _controller = Completer();

  void setCustomMarker() async{
    mapMarker= await BitmapDescriptor.fromAssetImage(ImageConfiguration(),'assets/placeholder.png');
  }


  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/";
  var _shopjson = [];
  FlutterSecureStorage storage = FlutterSecureStorage();
  void fetchPosts() async {
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
       print(_shopjson[1]['location']['coordinates'][0]);
    } catch (err) {}
  }

  void _onMapCreated(GoogleMapController controller){
    setState(() {

      for(int i=0;i<_shopjson.length;i++){
        _markers.add(
            Marker(
              markerId: MarkerId('id-1'),
              position: LatLng( _shopjson[i]['location']['coordinates'][0],_shopjson[i]['location']['coordinates'][1]),
              icon:BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet,
              ),

              infoWindow: InfoWindow(
                title: '${_shopjson[i]['shopName']}',
                snippet: 'history',

              ),
            )
        );
      }


      _markers.add(
          Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(lat,long),
            icon:mapMarker,
            infoWindow: InfoWindow(
              title: 'colombo',
              snippet: 'history',

            ),
          )
      );
      // _markers.add(newyork1Marker);
      //_markers.add(newyork2Marker);
      // _markers.add(newyork3Marker);

    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        // title: Text('${pos1}   ${pos2}'),
        actions: [
          /*  IconButton(
              icon: Icon(FontAwesomeIcons.plus),
              onPressed: () async {
                print("hello");
                Position position = await _determinePosition();
                googleMapController
                    .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));
                _markers.clear();
                _markers.add(Marker(markerId:  MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

                setState(() {});
              }),*/

        ],
      ),
      body:_shopjson==null?SizedBox(child: Center(child:CircularProgressIndicator()),):Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition:CameraPosition(
              target:LatLng(lat,long),
              zoom:15,),
          /*  markers:
            _markers,*/
          ),

          _buildGoogleMap(context),

          _buildContainer(),

        ],
      ),



    );
  }
  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition:  CameraPosition(target: LatLng(lat, 	long), zoom: 10),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers:
          _markers

      ),
    );
  }
  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 150.0,
        child:ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _shopjson.length,
            itemBuilder: (BuildContext context, int index){

              final shop=_shopjson[index];

              if(_shopjson[index]['location']['coordinates']!=null){
                for (var i = 0; i < _shopjson.length; i++){
                  /*  setState(() {

              });*/
                  _markers.add(
                      Marker(
                        markerId: MarkerId('id-1'),
                        position: LatLng( shop['location']['coordinates'][1],shop['location']['coordinates'][0]),
                        icon:BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueViolet,
                        ),

                        infoWindow: InfoWindow(
                          title: '${shop['shopName']}',
                          snippet: 'history',

                        ),
                      )
                  );
                }

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: _boxes(
                      "https://source.unsplash.com/random?sig=$index",
                      shop['location']['coordinates'][0],shop['location']['coordinates'][1],"${shop['shopName']}","${shop['email']}","${shop['address']}"),
                );
              }else{
                return SizedBox.shrink();
              }

            }

        ),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName,String email,String address) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(restaurantName,
                style: TextStyle(
                    color: Color(0xff6200ee),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              )),
        ),
        SizedBox(height:5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      "4.1",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    FontAwesomeIcons.solidStarHalf,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                    child: Text(
                      email,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
              ],
            )),
        SizedBox(height:5.0),
        Container(
            child: Text(
              address,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
        SizedBox(height:5.0),
        Container(
            child: Text(
              "Closed \u00B7 Opens 17:00 Thu",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
  Future<void> _gotoLocation(double lat,double long) async {
    setState(() {
      this.pos1=lat;
      this.pos2=long;
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 10,tilt: 50.0,
      bearing: 45.0,)));
  }
  Widget _boxes(String _image, double lat,double long,String restaurantName,String email,String address) {
    return  GestureDetector(
      onTap: () {
        _gotoLocation(lat,long);
      },
      child:Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName,email,address),
                    ),
                  ),

                ],)
          ),
        ),
      ),
    );
  }

}
class CustomFabLoc extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      scaffoldGeometry.scaffoldSize.width * .02, ///customize here
      scaffoldGeometry.scaffoldSize.height - 720,
    );
  }
}

Marker newyork1Marker = Marker(
  markerId: MarkerId('Eliyakanda'),
  position: LatLng(5.9410021,80.5638167),
  infoWindow: InfoWindow(title: 'Eliyakanda'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker newyork2Marker = Marker(
  markerId: MarkerId('Ja-ela'),
  position: LatLng(7.0766391, 79.8771548),
  infoWindow: InfoWindow(title: 'Ja-ela'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker newyork3Marker = Marker(
  markerId: MarkerId('Kandy'),
  position: LatLng(7.2946291,80.5907617),
  infoWindow: InfoWindow(title: "Kandy", snippet: 'Kandy'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
