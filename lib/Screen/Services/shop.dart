import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
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
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldstate = new GlobalKey<ScaffoldState>();
  Dio dio =Dio();
  Future getFile()async{
    File file = await FilePicker.getFile();

    setState(() {
      _file = file;
    });
  }
  final String endPoint = 'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops';
  String textFromField = 'Empty';

  getData() async {
    String response;
    response = await rootBundle.loadString('assets/policy/policy.txt');
    setState(() {
      textFromField = response;
    });
  }
  bool _isAcceptTermsAndConditions = false;
  createShop(shopName,email,longitude,latitude,address,File file,File shopimg1,File shopimg2,File shopimg3,File pic) async {
    String token = await storage.read(key: "token");
    dio.options.contentType = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${token}";
    print(token);
    try {

      String doc=file.path.split('/').last;
      String fileName1=shopimg1.path.split('/').last;
      String fileName2=shopimg2.path.split('/').last;
      String fileName3=shopimg3.path.split('/').last;
      String picName=file.path.split('/').last;
      FormData formData=FormData.fromMap({
        "shopName": shopName,
        "email": email,
        "address":address,
        "longitude":longitude,
        "latitude":latitude,
        "address":address,
        "profilePicture": await MultipartFile.fromFile(pic.path, filename:picName),
        "shopImages":await MultipartFile.fromFile(shopimg1.path, filename:fileName1),
        "shopImages":await MultipartFile.fromFile(shopimg2.path, filename:fileName2),
        "shopImages":await MultipartFile.fromFile(shopimg3.path, filename:fileName3),
        "proofDocuments":await MultipartFile.fromFile(file.path, filename:doc),

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

  void _showSnackBarMsg(String msg){
    _scaffoldstate.currentState
        .showSnackBar( new SnackBar(content: new Text(msg),));
  }
  final String location;
  final String latlang;
  final String longitude;

  _ShopState(this.location, this.latlang, this.longitude);

  File _image,_pic,_shopimg1,_shopimg2,_shopimg3;
  var arr = new List(2);
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
  chooseProfileImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _pic = File(image.path);
    });
  }
  void initState() {
    // TODO: implement initState
    getData();
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
  bool _isLoading = false;
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
   /*     appBar: AppBar(
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
        ),*/
        body:_isLoading==true?SizedBox(child:Center(child:CircularProgressIndicator())): SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 5.0),
            padding: EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 250,
                  width: 270,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(
                        5.0) //                 <--- border radius here
                    ),
                  ),
                  child: Image(
                    height: 200,
                    width: 300,
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
                          padding: EdgeInsets.all(6.0),
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
                              hintText:'Select Location From Map' ,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                prefixIcon:Icon(
                                  Icons.location_city,
                                  color: Colors.blue,
                                ) ,
                                suffixIcon: GestureDetector(
                                  child: Icon(
                                    Icons.add_location_alt,
                                    color: Colors.red,
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
                            borderRadius:  BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                        SizedBox(height: 5.0),
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
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
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
                              borderRadius:  BorderRadius.all(Radius.circular(15.0)),
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
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,

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
                            borderRadius:  BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          padding: EdgeInsets.all(6.0),
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextFormField(
                            controller:myController5 ,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText:'Address' ,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                prefixIcon:Icon(
                                  Icons.location_city,
                                  color: Colors.blue,
                                ) ,
                            ),
                            onChanged: (val) {
                              address = val;
                            },
                          ),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:  BorderRadius.all(Radius.circular(15.0)),
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
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
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
                            borderRadius:  BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),

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
                                  child: _pic!=null
                                      ?Container(
                                    height: 50,
                                    width:80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image:DecorationImage(
                                        image:FileImage(_pic),
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
                        SizedBox(height: 5.0),
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
                                  child: _shopimg1!=null
                                      ?Container(
                                    height: 50,
                                    width:80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image:DecorationImage(
                                        image:FileImage(_shopimg1),
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
                                Text("Shop Image 1"),
                                Container(child:Row(
                                  children: [
                                    IconButton(
                                        onPressed:(){
                                          chooseImage1(ImageSource.gallery);
                                        }, icon: Icon(Icons.camera_alt_sharp) )
                                  ],
                                )),
                              ],
                            )
                        ),
                        SizedBox(height: 5.0),
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
                                  child: _shopimg2!=null
                                      ?Container(
                                    height: 50,
                                    width:80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image:DecorationImage(
                                        image:FileImage(_shopimg2),
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
                                Text("Shop Image 2"),
                                Container(child:Row(
                                  children: [
                                    IconButton(
                                        onPressed:(){
                                          chooseImage2(ImageSource.gallery);
                                        }, icon: Icon(Icons.camera_alt_sharp) )
                                  ],
                                )),
                              ],
                            )
                        ),
                        SizedBox(height: 5.0),
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
                                  child: _shopimg3!=null
                                      ?Container(
                                    height: 50,
                                    width:80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image:DecorationImage(
                                        image:FileImage(_shopimg3),
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
                                Text("Shop Image 3"),
                                Container(child:Row(
                                  children: [
                                    IconButton(
                                        onPressed:(){
                                          chooseImage3(ImageSource.gallery);
                                        }, icon: Icon(Icons.camera_alt_sharp) )
                                  ],
                                )),
                              ],
                            )
                        ),
                        SizedBox(height: 5.0),
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
                                  child: _image!=null
                                      ?Container(
                                    height: 50,
                                    width:80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image:DecorationImage(
                                        image:FileImage(_image),
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
                                Text("Upload Proof Documents"),
                                Container(child:Row(
                                  children: [
                                    IconButton(
                                        onPressed:(){
                                          chooseImage(ImageSource.gallery);
                                        }, icon: Icon(Icons.upload) )
                                  ],
                                )),
                              ],
                            )
                        ),
                 /*       Container(
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
                        ),*/
                        SizedBox(height: 5.0),
                /*        Container(
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
                        ),*/
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
                              createShop(shopName,email,longitude,latlang,address,_image,_shopimg1,_shopimg2,_shopimg3,_pic);

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
                 /*       RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed: ()async {

                            if(_formkey.currentState.validate())
                            {
                              setState(() {
                                _isLoading=true;
                              });
                              createShop(shopName,email,longitude,latlang,address,_image,_shopimg1,_shopimg2,_shopimg3,_pic);
                              await Future.delayed(
                                  Duration(seconds: 8));
                              Fluttertoast.showToast(
                                msg: "Successfully Created Shop",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );

                              setState(() {
                                _isLoading=false;
                              });
                            }else
                            {
                              Fluttertoast.showToast(
                                msg: "Error",
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
                        ),*/
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
