import 'dart:convert';
import 'dart:io';
import 'package:blogapp/shop/Chart.dart';
import 'package:blogapp/shop/DataModel.dart';
import 'package:blogapp/shop/itemservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:fluttertoast/fluttertoast.dart';



class expertprofile extends StatefulWidget {
//  final Album cases;
  _expertprofileState createState() => _expertprofileState();
}

class _expertprofileState extends State<expertprofile> {
  final Itemservice api = Itemservice();
  final storage = FlutterSecureStorage();
  File _image;
  final picker = ImagePicker();
  String shopName;
  String email;
  String shopid;
  var _shopjson;
  String _imagepath;
  List<Widget> widgets = [expertprofile(), Chart()];
  void fetchshop() async {
    print('Shop');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/getUsersShop'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');

      print('ERROR FOR SHOW : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _shopjson = jsonData;
        shopName = _shopjson['shopName'].toString();
        email = _shopjson['email'].toString();
        shopid = _shopjson['_id'].toString();

      });
    } catch (err) {}
  }
  var _itemsJson = [];
  void fetchitems() async {
    print('item');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/getUsersShop'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');

      print('ERROR FOR SHOW : ${response.body}');
      final jsonData = jsonDecode(response.body)['data']['shopItems'];
      setState(() {
        _itemsJson = jsonData;


      });
    } catch (err) {}
  }
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  void SaveImage(path) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("imagepath", path);
    print(path);
  }

  Future deletePost(String id) async {
    print(id);
    final response =
    await http.delete("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/deleteItem/$id");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
  Future<DataModel> DeleteData(String id)async{
    var response=await http.post(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/$id'),
        body:{"shopId":shopid,});
    var data=response.body;
    print(data);
    if(response.statusCode==201){
      String responseString=response.body;
      dataModelFromJson(responseString);
    }
  }
  Future<String> deleteWithBodyExample(String id) async {
    print(id);
    print(shopid);
    final url = Uri.parse("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/$id");
    final request = http.Request("DELETE", url);
    request.headers.addAll(<String, String>{
      "Accept": "application/json",
    });
    request.body = jsonEncode({"shopId": shopid});
    final response = await request.send();
    if (response.statusCode != 200)
      return Future.error("error: status code ${response.statusCode}");
    return await response.stream.bytesToString();
  }
  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
  }

  void initState() {
    fetchitems();
    loadImage();
    fetchshop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String city = "Ja-ela";
    return Scaffold(

      //AssetImage("assets/architect.jpg")
      body: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 1)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Center(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "ShopName :${shopName.toString()}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    child: _image != null
                                        ? Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        image: DecorationImage(
                                          image: NetworkImage('https://govibucket01.s3.amazonaws.com/N1xVmQtgz-devil_may_cry_character_wings_army_light_sword_21828_1920x1080.jpg'),
                                        ),
                                      ),
                                    )
                                        : Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/myweb-72a93.appspot.com/o/govipiyasa%2Fshop.jpg?alt=media&token=fbe35e0b-76fc-4f7c-ad9b-730b9476860c'),
                                        ),
                                      ),
                                    ),
                                  ), /*
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.greenAccent)),
                                    child: Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 140,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                'https://firebasestorage.googleapis.com/v0/b/myweb-72a93.appspot.com/o/govipiyasa%2Fshop.jpg?alt=media&token=fbe35e0b-76fc-4f7c-ad9b-730b9476860c'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),*/
                                ]),
                          ),
                        ),
                      ]),
                ),
              ),
              Container(
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${shopid.toString()}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Center(
                            child: Column(children: [
                              GestureDetector(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            chooseImage(ImageSource.gallery);
                                          },
                                          icon: Icon(Icons.camera_alt_sharp)),
                                      IconButton(
                                          onPressed: () {
                                            SaveImage(_image.path);
                                            Fluttertoast.showToast(
                                              msg: "Saved",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          },
                                          icon: Icon(Icons.api_outlined)),
                                    ]),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(width: 5.0),
                      ]),
                ),
              ),
              Divider(),
              Container(

                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                        ),
                      ),
                      width: 185,

                      child: const Center(child: Text('Items', style: TextStyle(fontSize: 18, color: Colors.lightGreen),)),
                    ),
                    Container(

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                        ),
                      ),
                      width: 185,

                      child: const Center(child: Text('RentItems', style: TextStyle(fontSize: 18, color: Colors.green),)),
                    ),


                  ],
                ),
              ),

            ],
          ),
        ),
      ),

    );
  }

  Future loadImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = pref.getString("imagepath");
      _image = File(_imagepath.toString());
    });
    print(_imagepath);
  }
}
