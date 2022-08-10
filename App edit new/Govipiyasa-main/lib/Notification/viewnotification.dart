
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Viewnotification extends StatefulWidget {
  final String title;
  final String date;
  final String description;

  Viewnotification(
      {@required this.title,
        @required this.date,
        @required this.description,});

  @override
  State<Viewnotification> createState() => _ViewnotificationState(title,description,date);
}

class _ViewnotificationState extends State<Viewnotification> {
  final String title;
  final String date;
  final String description;

  _ViewnotificationState(this.title,this.description,this.date,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(title,style: TextStyle(fontSize:25,fontFamily: 'Roboto',fontWeight: FontWeight.bold)),
            Text(description,style: TextStyle(fontSize:25,fontFamily: 'Roboto',fontWeight: FontWeight.normal)),
            Text(date,style: TextStyle(fontSize:15,fontFamily: 'Roboto',fontWeight: FontWeight.w600)),

          ],
        ),

      ),

    );
  }
}
