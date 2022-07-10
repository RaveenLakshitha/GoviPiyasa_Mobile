import 'package:blogapp/shop/Chart.dart';
import 'package:blogapp/shop/item.dart';
import 'package:blogapp/shop/table/main.dart';
import 'package:blogapp/shop/vieworders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ReaqustAds.dart';

class Service extends StatefulWidget {
  const Service({Key key}) : super(key: key);

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        flexibleSpace: Image(
          image: NetworkImage('https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
          fit: BoxFit.cover,
          height: 150.0,
        ),


      ),
      body:GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("view Order"),
                  Icon(Icons.description_outlined,color: Colors.pink,
                    size: 50.0,),
                ],),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewOrder(),
                  ));
            },
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Tables"),
                Icon(Icons.dvr_rounded , color: Colors.pink,
                  size: 50.0,),
              ],),

            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ));
            },
          ),
          GestureDetector(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("view Order"),
                  Icon(Icons.developer_board_rounded , color: Colors.pink,
                    size: 50.0,),
                ],),

              padding: const EdgeInsets.all(8),
              color: Colors.teal[300],

            ), onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chart(),
                ));
          },
          ),
          GestureDetector(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Charts"),
                  Icon(Icons.add_chart_sharp ,     color: Colors.pink,
                    size: 50.0,),
                ],),
              padding: const EdgeInsets.all(8),
              color: Colors.teal[400],

            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chart(),
                  ));
            },
          ),
          GestureDetector(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("view Order"),
                  Icon(Icons.assignment_rounded ,   color: Colors.pink,
                    size: 50.0,),
                ],),
              padding: const EdgeInsets.all(8),
              color: Colors.teal[500],
            ),
            onTap: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormPage(),
                  ));
            },
          ),

          GestureDetector(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Request Ads"),
                  Icon(Icons.ballot_sharp ,
                    color: Colors.pink,
                    size: 50.0,
                  )
                ],),
              padding: const EdgeInsets.all(8),
              color: Colors.teal[600],

            ),
            onTap: () {

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ads(),
                  ));

            },
          )

        ],
      ),
    );

  }
}
