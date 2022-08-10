import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart';


class Answers extends StatefulWidget {
  final String answer;
  final String body;



  // receive data from the FirstScreen as a parameter
  Answers(
      {
        @required this.answer,
        @required this.body,
    });
  @override
  _AnswersState createState() => _AnswersState();
}

class _AnswersState extends State<Answers> {



  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/getExperts";
  var _postsJson = [];

  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {}
  }

  void initState() {
    super.initState();

    fetchPosts();

  }

  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Answers',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
        ),
        body: RefreshIndicator(
          onRefresh: refreshList2,
          child: ListView.builder(
              itemCount: _postsJson.length,
              itemBuilder: (BuildContext context, index) {
                final post = _postsJson[index];
                return Container(
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(
                        5.0) //                 <--- border radius here
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network("${post['profilePicture']}"),
                    title: Text("Name:${post['userName']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Email:${post['email']}"),
                        Text("City:${post['city']}"),
                        Text("Contact:+94${post['contactNumber']}"),

                      ],
                    ),
                    trailing: GestureDetector(
                      child: Icon(Icons.add_call),
                      onTap: () {

                      },
                    ),
                    isThreeLine: true,
                  ),
                );
              }),
        ));
  }




}
