import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'infoui.dart';


class Infordescription extends StatefulWidget {
  //final String id;
  final String id;
 // final List list;

  Infordescription (
      {
        @required this.id,
     //   @required this.list,
      });
  @override
  State<Infordescription> createState() => _InfordescriptionState(id
  );
}

class _InfordescriptionState extends State<Infordescription> {
  List<Node> data = [];
  Categorylist _inforJson = Categorylist();
  final String id;
   List articleslist;

  _InfordescriptionState(this.id);
  var _infordetails = [];
  String category;


  void infocategory(String id) async {
    print(id);
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/information/getInfoByCategory/$id'));
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _infordetails = jsonData;
        articleslist=_infordetails[0]['Articles'];
      });
      print("infodetails");
      print(_infordetails);


    } catch (err) {}
  }



  @override
  void initState() {
    infocategory(id);
    /*for (var element in list) {
      data.add(Node.fromJson(element));
    }*/
    print(data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   // print(widget.list);
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body:Center(
          child:       ListView.builder(
            itemCount: _infordetails.length,
            itemBuilder: (context, index){

              return _infordetails==null?SizedBox():ExpansionTile(
                title: Center(child:Text(_infordetails[index]['Title'],style: TextStyle(   fontFamily: 'Roboto',fontWeight: FontWeight.bold, fontSize: 24.0)),),
                children: <Widget>[
                  ListTile(
                     /* title: Text(
                        _infordetails[index]['Family'],
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),*/
                      subtitle:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                         // Text(_infordetails[index]['Family']),
                         _infordetails[index]['SubTitles']==null?SizedBox():Text(_infordetails[index]['SubTitles'][index]),
                         /* Text(_infordetails[index]['ScientificName'],  style: TextStyle(
                            color: Colors.red,
                          )),*/
                          Text("${_infordetails[index]['Articles']}"),
                        // Text(widget.list.toString()),
                           Text(_infordetails[index]['createdAt'])
                        ],
                      )
                  )
                ],

              );
            },
          ),
        )
    );
  }

  Widget _buildList(Node node) {
    if (node.children.isEmpty) {
      return Builder(
          builder: (context) {
            return ListTile(
                leading: const SizedBox(),
                title: Text(node.Title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), )
            );
          }
      );
    }

    //build the expansion tile
    double lp = 0; //left padding
    double fontSize = 28;
    if(node.level == 1){lp =20; fontSize =24;}
    if(node.level == 2){lp =30; fontSize =20;}
    return  Padding(
      padding: EdgeInsets.only(left: lp),
      child: ExpansionTile(
        leading: Icon(Icons.star,color: Colors.yellow,),
        title: Text(
          node.Title,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          node.Descrptions,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        children: node.children.map(_buildList).toList(),
      ),);

  }
}


//The Node Model
class Node {
  int level =0;
  String Title ="";
  String Descrptions;
  List<Node> children = [];
  //default constructor
  Node(this.level, this.Title, this.children,this.Descrptions);

  //one method for  Json data
  Node.fromJson(Map<String, dynamic> json) {
    if(json["level"] != null){level = json["level"];}
    Title = json['Title'];
    Descrptions = json['Descrptions'];
    //children
    if (json['children'] != null) {
      children.clear();
      //for each entry from json children add to the Node children
      json['children'].forEach((v) {
        children.add(Node.fromJson(v));
      });
    }
  }
}


//data
List dataList = [
  //data item
  {
    "level": 0,
    "title": "First Parent Title. Click me to expand!",
    "children": [
      {"title": "First child title"},
      {"title": "Second Child title"}
    ]
  },

  //data item
  {
    "level": 0,
    "title": "Second Parent Title. Click me to expand!",
    "children": [
      {
        "level":1,
        "title": "First child title",
        "children":[
          {
            "level":2,
            "title": "some more title",
            "children":[
              {"title": "Child Title more inner level"},
              {"title": "Child Title more  inner level"},
            ],

          },
          {"title": "Child Title inner level"},
          {"title": "Child Title inner level"},
        ],
      },
      {
        "level":1,
        "title": "Second child title",
        "children":[
          {
            "level":2,
            "title": "some more title",
            "children":[
              {"title": "Child Title more inner level"},
              {"title": "Child Title more  inner level"},
            ],

          },
          {"title": "Child Title inner level"},
          {"title": "Child Title inner level"},
        ],
      },
      {"title": "Third Child title"}
    ]
  },

  //data item
  {
    "level": 0,
    "title": "Third Parent Title. Click me to expand!",
    "children": [
      {
        "level":1,
        "title": "First child title",
        "children":[
          {
            "level":2,
            "title": "some more title",
            "children":[
              {"title": "Child Title more inner level"},
              {"title": "Child Title more  inner level"},
            ],

          },
          {"title": "Child Title inner level"},
          {"title": "Child Title inner level"},
        ],
      },
      {
        "level":1,
        "title": "Second child title",
        "children":[
          {
            "level":2,
            "title": "some more title",
            "children":[
              {"title": "Child Title more inner level"},
              {"title": "Child Title more  inner level"},
            ],

          },
          {"title": "Child Title inner level"},
          {"title": "Child Title inner level"},
        ],
      },
      {"title": "Third Child title"}
    ]
  },
];