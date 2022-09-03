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
  File _image,_pic;
  FlutterSecureStorage storage = FlutterSecureStorage();

  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
  }

  chooseProfileImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _pic = File(image.path);
    });
  }
  upload(String filename) async {
    print("test");
    var request = http.MultipartRequest('POST', Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/experts'));
    request.files.add(
        await http.MultipartFile.fromPath(
            'proofDocuments',
            filename
        )
    );
    var res = await request.send();
  }
  Dio dio =Dio();
  createExpert(email,contact,description,city,designation,qualification,latitude,longitude,File file,File pic) async {
    String token = await storage.read(key: "token");
    dio.options.contentType = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${token}";
    print(token);
    try {

      String fileName=file.path.split('/').last;
      String picName=file.path.split('/').last;
      FormData formData=FormData.fromMap({
        "email": email,
        "contactNumber":contact,
        "description":description,
        "qualification":qualification,
        "city":city,
        "designation": designation,
        "latitude":latitude,
        "longitude":longitude,
        "profilePicture": await MultipartFile.fromFile(pic.path, filename:picName),
        "shopImages":await MultipartFile.fromFile(file.path, filename:fileName),
      });
      final response=await dio.post('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/experts', data: formData);
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
  var description, email ,qualification , designation, city, lat, long,contact;
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
  /*      appBar: AppBar(
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
        ),*/
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
                            controller: myController5,
                            decoration: InputDecoration(
                              labelText: 'City',
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  Icons.add_location_alt,
                                  color: Colors.red,
                                ),
                                onTap:(){      Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => expertmap()));} ,
                              ),
                              prefixIcon:Icon(
                                Icons.add_location,
                                color: Colors.blue,
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
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Field is empty';
                                }
                                return null;
                              },
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
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

                      //  SizedBox(height: 5.0),
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
                              labelText: 'Email',
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Contact Number',
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
                       /* Container(
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
                        ),*/
                        SizedBox(height: 5.0),
                        Container(
                            margin:
                            const EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightGreen, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: _pic != null
                                      ? Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                          color: Colors.blueAccent,
                                          width: 3),
                                      image: DecorationImage(
                                        image: FileImage(_pic),
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
                                              chooseProfileImage(ImageSource.gallery);
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
                                onTap: () async{
                                  // _showToast(context);
                                  //  chooseImage(ImageSource.gallery);

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
    if (_formkey.currentState.validate()) {
      createExpert(email,contact,description,city,designation,qualification,lat,long,_image,_pic);
    }


                            //postExpert(description,designation,qualification,lat,long,city,email,contact);
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
                        SizedBox(height: 50,),
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
