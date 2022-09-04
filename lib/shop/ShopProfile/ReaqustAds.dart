import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blogapp/payment/AdsPayments.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'Shopdashboard.dart';



class Ads extends StatefulWidget {
  Ads({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  final storage = FlutterSecureStorage();
  Dio dio =Dio();
  bool _isLoading = false;
@override
  void initState() {
  //getHttp();
  //fetchshop();
  getConsumerInfo();
    super.initState();
  }


  File _image;
  final picker = ImagePicker();
  bool visibility;

  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
  }

  var _adsjson=[];
  var  _reqads;
/*  void fetchshop() async {
    print('Shop');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/advertisements'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');

      print('Ads SHOW : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      print(jsonData);
      setState(() {
        _reqads = jsonData;
        visibility = _reqads[0]['Paid'];


      });
    //  print(_reqads[0]['Paid']);
    } catch (err) {}
  }*/
/*  void checkvisibility() async {
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/advertisements'));
      final jsonData = jsonDecode(response.body)['data'] as List;
      print("vis");
      print(jsonData);
      setState(() {
        _adsjson = jsonData;
        visibility=_adsjson[0]['Paid'];
      });
      print("done");
    } catch (err) {}
  }*/

  getConsumerInfo() async {
    String token = await storage.read(key: "token");
    print("=========ads============");
    try {
      dio.options.headers['authorization'] = 'Bearer $token';
      final response = await dio.get('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/advertisements/getUsersAdd');
      print(response.data['data']);

      setState(() {
        _adsjson=response.data['data'];
        visibility=_adsjson[0]['Paid'];
      });
      print(visibility);
      print("=========ads============");
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: e.response?.data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
/*  void getHttp() async {
    print("=========ads============");
    try {
      var response = await Dio().get('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/advertisements');
     // final jsonData = jsonDecode(response.data)['data'];
      print(response.data['data']['Paid']);
      setState(() {
        _adsjson =response.data['data'];
        visibility=_adsjson  ;
      });
      print(visibility);
      print("=========ads============");

    } catch (e) {
      print(e);
    }
  }*/
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  uploadAds(Title,File file) async {
    String token = await storage.read(key: "token");
    dio.options.contentType = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${token}";
    print(token);
    try {

      String doc=file.path.split('/').last;
      FormData formData=FormData.fromMap({
        "Title": Title,

        "image":await MultipartFile.fromFile(file.path, filename:doc),

      });
      final response=await dio.post('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/advertisements', data: formData);
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
  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }
  final myController5 = TextEditingController();
  final myController6 = TextEditingController();
  //uploadImage('image', File('assets/about.jpg'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_isLoading==true?SizedBox(child:Center(child:CircularProgressIndicator())):  RefreshIndicator(
        onRefresh: refreshList2,
        child:visibility != false
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child:Center(
                  child:Text("Make Your Advertistment",  style: TextStyle(
                      color: Colors.black, fontSize: 30.0, fontFamily: 'Roboto'),),
                  )
                ),
                Form(
                    key: _formkey,
                  child:  Container(

                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                    ),
                   // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child:  TextFormField(
                      controller:myController5,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter title';
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

                    ),
                  ),
                ),

                Container(
                    margin: const EdgeInsets.all(13.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //                 <--- border radius here
                            ),
                        border: Border.all(color: Colors.lightGreen)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: _image != null
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    image: DecorationImage(
                                      image: FileImage(_image),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey,
                                  ),
                                ),
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

                        /*      Container(child:LinearPercentIndicator(
                    width: 140.0,
                    lineHeight: 14.0,
                    percent: 0.5,
                    backgroundColor: Colors.grey,
                    progressColor: Colors.blue,
                  ),)*/
                      ],
                    )),
                SizedBox(height: 10.0),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: ()async {
                    if (_formkey.currentState.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      await Future.delayed(
                          Duration(seconds: 4));
                      uploadAds(myController5.text,_image);

                      setState(() {
                        _isLoading = false;
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
                                  Shopdashboard()));
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

                  },
                  child: Text("Apply",
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2.2,
                        color: Colors.black,
                      )),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child:Text("Approved your Advertistment",style: TextStyle(   fontFamily: 'Roboto',fontWeight: FontWeight.bold, fontSize: 14.0,))
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    controller:myController6,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter amount minimum Rs 500',
                    ),
                  ),
                ),

                SizedBox(height: 10.0),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Payment(amount:"${myController6.text}",cardNo:"4444 4444 4444 4444",expiredate:"12/22"),
                    ));
                  },
                  child: Text("Pay",
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2.2,
                        color: Colors.black,
                      )),
                ),
              ],
            ),)
    );
  }
}
