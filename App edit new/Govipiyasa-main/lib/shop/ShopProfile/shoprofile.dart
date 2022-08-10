import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blogapp/Screen/Navbar/Delivery.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/shop/ShopProfile/updateitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Chart.dart';


import '../DataModel.dart';
import 'Editshop.dart';
import '../item.dart';
import '../itemservice.dart';

class Showitem extends StatefulWidget {
//  final Album cases;
  _ShowitemState createState() => _ShowitemState();
}

class _ShowitemState extends State<Showitem> with TickerProviderStateMixin{
  String textFromField='Loading....';
  getData()async{
    String response;
    response =await rootBundle.loadString('text/policy');
    setState(() {
      textFromField=response;
    });
  }
  final Itemservice api = Itemservice();
  final storage = FlutterSecureStorage();
  File _image;
  final picker = ImagePicker();
  String shopName;
  String email;
  String shopid;
  String rating;
  String address;

  var _shopjson;
  String _imagepath;
  List<Widget> widgets = [Showitem(), Chart()];
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
        rating = _shopjson['rating'].toString();
        address = _shopjson['address'].toString();

      });
      print(rating.toString());
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
    SaveImage(_image.path);
  }
  AnimationController controller;
  void initState() {
    getData();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: false);
    fetchitems();
    loadImage();
    fetchshop();
    super.initState();
  }

  Future<Item> updatestatus(String id) async {
    print(id);
    final response = await http.put(
      Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/setShopVisibility/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'status':"Block",

      }),
    );
    print(response.body);

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {

      throw Exception('Failed to Deactivate.');
    }
  }
  /*_shopjson==null?Center(
  child: CircularProgressIndicator(
  value: controller.value,
  semanticsLabel: 'Linear progress indicator',
  ),
  ):*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //AssetImage("assets/architect.jpg")
      body:Container(
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
                                    "${shopName.toString()}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                  Container(
                                    width: 340,
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 1.0),
                                          child:Material(
                                            type: MaterialType.transparency,
                                            child: Ink(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.green, width: 2.0),
                                                color: Colors.lightGreen,
                                                shape: BoxShape.circle,
                                              ),
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(500.0),
                                                onTap: () {   Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Editshop(id:"${shopid}",shopName:"${shopName}",email:"${email}",address:"${address}"),
                                                    ));},
                                                child: Padding(
                                                  padding: EdgeInsets.all(2.0),
                                                  child: Icon(
                                                    Icons.article_sharp,
                                                    size: 25.0,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                  ),),

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
                                  ),
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
                          "${email.toString()}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15.0,
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star,color: Colors.yellow,),
                              Text(
                                "${rating.toString()}",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          )
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
                             /*         IconButton(
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
                                          icon: Icon(Icons.api_outlined)),*/
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
                        ),),
                      width: 185,
                      child: const Center(child: Text('RentItems', style: TextStyle(fontSize: 18, color: Colors.green),)),
                    ),],
                ),
              ),
              Container(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: _itemsJson.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = _itemsJson[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.lightGreen, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                              onTap: () {
                                /*   Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Itemdetails(text: '${data[index].producyName}',price:'${data[index].description}',image:'https://source.unsplash.com/random?sig=$index',description:'${data[index].description}',quantity:'${data[index].description}',category:'${data[index].description}'),
                                  ));*/
                              },
                              title: Column(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://source.unsplash.com/random?sig=$index',
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                    ),
                                    onTap: () {

                                      //Navigator.push(context,MaterialPageRoute(
                                      //builder: (context) => Shopview(text: '${data[index].producyName}',price:'${data[index].description}',image:'https://source.unsplash.com/random?sig=$index',description:'${data[index].description}',quantity:'${data[index].description}',category:'${data[index].description}'),));
                                    },
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${item['description']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),

                                        Text("Rs:${item['price']}"),

                                        Container(child:Row(
                                          children:[
                                            Text("${item['quantity']}"),
                                            SizedBox(width: 40,),
                                            GestureDetector(
                                              child: Icon(
                                                FontAwesomeIcons.eye,
                                                size: 25.0,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Itemdetails(text: '${item['productName']}',price:'${item['price']}',image:'https://source.unsplash.com/random?sig=$index',description:'${item['description']}',quantity:'${item['quantity']}',category:'${item['categoryName']}'),
                                                    ));
                                              },
                                            ),
                                          ]
                                        ))
                                      ])
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      FontAwesomeIcons.edit,
                                      size: 22.0,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Updateitem(
                                                id: '${item['_id']}',
                                                productName: '${item['productName']}',
                                                description:
                                                    '${item['description']}',
                                                price: '${item['price']}',
                                                quantity: '${item['quantity']}',
                                                categoryName: '${item['categoryName']}',
                                                image: '${item['image']}'),
                                          ));
                                    },
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 120.0,

                                      margin: EdgeInsets.all(10.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.green, width: 1),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        color: Colors.white,
                                        elevation: 5,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                          children: <Widget>[

                                            Image.asset(
                                              'assets/Delivery.png',
                                              width: 90.0,
                                              height: 90.0,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Container(
                                              child: Text('Domex',
                                                  style: TextStyle(color: Colors.green, fontSize: 20)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) =>Delivery()));
                                    },
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      FontAwesomeIcons.trash,
                                      size: 22.0,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                     // deletePost(item['_id']);
                                     // deleteItem(item['_id']);
                                  //    deleteWithBodyExample(item['_id']);
                                      DeleteData(item['_id']);
/*
                                      Fluttertoast.showToast(
                                        msg: "Deleted",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );*/
                                    },
                                  ),

                                ],
                              )),
                        ),
                      );
                    }),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: ()async {
                 //
                  alert(context);

                },
                child: Text("Deactivate shop",
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

    );
  }

  void alert(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: "Shop Deactivate",
      buttonsTextStyle: const TextStyle(color: Colors.black),
      showCloseIcon: true,
      btnOkOnPress: () {
        updatestatus(shopid);
      },
    ).show();
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

