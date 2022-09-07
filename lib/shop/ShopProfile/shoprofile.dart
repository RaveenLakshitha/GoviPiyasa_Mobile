import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blogapp/Architectureprofile/constants.dart';
import 'package:blogapp/Screen/Navbar/Delivery.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/checkout/widgets/viewgallery.dart';
import 'package:blogapp/shop/ShopProfile/updateitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Chart.dart';

import '../DataModel.dart';
import 'Editshop.dart';
import '../itemservice.dart';

class Showitem extends StatefulWidget {
//  final Album cases;
  _ShowitemState createState() => _ShowitemState();
}

class _ShowitemState extends State<Showitem> with TickerProviderStateMixin {
  String textFromField = 'Loading....';

  getData() async {
    String response;
    response = await rootBundle.loadString('text/policy');
    setState(() {
      textFromField = response;
    });
  }

  final Itemservice api = Itemservice();
  final storage = FlutterSecureStorage();
  File _image;
  final picker = ImagePicker();
  String shopName;
  String email;
  String city;
  String shopid;
  String rating;
  String address;
  String contact;
  List profilepic;
  List shopPics;
  String imgurl;
  var _shopjson;
  List doc;
  List shopItems;
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
        profilepic = _shopjson['profilePic'];
        imgurl = profilepic[0]['img'];
        shopPics = _shopjson['shopPictures'];
        city=_shopjson['city'];
        shopItems=_shopjson['shopItems'];
        doc=_shopjson['proofDocs'];
        contact= _shopjson['contactNumber'];

      });
      print(shopPics);
    } catch (err) {}
  }

  //var _itemsJson = [];
  String thumbnail1;
  void fetchrentitems() async {
    print('============items==================');
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

      print('Shop Items : ${response.body}');
      final jsonData = jsonDecode(response.body)['data']['shopItems'];
      setState(() {
       // _itemsJson = jsonData;
        // thumbnail1=_itemsJson['thumbnail'][0]['img'];
      });
     // print(_itemsJson);
    } catch (err) {}
  }

  void SaveImage(path) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("imagepath", path);
    print(path);
  }

  Future deletePost(String id) async {
    print(id);
    final response = await http.delete(
        "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/deleteItem/$id");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<DataModel> DeleteData(String id) async {
    var response = await http.post(
        Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/$id'),
        body: {
          "shopId": shopid,
        });
    var data = response.body;
    print(data);
    if (response.statusCode == 201) {
      String responseString = response.body;
      dataModelFromJson(responseString);
    }
  }

  Future<String> deleteWithBodyExample(String id) async {
    print(id);
    print(shopid);
    final url =
        Uri.parse("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/$id");
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

  void initState() {
    getData();
    fetchrentitems();

    loadImage();
    fetchshop();
    super.initState();
  }

  Future<Item> updatestatus(String id) async {
    print(id);
    final response = await http.put(
      Uri.parse(
          'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/setShopVisibility/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'status': "Block",
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
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return Scaffold(
      //AssetImage("assets/architect.jpg")
      body: _shopjson == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(10.0),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 340,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 1.0),
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: Ink(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.green,
                                                          width: 2.0),
                                                      color: Colors.lightGreen,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              500.0),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Editshop(
                                                                  id:
                                                                      "${shopid}",
                                                                  shopName:
                                                                      "${shopName}",
                                                                  email:
                                                                      "${email}",
                                                                  address:
                                                                      "${address}",
                                                              contact:"${contact}"),
                                                            ));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(2.0),
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: 25.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        viewgallery(
                                                            image:
                                                                "${imgurl}")));
                                          },
                                          child: Container(
                                              height: 200,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                      "${imgurl}"),
                                                ),
                                              )),
                                        ),
                                       Container(
                                            child: Column(children: [
                                              GestureDetector(
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                   /*   IconButton(
                                                          onPressed: () {
                                                            chooseImage(
                                                                ImageSource
                                                                    .gallery);
                                                          },
                                                          icon: Icon(Icons
                                                              .camera_alt_sharp)),*/
                                                      Text(
                                                        "${shopName.toString()}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 30.0,
                                                        ),
                                                      ),

                                                    ]),
                                              ),
                                            ]),
                                       ),
                                        Text(
                                          "${contact.toString()}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        Text(
                                          "${city.toString()}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
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
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                "${address.toString()}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
                              Container(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //   Icon(Icons.star,color: Colors.yellow,),

                                  rating == null
                                      ? buildRating1(double.parse("0"))
                                      : buildRating1(
                                          double.parse(rating.toString())),
                                  Text(
                                    "(${rating.toString()})",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              )),
                              SizedBox(width: 5.0),
                            ]),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                     shopPics.length >0 ?Container(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: shopPics.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => viewgallery(
                                            image: shopPics[index]["img"])));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                 // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  color: const Color(0x1A0097A7).withOpacity(0.1),
                                ),
                                child: Container(

                                    child:Image.network(shopPics[index]["img"])),
                              ),
                            );
                          }),
                    ):Container(child:Center(child:Text("No data"))),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                      ),
                      width: 185,
                      child: const Center(
                          child: Text(
                            'Items',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF545D68))
                          )),
                    ),
                    Container(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: shopItems.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = shopItems[index];
                            return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: BorderSide(
                                      color: Colors.lightGreen, width: 1),
                                ),
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                '${item['thumbnail'][0]['img']}',
                                              ),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                          Container(
                                            child:Row(
                                              children: [
                                                Text("${item['quantity']}"),
                                                SizedBox(width: 40,),
                                                GestureDetector(
                                                  child: Icon(
                                                    FontAwesomeIcons.eye,
                                                    size: 25.0,
                                                    color: Colors.black,
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => Itemdetails(
                                                              text: '${item['productName']}',price:'${item['price']}',image:'${item['thumbnail'][0]['img']}',description:'${item['description']}',quantity:'${item['quantity']}',category:'${item['categoryName']}'),
                                                        ));
                                                  },
                                                ),
                                              ],
                                            )
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  trailing: Column(
                                    children: [
                                      GestureDetector(
                                        child: Icon(
                                          FontAwesomeIcons.edit,
                                          size: 22.0,
                                          color: Colors.black,
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
                                        child: Icon(
                                          FontAwesomeIcons.trash,
                                          size: 22.0,
                                          color: Colors.red,
                                        ),
                                        onTap: () {

                                          DeleteData(item['_id']);

                                          Fluttertoast.showToast(
                                          msg: "Deleted",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )

                            );
                          }),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                      ),
                      width: 185,
                      child: const Center(
                          child: Text(
                            'RentItems',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF545D68))
                          )),
                    ),

                    Padding(
                      padding: sidePadding,
                      child: Center(
                          child: Text(
                              "ProofDocuments",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF545D68))
                          )),
                    ),
                    doc == null
                        ? SizedBox()
                        : Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border:
                        Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: ListView.builder(
                          itemCount: doc.length,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Container(
                              margin:
                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                              height: 160,
                              child: InkWell(
                                onTap: () {},
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    // Those are our background
                                    Container(
                                      height: 116,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                            22),
                                        color: index.isEven
                                            ? kBlueColor
                                            : kSecondaryColor,
                                        boxShadow: [kDefaultShadow],
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(
                                              22),
                                        ),
                                      ),
                                    ),
                                    // our product image
                                    GestureDetector(
                                      onTap: ()
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => viewgallery(
                                                    image:"${doc[index]['img']}")));
                                      },
                                      child: Positioned(
                                        top: 55,
                                        right: 20,
                                        child: Hero(
                                          tag: 'mk',
                                          child: Container(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                kDefaultPadding),
                                            height: 100,
                                            // image is square but we add extra 20 + 20 padding thats why width is 200
                                            width: 160,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "${doc[index]['img']}"),
                                                    fit: BoxFit
                                                        .cover)),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Product title and price
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: SizedBox(
                                        height: 106,
                                        // our image take 200 width, thats why we set out total width - 200
                                        width: 200,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal:
                                                  kDefaultPadding),
                                              child: Text(
                                                "",
                                                style: Theme.of(
                                                    context)
                                                    .textTheme
                                                    .button,
                                              ),
                                            ),
                                            // it use the available space
                                            Spacer(),
                                            /*     Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: kDefaultPadding * 1.5, // 30 padding
                                                vertical: kDefaultPadding / 4, // 5 top and bottom
                                              ),
                                              decoration: BoxDecoration(
                                                color: kSecondaryColor,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(22),
                                                  topRight: Radius.circular(22),
                                                ),
                                              ),
                                              child: Text(
                                                "\$",
                                                style: Theme.of(context).textTheme.button,
                                              ),
                                            ),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
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
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
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

  Widget buildRating1(rating) => RatingBar.builder(
        minRating: 1,
        itemSize: 18,
        initialRating: rating,
        itemPadding: EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
        updateOnDrag: false,
        onRatingUpdate: (rating) => setState(() {}),
      );

  Future loadImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = pref.getString("imagepath");
      _image = File(_imagepath.toString());
    });
    print(_imagepath);
  }
}
