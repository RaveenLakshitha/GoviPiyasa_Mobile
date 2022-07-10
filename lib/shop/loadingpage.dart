import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loadingpage extends StatefulWidget {
  const Loadingpage({Key key}) : super(key: key);

  @override
  State<Loadingpage> createState() => _LoadingpageState();
}

class _LoadingpageState extends State<Loadingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body:Center(
          child:SpinKitCircle(
            size:60,

            itemBuilder: (context,index){
              final colors=[Colors.white,Colors.lightGreen];
              final color=colors[index%colors.length];
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  shape:BoxShape.circle,
                ),
              );
            },
          )
      ),

    );
  }
}
