import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:badges/badges.dart';
import 'package:blogapp/Architectureprofile/ArchitectDashboard.dart';
import 'package:blogapp/BankCardDetails/CardList.dart';

import 'package:blogapp/Expertprofile/Expertdashboard.dart';
import 'package:blogapp/Language/translator.dart';
import 'package:blogapp/LoadingScreen/loading4.dart';
import 'package:blogapp/NewCart/CartScreenNew.dart';
import 'package:blogapp/Notification/destination_screen.dart';
import 'package:blogapp/Notification/notify.dart';
import 'package:blogapp/Pages/WelcomePage.dart';
import 'package:blogapp/Profile/ProfileScreen1.dart';
import 'package:blogapp/Screen/Maps/CurrentLocation.dart';
import 'package:blogapp/Screen/Maps/Map.dart';

import 'package:blogapp/Screen/HomeScreen.dart';
import 'package:blogapp/Screen/Maps/Nearshop.dart';
import 'package:blogapp/Screen/Navbar/aboutPage.dart';

import 'package:blogapp/Screen/Navbar/chatBot.dart';
import 'package:blogapp/Screen/Services/ExpertForm.dart';
import 'package:blogapp/Screen/Services/Settings.dart';
import 'package:blogapp/Screen/Navbar/feedback.dart';
import 'package:blogapp/Screen/Navbar/expertlist.dart';
import 'package:blogapp/Screen/Services/shop.dart';
import 'package:blogapp/Screen/Services/architecture.dart';
import 'package:blogapp/Wishlist/wishlist.dart';

import 'package:blogapp/architecture/widget_screen.dart';
import 'package:blogapp/checkout/mainpage.dart';
import 'package:blogapp/shop/ShopProfile/Shopdashboard.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../OrderPage.dart';
import '../usersAppointments.dart';
import 'bg_drawer.dart';

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
  int index=1;
  final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  final keyOne = GlobalKey();
  final keyTwo = GlobalKey();
  final keyThree = GlobalKey();
  final keyFour = GlobalKey();
  int currentState = 0;

  final screens=[Wishlist(), HomeScreen(),UserAppointment(),ProfilePage()];
 // List<String> titleString = ["Home Page", "Profile Page"];
  bool approval ;
  bool approval2 ;
  bool approval3 ;
  var username1 = "";
  int _counter;
  int _counter2;
  int _counter3;
  int _counter1 = 0;
  String visibility;
  String visibility2;
  String visibility3;
  String value;
  var jsonData;
  var _postsJson;
  var _architecture;
  var _expert;

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

  void fetchexpert() async {
    print('expert Working');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/experts/getUsersExpertProfile'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');
      print(' Expert : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _expert = jsonData;
        visibility3 = _expert['expertVisibility'].toString();
      });
      if (visibility3 == "Active") {
        print("active expert");
        if (_counter3 < 3) {
          showSimpleNotification(
              "Activated expert", "Not Activated expert profile");
        }
        setState(() {
          approval = true;
        });

      } else {
        setState(() {
          approval = false;
        });

        print("not active");
      }
    } catch (err) {}
  }
  final navigationKey=GlobalKey<CurvedNavigationBarState>();
  void fetchArchitect() async {
    print('Architect Working');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architects/getUsersArchitect'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');
      print(' SHOW : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _architecture = jsonData;
        visibility2 = _architecture['architectVisibility'].toString();
      });
      if (visibility2 == "Active") {
        print("active");
        if (_counter2 < 3) {
          showSimpleNotification(
              "Activated Architect", "Not Activated Architect profile");
        }
        setState(() {
          approval2 = true;
        });

      } else {
        setState(() {
          approval2 = false;
        });

        print("not active");
      }
    } catch (err) {}
  }
  void writeNotification() async{
    setState(() async{
      await storage.write(key: "notificationcount", value:_notificationcount.toString());
    });

    print(_notificationcount.toString());
  }
  void fetchShop() async {
    print('Shop Working');
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
      if (visibility == "Active") {
        print("active");
        if (_counter < 3) {
          showSimpleNotification("Activated shop", "Not Activated yet");
        }
        setState(() {
          approval3 = true;
        });

      } else {
        setState(() {
          approval3 = false;
        });

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

  Future readuser() async {
    username1 = await storage.read(key: "id");
    print(username1);
  }
  int _notificationcount=0;
  var _notification=[];

  void fetchPrivateNotification() async {
    print('fetchPrivateNotification');
    String token = await storage.read(key: "token");
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/notifications/getUsersNotifications'),  headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('Token : ${token}');

      print('Notification Data : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      print(jsonData);
      setState(() {
        _notification = jsonData;
        _notificationcount=_notification.length;
        //notification=_notification[0]['Title'];
      });
      print("Private Notification");
      print(_notification);
    } catch (err) {

    }


  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    loadCounter();
    writeNotification();
    fetchPrivateNotification();
    fetchShop();
    fetchArchitect();
    fetchexpert();
    requestPermissions();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings(
        'app_icon'); // <- default icon name is @mipmap/ic_launcher
    //var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var iOSSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    var initializationSettings =
    InitializationSettings(initializationSettingsAndroid, iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onClickNotification);

    readNotify1();
    readuser();
    super.initState();


  }

  void requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
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
  var Count="0";
  void readNotify1() async {
    Count = await storage.read(key: "notificationcount");

  }
  showSimpleNotification(title, title2) async {
    var androidDetails = AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOSDetails = IOSNotificationDetails();
    var platformDetails = new NotificationDetails(androidDetails, iOSDetails);
    await flutterLocalNotificationsPlugin.show(
        0, '${title}', '${title2}', platformDetails,
        payload: 'Destination Screen (Simple Notification)');
  }

  bool isloading = false;

  Widget _NotificationBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        _notificationcount.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
          icon: Icon(Icons.notifications, color: Colors.black),
          onPressed: () {
            _increment();
            loadCounter();
            Navigator.push(
              context,
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
    final items=<Widget>[

      Icon(Icons.favorite,size:30),
      Icon(Icons.home,size:30),
      Icon(Icons.calendar_today,size:30),
      Icon(Icons.person,size:30),

    ];
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
                        height:MediaQuery.of(context).size.height/8,
                        width: 120,
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage("assets/3.png"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      Text(
                        "Govipiyasa",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text("Feedback",style:TextStyle(fontSize:20,)),
                  trailing: Icon(Icons.feedback, color: Colors.black),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => FeedBack()));
                  },
                ),
                ListTile(
                  title: Text("Manage BankCards",style:TextStyle(fontSize:20,)),
                  trailing: Icon(Icons.credit_card, color: Colors.black),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => ListScreen()));
                  },
                ),
                ListTile(
                  title: Text("Near by Shops",style:TextStyle(fontSize:20,)),
                  trailing: Icon(Icons.lightbulb_rounded, color: Colors.black),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => NearShops()));
                  },
                ),
                //F8F8Fb
                ListTile(
                  title: Text("Bot",style:TextStyle(fontSize:20,)),
                  trailing: Icon(Icons.chat_outlined, color: Colors.black),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Chatbot()));
                  },
                ),
                ListTile(
                  title: Text("About",style:TextStyle(fontSize:20,)),
                  trailing: Icon(Icons.assignment_sharp, color: Colors.black),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => AboutPage()));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Logout",style:TextStyle(fontSize:20,)),
                  trailing: Icon(Icons.power_settings_new, color: Colors.black),
                  onTap: logout,
                ),
              ],
            ),
          )),
      appBar: AppBar(
        backgroundColor: HexColor("#F8F8FB"),
        elevation: 5,
  /*      backgroundColor: Colors.white,

        //centerTitle: true,
        title: TextLiquidFill(
          waveDuration: Duration(milliseconds: 4000),
          text: "GiviPiyasa",
          waveColor: Colors.lightGreen,
          boxBackgroundColor: Colors.white,
          textStyle: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto'),
          boxHeight: 300.0,
        ),*/
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
          IconButton(
              icon: Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartScreenNew(),
                  ),
                );
              }),
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.apps_rounded , color: Colors.blue),
                    Text("Services"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.build_rounded, color: Colors.blue),
                    Text("Settings"),
                  ],
                ),
              ),

              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.credit_card , color: Colors.blue),
                    Text("Manage Bank Cards"),
                  ],
                ),
              ),
         /*     PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.app_registration_sharp, color: Colors.blue),
                    Text("Language"),
                  ],
                ),
              ),*/
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Icon(Icons.add_location_rounded, color: Colors.blue),
                    Text("My Location"),
                  ],
                ),
              ),
        /*      PopupMenuItem<int>(
                value: 5,
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.blue),
                    Text("Wish List"),
                  ],
                ),
              ),*/

            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  /*    floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          showPopUp(context);
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 40),
        ),
      ),*/
      bottomNavigationBar:Theme(
        data:Theme.of(context).copyWith(
          iconTheme:IconThemeData(color:Colors.black),

        ) ,
        child:CurvedNavigationBar(
          key:navigationKey,
          height: 60,
          color:Colors.lightGreen,
          buttonBackgroundColor:HexColor("#e9fce4") ,
          backgroundColor:HexColor("#e9fce4") ,
          items:items,
          index:index,
          onTap: (index)=>setState(()=>this.index=index),


        ),),
   /*   bottomNavigationBar: BottomAppBar(
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
                  icon: Icon(Icons.home,size: 25,),
                  color: currentState == 0 ? Colors.black : Colors.black12,
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.chat,size: 25,),
                  color: currentState == 1 ? Colors.black12 : Colors.black,
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.store,size: 25,),
                  color: currentState == 2 ? Colors.black12 : Colors.black,
                  onPressed: () {
                    setState(() {
                      currentState = 2;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.account_circle_rounded,size: 25,),
                  color: currentState == 2 ? Colors.black12 : Colors.black,
                  onPressed: () {
                    setState(() {
                      currentState = 3;
                    });
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),*/
      body: screens[index],
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
            .push(MaterialPageRoute(builder: (context) => ListScreen()));
        break;
  /*    case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => OrderPage()));
        break;*/
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>  googlemap(lat: 6.0559758, long: 80.1769773)));
        break;
    /*  case 5:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>  Wishlist()));
        break;*/

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
          approval2==true?GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Architect()));
            },
              child: ListTile(
                title: Text('Create Architecture Profile'),
                leading: CircleAvatar(
                    child: Image.network(
                      "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                      fit: BoxFit.scaleDown,
                    )),
              ),

          ):GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Architectdashboard()));
            },

              child: ListTile(
                title: Text('Architecture Profile'),
                leading: CircleAvatar(
                    child: Image.network(
                      "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                      fit: BoxFit.scaleDown,
                    )),
              ),

          ),
          approval3==true?GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Shop()));
              },
                child: ListTile(
                  title: Text('Create Shop'),
                  leading: CircleAvatar(
                      child: Image.network(
                        "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                        fit: BoxFit.scaleDown,
                      )),
                ),
                //visible: approval,
              ):GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Shopdashboard()));
              },
                child: ListTile(
                  title: Text('Shop Profile'),
                  leading: CircleAvatar(
                      child: Image.network(
                        "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                        fit: BoxFit.scaleDown,
                      )),
                ),

              ),
          approval!=true?GestureDetector(
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ExpertForm()));
            },
            child: ListTile(
                title: Text('Create Expert'),
                leading: CircleAvatar(
                    child: Image.network(
                      "https://protocoderspoint.com/wp-content/uploads/2020/10/PROTO-CODERS-POINT-LOGO-water-mark-.png",
                      fit: BoxFit.scaleDown,
                    )),
              ),
             // visible: approval3,

          ):GestureDetector(
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Expertdashboard()));
            },

              child: ListTile(
                title: Text('Expert Profile'),
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
