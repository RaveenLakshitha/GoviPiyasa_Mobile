import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Policy extends StatefulWidget {
  const Policy({Key key}) : super(key: key);

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: new Text(
          "Description that is too long in text format(Here Data is coming from API)",
          style: new TextStyle(
            fontSize: 16.0, color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
