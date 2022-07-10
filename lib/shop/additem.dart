




import 'dart:io';

import 'package:blogapp/Notification/destination_screen.dart';
import 'package:blogapp/Notification/local_notifications.dart';
import 'package:blogapp/shop/shoprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:logger/logger.dart';

import 'itemservice.dart';

class AddItem extends StatefulWidget {

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
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
  File _image;

final picker=ImagePicker();

  chooseImage(ImageSource source) async{
    final image=await picker.getImage(source:source);
    setState(() {
      _image=File(image.path);
    });
  }

  String valueChoose;
  List listitem = ["Delivery Available", "Delivery not Available"];
  List listitem1 = ["Plants", "Seeds"];
  var itemname,description,price,quantity,category,deliverystatus;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          flexibleSpace: Image(
            image: AssetImage('assets/about.jpg'),
            fit: BoxFit.cover,
          ),
          title: Text('Add Item',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 20.0,
                  color: Color(0xFF545D68))),
        ),
        body: SingleChildScrollView(

          child: Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.all(6.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left:16,right:16),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'ItemName',
                              prefixIcon: Icon(Icons.person),
                            ),
                            onChanged: (val){
                              itemname=val;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left:16,right:16),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Description',
                                prefixIcon: Icon(Icons.attribution_outlined)),
                            onChanged: (val){
                              description=val;
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left:16,right:16),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'price',
                              prefixIcon: Icon(Icons.contact_phone),
                            ),
                            onChanged: (val){
                              price=val;
                            },
                          ),

                        ),
                        Container(
                          padding: EdgeInsets.only(left:16,right:16),
                          child: TextFormField(
                            decoration: InputDecoration(

                              labelText: 'quantity',
                              prefixIcon: Icon(Icons.attach_email_rounded),
                            ),
                            onChanged: (val){
                              quantity=val;
                            },
                          ),
                        ),
                        Container(
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
                                ),),),),),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             Container(
                               child: _image!=null
                                   ?Container(
                                 height: 50,
                                 width:50,
                                 decoration: BoxDecoration(
                                   image:DecorationImage(
                                     image:FileImage(_image),
                                   ),
                                 ),
                               ):Container(
                                 height: 50,
                                 width:50,
                                 decoration: BoxDecoration(
                                   color:Colors.grey,
                                 ),
                               ),


                             ),

                             Container(child:Row(
                               children: [
                                 IconButton(
                                     onPressed:(){
                                       chooseImage(ImageSource.gallery);
                                     }, icon: Icon(Icons.camera_alt_sharp) )
                               ],
                             )),
                           ],
                         )
                        ),
                        Container(
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
                                  hint: Text("Delivery Availability"),
                                  dropdownColor: Colors.grey,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                  ),
                                  value:  deliverystatus,
                                  onChanged: (value) {
                                    setState(() {
                                      deliverystatus=value;
                                    });
                                  },
                                  items: listitem.map((valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem,
                                      child: Text(valueItem),
                                    );
                                  }).toList(),
                                ),

                              ),
                            ),

                          ),
                          /*
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Deliverystatus(yes/no)',
                              prefixIcon: Icon(Icons.add_location),
                            ),
                            onChanged: (val){
                              deliverystatus=val;
                            },
                          ),*/
                        ),
                        RaisedButton(
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                          onPressed:(){

                            Itemservice().addItem(itemname,description,price,quantity,category,deliverystatus,_image).then((val){
                              Fluttertoast.showToast(
                                msg: val.data['msg'],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              showBigTextNotification();
                             // notification.showBigTextNotification();
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>Showitem()));

                            });
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
}
