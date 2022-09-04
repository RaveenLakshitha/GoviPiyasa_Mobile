import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class EditArchitect extends StatefulWidget {

  final String id;
  final String businessName;
  final String email;
  final String motto;
  final String description;
  EditArchitect(
      {
        @required this.id,
        @required this.businessName,
        @required this.email,
        @required this.motto,@required this.description});
  @override
  State<EditArchitect> createState() => _EditArchitectState(id,businessName,email,motto,description);
}
class Architect {
  final String id;
  final String businessName;
  final String email;
  final String description;
  final String motto;


  const Architect({@required this.id, @required this.businessName,@required this.email,@required this.motto,@required this.description});

  factory Architect.fromJson(Map<String, dynamic> json) {
    return Architect(
      id: json['id'],
      businessName: json['businessName'],
      email: json['email'],
      motto:json['motto'],
      description:json['description'],


    );
  }
}
class _EditArchitectState extends State<EditArchitect> with SingleTickerProviderStateMixin{
  final String id;
  final String businessName;
  final String email;
  final String motto;
  final String description;
  _EditArchitectState(this.id,this.businessName, this.email, this.motto,this.description);
  bool _status = true;
  final picker = ImagePicker();
  File _file;
  chooseProfileImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _file = File(image.path);
    });
  }
  final FocusNode myFocusNode = FocusNode();
  Dio dio =Dio();
  updateshop(String contactNumber,String shopName,String email, String address,File pic) async {
    String token = await storage.read(key: "token");
    print(id);
    dio.options.contentType = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${token}";
    print(token);
    try {


      String picName=pic.path.split('/').last;
      FormData formData=FormData.fromMap({
        //'_id':id,
        'businessName':businessName,
        'email':email,
        'motto':motto,
        'description':description,
        'contactNumber':contactNumber,
        "profilePicture":await MultipartFile.fromFile(pic.path, filename:picName),

      });
      final response=await dio.post('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/updateUsersShop', data: formData);
      print(response);
      return response;
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }/*
  Future<Architect> updateArchitect(String id,String businessName,String email, String motto,String description) async {
    print(id);
    final response = await http.put(
      Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        '_id':id,
        'businessName':businessName,
        'email':email,
        'motto':motto,
        'description':description

      }),
    );
    print(response.body);

    if (response.statusCode == 200) {

      return Architect.fromJson(jsonDecode(response.body));
    } else {

      throw Exception('Failed to update data.');
    }
  }*/
  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 3));
  }


  void initState() {
    // TODO: implement initState
    setState(() {
      myController1.text=businessName;
      myController2.text=email;
      myController3.text=motto;
      myController4.text=id;


    });
    super.initState();
  }
  FlutterSecureStorage storage = FlutterSecureStorage();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();
  final myController5 = TextEditingController();
  final myController6 = TextEditingController();
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
                                            'Edit Architect Information',
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
                                            'BusinessName',
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
                                            hintText: "Enter Your Business Name",
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
                                              hintText:"Enter your Email" ),
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
                                            "Address",
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
                                              hintText:"Enter your Description" ),
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
                                            'Contact No',
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
                                          controller:myController4,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Contact Number"),
                                          enabled: false,
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
                                            'Motto',
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
                                          controller:myController4,
                                          decoration: const InputDecoration(
                                              hintText: "Enter your motto"),
                                          enabled: false,
                                        ),
                                      ),
                                    ],
                                  )),

                              Container(
                                  margin:
                                  const EdgeInsets.only(left: 10.0, right: 10.0),
                                  decoration:BoxDecoration(
                                      border: Border.all(color: Colors.lightGreen, width: 1),
                                      borderRadius:BorderRadius.circular(15)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: _file!=null
                                            ?Container(
                                          height: 50,
                                          width:80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            image:DecorationImage(
                                              image:FileImage(_file),
                                            ),
                                          ),
                                        ):Container(
                                          height: 50,
                                          width:50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color:Colors.grey,
                                          ),
                                        ),


                                      ),
                                      Text("Profile Picture"),
                                      Container(child:Row(
                                        children: [
                                          IconButton(
                                              onPressed:(){
                                                chooseProfileImage(ImageSource.gallery);
                                              }, icon: Icon(Icons.camera_alt_sharp) )
                                        ],
                                      )),
                                    ],
                                  )
                              ),
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
                    child: new Text("Update"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      updateshop(myController4.text,myController1.text, myController2.text, myController3.text,_file);
                      Fluttertoast.showToast(
                        msg: "Architect Updated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
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
