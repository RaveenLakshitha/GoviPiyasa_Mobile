import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:blogapp/CustumWidget/shopservice.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/shop/ShopProfile/shoprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Architect extends StatefulWidget {
  @override
  _ArchitectState createState() => _ArchitectState();
}

class _ArchitectState extends State<Architect> {
  final picker = ImagePicker();
  FlutterSecureStorage storage = FlutterSecureStorage();
  File _image;

  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
  }

  void uploadFileToServer(File imagePath) async {
    print("test");
    var request = new http.MultipartRequest("POST",
        Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architects'));
    request.fields['description'] = 'Rohan';
    request.fields['designation'] = 'My first image';
    request.files.add(
        await http.MultipartFile.fromPath('proofDocuments', imagePath.path));
    request.send().then((response) {
      http.Response.fromStream(response).then((onValue) {
        try {
          // get your response here...
        } catch (e) {
          // handle exeption
        }
      });
    });
  }

  postArchitect(description, businessName, email, contactNumber, motto, city,
      filePath) async {
    String fileName = basename(filePath.path);
    print("file base name:$fileName");
    String token = await storage.read(key: "token");
    print(token);
    print(filePath);
    var fileContent = filePath.readAsBytesSync();
    var fileContentBase64 = base64.encode(fileContent);
    final uri = 'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architects';
    var requestBody = {
      "description": description,
      "businessName": businessName,
      "email": email,
      "contactNumber": contactNumber,
      "motto": motto,
    };

    http.Response response = await http.post(
      uri,
      body: json.encode(requestBody),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var businessName, description, token, motto, contact, email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              }),
          // backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Create Architecture Profile',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 5.0),
            padding: EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                  ),
                  child: Image(
                    image: AssetImage("assets/architect.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'BusinessName',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                            ),
                            onChanged: (val) {
                              businessName = val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ContactNumber',
                              prefixIcon: Icon(
                                Icons.contact_phone,
                                color: Colors.blue,
                              ),
                            ),
                            onChanged: (val) {
                              contact = val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Descriiption',
                              prefixIcon: Icon(
                                Icons.contact_phone,
                                color: Colors.blue,
                              ),
                            ),
                            onChanged: (val) {
                              description = val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Motto',
                              prefixIcon: Icon(
                                Icons.contact_phone,
                                color: Colors.blue,
                              ),
                            ),
                            onChanged: (val) {
                              motto = val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.article_sharp,
                                color: Colors.blue,
                              ),
                            ),
                            onChanged: (val) {
                              email = val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Upload Proof Document',
                              prefixIcon: GestureDetector(
                                child: Icon(
                                  Icons.upload,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  chooseImage(ImageSource.gallery);
//                                    uploadImage();
                                },
                              ),
                            ),
                            onChanged: (val) {
                              // proofDoc=val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Showitem()));
                            } else {
                              Fluttertoast.showToast(
                                msg: "Unsuccessfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                          child: Text("Create Architect shop",
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 2.2,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
