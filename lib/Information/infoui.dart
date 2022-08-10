import 'dart:convert';

import 'package:blogapp/Information/weather.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'infocategory.dart';
import 'infosub.dart';
import 'news.dart';

class Categorylist extends StatefulWidget {
  const Categorylist({Key key}) : super(key: key);

  @override
  State<Categorylist> createState() => _CategorylistState();
}

class _CategorylistState extends State<Categorylist> {
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/infoCategories";
  var _inforJson = [];

  void infocategory() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _inforJson = jsonData;
      });
      print(_inforJson[3]['Information']);
      print(_inforJson[3]['Information'][0]['Title'].toString());
    } catch (err) {}
  }

@override
  void initState() {
  infocategory();
  // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.aod),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsScreen(),
                    ));
              }),
          IconButton(
              icon: Icon(Icons.bathroom ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Weather(),
                    ));
              }),
        ],
        flexibleSpace: Image(
          image: NetworkImage(
              'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
          fit: BoxFit.cover,

        ),
      ),
      body:Container(
   /*     decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/about.jpg"),
            fit: BoxFit.cover,
          ),
        ),*/
        child:GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: _inforJson.length,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index){
              final infor = _inforJson[index];
              if(_inforJson[index]['categoryType']== "Main"){
                return     GestureDetector(
                  child:Card(
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage('${infor['image']}'))),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '${infor['categoryName']}',
                            style: TextStyle(
                              fontFamily: 'Indies',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
                          )),
                    ),
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                  ),
                  onTap:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InfoSub(category:_inforJson[index]['_id'])));
                /*    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Infordescription(Title:_inforJson[index]['Information'][0]['Title'],list:_inforJson[index]['Information'])));*/
                  } ,);
              }else{
                return SizedBox.shrink();
              }



        }),)
    );
  }
}
