import 'package:blogapp/Notification/notification1.dart';
import 'package:blogapp/Screen/Services/shop.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map1 extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Map1> {
  String googleApikey = "AIzaSyDG9lYLOCWZ4cl_8UxWnhJYMYCl5W8xAdo";
  GoogleMapController mapController; //contrller for Google map
  CameraPosition cameraPosition;
  LatLng startLocation = LatLng(6.927079, 	79.861244);
  String location = "Location Name:";
  var latlang;
  var longitude;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Google Map Picker"),
          backgroundColor: Colors.lightGreen,
        ),
        body: Stack(
            children:[

              GoogleMap( //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                initialCameraPosition: CameraPosition( //innital position in map
                  target: startLocation, //initial position
                  zoom: 14.0, //initial zoom level
                ),
                mapType: MapType.normal, //map type
                onMapCreated: (controller) { //method called when map is created
                  setState(() {
                    mapController = controller;
                  });
                },
                onCameraMove: (CameraPosition cameraPositiona) {
                  cameraPosition = cameraPositiona; //when map is dragging
                },
                onCameraIdle: () async { //when map drag stops
                  List<Placemark> placemarks = await placemarkFromCoordinates(cameraPosition.target.latitude, cameraPosition.target.longitude);
                  setState(() {
                     latlang=cameraPosition.target.latitude;
                     longitude=cameraPosition.target.longitude;//get place name from lat and lang
                    location = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.street.toString();
                  });
                },
              ),

              Center( //picker image on google map
                child: Image.asset("assets/placeholder.png", width: 80,),
              ),


              Positioned(  //widget to display location name
                  bottom:100,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            leading: Image.asset("assets/placeholder.png", width: 25,),
                            title:Text(location, style: TextStyle(fontSize: 18),),
                            subtitle: Text("${longitude}  ${latlang}", style: TextStyle(fontSize: 18),),

                            dense: true,
                          )
                      ),
                    ),
                  )
              ),

            ]),
        floatingActionButton: new FloatingActionButton(
        elevation: 0.0,
        child: new Icon(Icons.check),
        backgroundColor: new Color(0xFFE57373),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Shop(location:location,latlang:latlang.toString()),
              ));
          //Navigator.pop(context);
        }
    )
    );
  }
}