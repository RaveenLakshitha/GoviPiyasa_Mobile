import 'package:blogapp/Notification/local_notifications.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Screen/HomeScreen.dart';
import 'package:blogapp/shop/Chart.dart';
import 'package:blogapp/shop/ReaqustAds.dart';
import 'package:blogapp/shop/additem.dart';
import 'package:blogapp/shop/itemservice.dart';
import 'package:blogapp/shop/services.dart';
import 'package:blogapp/shop/shoprofile.dart';
import 'package:blogapp/shop/updateitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Architectdashboard extends StatefulWidget {
//  final Album cases;
  _ArchitectdashboardState createState() => _ArchitectdashboardState();
}

class _ArchitectdashboardState extends State<Architectdashboard> {
  final Itemservice api = Itemservice();
  final storage = FlutterSecureStorage();

  List<Widget> widgets = [Showitem(), Chart(), Ads()];

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
    String city = "Ja-ela";
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
          "My Architecture Profile",
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

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'MyShop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Ads',
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddItem()));
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
