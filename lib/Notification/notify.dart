import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notify extends StatefulWidget {
  const Notify({Key key}) : super(key: key);

  @override
  State<Notify> createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Notifications',style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontFamily: 'Indies'
        ),),
        elevation: 0.3,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 0.6,

              child: ListTile(
                title:  Text(
                  notificationAlert,
                ),
                subtitle:   Text(
                  messageTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            )


          ],
        ),
      ),
    );

  }
}
