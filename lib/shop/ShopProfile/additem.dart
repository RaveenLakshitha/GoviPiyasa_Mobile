import 'dart:convert';
import 'dart:io';
import 'package:blogapp/Notification/destination_screen.dart';
import 'package:blogapp/Notification/local_notifications.dart';
import 'package:blogapp/shop/ShopProfile/shoprofile.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../itemservice.dart';
import 'package:dio/dio.dart';

import 'Shopdashboard.dart';
class AddItem extends StatefulWidget {
  final String categoryId;
  final String categoryParentId;
  AddItem({this.categoryId, this.categoryParentId});
  @override
  _AddItemState createState() => _AddItemState(categoryId,categoryParentId);
}

class _AddItemState extends State<AddItem> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler();
  Dio dio =Dio();
  bool _isLoading = false;
  String categoryId;
  String categoryParentId;
  _AddItemState(this.categoryId,this.categoryParentId);
  AddItems(productName,price,description,quantity,categoryId,categoryParentId,File pic1,File pic2,File pic3,File thumbnail) async {
    String token = await storage.read(key: "token");
    dio.options.contentType = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${token}";
    print(token);
    try {
      String picture1=pic1.path.split('/').last;
      String picture2=pic2.path.split('/').last;
      String picture3=pic3.path.split('/').last;
      String thumbnails=thumbnail.path.split('/').last;
      FormData formData=FormData.fromMap({
        "productName": productName,
        "price": price,
        "description":description,
        "quantity":quantity,
        "categoryId":categoryId,
        "parentCategoryId":categoryParentId,
        "thumbnail":await MultipartFile.fromFile(pic1.path, filename:thumbnails),
        "productPictures": await MultipartFile.fromFile(pic1.path, filename:picture1),
        "productPictures": await MultipartFile.fromFile(pic2.path, filename:picture2),
        "productPictures": await MultipartFile.fromFile(pic3.path, filename:picture3),
      });
      final response=await dio.post('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/', data: formData);
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
  var result;
  List<String> strArr = ['choose your item'];
  @override
  void initState() {
    writeuser();
    super.initState();
    requestPermissions();
    var androidSettings = AndroidInitializationSettings('app_icon');
    var iOSSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    var initSetttings = InitializationSettings(androidSettings, iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onClickNotification);

  }
  void writeuser() async{
    await storage.write(key: "array", value:strArr.toString());
  }

  void requestPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future onClickNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return DestinationScreen(
        payload: payload,
      );
    }));
  }

  Future<void> showBigTextNotification() async {
    const BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'Flutter Big Text Notification Title',
      htmlFormatContentTitle: true,
      summaryText: 'Flutter Big Text Notification Summary Text',
      htmlFormatSummaryText: true,
    );
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'Channel Name', 'Channel Description', styleInformation: bigTextStyleInformation);
    const NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, null);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification', 'Flutter Big Text Notification',
        notificationDetails, payload: 'Destination Screen(Big Text Notification)');
  }
  var notification =LocalNotifications();
  FlutterSecureStorage storage = FlutterSecureStorage();
  var log = Logger();
  File _image,_image1,_image2,_image3,_image4;

  final picker=ImagePicker();
  TextEditingController _textEditingController = TextEditingController();
  chooseImage4(ImageSource source) async{
    final image=await picker.getImage(source:source);
    setState(() {
      _image4=File(image.path);
    });
  }
  chooseImage1(ImageSource source) async{
    final image=await picker.getImage(source:source);
    setState(() {
      _image1=File(image.path);
    });
  }

  chooseImage2(ImageSource source) async{
    final image=await picker.getImage(source:source);
    setState(() {
      _image2=File(image.path);
    });
  }
  chooseImage3(ImageSource source) async{
    final image=await picker.getImage(source:source);
    setState(() {
      _image3=File(image.path);
    });
  }
  String valueChoose;
  List listitem = ["Delivery Available", "Delivery not Available"];
  List listitem1 = ["Plants", "Seeds"];
  var itemname,description,price,quantity,category;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,

          title: Text('Add Itemes',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
        ),
        body: SingleChildScrollView(

          child:_isLoading==true?SizedBox(child:Center(child:CircularProgressIndicator())): Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.all(6.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
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
                                  child: _image4!=null
                                      ?Container(
                                    height: 50,
                                    width:80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image:DecorationImage(
                                        image:FileImage(_image4),
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
                                Text("Main Thumbnail"),
                                Container(child:Row(
                                  children: [
                                    IconButton(
                                        onPressed:(){
                                          // getImage();
                                          chooseImage4(ImageSource.gallery);
                                        }, icon: Icon(Icons.camera_alt_sharp) )
                                  ],
                                )),
                              ],
                            )
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
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
                                  child: _image1!=null
                                      ?Container(
                                    height: 50,
                                    width:80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image:DecorationImage(
                                        image:FileImage(_image1),
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
                                Text("Profile Picture1"),
                                Container(child:Row(
                                  children: [
                                    IconButton(
                                        onPressed:(){
                                         // getImage();
                                           chooseImage1(ImageSource.gallery);
                                        }, icon: Icon(Icons.camera_alt_sharp) )
                                  ],
                                )),
                              ],
                            )
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
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
                                  child: _image2!=null
                                      ?Container(
                                    height: 50,
                                    width:80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      image:DecorationImage(
                                        image:FileImage(_image2),
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
                                Text("Profile Picture2"),
                                Container(child:Row(
                                  children: [
                                    IconButton(
                                        onPressed:(){
                                         // getImage();
                                           chooseImage2(ImageSource.gallery);
                                        }, icon: Icon(Icons.camera_alt_sharp) )
                                  ],
                                )),
                              ],
                            )
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
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
                                  child: _image3!=null
                                      ?Container(
                                    height: 50,
                                    width:80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      image:DecorationImage(
                                        image:FileImage(_image3),
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
                                         // getImage();
                                           chooseImage3(ImageSource.gallery);
                                        }, icon: Icon(Icons.camera_alt_sharp) )
                                  ],
                                )),
                              ],
                            )
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          padding: EdgeInsets.only(left:16,right:16),
                          child:TypeAheadFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Email';
                              }
                              return null;
                            },
                            suggestionsCallback: (pattern)=>strArr.where((item)=>item.toLowerCase().contains(pattern.toLowerCase())
                            ),
                            itemBuilder: (_, String item)=>ListTile(title:Text(item)),
                            onSuggestionSelected: (String val){
                              this._textEditingController.text=val;
                              print(val);
                            },
                            getImmediateSuggestions: true,
                            hideSuggestionsOnKeyboardHide: false,
                            hideOnEmpty: false,
                            noItemsFoundBuilder: (context)=>Padding(
                              padding:const EdgeInsets.all(8.0),
                              child:Text('No item found'),
                            ),
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: this._textEditingController,
                              decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  labelText: 'Item Name',
                                  prefixIcon: Icon(Icons.chat )),
                            ),

                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          padding: EdgeInsets.only(left:16,right:16),
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
                                contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                                labelText: 'Description',
                                prefixIcon: Icon(Icons.dehaze_sharp )),
                            onChanged: (val){
                              description=val;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          padding: EdgeInsets.only(left:16,right:16),
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
                              labelText: 'price',
                              prefixIcon: Icon(Icons.attach_money_sharp ),
                            ),
                            onChanged: (val){
                              price=val;
                            },
                          ),

                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          padding: EdgeInsets.only(left:16,right:16),
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
                              labelText: 'quantity',
                              prefixIcon: Icon(Icons.corporate_fare_outlined   ),
                            ),
                            onChanged: (val){
                              quantity=val;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                    /*    Container(
                          margin:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child:Center(
                            child:Padding(
                              padding:const EdgeInsets.all(16.0),
                              child: Container(
                                padding: EdgeInsets.only(left:16,right:16),
                                decoration:BoxDecoration(
                                    border:Border.all(color:Colors.grey,width:1),
                                    borderRadius:BorderRadius.circular(15)
                                ),
                                child: DropdownButton(
                                  hint: Text("Category"),
                                  dropdownColor: Colors.grey,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                  ),
                                  value:  category,
                                  onChanged: (value) {
                                    setState(() {
                                      category=value;
                                    });
                                  },
                                  items: listitem1.map((valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem,
                                      child: Text(valueItem),
                                    );
                                  }).toList(),
                                ),),),),),*/
                        SizedBox(
                          height: 10,
                        ),


                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed:()async{

                            if (_formkey.currentState.validate()) {
                              setState(() {
                                _isLoading=true;
                              });
                              AddItems(_textEditingController.text,price,description,quantity,categoryId,categoryParentId,_image1,_image2,_image3,_image4);
                              await Future.delayed(
                                  Duration(seconds: 8));
                              Fluttertoast.showToast(
                                msg: "Successfully Updated",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              //showBigTextNotification();
                              // notification.showBigTextNotification();
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Shopdashboard()));

                            }

                          },

                          child: Text('Add Item',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.green,
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
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        processImageLabels();
      } else {
        print('No image selected.');
      }
    });
  }

  processImageLabels() async {
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(_image);
    ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    var _imageLabels = await labeler.processImage(myImage);
    result = "";
    for (ImageLabel imageLabel in _imageLabels) {
      setState(() {
        result = result + imageLabel.text + ":" + imageLabel.confidence.toString() + "\n";
        strArr.add(imageLabel.text);
      });
    }
    writeimahelabel();
  }
  void writeimahelabel() async{
    await storage.write(key: "label", value:strArr[1]);
    Fluttertoast.showToast(
      msg: "image saved",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );


  }
}
