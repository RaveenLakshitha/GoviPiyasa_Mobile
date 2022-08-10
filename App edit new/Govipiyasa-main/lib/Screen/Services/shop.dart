import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';

import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Profile/map.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Shop extends StatefulWidget {
  final String location;
  final String latlang;
  final String longitude;

  const Shop({Key key, this.location, this.latlang, this.longitude})
      : super(key: key);

  @override
  _ShopState createState() => _ShopState(location, latlang, longitude);
}

class _ShopState extends State<Shop> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  final picker = ImagePicker();
  File _file;
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  Dio dio =Dio();
  Future getFile()async{
    File file = await FilePicker.getFile();

    setState(() {
      _file = file;
    });
  }
  final String endPoint = 'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops';

  createShop(shopName,email,address,longitude,latitude,File file,File pic) async {
    String token = await storage.read(key: "token");
    dio.options.contentType = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${token}";
    print(token);
    try {

      String fileName=file.path.split('/').last;
      String picName=file.path.split('/').last;
      FormData formData=FormData.fromMap({
        "shopName": shopName,
        "email": email,
        "address":address,
        "longitude":longitude,
        "latitude":latitude,
        "profilePicture": await MultipartFile.fromFile(pic.path, filename:picName),
        "shopImages":await MultipartFile.fromFile(file.path, filename:fileName),
      });
      final response=await dio.post('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops', data: formData);
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
  /*postTest(shopName,email,address,longitude,latitude,filePath) async {
    String fileName = basename(filePath.path);
    print("file base name:$fileName");
    String token = await storage.read(key: "token");
    print(token);
    //var fileContent = filePath.readAsBytesSync();
   // var fileContentBase64 = base64.encode(fileContent);
    final uri = 'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops';
    var requestBody = {
      "shopName": shopName,
      "email": email,
      "address":address,
      "longitude":longitude,
      "latitude":latitude,
      "profilePicture":await MultipartFile.fromFile(filePath.path, filename:fileName),
      "shopPictures":await MultipartFile.fromFile(filePath.path, filename:fileName),



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

  void _showSnackBarMsg(String msg){
    _scaffoldstate.currentState
        .showSnackBar( new SnackBar(content: new Text(msg),));
  }
  final String location;
  final String latlang;
  final String longitude;

  _ShopState(this.location, this.latlang, this.longitude);

  File _image,_pic;
  var arr = new List(2);
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
  void initState() {
    // TODO: implement initState
    arr[0] = latlang;
    arr[1] = longitude;
    print(arr);
    setState(() {
      myController5.text = location;
      myController6.text = longitude;
      myController7.text = latlang;
    });
    super.initState();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final myController5 = TextEditingController();
  final myController6 = TextEditingController();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController7 = TextEditingController();
  final myController8 = TextEditingController();
  var shopName, email, sellerName, phoneNo, address, city,lat, long;


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
          title: Text('Create shop',
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
                    image: AssetImage("assets/shop.jpg"),
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
                                controller:myController1,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Shop Name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'ShopName',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                              ),
                              onChanged: (val) {
                                shopName = val;
                              },
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightGreen, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            )),
                        SizedBox(height: 5.0),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter contact number';
                              }
                              return null;
                            },
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
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller:myController2,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter vaild email address';
                              }
                              return null;
                            },
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
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller:myController5 ,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter city';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'City',
                              prefixIcon: GestureDetector(
                                child: Icon(
                                  Icons.add_location_alt,
                                  color: Colors.blue,
                                ),
                                onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context) =>Map1()));} ,
                              )
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
                       /* Container(
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: myController6,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Longitude';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Longitude',
                              prefixIcon: Icon(
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
                        ),*/
                        SizedBox(height: 5.0),
                       /* Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter NIC Number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'NIC',
                              prefixIcon: GestureDetector(
                                child: Icon(
                                  Icons.today,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  // _showToast(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Map1()));
//                                    uploadImage();
                                },
                              ),
                            ),
                            onChanged: (val) {
                              address = val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),*/
                        Container(
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: myController8,
                            decoration: InputDecoration(
                              labelText: 'Profile Picture',
                              prefixIcon: GestureDetector(
                                child: Icon(
                                  Icons.upload,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  chooseProfileImage(ImageSource.gallery);

                                },
                              ),
                            ),
                            onChanged: (val) {
                              _pic = val as File;
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
                            controller: myController8,
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
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed: () {
                          // consumerProfile(_image,"62ac01f65db35f1b19e6a22b");

                           // postTest(shopName,email,address,longitude,latlang,_image);
                            //postTest(shopName,email,myController5.text,_image);
                           // _uploadFile(shopName,email,myController5.text,_image);
                           if(_formkey.currentState.validate())
                            {


                              createShop(shopName,email,address,longitude,latlang,_image,_pic);

                            }else
                            {
                              Fluttertoast.showToast(
                                msg: "shop Created Unsuccessful",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }

                          },
                          child: Text('Create shop',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.orange,
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
        ));
  }
}
