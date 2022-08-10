import 'dart:convert';
import 'dart:io';
import 'package:blogapp/wishlist/wishmain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;



import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'orderhistory.dart';


class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}
class User {
  final String id;
  final String userName;
  final String email;
  final String contactNumber;
  final String city;


  const User({@required this.id, @required this.userName,@required this.email,@required this.contactNumber,@required this.city,});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      contactNumber:json['contactNumber'],
      city:json['contactNumber'],


    );
  }
}
class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  var id;
  String errmsg = "";
  Future<User> updateUser(String id,String userName,String email, String contactNumber ,String city,String password) async {
    print(id);
    final response = await http.put(
      Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        '_id':id,
        'userName':userName,
        'email':email,
        'contactNumber':contactNumber,
        'city':city,
        'password':password

      }),
    );
    print(response.body);

    if (response.statusCode == 200) {

      return User.fromJson(jsonDecode(response.body));
    } else {

      throw Exception('Failed to update album.');
    }
  }
  final FocusNode myFocusNode = FocusNode();
  var email;
  @override

  FlutterSecureStorage storage = FlutterSecureStorage();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();
  final myController5 = TextEditingController();
  final myController6 = TextEditingController();
  Dio dio =Dio();
  var jsonData;
  var _postsJson;
  String name;
  var apidata;
  userProfile(File file,id) async {
    print(file);
    print("working upload");
    try {
      String fileName=file.path.split('/').last;
      FormData formData=FormData.fromMap({
        "profilePicture": await MultipartFile.fromFile(file.path, filename:fileName),
      });

      return await dio.put('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/updateProfilePic/$id', data: formData);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

 void fetchsingleuser() async {
    print('bye');
    String token = await storage.read(key: "token");
    try {
      final response = await http.get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/getLoggedUser'),  headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print('Token : ${token}');

      print('Profile Data : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _postsJson = jsonData;
        myController1.text=_postsJson['userName'].toString();
        myController2.text=_postsJson['email'].toString();
        myController3.text=_postsJson['contactNumber'].toString();
        myController4.text=_postsJson['city'].toString();
        myController5.text=_postsJson['_id'].toString();

        id=_postsJson['_id'].toString();
      });
    } catch (err) {}


  }
  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 3));
  }

  void writeuser() async{
    await storage.write(key: "id", value:id);
    print(id);
  }
  void initState() {
    name= myController1.text;
    fetchsingleuser();

    loadImage();
    writeuser();
    super.initState();
  }
 final picker=ImagePicker();
  File _image;
  String _imagepath;


  chooseImage(ImageSource source) async{
    final image=await picker.getImage(source:source);

    setState(() {
      _image=File(image.path);
      SaveImage(_image.path);
      userProfile(_image,id);
    });


  }
  void SaveImage(path) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("imagepath1", path);
    print(path);
    Fluttertoast.showToast(
      msg: "save",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


  Future loadImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    // pref.getString("imagepath");
    setState(() {
      _imagepath = pref.getString("imagepath1");
      _image = File(_imagepath.toString());
    });
    print(_imagepath);
    Fluttertoast.showToast(
      msg: "Loaded",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body:  RefreshIndicator(
        onRefresh: refreshList,
          child:Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(width: 10,),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: new Text('PROFILE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          fontFamily: 'sans-serif-light',
                                          color: Colors.black)),
                                ),
                                SizedBox(width: 50,),
                                Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child:Material(
                                    type: MaterialType.transparency,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green, width: 2.0),
                                        color: Colors.lightGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(400.0),
                                        onTap: () {   Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WishNew(),
                                            ));},
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.all_inbox ,
                                            size: 25.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child:Material(
                                    type: MaterialType.transparency,
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green, width: 2.0),
                                        color: Colors.lightGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(400.0),
                                        onTap: () {   Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Orderhistory(),
                                            ));},
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.article_sharp,
                                            size: 25.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: _image!=null?FileImage(_image): AssetImage(
                                            'assets/profile.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child:GestureDetector(
                                        child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,

                                      ),onTap: (){
                                        chooseImage(ImageSource.gallery);

                                      },)
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Parsonal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  //_postsJson['email'].toString()
                                  new Flexible(
                                    child: new TextField(
                                      controller: myController1,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        "Password",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: myController6,
                                      decoration: const InputDecoration(
                                          hintText:"Enter New Password" ),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                       "Email",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: myController2,
                                      decoration: const InputDecoration(
                                          hintText:"Enter Email Address" ),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: myController3,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'City',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: new TextField(
                                        controller: myController4,
                                        decoration: const InputDecoration(
                                            hintText: "Enter a city"),
                                        enabled: !_status,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: new TextField(
                                      controller: myController5,
                                      decoration: const InputDecoration(
                                          hintText: "ID"),
                                      enabled: false,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      updateUser(id,myController1.text, myController2.text, myController3.text,myController4.text,myController6.text);
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                       FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}