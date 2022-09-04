import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blogapp/Architectureprofile/projects.dart';
import 'package:blogapp/Architectureprofile/screens/ArchitectureProjects.dart';
import 'package:blogapp/Architectureprofile/services.dart';

import 'package:blogapp/shop/itemservice.dart';

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

  List<Widget> widgets = [Architectprofile(), Appointmentslot(), Projects()];

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
                fontFamily: 'Roboto',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF545D68))
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.plus,size: 20,),
              onPressed: () {
                showPopUp(context);
              }),

          IconButton(
              icon: Icon(Icons.integration_instructions,size: 20,),
              onPressed: () {
                getData();
                showPolicy(context);
              }),
          SizedBox.fromSize(
            size: Size(60, 60), // button width and height
            child: ClipRect(
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.green, // splash color
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Service()));
                  }, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.ac_unit_rounded), // icon
                      Text("Services"), // text
                    ],
                  ),
                ),
              ),
            ),
          )

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
