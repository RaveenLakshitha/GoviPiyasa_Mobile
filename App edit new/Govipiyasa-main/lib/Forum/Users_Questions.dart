import 'dart:convert';
import 'package:blogapp/assets/my_flutter_app_icons.dart';
import 'package:like_button/like_button.dart';
import 'package:blogapp/Forum/updateqty.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'Answers.dart';
import 'CreatePost.dart';
import 'Qmodel.dart';

class UserQuestion extends StatefulWidget {

  UserQuestion({Key key});

  @override
  _State createState() => _State();
}

class _State extends State<UserQuestion> {
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions";
  final storage = FlutterSecureStorage();
  var _postsJson = [];
  String ID;
  String answer;



  var _singleuser;
  void fetchuserQty() async {
    print('bye');
    String token = await storage.read(key: "token");
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/getUsersQuestions/'),  headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('Token : ${token}');

      print('Profile Data : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      print(jsonData);
      setState(() {
        _singleuser = jsonData;
        ID=_singleuser['_id'].toString();
      });
    } catch (err) {}


  }
  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 3));
  }

  Future<Qmodel> DeleteData(String id) async {
    var response = await http.delete(Uri.parse(
        'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/RemoveQuestion/$id'));
    var data = response.body;
    print(data);
    if (response.statusCode == 201) {
      String responseString = response.body;
      qModelFromJson(responseString);
    }
  }

  void initState() {
    fetchuserQty();
    super.initState();
  }
  final _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("",
              style: TextStyle(
                  fontFamily: 'Varela', fontSize: 25.0, color: Colors.black)),
          /*     //backgroundColor: Colors.lightGreen,
          centerTitle: true,
          flexibleSpace: Image(
            image: AssetImage('assets/about.jpg'),
            fit: BoxFit.cover,
          ),*/
          actions: [
            IconButton(
                icon: Icon(FontAwesomeIcons.plus, color: Colors.blue),
                onPressed: () {/*
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreatePost(value: "${categoryName}"),
                      ));*/
                }),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refreshList,
          child: ListView.builder(
            itemBuilder: (context, index) {
            //  final post = _singleuser[index];

              return SizedBox();
            },
            itemCount:3,
          ),
        ));
  }
  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }
  void showAnswer(post, total,index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Answers'),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('No of Answer:${post['AnswerCount']}',
                  style: TextStyle(
                      fontFamily: 'Varela',
                      fontSize: 20.0,
                      color: Color(0xFF545D68))),
              for (var i = 0; i<total; i++)
              //if(){}
                Text('$i):${post['Answers'][i]['AnswerBody']}\n',
                    style: TextStyle(
                        fontFamily: 'Varela',
                        fontSize: 15.0,
                        color: Colors.red)),
            ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok', style: TextStyle(fontSize: 20)))
        ],
      ),
    );
  }
}
