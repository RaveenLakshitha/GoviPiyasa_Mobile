

import 'dart:convert';

import 'package:blogapp/Darkmode/ThemeManager.dart';
import 'package:blogapp/Forum/Qmodel.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'Forumcategory.dart';
import 'Postlist.dart';


class CreatePost extends StatefulWidget {
  String value;
CreatePost({this.value});
  @override
  _AddItemState createState() => _AddItemState(value);
}

class _AddItemState extends State<CreatePost> {
  String valueChoose;
  List listitem = ["Fruits", "Seeds","Plants"];
  var title,description,category;

  String Token;
  Qmodel _datamodel;
  _AddItemState(this.value);
  String value;
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool _isLoading = false;

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });
  }


addQuestion(title,category,description)async{

  String token = await storage.read(key: "token");
  print(token);
  var headers = {
    'Content-Type':'application/json',
    'authorization':'Basic $token'
  };

  final body = {
    "Title": title,
    "Category": category,
    "QuestionBody": description
  };
  http.post(
    "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/AddQuestion",body:jsonEncode(body),
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


  TextEditingController _title = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _description = TextEditingController();

@override
void initState() {
  super.initState();
  _category.text=value;
}
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
        theme: theme.getTheme(),home: Scaffold(
        appBar: AppBar(
         // backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          flexibleSpace: Image(
            image: AssetImage('assets/about.jpg'),
            fit: BoxFit.cover,
          ),
          title: Text("sdsd",
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
        ),
        body:Card(
            margin: EdgeInsets.all(20),
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child:SingleChildScrollView(

              child: Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: EdgeInsets.all(6.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                validator: (String value){
                                  if(value.isEmpty)
                                  {
                                    return "Please enter name";
                                  }
                                  return null;
                                },
                                controller:_title,
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  prefixIcon: Icon(Icons. title),
                                ),
                              ),
                            ),
                            Container(
                              child: TextFormField(
                                validator: (String value){
                                  if(value.isEmpty)
                                  {
                                    return "Please enter name";
                                  }
                                  return null;
                                },
                                controller: _description,
                                decoration: InputDecoration(
                                    labelText: 'Description',
                                    prefixIcon: Icon(Icons.description)),

                              ),
                            ),
                            Container(
                              child: TextFormField(
                                validator: (String value){
                                  if(value.isEmpty)
                                  {
                                    return "Please enter name";
                                  }
                                  return null;
                                },
                                controller: _category,
                                decoration: InputDecoration(
                                    labelText: 'Category',
                                    prefixIcon: Icon(Icons.category)),

                              ),
                            ),


SizedBox(height:10.0),
                            RaisedButton(
                              padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                              onPressed:()async{
                                if(_formkey.currentState.validate())
                                {
                                  String itemname=_title.text;
                                  String category=_category.text;
                                  String description=_description.text;
                                  addQuestion(itemname, category,description,);

_category.clear();
                                  _title.clear();
                                  _description.clear();
                                  await Future.delayed(Duration(seconds: 5));
                                  Fluttertoast.showToast(
                                    msg: "Successfull",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>ForumCategory()));
                                }else
                                {
                                  Fluttertoast.showToast(
                                    msg: "Unsuccessfull",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }

                              },
                              child: Text('Add Question',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold)),
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
    ),)
      );
  }
}
