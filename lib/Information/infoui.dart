import 'package:blogapp/Information/weather.dart';
import 'package:blogapp/shop/Chart.dart';
import 'package:blogapp/shop/item.dart';
import 'package:blogapp/shop/table/main.dart';
import 'package:blogapp/shop/vieworders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'news.dart';

class Categorylist extends StatefulWidget {
  const Categorylist({Key key}) : super(key: key);

  @override
  State<Categorylist> createState() => _CategorylistState();
}

class _CategorylistState extends State<Categorylist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        flexibleSpace: Image(
          image: NetworkImage(
              'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
          fit: BoxFit.cover,

        ),
      ),
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/.png"),
            fit: BoxFit.cover,
          ),
        ),
        child:GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          GestureDetector(
            child: Card(
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/flowers2.png'))),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Rose',
                      style: TextStyle(
                        fontFamily: 'Indies',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    )),
              ),
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Weather(),
                  ));
            },
          ),
          GestureDetector(
            child: Card(
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/fertilizer.jpg'))),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Fertilizer',
                      style: TextStyle(
                        fontFamily: 'Indies',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    )),
              ),
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
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
            child: Card(
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/plants1.jpg'))),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Plants',
                      style: TextStyle(
                        fontFamily: 'Indies',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    )),
              ),
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
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
            child: Card(
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/flowers3.jpg'))),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Rose',
                      style: TextStyle(
                        fontFamily: 'Indies',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    )),
              ),
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormPage(),
                  ));
            },
          ),




        ],
      ),)
    );
  }
}
