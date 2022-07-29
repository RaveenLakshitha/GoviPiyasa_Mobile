
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Darkmode/ThemeManager.dart';

import 'Pages/LoadingPage.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Splash/page/onboarding_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
  ));

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = LoadingPage();
  final storage = FlutterSecureStorage();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = ((prefs.getInt('counter') ?? 0) + 1);
      prefs.setInt('counter', _counter);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initializing();
    _incrementCounter();
    checkLogin();
    _incrementCounter();
  }
  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');

    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  void checkLogin() async {
    String token = await storage.read(key: "token");
    if (token != null) {
      setState(() {
        page = HomePage();
      });
    } else {
      setState(() {
        page = OnBoardingPage();
      });
    }
  }
  int _counter = 0;
/*  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }*/
  //Image.asset('assets/original_logo.png'),
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(

      debugShowCheckedModeBanner: false,

      theme:  theme.getTheme(),
      home:AnimatedSplashScreen(
        duration: 2000,
        splash: Container(
        color: Colors.white,
        child:Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),child:Image.asset('assets/31.png' , height: 300,
          width: 300,),)
      ),
        nextScreen:page,
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.white,


      ),
    ));
  }
}
