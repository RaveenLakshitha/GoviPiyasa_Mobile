
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/shop/ShopProfile/Chart.dart';
import 'package:blogapp/shop/ShopProfile/Editshop.dart';
import 'package:blogapp/shop/itemservice.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Editexpertprofile.dart';
import 'ExpertAppointmentSlots.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(_selectedIndex);
  }

  void initState() {
    super.initState();
  }
  final screens=[

    ExpertAppointmentslot(),
    expertprofile(),
    Editexpert(),
  ];
  int index=1;
  final navigationKey=GlobalKey<CurvedNavigationBarState>();

  @override
  Widget build(BuildContext context) {
    final items=<Widget>[
      Icon(Icons.search,size:30),
      Icon(Icons.home,size:30),
      Icon(Icons.person,size:30),

    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.black,),
            onPressed: () {Navigator.pop(context);
            }),
        title: Text(
          "My Expert Profile ",
          style: TextStyle(
              color: Colors.black, fontSize: 30.0, fontFamily: 'Indies'),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      bottomNavigationBar:Theme(
        data:Theme.of(context).copyWith(
          iconTheme:IconThemeData(color:Colors.black),

      ) ,
      child:CurvedNavigationBar(
        key:navigationKey,
        height: 60,
        color:Colors.white70,
        buttonBackgroundColor: Colors.purple,
        backgroundColor: Colors.white,
        items:items,
        index:index,
        onTap: (index)=>setState(()=>this.index=index),


      ),),
      //AssetImage("assets/architect.jpg")
      body: screens[index],
    );
  }
}
