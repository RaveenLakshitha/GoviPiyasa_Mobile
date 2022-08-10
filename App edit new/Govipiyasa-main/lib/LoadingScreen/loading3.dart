import 'package:blogapp/Forum/Forumcategory.dart';
import 'package:blogapp/Screen/Navbar/Architectlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../Screen/Navbar/expertlist.dart';

class Loading3 extends StatefulWidget {
  @override
  _Loading3State createState() => _Loading3State();
}

class _Loading3State extends State<Loading3> {

  void setup() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => expert()));
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SpinKitFadingFour(
          color: Colors.white,
          size: 50.0,
          //  controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
        ),
      ),
    );
  }
}