import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
  File _image, _pic;
  bool loading = false;
  bool _isAcceptTermsAndConditions = false;
  File _shopimg1, _shopimg2, _shopimg3;

  chooseImage1(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _shopimg1 = File(image.path);
    });
  }

  chooseImage2(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _shopimg2 = File(image.path);
    });
  }

  chooseImage3(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _shopimg3 = File(image.path);
    });
  }

  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
  }

  String textFromField = 'Empty';

  getData() async {
    String response;
    response = await rootBundle.loadString('assets/policy/policy.txt');
    setState(() {
      textFromField = response;
    });
  }

  chooseProfileImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _pic = File(image.path);
    });
  }

  Dio dio = Dio();


  createArchitect(businessName, email, contact, description, motto, File file,
      File shopPic1, File shopPic2, File shopPic3, File pic) async {
    String token = await storage.read(key: "token");
    dio.options.contentType = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${token}";
    print(token);
    try {
      String doc = file.path.split('/').last;
      String fileName1 = shopPic1.path.split('/').last;
      String fileName2 = shopPic2.path.split('/').last;
      String fileName3 = shopPic3.path.split('/').last;
      String picName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "businessName": businessName,
        "email": email,
        "contactNumber": contact,
        "description": description,
        "motto": motto,
        "profilePicture":
            await MultipartFile.fromFile(pic.path, filename: picName),
        "shopImages":
            await MultipartFile.fromFile(file.path, filename: fileName1),
        "shopImages":
            await MultipartFile.fromFile(file.path, filename: fileName2),
        "shopImages":
            await MultipartFile.fromFile(file.path, filename: fileName3),
        "proofDocuments":
            await MultipartFile.fromFile(file.path, filename: doc),
      });
      final response = await dio.post(
          'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architects',
          data: formData);
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
  }

/*  postArchitect(description, businessName, email, contactNumber, motto,
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
      "profilePicture":await MultipartFile.fromFile(filePath.path, filename:fileName),
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

  }*/

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var businessName, description, token, motto, contact, email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*    appBar: AppBar(
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
        ),*/
        body: SingleChildScrollView(
      child: loading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Field is empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
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
                              border: Border.all(
                                  color: Colors.lightGreen, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter contactNumber';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
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
                              border: Border.all(
                                  color: Colors.lightGreen, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Description';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
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
                              border: Border.all(
                                  color: Colors.lightGreen, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Motto';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
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
                              border: Border.all(
                                  color: Colors.lightGreen, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
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
                              border: Border.all(
                                  color: Colors.lightGreen, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: _image != null
                                        ? Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              image: DecorationImage(
                                                image: FileImage(_image),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(5),
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                  Text(" Upload Profile Picture"),
                                  Container(
                                      child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            chooseImage(ImageSource.gallery);
                                            chooseProfileImage(
                                                ImageSource.gallery);
                                          },
                                          icon: Icon(Icons.camera_alt_sharp))
                                    ],
                                  )),
                                ],
                              )),
                          SizedBox(height: 5.0),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightGreen, width: 1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: _shopimg1 != null
                                        ? Container(
                                            height: 50,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              image: DecorationImage(
                                                image: FileImage(_shopimg1),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                  Text("Shop Image 1"),
                                  Container(
                                      child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            chooseImage1(ImageSource.gallery);
                                          },
                                          icon: Icon(Icons.camera_alt_sharp))
                                    ],
                                  )),
                                ],
                              )),
                          SizedBox(height: 5.0),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightGreen, width: 1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: _shopimg2 != null
                                        ? Container(
                                            height: 50,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              image: DecorationImage(
                                                image: FileImage(_shopimg2),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                  Text("Shop Image 2"),
                                  Container(
                                      child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            chooseImage2(ImageSource.gallery);
                                          },
                                          icon: Icon(Icons.camera_alt_sharp))
                                    ],
                                  )),
                                ],
                              )),
                          SizedBox(height: 5.0),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.lightGreen, width: 1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: _shopimg3 != null
                                        ? Container(
                                            height: 50,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              image: DecorationImage(
                                                image: FileImage(_shopimg3),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                  Text("Shop Image 3"),
                                  Container(
                                      child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            chooseImage3(ImageSource.gallery);
                                          },
                                          icon: Icon(Icons.camera_alt_sharp))
                                    ],
                                  )),
                                ],
                              )),
                          SizedBox(height: 5.0),
                          Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: _image != null
                                        ? Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              image: DecorationImage(
                                                image: FileImage(_image),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(5),
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                  Text("Upload Proof Documents"),
                                  Container(
                                      child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            chooseImage(ImageSource.gallery);
                                          },
                                          icon: Icon(Icons.upload))
                                    ],
                                  )),
                                ],
                              )),
                          SizedBox(height: 5.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                    value: _isAcceptTermsAndConditions,
                                    onChanged: (value) {
                                      setState(() {
                                        // 2
                                        _isAcceptTermsAndConditions =
                                            value ?? false;
                                      });
                                    }),
                                privacyPolicyLinkAndTermsOfService(),
                                // Text('I accept the terms and conditions.'),
                              ]),
                          ElevatedButton(
                            // 3
                            onPressed: _isAcceptTermsAndConditions
                                ? () async {
                                    if (_formkey.currentState.validate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      await Future.delayed(
                                          Duration(seconds: 4));
                                      createArchitect(
                                          businessName,
                                          email,
                                          contact,
                                          description,
                                          motto,
                                          _image,
                                          _shopimg1,
                                          _shopimg2,
                                          _shopimg3,
                                          _image);
                                      //postArchitect(description, businessName, email, contact, motto,_image);
                                      setState(() {
                                        loading = false;
                                      });
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.SUCCES,
                                        headerAnimationLoop: false,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'Sucessfully Created',
                                        buttonsTextStyle: const TextStyle(
                                            color: Colors.black),
                                        showCloseIcon: false,
                                        btnOkOnPress: () {},
                                      ).show();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage()));
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        headerAnimationLoop: false,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: 'UnSucessfully',
                                        buttonsTextStyle: const TextStyle(
                                            color: Colors.black),
                                        showCloseIcon: false,
                                        btnOkOnPress: () {},
                                      ).show();
                                    }
                                  }
                                : null,
                            child: Text('Create Architect shop'),
                          ),
                          /*   OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: ()async {

                          },
                          child: Text("Create Architect shop",
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 2.2,
                                color: Colors.black,
                              )),
                        ),*/
                          SizedBox(
                            height: 50,
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

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
          child: Text.rich(TextSpan(
              text: 'By continuing, you agree to our ',
              style: TextStyle(fontSize: 16, color: Colors.black),
              children: <TextSpan>[
            TextSpan(
                text: '\n Terms of Service',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // code to open / launch terms of service link here
                  }),
            TextSpan(
                text: ' and ',
                style: TextStyle(fontSize: 18, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          getData();
                          showPolicy(context);
                          // code to open / launch privacy policy link here
                        })
                ])
          ]))),
    );
  }

  showPolicy(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: Text(textFromField),
        ),
      ),
    );
  }
}
