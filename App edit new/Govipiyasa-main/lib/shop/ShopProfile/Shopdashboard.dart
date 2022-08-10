import 'package:blogapp/Notification/local_notifications.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Screen/HomeScreen.dart';
import 'package:blogapp/shop/services.dart';
import 'package:blogapp/shop/ShopProfile/shoprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shopChart.dart';
import 'Chart.dart';
import 'ReaqustAds.dart';
import 'additem.dart';
import '../item.dart';
import '../itemservice.dart';

class Shopdashboard extends StatefulWidget {
  _ShopdashboardState createState() => _ShopdashboardState();
}

class _ShopdashboardState extends State<Shopdashboard> {
  final Itemservice api = Itemservice();
  final storage = FlutterSecureStorage();

  List<Widget> widgets = [Showitem(), Chart(), Ads()];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(_selectedIndex);
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            }),
        title: Text(
          "My Shop",
          style: TextStyle(
              color: Colors.white, fontSize: 30.0, fontFamily: 'Indies'),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.plus),
              onPressed: () {
                showPopUp(context);
              }),
          IconButton(
              icon: Icon(FontAwesomeIcons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Charts(),
                    ));
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'MyShop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.addchart_sharp),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Advertistment',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
      //AssetImage("assets/architect.jpg")
      body: widgets[_selectedIndex],
    );
  }

  showPopUp(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItem(),
                  ));
            },
            child: ListTile(
              title: Text('Add equipment'),
              leading: CircleAvatar(
                  child: Image.network(
                "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                fit: BoxFit.scaleDown,
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddItem()));
            },
            child: ListTile(
              title: Text('Add items'),
              leading: CircleAvatar(
                  child: Image.network(
                "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                fit: BoxFit.scaleDown,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
