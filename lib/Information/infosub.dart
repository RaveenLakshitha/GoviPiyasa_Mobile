import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'infocategory.dart';
import 'news.dart';

class InfoSub extends StatefulWidget {
  final String category;

  InfoSub (
      {
        @required this.category,
      });

  @override
  State<InfoSub> createState() => _InfoSubState(category);
}

class _InfoSubState extends State<InfoSub> {
  // final url = "";
  var _inforJson = [];
  String category;
  _InfoSubState(this.category);

  void infocategory(String id) async {
    print(id);
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/infoCategories/getCategoryByParent/$id'));
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _inforJson = jsonData;
      });
      print(_inforJson);
      // print(_inforJson[0]['Information'][0]['categoryId']);
      // print(_inforJson[3]['Information'][0]['Title'].toString());
    } catch (err) {}
  }

  @override
  void initState() {
    infocategory(category);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         // title: Text("${category}"),
          toolbarHeight: 50,
          backgroundColor: Colors.white,
          centerTitle: true,

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
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                final infor = _inforJson[index];
                //if(_inforJson[index]['categoryType']== "Sub"&&_inforJson[index]['parentId']=="${category}"){
                return  GestureDetector(

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
                    //if(_inforJson[index]['Information'][index]['Title']!=null){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Infordescription(id:_inforJson[index]['_id'])));


                  } ,);
                /*}else{
                  return SizedBox.shrink();
                }*/



              }),)
    );
  }
}
