
import 'dart:async';
import 'dart:convert';

import 'package:blogapp/shop/ShopProfile/shopview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import 'CurrentLocation.dart';
class NearShops extends StatefulWidget {


  NearShops({Key key}) : super(key: key);
  @override
  _NearShopsState createState() => _NearShopsState();
}

class _NearShopsState extends State<NearShops> {
  Set<Marker> _markers={};
  // Set<Marker> _markers = Set();
  // List <Marker> _markers=<Marker>[];
  BitmapDescriptor mapMarker;
  GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);
  Iterable markers = [];
  double lat,long;
  double pos1,pos2;

  void initState(){




    setState(() {
      markers = _markers;
    });

//}
    super.initState();

    setCustomMarker();


  }

  Completer<GoogleMapController> _controller = Completer();

  void setCustomMarker() async{
    mapMarker= await BitmapDescriptor.fromAssetImage(ImageConfiguration(),'assets/placeholder.png');
  }


  var _shopjson = [];


  FlutterSecureStorage storage = FlutterSecureStorage();
  fetchPosts() async {
    final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/radius/$lat/$long/30";

    print("{$lat$long}");
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



  void _onMapCreated(GoogleMapController controller){


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

    _markers.add(
        Marker(
          markerId: MarkerId('id-1'),
          position:LatLng( _shopjson[1]['location']['coordinates'][0],_shopjson[1]['location']['coordinates'][1]),
          icon:mapMarker,
          infoWindow: InfoWindow(
            title: 'colombo',
            snippet: 'history',

          ),
        )
    );


  }
  String location ='Null, Press Button';
  String Address = 'search';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(()  {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Near Shops'),
        actions: [
          IconButton(
              icon: Icon(Icons.location_on,color:Colors.lightGreen),
              onPressed: () async {

                fetchPosts();
                Position position = await _getGeoLocationPosition();
                location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                setState(() {
                  lat=position.latitude;
                  long=position.longitude;
                });
                GetAddressFromLatLong(position);
                showPopUp(context);

              }),


        ],
      ),
      body:_shopjson==null?SizedBox(child: Center(child:CircularProgressIndicator()),):Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            zoomGesturesEnabled: true,

            initialCameraPosition:CameraPosition(
              target:LatLng(7.2946291,80.5907617),
              zoom:8,),),
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
        initialCameraPosition:  CameraPosition(target: LatLng(7.2946291,80.5907617), zoom: 10),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.from(markers),



      ),
    );
  }
  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          height: 140.0,
          child: FutureBuilder(
              future: fetchPosts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child:ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _shopjson.length,
                        itemBuilder: (BuildContext context, int index){
                          //  print(index);
                          final shop=_shopjson[index];

                          if(_shopjson[index]['location']['coordinates']!=null){
                            for (var i = 0; i <2; i++){
                              print(index);


                              _markers.add(
                                  Marker(
                                    markerId: MarkerId('id-1'),
                                    position: LatLng( _shopjson[index]['location']['coordinates'][0],_shopjson[index]['location']['coordinates'][1]),
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
                                  shop['location']['coordinates'][0],shop['location']['coordinates'][1],"${shop['shopName']}","${shop['email']}","${shop['address']}","${shop['rating']}","${shop['contactNumber']}","${shop['_id']}"),
                            );
                          }else{
                            return SizedBox.shrink();
                          }

                        }

                    ),);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })

      ),
    );
  }


  Widget myDetailsContainer1(String restaurantName,String email,String address,String rating,String contactNumber,String id) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Shopview(
                          id: "${id}",),
                      ));
                },
                child: Text(restaurantName,
                  style: TextStyle(
                      color: Color(0xff6200ee),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ),
        SizedBox(height:5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      "${rating}",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
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
              "${contactNumber}",
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
  Widget _boxes(String _image, double lat,double long,String restaurantName,String email,String address,String rating,String contactNumber,String id) {
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
                      child: myDetailsContainer1(restaurantName,email,address,rating,contactNumber,id),
                    ),
                  ),

                ],)
          ),
        ),
      ),
    );
  }
  showPopUp(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        //title: const Text('Select Your Account'),
        actions: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text('Coordinates Points',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(location,style: TextStyle(color: Colors.black,fontSize: 16),),
                SizedBox(height: 10,),
                Text('ADDRESS',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                Text('${Address}'),
                SizedBox(height: 10,),
              ]
          )





        ],
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
