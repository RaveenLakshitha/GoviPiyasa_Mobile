import 'dart:convert';

import 'package:blogapp/architecture/architect_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class expert extends StatefulWidget {
  @override
  _expertState createState() => _expertState();
}

class _expertState extends State<expert> {


  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architects";
  var _itemsJson = [];
  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _itemsJson = jsonData;
      });
    } catch (err) {}
  }

  void initState() {
    super.initState();
    fetchPosts();
  }
  bool isGrid = true;
  //List<String> items = ['Anna', 'Brandon', 'Emma', 'Ashen','nilura'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Architectures'),
          centerTitle: true,
          //  backgroundColor: Colors.lightGreen,
          actions: [
            Switch(
                value: isGrid,
                onChanged: (val) {
                  setState(() {
                    isGrid = val;
                  });
                }),
          ]),
        body: buildList());
  }

  void selectItem(String item) {
    final snackBar = SnackBar(
      content: Text(
        'Selected $item..',
        style: TextStyle(fontSize: 24),
      ),
      backgroundColor: Colors.lightGreen,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Widget buildList() => isGrid
      ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: _itemsJson.length,
          itemBuilder: (context, index) {
            final item = _itemsJson[index];
            return GridTile(
              child:InkWell(
                child: Ink.image(
                  image: NetworkImage(
                      'https://source.unsplash.com/random?sig=$index'),
                  fit: BoxFit.cover,
                ),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Architect(name: '${item['profileName']}',description: '${item['description']}',city: '${item['city']}',email: '${item['email']}',),
                      ));
                },
              ),

              footer: Container(
                padding: EdgeInsets.all(12),
                alignment: Alignment.center,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      "${item['profileName']}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${item['description']}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

              ),
            );
          },
        )
      : ListView.builder(
          itemCount: _itemsJson.length,
          itemBuilder: (context, index) {
            final item = _itemsJson[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                    'https://source.unsplash.com/random?sig=$index'),
              ),
              title: Text("Name ${item['name']}"),
              subtitle: Text("About ${item['about']}"),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Architect(name: '${item['profileName']}',description: '${item['description']}',city: '${item['city']}',email: '${item['email']}',),
                    ));
              },
            );
          });
}
