
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/shop/Chart.dart';
import 'package:blogapp/shop/Editshop.dart';
import 'package:blogapp/shop/itemservice.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Editexpertprofile.dart';
import 'expertprofile.dart';


class Expertdashboard extends StatefulWidget {
//  final Album cases;
  _ExpertdashboardState createState() => _ExpertdashboardState();
}

class _ExpertdashboardState extends State<Expertdashboard> {
  final Itemservice api = Itemservice();
  final storage = FlutterSecureStorage();

  List<Widget> widgets = [expertprofile(), Chart(),Editshop()];

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];
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
          "My Expert Profile ",
          style: TextStyle(
              color: Colors.white, fontSize: 30.0, fontFamily: 'Indies'),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Answerd Question',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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
}
