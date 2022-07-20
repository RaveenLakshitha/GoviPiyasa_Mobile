import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Profile/map.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
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
  final picker = ImagePicker();
  File _file;
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();

  Future getFile()async{
    File file = await FilePicker.getFile();

    setState(() {
      _file = file;
    });
  }

  void _uploadFile(shopName,email,filePath) async {
    String fileName = basename(filePath.path);
    print("file base name:$fileName");

    try {
      FormData formData = new FormData.fromMap({
        "shopName": shopName,
        "email": email,
        "address":address,
        "shopPictures": await MultipartFile.fromFile(filePath.path, filename: fileName),
      });

      Response response = await Dio().post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/createShop",data: formData);
      print("File upload response: $response");
    //  _showSnackBarMsg(response.data['message']);
    } catch (e) {
      print("expectation Caugch: $e");
    }



  }
  void _showSnackBarMsg(String msg){
    _scaffoldstate.currentState
        .showSnackBar( new SnackBar(content: new Text(msg),));
  }
  final String location;
  final String latlang;
  final String longitude;

  _ShopState(this.location, this.latlang, this.longitude);

  File _image;
  var arr = new List(2);
  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
  }
  //var send = [{'latitude': '${latlang}'}, {'latitude': 123.456}];
  void initState() {
    // TODO: implement initState
    arr[0] = latlang;
    arr[1] = longitude;
    print(arr);
    setState(() {
      myController5.text = location;
      myController6.text=arr.toString();
      myController7.text=longitude;


    });
    super.initState();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final myController5 = TextEditingController();
  final myController6 = TextEditingController();
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController7 = TextEditingController();
  var shopName, email, sellerName, phoneNo, address, city;


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
                                return 'Please enter Name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'SellerName',
                                prefixIcon: Icon(
                                  Icons.attribution_outlined,
                                  color: Colors.blue,
                                )),
                            onChanged: (val) {
                              sellerName = val;
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
                        Container(
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller: myController6,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Cordinates';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Cordinates',
                              prefixIcon: Icon(
                                Icons.add_location_alt,
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
                            _uploadFile(shopName,email,_image);
                          /*  if(_formkey.currentState.validate())
                            {
                              // _uploadFile(_file,shopName, sellerName, phoneNo, email,
                              //     address, city);
                              ShopService()
                                  .addShop(shopName, sellerName, phoneNo, email,
                                  address, city)
                                  .then((val) {
                                Fluttertoast.showToast(
                                  msg: val.data['msg'],
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );

                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Showitem()));
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
                            }*/

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
