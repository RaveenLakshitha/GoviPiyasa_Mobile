import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart';


class ViewOrder extends StatefulWidget {


  @override
  _State createState() => _State();
}

class _State extends State<ViewOrder> {

  final url="https://mongoapi3.herokuapp.com/posts";

  var _postsJson = [];
  String answer;
  void getPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {}
  }
  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 3));
  }
  void initState() {
    super.initState();
    getPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
          backgroundColor: Colors.lightGreen,
          centerTitle: true,
          flexibleSpace: Image(
            image: AssetImage('assets/about.jpg'),
            fit: BoxFit.cover,
          ),
          actions: [

          ],
        ),
        body: RefreshIndicator(
          onRefresh: refreshList,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final post = _postsJson[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Question:${post['title']}"),
                        Text("Category:${post['category']}"),
                        Text("description:${post['description']}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Warning"),
                                        content: Text("Are you sure want to delete data profile ${post['title']}?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Yes"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              /*  apiService.deleteProfile(profile.id).then((isSuccess) {
                                                if (isSuccess) {
                                                  setState(() {});
                                                  Scaffold.of(this.context)
                                                      .showSnackBar(SnackBar(content: Text("Delete data success")));
                                                } else {
                                                  Scaffold.of(this.context)
                                                      .showSnackBar(SnackBar(content: Text("Delete data failed")));
                                                }
                                              });*/
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("No"),
                                            onPressed: () {
                                              //   Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            FlatButton(
                              onPressed: () async {

                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: _postsJson.length,
          ),
        )
    );
  }
}
