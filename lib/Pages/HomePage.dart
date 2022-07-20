import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:blogapp/Architectureprofile/ArchitectDashboard.dart';
import 'package:blogapp/Cart/main.dart';
import 'package:blogapp/Expertprofile/Expertdashboard.dart';
import 'package:blogapp/Language/translator.dart';
import 'package:blogapp/Notification/destination_screen.dart';
import 'package:blogapp/Notification/notify.dart';
import 'package:blogapp/Pages/WelcomePage.dart';
import 'package:blogapp/Profile/ProfileScreen1.dart';
import 'package:blogapp/Screen/Maps/Map.dart';
import 'package:blogapp/Screen/Maps/MapActivity.dart';
import 'package:blogapp/Screen/Navbar/About.dart';
import 'package:blogapp/Screen/Navbar/Delivery.dart';
import 'package:blogapp/Screen/HomeScreen.dart';
import 'package:blogapp/Screen/Navbar/Architectlist.dart';
import 'package:blogapp/Screen/Services/Settings.dart';
import 'package:blogapp/Screen/Navbar/feedback.dart';
import 'package:blogapp/Screen/Navbar/expertlist.dart';
import 'package:blogapp/Search/HomeScreen.dart';
import 'package:blogapp/architecture/widget_screen.dart';
import 'package:blogapp/shop/Shopdashboard.dart';
import 'package:blogapp/shop/shoprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:showcaseview/showcase_widget.dart';

import '../Imagelabel.dart';
import 'bg_drawer.dart';

//import 'package:blogapp/onesignal_flutter/onesignal_flutter.dart';
class HomePage extends StatefulWidget {
  HomePage({Key key, this.value}) : super(key: key);
  String value;

  @override
  _HomePageState createState() => _HomePageState(value);
}

class _HomePageState extends State<HomePage> {
/*
static final String oneSignalAppId="7a1f4b11-b687-479e-84b1-35d8ac53978f";
Future<void> initPlateformState() async{
  OneSignal.shared.setAppId(oneSignalAppId);
}*/
  final keyOne = GlobalKey();
  final keyTwo = GlobalKey();
  final keyThree = GlobalKey();
  final keyFour = GlobalKey();
  int currentState = 0;

  List<Widget> widgets = [HomeScreen(), ProfilePage()];
  List<String> titleString = ["Home Page", "Profile Page"];
  bool approval=false;
  bool approval2=false;
  bool approval3=false;
  final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  var username1="";
  int _counter;
  int _counter1 = 0;
  String visibility;
  String value;
  var jsonData;
  var _postsJson;
  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(50),
    ),
  );

  _HomePageState(this.value);
  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
    });
    print(_counter);
  }

  void fetchPosts() async {
    print('bye');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/getUsersShop'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');

      print(' SHOW : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _postsJson = jsonData;
        visibility = _postsJson['shopVisibility'].toString();
      });
      if(visibility=="Active"){
        print("active");
        if(_counter<3){

          showSimpleNotification();

        }
        approval=true;
      }else{
        approval=false;
        print("not active");
      }

    } catch (err) {}
  }
  void _increment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('counter', _counter1);
    });
    print(_counter1);
  }
   Future  readuser() async {
    username1 = await storage.read(key: "id");
    print(username1);
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    loadCounter();

    requestPermissions();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon'); // <- default icon name is @mipmap/ic_launcher
    //var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var iOSSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onClickNotification);
    fetchPosts();
    readuser();
    super.initState();

    // checkProfile();
    /* WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([
        keyOne,
        keyThree,
        keyFour,
        keyTwo,
      ]),
    );*/
  }
  void requestPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future onClickNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return DestinationScreen(
        payload: payload,
      );
    }));
  }

  showSimpleNotification() async {
    var androidDetails = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOSDetails = IOSNotificationDetails();
    var platformDetails = new NotificationDetails(androidDetails, iOSDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Shop Activation Process', 'Shop Activated',
        platformDetails, payload: 'Destination Screen (Simple Notification)');
  }

  bool isloading=false;
  Widget _NotificationBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        _counter.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(icon: Icon(Icons.notifications), onPressed: () {
        _increment();
        loadCounter();
        Navigator.push(context,
          MaterialPageRoute(
            builder: (_) => Notify(),
          ),
        );
      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    String _message;

    DateTime now = DateTime.now();
    String _currentHour = DateFormat('kk').format(now);
    int hour = int.parse(_currentHour);

    setState(
      () {
        if (hour >= 5 && hour < 12) {
          _message = 'Good Morning';
        } else if (hour >= 12 && hour <= 17) {
          _message = 'Good Afternoon';
        } else {
          _message = 'Good Evening';
        }
      },
    );
    return Scaffold(
      drawer: Drawer(
          child: CustomPaint(
        painter: BackgroundDrawer(),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/3.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),

                  Text(
                    "Govipiyasa",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("Feedback"),
              trailing: Icon(Icons.feedback, color: Colors.green),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ReachUs()));
              },
            ),
            ListTile(
              title: Text("Designers"),
              trailing: Icon(Icons.assistant_rounded, color: Colors.green),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => expert()));
              },
            ),
            ListTile(
              title: Text("Expertlist"),
              trailing: Icon(Icons.lightbulb_rounded, color: Colors.green),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SellerList()));
              },
            ),
            ListTile(
              title: Text("About"),
              trailing: Icon(Icons.assignment_sharp, color: Colors.green),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => About()));
              },
            ),
            Divider(),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new, color: Colors.green),
              onTap: logout,
            ),
          ],
        ),
      )),
      appBar: AppBar(
        //backgroundColor: Colors.white,
        elevation: 5,
        //centerTitle: true,
        title: Text(_message,
            style: TextStyle(
                fontFamily: 'Roboto',fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black)),
      /*  flexibleSpace: Image(
          image: AssetImage('assets/about.jpg'),
          fit: BoxFit.cover,
        ),*/
        actions: <Widget>[
          /* Showcase(key:keyOne,
            showcaseBackgroundColor: Colors.lightBlue,
            contentPadding: EdgeInsets.all(12),
            descTextStyle: TextStyle(
              color:Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            child:  IconButton(
            icon:Icon(Icons.notifications),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => Messaging_Widge(),
              //   ),
              // );
            },),
             description:'Tap to see menu options',),*/
          _NotificationBadge(),
      /*    IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Notify(),
                  ),
                );
              }),*/
          PopupMenuButton<int>(

            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.apps_rounded, color: Colors.blue),
                    Text("Services"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.api_sharp, color: Colors.blue),
                    Text("Settings"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.art_track_outlined, color: Colors.blue),
                    Text("Search Products"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.article_sharp, color: Colors.blue),
                    Text("Create architecture Profile"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.app_registration_sharp, color: Colors.blue),
                    Text("Language"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 5,
                child: Row(
                  children: [
                    Icon(Icons.add_location_rounded, color: Colors.blue),
                    Text("Map"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          showPopUp(context);
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 40),
        ),
      ),
      bottomNavigationBar:BottomAppBar(
        elevation: 10,
       // color: Colors.lightGreen,
        shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: currentState == 0 ? Colors.black : Colors.black12,
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: currentState == 1 ? Colors.black12 : Colors.black,
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),
      body: widgets[currentState],
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => WidgetScreen()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Settings()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Searchitems()));
        break;
      case 3:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Imagelabel()));
        break;
      case 4:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>CartNew()));
        break;
      case 5:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>  googlemap(lat:7.0766391,long:79.8771548)));
        break;
    }
  }

  void logout() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (route) => false);
  }

  showPopUp(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select Your Account'),
        actions: <Widget>[
          GestureDetector(
            onTap: () async{

             Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>Architectdashboard()));
             },
            child: Visibility(
              child: ListTile(
                title: Text('Architecture Profile'),
                leading: CircleAvatar(
                    child: Image.network(
                  "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                  fit: BoxFit.scaleDown,
                )),
              ),
              visible: approval2,
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Shopdashboard()));
              },
              child: Visibility(
                child: ListTile(
                  title: Text('Shop Profile'),
                  leading: CircleAvatar(
                      child: Image.network(
                    "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                    fit: BoxFit.scaleDown,
                  )),
                ),
                visible: approval,
              )),
          GestureDetector(
            onTap: () async{
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Expertdashboard()));
              },
            child: Visibility(
              child: ListTile(
                title: Text('Expert Profile'),
                leading: CircleAvatar(
                    child: Image.network(
                      "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                      fit: BoxFit.scaleDown,
                    )),
              ),
              visible: approval3,
            ),
          ),
        ],
      ),
    );
  }
}
