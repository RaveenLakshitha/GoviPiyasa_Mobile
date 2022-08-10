import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blogapp/Architectureprofile/screens/ArchitectureProjects.dart';
import 'package:blogapp/Architectureprofile/screens/product/products_screen.dart';
import 'package:blogapp/Notification/local_notifications.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Screen/HomeScreen.dart';
import 'package:blogapp/shop/ShopProfile/Chart.dart';
import 'package:blogapp/shop/ShopProfile/ReaqustAds.dart';
import 'package:blogapp/shop/ShopProfile/additem.dart';
import 'package:blogapp/shop/itemservice.dart';
import 'package:blogapp/shop/services.dart';
import 'package:blogapp/shop/ShopProfile/shoprofile.dart';
import 'package:blogapp/shop/ShopProfile/updateitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'AppointmentSlot.dart';
import 'Architectprofile.dart';
import 'addProjects.dart';


class Architectdashboard extends StatefulWidget {
//  final Album cases;
  _ArchitectdashboardState createState() => _ArchitectdashboardState();
}

class _ArchitectdashboardState extends State<Architectdashboard> {
  final Itemservice api = Itemservice();
  final storage = FlutterSecureStorage();

  List<Widget> widgets = [Architectprofile(), Appointmentslot(), ArchitectProject()];

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

  String textFromField='Loading....';
  getData()async{
    String response;
    response =await rootBundle.loadString('assets/policy/policy.txt');
    setState(() {
      textFromField=response;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
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

          IconButton(
              icon: Icon(Icons.integration_instructions),
              onPressed: () {
                getData();
                showPolicy(context);
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
            label: 'Appointment slots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Projects',
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

  showPolicy(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: Text(textFromField),
        ),

      ),
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
                    builder: (context) => Addprojects(),
                  ));
            },
            child: ListTile(
              title: Text('Add Projects'),
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
  void alert(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: "Shop Deactivate",
      buttonsTextStyle: const TextStyle(color: Colors.black),
      showCloseIcon: false,
      btnOkOnPress: () {

      },
    ).show();
  }
}
