import 'package:blogapp/Screen/Navbar/Architectlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../Screen/Navbar/expertlist.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setupWorldTime() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => expert()));
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
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