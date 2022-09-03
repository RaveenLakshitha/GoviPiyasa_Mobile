import 'dart:convert';

import 'package:blogapp/Notification/viewnotification.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notify extends StatefulWidget {
  const Notify({Key key}) : super(key: key);

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/notifications";
  var singlenotificationlist = [];
  final storage = FlutterSecureStorage();
  var ID;
  var Count;

  void readuser() async {
    Count = await storage.read(key: "notificationcount");
   // ID = await storage.read(key: "id");
    print(Count);
    Fluttertoast.showToast(
      msg: Count,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
/*  void fetchsinglenotification(String id) async {
    print(ID);
    try {
      final response = await get(Uri.parse("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/notifications/getSingleNotification/${id}"));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        singlenotificationlist = jsonData;
      });
      print(singlenotificationlist);
    } catch (err) {}
  }*/

  var notificationlist = [];
int length;
  void fetchnotification() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        notificationlist = jsonData;
       length=notificationlist.length;
      });
    } catch (err) {}
  }
  var _notification=[];
  var notification;
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
        //notification=_notification[0]['Title'];
      });
      print("Private Notification");
      print(_notification);
    } catch (err) {

    }


  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    readuser();

    fetchnotification();
    fetchPrivateNotification();
    super.initState();

    _firebaseMessaging.configure(
      onMessage: (message) async{
        setState(() {
          messageTitle = message["notification"]["title"];
          notificationAlert = "New Notification Alert";
        });

      },
      onResume: (message) async{
        setState(() {
          messageTitle = message["data"]["title"];
          notificationAlert = "Application opened from Notification";
        });

      },
    );
  }
  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      //  backgroundColor: Colors.lightGreen,
        title: Text('Notifications',style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontFamily: 'Indies'
        ),),
        elevation: 3,
      ),
      body:Column(
        children: [

          Container(child:Text("Private Messages",style: TextStyle(fontSize:25,fontFamily: 'Roboto',fontWeight: FontWeight.bold),)),
          Expanded(child:
          Container(
            child: RefreshIndicator(
              onRefresh: refreshList2,
              child: ListView.builder(
                  itemCount:  _notification.length,
                  itemBuilder: (BuildContext context, index) {
                   final post = _notification[index];
                   print(post);
                    return Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white70.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        border: Border.all(color: Colors.blueAccent,width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                      ),
                      child: ListTile(
                        title: Text("${post['Title']}",   style: TextStyle(
                            fontFamily: 'Varela',
                            fontSize: 15.0,
                            color: Colors.red)),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                           Text("${post['Description']}"),



                          ],
                        ),

                      ),
                    );
                  }),
            ),
          )
          ),
          Container(child:Card(
            elevation: 3,

            child: ListTile(
              title:  Text(
                notificationAlert,
              ),
              subtitle:   Text(
                messageTitle,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          ),
         SizedBox(height: 10,),
         /* Container(child:Text("Public Messages",style: TextStyle(fontSize:25 ,fontFamily: 'Roboto',fontWeight: FontWeight.bold),),),
          Expanded(child:
          Container(
            child: RefreshIndicator(
              onRefresh: refreshList2,
              child: ListView.builder(
                  itemCount: notificationlist.length,
                  itemBuilder: (BuildContext context, index) {
                    final post =notificationlist[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(
                          builder: (context)=>Viewnotification(title:"${post['Title']}",description: "${post['Description']}",date:"${post['DateAndTime']}")
                        ));
                      },
                      child:   Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //                 <--- border radius here
                          ),
                        ),
                        child: ListTile(
                          title: Text("${post['Title']}",   style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 15.0,
                              color: Colors.black)),
                          trailing:Text("${post['DateAndTime']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Text("${post['Description']}"),
                              //  Text("${post['user']}"),



                            ],
                          ),

                        ),
                      )
                    );

                  }),
            ),
          )
          ),*/
        ],
      )
    );

  }
}
