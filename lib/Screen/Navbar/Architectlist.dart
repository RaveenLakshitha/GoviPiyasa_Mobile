import 'dart:convert';

import 'package:blogapp/Architectureprofile/Architectureview.dart';
import 'package:blogapp/Architectureprofile/screens/product/products_screen.dart';
import 'package:blogapp/architecture/architect_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
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
                        builder: (context) => Architectureview(id:"${item['_id']}",businessName:"${item['businessName']}",description:"${item['description']}",contactNumber:"${item['contactNumber']}",motto:"${item['motto']}",email:"${item['email']}",rating:"${item['rating']}",image:"https://source.unsplash.com/random?sig=$index"),
                      ));
                },
              ),

              footer: Container(
                padding: EdgeInsets.all(12),
                alignment: Alignment.center,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          '${item['businessName']}',
                          textStyle: const TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color:Colors.white
                          ),
                          speed: const Duration(milliseconds: 500),
                        ),
                      ],

                      totalRepeatCount: 4,
                      pause: const Duration(milliseconds: 1000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText(
                          'Fade First',
                          textStyle: TextStyle(color:Colors.blue,fontSize: 32.0, fontWeight: FontWeight.bold),
                        ),
                     /*   ScaleAnimatedText(
                          'Then Scale',
                          textStyle: TextStyle(fontSize: 70.0, fontFamily: 'Canterbury'),
                        ),*/
                      ],
                    ),
                /*    Text(
                      "${item['businessName']}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),*/
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
              title: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    '${item['businessName']}',
                    textStyle: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 1000),
                  ),
                ],

                totalRepeatCount: 4,
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
              subtitle: Text("${item['motto']}"),
              onTap: (){

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Architectureview(id:"${item['_id']}",businessName:"${item['businessName']}",description:"${item['description']}",contactNumber:"${item['contactNumber']}",motto:"${item['motto']}",email:"${item['email']}",rating:"${item['rating']}",image:"https://source.unsplash.com/random?sig=$index"),
                    ));

              },
            );
          });
}
