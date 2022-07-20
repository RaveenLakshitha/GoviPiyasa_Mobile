import 'package:flutter/material.dart';


class Infordescription extends StatefulWidget {
  //final String id;
  final String Title;
 /* final String Descriptions;
  final String SubTitles;
  final String ScientificName;
  final String Family;*/



  // receive data from the FirstScreen as a parameter
  Infordescription (
      {

        @required this.Title,
       });
  @override
  State<Infordescription> createState() => _InfordescriptionState(Title
  );
}

class _InfordescriptionState extends State<Infordescription> {
  List<Node> data = [];
//  final String id;
  final String Title;
/*  final String Descriptions;
  final String SubTitles;
  final String ScientificName;
  final String Family;*/
  _InfordescriptionState(this.Title);

  @override
  void initState() {
    for (var element in dataList) {
      data.add(Node.fromJson(element));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information"),
      ),
      body:  ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) => _buildList(data[index]),
        separatorBuilder: (BuildContext context, int index) => const Divider( height: 1, thickness: 2,),
      ),
    );
  }

  Widget _buildList(Node node) {
    if (node.children.isEmpty) {
      return Builder(
          builder: (context) {
            return ListTile(
                leading: const SizedBox(),
                title: Text(node.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), )
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
          node.title,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        children: node.children.map(_buildList).toList(),
      ),);

  }
}


//The Node Model
class Node {
  int level =0;
  String title ="";
  List<Node> children = [];
  //default constructor
  Node(this.level, this.title, this.children);

  //one method for  Json data
  Node.fromJson(Map<String, dynamic> json) {
    if(json["level"] != null){level = json["level"];}
    title = json['title'];
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