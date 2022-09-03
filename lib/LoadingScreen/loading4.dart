import 'package:blogapp/Forum/Forumcategory.dart';
import 'package:blogapp/Screen/Navbar/Architectlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../Screen/Navbar/expertlist.dart';
import '../usersAppointments.dart';

class Loading4 extends StatefulWidget {
  @override
  _Loading4State createState() => _Loading4State();
}

class _Loading4State extends State<Loading4> {

  void setup() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserAppointment()));
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SpinKitFadingFour(
          color: Colors.lightGreen,
          size: 50.0,
          //  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      ),
    );
  }
}