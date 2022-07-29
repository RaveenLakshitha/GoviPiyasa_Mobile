import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:blogapp/CustumWidget/shopservice.dart';
import 'package:blogapp/Expertprofile/expertmap.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Profile/map.dart';
import 'package:blogapp/shop/ShopProfile/shoprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ExpertForm extends StatefulWidget {
  final String location;
  final String latlang;
  final String longitude;

  const ExpertForm({Key key, this.location, this.latlang, this.longitude})
      : super(key: key);

  @override
  _ExpertFormState createState() =>
      _ExpertFormState(location, latlang, longitude);
}

class _ExpertFormState extends State<ExpertForm> {
  final String location;
  final String latlang;
  final String longitude;

  _ExpertFormState(this.location, this.latlang, this.longitude);

  final picker = ImagePicker();
  File _image;
  FlutterSecureStorage storage = FlutterSecureStorage();

  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
  }
  void uploadFileToServer(File imagePath) async {
    print("test");
    var request = new http.MultipartRequest(
        "POST", Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/experts'));
    request.fields['description'] = 'Rohan';
    request.fields['designation'] = 'My first image';
    request.files.add(await http.MultipartFile.fromPath('proofDocuments', imagePath.path));
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
  postExpert(description,designation,qualification,latitude,longitude,city,filePath) async {

    String fileName = basename(filePath.path);
   print("file base name:$fileName");
    String token = await storage.read(key: "token");
    print(token);
    print(filePath);
    var fileContent = filePath.readAsBytesSync();
    var fileContentBase64 = base64.encode(fileContent);
    final uri = 'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/experts';
    var requestBody = {
      "description":description,
      "designation":designation,
      "city":city,
      "qualification":qualification,
      "latitude":latitude,
      "longitude":longitude,
      "proofDocuments": fileContentBase64 ,




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
/*    var postUri = Uri.parse("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops");

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'profilePic',  fileContentBase64);
    request.headers['Authorization'] ='bearer $token';
    request.headers['Content-Type'] ='application/json';
    request.fields['shopName']=shopName;
    request.fields['email']=email;
    request.fields['address']=address;
    request.files.add(multipartFile);

    http.StreamedResponse response1 = await request.send();


    print(response1.statusCode);*/
  }
  var description, email ,qualification , designation, city, lat, long;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final myController5 = TextEditingController();
  final myController6 = TextEditingController();
  final myController7 = TextEditingController();

  void initState() {
    setState(() {
      myController5.text = location;
      myController6.text = longitude;
      myController7.text = latlang;
    });
    super.initState();
  }

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
          backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Text('Apply For Expert',
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
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                  ),
                  child: Image(
                    image: AssetImage("assets/expertform.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5.0),
            /*            Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.attach_email_rounded,
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
                          ),
                        ),*/
                        Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Description',
                                prefixIcon: Icon(
                                  Icons.person,
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
                                  BorderRadius.all(Radius.circular(5.0)),
                            )),
                  /*      SizedBox(height: 5.0),
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
                              phoneNo = val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),*/
                        SizedBox(height: 5.0),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Designation',
                                prefixIcon: Icon(
                                  Icons.article_sharp,
                                  color: Colors.blue,
                                )),
                            onChanged: (val) {
                              designation = val;
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
                              labelText: 'Qualification',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                            ),
                            onChanged: (val) {
                              qualification = val;
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
                            controller: myController5,
                            decoration: InputDecoration(
                              labelText: 'City',
                              prefixIcon: GestureDetector(
                                child: Icon(
                                  Icons.add_location,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  // _showToast(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => expertmap()));
//                                    uploadImage();
                                },
                              ),
                            ),
                            onChanged: (val) {
                              city = val;
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
                            controller: myController7,
                            decoration: InputDecoration(
                                labelText: 'Latitude',
                                prefixIcon: Icon(
                                  Icons.article_sharp,
                                  color: Colors.blue,
                                )),
                            onChanged: (val) {
                              lat = val;
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
                            controller: myController6,
                            decoration: InputDecoration(
                                labelText: 'longitude',
                                prefixIcon: Icon(
                                  Icons.article_sharp,
                                  color: Colors.blue,
                                )),
                            onChanged: (val) {
                              long = val;
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
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightGreen, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 16, right: 16),
                                  child: _image != null
                                      ? Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blueAccent,
                                                width: 3),
                                            image: DecorationImage(
                                              image: FileImage(_image),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.only(
                                              left: 16, right: 16),
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          chooseImage(ImageSource.gallery);
                                        },
                                        icon: Icon(Icons.camera_alt_sharp))
                                  ],
                                )),
                              ],
                            )),
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
                                  // _showToast(context);
                                  chooseImage(ImageSource.gallery);
//                                    uploadImage();
                                },
                              ),
                            ),
                            onChanged: (val) {
                              _image = val as File;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            uploadFileToServer(_image);
                           // postExpert(description,designation,qualification,lat,long,city,_image);
                        /*    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Showitem()));*/
                          },
                          child: Text("Apply",
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
