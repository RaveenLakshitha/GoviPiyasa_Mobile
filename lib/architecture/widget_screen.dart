
import 'package:blogapp/Architectureprofile/ArchitectDashboard.dart';
import 'package:blogapp/Expertprofile/Expertdashboard.dart';
import 'package:blogapp/Screen/Services/ExpertForm.dart';
import 'package:blogapp/Screen/Services/architecture.dart';
import 'package:blogapp/Screen/Services/shop.dart';
import 'package:blogapp/shop/ShopProfile/Shopdashboard.dart';
import 'package:blogapp/websites/website1.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'bannerModel.dart';
import 'carouselSlider.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class WidgetScreen extends StatefulWidget {
  @override
  _WidgetScreenState createState() => _WidgetScreenState();
}

class _WidgetScreenState extends State<WidgetScreen> {
  final storage = FlutterSecureStorage();
  String visibility;
  String visibility2;
  String visibility3;
  bool approval1 = false;
  bool approval2 = true;
  bool approval3 = false;
  String value;
  var jsonData;
  var _postsJson;
  var _architecture;
  var _expert;

  void fetchexpert() async {
    print('expert method Working');
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
        _expert = jsonData;
        visibility3 = _expert['expertVisibility'].toString();
      });
      if (visibility3 == "Active") {
        print("active expert");setState(() {
          approval1 = true;
        });
      } else {
        setState(() {
          approval1 = false;
        });

        print("not active");
      }
    } catch (err) {}
  }

  void fetchArchitect() async {
    print('Architect method Working');
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
      print(' SHOW : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _architecture = jsonData;
        visibility2 = _architecture['architectVisibility'].toString();
      });
      if (visibility2 == "Active") {
        print("active");
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
  @override
  void initState() {
    fetchShop();
    fetchArchitect();
    fetchexpert();

    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(

          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, bottom: 25),
                    child: Text(
                      "Let's Create Your Shop",
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 23, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Services",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child:Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider.builder(
                        itemCount: bannerCards.length,
                        itemBuilder: (context, index, realIndex) {
                          print(index);
                          return Container(
                            //alignment:  Alignment.centerLeft,
                            //width: MediaQuery.of(context).size.width,
                            height: 140,
                            margin: EdgeInsets.only(left: 0, right: 0, bottom: 20),
                            padding: EdgeInsets.only(left: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                stops: [0.3, 0.7],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: bannerCards[index].cardBackground,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if(index == 0){
                                  if(approval3==true){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return Shopdashboard();
                                        }));
                                  }else{
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return Shop();
                                        }));
                                  }

                                }

                                else if(index==1){
                                  if(approval2==true){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return Architectdashboard();
                                        }));
                                  }else{
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return Architect();
                                        }));
                                  }

                                }else if(index==2){
                                  if(approval1==true){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return Expertdashboard();
                                        }));
                                  }else{
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return ExpertForm();
                                        }));
                                  }

                                }
                              },
                              child: Stack(
                                children: [
                                  Image.asset(
                                    bannerCards[index].image,
                                    //'assets/414.jpg',
                                    fit: BoxFit.fitHeight,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 7, right: 5),
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          bannerCards[index].text,
                                          //'Check Disease',
                                          style: GoogleFonts.lato(
                                            color: Colors.lightBlue[900],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          color: Colors.lightBlue[900],
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          scrollPhysics: ClampingScrollPhysics(),
                        ),
                      ),
                    )
                  ),
                  SizedBox(height: 10.0,),
                  GestureDetector(
                    child: Container(
                      height: 120.0,

                      margin: EdgeInsets.all(10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 1),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          children: <Widget>[

                            Image.asset(
                              'assets/flowers2.png',
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Container(
                              child: Text('Go to website',
                                  style: TextStyle(color: Colors.green, fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>Website1()));
                    },
                  ),
               /*   GestureDetector(
                    child: Container(
                      height: 120.0,

                      margin: EdgeInsets.all(10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 1),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          children: <Widget>[

                            Image.asset(
                              'assets/Delivery.png',
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Container(
                              child: Text('Domex',
                                  style: TextStyle(color: Colors.green, fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>Delivery()));
                    },
                  ),*/

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
