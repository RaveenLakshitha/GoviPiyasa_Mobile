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

class Updateqty extends StatefulWidget {
  String id;
  String Title;
  String Category;
  String QuestionBody;

  Updateqty({this.Title, this.QuestionBody,this.Category,this.id});

  @override
  _AddItemState createState() => _AddItemState(Title,QuestionBody,Category,id);
}

class Question {
  final String Title;
  final String QuestionBody;
  final String Category;


  const Question(
      {@required this.Title,
      @required this.QuestionBody,
      @required this.Category});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      Title: json['Title'],
      Category: json['Category'],
      QuestionBody: json['QuestionBody'],
    );
  }
}

class _AddItemState extends State<Updateqty> {
  String valueChoose;
  final String Title;
  final String QuestionBody;
  final String Category;
  final String id;
  String Token;
  Qmodel _datamodel;

  _AddItemState(this.Title, this.QuestionBody, this.Category,this.id);

  String value;
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool _isLoading = false;



  Future<Question> updateQuestion(
      String Title, String Category, String QuestionBody, String id) async {
    print(id);
    final response = await http.put(
      Uri.parse(
          'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/UpdateQuestion/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Title': Title,
        'QuestionBody': QuestionBody,
        'Category': Category,

      }),
    );
    print(response.body);

    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update Question.');
    }
  }

  TextEditingController _title = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _description = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _title.text = Title;
      _description.text = QuestionBody;
      _category.text = Category;
    });
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              theme: theme.getTheme(),
              home: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.lightGreen,
                  elevation: 0.0,
                  centerTitle: true,
               /*   flexibleSpace: Image(
                    image: AssetImage('assets/about.jpg'),
                    fit: BoxFit.cover,
                  ),*/
                  title: Text("Update Question",
                      style: TextStyle(
                          fontFamily: 'Varela',
                          fontSize: 25.0,
                          color: Colors.white)),
                ),
                body:_isLoading==true?SizedBox(child:Center(child:CircularProgressIndicator())):Card(
                    margin: EdgeInsets.all(20),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: SingleChildScrollView(
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
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "Please enter name";
                                          }
                                          return null;
                                        },
                                        controller: _title,
                                        decoration: InputDecoration(
                                          labelText: 'Title',
                                          prefixIcon: Icon(Icons.title),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "Please enter name";
                                          }
                                          return null;
                                        },
                                        controller: _description,
                                        decoration: InputDecoration(
                                            labelText: 'Description',
                                            prefixIcon:
                                                Icon(Icons.description)),
                                      ),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        validator: (String value) {
                                          if (value.isEmpty) {
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
                                    SizedBox(height: 10.0),
                                    RaisedButton(
                                      padding:
                                          EdgeInsets.fromLTRB(70, 10, 70, 10),
                                      onPressed: () async {
                                        if (_formkey.currentState.validate()) {

                                          setState(() {
                                            _isLoading=true;
                                          });
                                          String title = _title.text;
                                          String category = _category.text;
                                          String description =
                                              _description.text;
                                          updateQuestion(title, category, description,id);

                                          _category.clear();
                                          _title.clear();
                                          _description.clear();
                                          await Future.delayed(
                                              Duration(seconds: 8));
                                          Fluttertoast.showToast(
                                            msg: "Successfully Updated",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );

                                          setState(() {
                                            _isLoading=false;
                                          });
                                         Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForumCategory()));
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "Failed",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      },
                                      child: Text('Update Question',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold)),
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ));
  }
}
