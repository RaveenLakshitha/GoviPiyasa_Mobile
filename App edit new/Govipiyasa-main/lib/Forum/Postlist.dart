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

class Postlist extends StatefulWidget {
  final String categoryName;

  // receive data from the FirstScreen as a parameter
  Postlist({@required this.categoryName});

  @override
  _State createState() => _State(categoryName);
}

class _State extends State<Postlist> {
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions";
  final storage = FlutterSecureStorage();
  var _postsJson = [];
  var _postsJson1 = [];
  String ID;
  String answer;
  final String categoryName;
  _State(this.categoryName);


  downvote(id)async{
    String token = await storage.read(key: "token");
    print(token);
    var headers = {
      'Content-Type':'application/json',
      'authorization':'Basic $token'
    };
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/DownVoteFromQuest/$id",
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }

  addvote(id)async{
    String token = await storage.read(key: "token");
    print(token);
    var headers = {
      'Content-Type':'application/json',
      'authorization':'Basic $token'
    };
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/AddVoteToQuest/$id",
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }
  addAnswer(answerbody,Qid)async{

    String token = await storage.read(key: "token");
    print(token);
    print(Qid);
    var headers = {
      'Content-Type':'application/json',
      'authorization':'Basic $token'
    };

    final body = {
      "AnswerBody":answerbody,
      "QuestionId": Qid
    };
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Answers/addAnswer/$Qid",body:jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }
  void getPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;

      setState(() {
        _postsJson = jsonData;
      });
    } catch (err) {}
  }
  var _singleuser;
  void fetchPosts() async {
    print('bye');
    String token = await storage.read(key: "token");
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/getLoggedUser'),  headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('Token : ${token}');

      print('Profile Data : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _singleuser = jsonData;
        ID=_singleuser['_id'].toString();
      });
    } catch (err) {}


  }
  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 3));
  }
/*
  void readuser() async {
    //ID = await storage.read(key: "id");
    ID = await storage.read(key: "id");
    Fluttertoast.showToast(
      msg: ID,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }*/

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
    fetchPosts();
    getPosts();
   // readuser();
    super.initState();
  }
  final _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${categoryName}",
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreatePost(value: "${categoryName}"),
                      ));
                }),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refreshList,
          child: ListView.builder(
            itemBuilder: (context, index) {
              final post = _postsJson[index];
              int count = post['AnswerCount'];
              print(post['Category']);
              if (_postsJson[index]['Category'] == "${categoryName}") {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "${post['Title']}",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Varela',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text("${post['Category']}",style: TextStyle(
                              fontSize: 15,
                              color:Colors.red,
                              fontFamily: 'Varela',
                              fontWeight: FontWeight.bold)),
                          Text("${post['QuestionBody']}"),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _comment,
                                decoration: InputDecoration(
                                    labelText: 'Comment here',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: (){
                                        addAnswer(_comment.text,post['_id']);
                                        _comment.clear();
                                        Fluttertoast.showToast(
                                          msg: "Added",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    prefixIcon: Icon(Icons.comment,color: Colors.lightGreen,)),
                                onChanged: (val) {
                                  answer = val;
                                },
                              ),
                              OutlinedButton(
                                style:OutlinedButton.styleFrom(
                                  padding:const EdgeInsets.symmetric(horizontal: 40),
                                  shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                ),
                                child: Text(
                                  'Show Answer',
                                  style:TextStyle(
                                fontSize: 16,
                                letterSpacing: 2.2,
                                  color:Colors.black,
                                ),
                                ),
                                onPressed: (){    /*Navigator.push(context,MaterialPageRoute(
                                  builder: (context) => Answers(answer: '${post['Answers'][]['AnswerBody']}',count:count),));*/}
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [

                                  IconButton(
                                      icon: Icon(
                                        Icons.beenhere_rounded ,
                                      ),
                                      onPressed: () {

                                      }),
                            /*      IconButton(
                                      icon: Icon(
                                        MyFlutterApp.thumbs_up,
                                      ),
                                      onPressed: () {
                                        //downvote(post['_id']);
                                        addvote(post['_id']);
                                        Fluttertoast.showToast(
                                          msg: "like",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }),*/
                                  LikeButton(
                                    onTap: onLikeButtonTapped,
                                    size: 20,
                                    circleColor:
                                    CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                    bubblesColor: BubblesColor(
                                      dotPrimaryColor: Color(0xff33b5e5),
                                      dotSecondaryColor: Color(0xff0099cc),
                                    ),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.favorite_border,
                                        color: isLiked ? Colors.red : Colors.grey,
                                        size: 20,

                                      );
                                    },
                                    likeCount: post['Vote'],

                                    countBuilder: (int count, bool isLiked, String text) {
                                     // addvote(post['_id']);
                                      var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                                      Widget result;
                                      if (count == 0) {
                                        result = Text(
                                          "love",
                                          style: TextStyle(color: color),
                                        );
                                      } else
                                        result = Text(
                                          text,
                                          style: TextStyle(color: color),
                                        );
                                      return result;
                                    },
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        MyFlutterApp.thumbs_down,
                                      ),
                                      onPressed: () {
                                        downvote(post['_id']);
                                       // addvote(post['_id']);
                                        Fluttertoast.showToast(
                                          msg: "Dislike",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }),
                                  post['user']=="$ID"?
                                  FlatButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Warning"),
                                              content: Text(ID),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("Yes"),
                                                  onPressed: () {
                                                    DeleteData(post['_id']);
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                      msg: "Deleted",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0,
                                                    );
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text("No"),
                                                  onPressed: () {
                                                      Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Text(

                                      "Delete",style:TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 2.2,
                                      color:Colors.black,
                                    ),
                                    ),
                                  ):SizedBox.shrink(),
                                  post['user']=="$ID"?
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => Updateqty(Title:post['Title'],Description:post['Description'],Category:post['Category'])));

                                    },
                                    child: Text(
                                      "Update",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ):SizedBox.shrink()
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
            itemCount: _postsJson.length,
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
