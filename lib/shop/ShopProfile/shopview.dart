import 'dart:convert';
import 'package:blogapp/Architectureprofile/constants.dart';
import 'package:blogapp/Screen/Maps/Map2.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/checkout/widgets/viewgallery.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:blogapp/shop/custom/BorderIcon.dart';

import 'package:blogapp/shop/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class Shopview extends StatefulWidget {
  final String id;

  Shopview({this.id});

  @override
  State<Shopview> createState() => _ShopviewState(id);
}

class _ShopviewState extends State<Shopview> {
  String name;
  String message;
  final String id;
  String shopname;
  String email;
  String address, contact;
  String pic;
  List pic2;
  String rating1;
  List shopPictures;
  List doc;
  List shopItems1;

  _ShopviewState(this.id);

  var _shopitems;
  double lat1, long1;
  FlutterSecureStorage storage = FlutterSecureStorage();

  void fetchShop(id) async {
    print("shopview");
    print(id);

    try {
      String token = await storage.read(key: "token");
      final response = await get(
          Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/$id'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          });
      print("==========================");
      //print(response.body);
      print("==========================");
      final jsonData = jsonDecode(response.body)['data'];
      print(jsonData);
      setState(() {
        _shopitems = jsonData;
        shopname = _shopitems['shopName'];
        email = _shopitems['email'];
        address = _shopitems['address'];
        contact = _shopitems['contactNumber'];
        pic = _shopitems['profilePic'][0]['img'];
        shopPictures = _shopitems['shopPictures'];
        rating1 = _shopitems['rating'].toString();
        lat1 = _shopitems['location']['coordinates'][0];
        long1 = _shopitems['location']['coordinates'][1];
        doc = _shopitems['proofDocs'];
        shopItems1=_shopitems['shopItems'];

        //pic2=_shopitems[' proofDocs'][0];
      });
      print(pic2);
      print("=========================");
    } catch (err) {}
  }


  var _shopjson = [];
  addtowishlist(id) async {
    String token = await storage.read(key: "token");
    print(token);
    print(id);
    final body = {"item": id};
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/listItems",
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        print(json.decode(response.body));

      }
    });
  }
  addtocart(id, amount, unitPrice) async {
    String token = await storage.read(key: "token");
    print(token);
    print(id);

    final body = {"item": id, "amount": amount, "unitPrice": unitPrice};
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cartItems",
      body: jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }
/*  void infocategory(String id) async {
    print(id);
    try {
      final response = await get(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/information/getInfoByCategory/$id'));
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _shopjson = jsonData;
      });
      //print("infodetails");
      print(_shopjson);


    } catch (err) {}
  }*/
  double rating;

  void initState() {
    fetchShop(id);
    super.initState();
  }

  Future<http.Response> addrate(String rate,String id) async{
    String token = await storage.read(key: "token");
    return http.post(
      Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/ratings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'rating': rate,
        'shopId':id
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _shopitems == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: size.width,
                height: size.height,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [

                              Center(child: Image.network("${pic}")),
                              Positioned(
                                width: size.width,
                                top: padding,
                                child: Padding(
                                  padding: sidePadding,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: BorderIcon(
                                          height: 50,
                                          width: 50,
                                          child: Icon(
                                            Icons.keyboard_backspace,
                                            color: Colors.lightGreen,
                                          ),
                                        ),
                                      ),
                                      BorderIcon(
                                        height: 50,
                                        width: 50,
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: Colors.lightGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(padding),
                          Padding(
                            padding: sidePadding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BorderIcon(
                                  child: Text("${shopname}".toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF545D68))),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),

                                Text('${email}',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text('${address}',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                //Text(shopitems),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Map2(
                                            lat: lat1,
                                            long: long1,
                                            name:shopname,
                                            address:address,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.add_location_alt,color:Colors.red)),
                                // Text(id),
                                //  latlang!=null?Text(latlang):Text("null"),
                                // longitude!=null?Text(longitude):Text("null"),
                                //Text(longitude),
                                SizedBox(height: 5.0),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // addVerticalSpace(5),
                                    FlatButton(
                                      onPressed: () => showRating(),
                                      child: Text('Rate Here',
                                          style: TextStyle(fontSize:20,color: Colors.blue)),
                                      /* textColor: Colors.black,
                                shape: RoundedRectangleBorder(side: BorderSide(
                                    color: Colors.blue,
                                    width: 1,
                                    style: BorderStyle.solid
                                )*/
                                      //, borderRadius: BorderRadius.circular(50)),
                                    ),

                                    SizedBox(width: 80.0),
                                    Row(children: [
                                      buildRating1(double.parse("${rating1}")),
                                      // Icon(Icons.star,color: Colors.yellow,),
                                      Text(
                                        "(${rating1})",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // addVerticalSpace(padding),
                          Padding(
                            padding: sidePadding,
                            child: Center(
                                child: Text(
                              "Shop Images",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF545D68)),
                            )),
                          ),
                          // addVerticalSpace(padding),

                          //  addVerticalSpace(padding),
                          addVerticalSpace(10),
                          //  addVerticalSpace(100),
                          Container(
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: shopPictures.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => viewgallery(
                                                  image: shopPictures[index]
                                                      ["img"])));
                                    },
                                    child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.all(
                                        //     Radius.circular(10.0)),
                                        color: const Color(0x1A0097A7)
                                            .withOpacity(0.1),
                                      ),
                                      child:
                                      FittedBox(
                                        child:Image.network(

                                            shopPictures[index]["img"]),
                                        fit: BoxFit.fill,
                                      )
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: sidePadding,
                            child: Center(
                                child: Text(
                                  "Items",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF545D68)),
                                )),
                          ),
                          Container(
                            child: GridView.builder(
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemCount: 2,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                 final item = shopItems1[index];
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
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Itemdetails(
                                                          text: '${item['productName']}',price:'${item['price']}',image:'${item['thumbnail'][0]['img']}',description:'${item['description']}',quantity:'${item['quantity']}',category:'${item['categoryName']}'),
                                                    ));
                                              },
                                            ),
                                            SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${item['productName']}",
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
                                                Icons.shopping_cart,
                                                size: 22.0,
                                                color: Colors.black,
                                              ),
                                              onTap: () {
                                                addtocart(shopItems1[index]['_id'],1,shopItems1[index]['price']);
                                                Fluttertoast.showToast(
                                                  msg: "Add item to cart",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0,
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),


                                            GestureDetector(
                                              child: Icon(
                                                Icons.favorite,
                                                size: 22.0,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                addtowishlist(shopItems1[index]['_id']);
                                               // DeleteData(item['_id']);

                                                Fluttertoast.showToast(
                                                  msg: "Add items to wish list",
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
                          addVerticalSpace(10),
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
                          addVerticalSpace(10),
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
                                                          padding: const EdgeInsets
                                                                  .symmetric(
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
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 50,
                            child: RaisedButton(
                              splashColor: Colors.lightGreen,
                              padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                              color: Colors.black,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.message,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Message",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              onPressed: () {
                                print("hello");
                                lanchwhatsapp(
                                    number: "+94${contact}", message: "hello");
                                //launchUrl("mailto: $price?subject=From $price&body=$message");
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                            ),
                          ),
                          addHorizontalSpace(10),
                          SizedBox(
                            width: 120,
                            height: 50,
                            child: RaisedButton(
                              splashColor: Colors.lightGreen,
                              padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                              color: Colors.black,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Call",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              onPressed: () {
                                launch("tel:${contact}");
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                            ),
                          ),
                          SizedBox(
                            height: 20,
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

  Widget buildRating1(rating) => RatingBar.builder(
        minRating: 1,
        itemSize: 13,
        initialRating: rating,
        itemPadding: EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
        updateOnDrag: false,
        onRatingUpdate: (rating) => setState(() {
          //this.rating = rating;
        }),
      );

  void showRating() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Rate this Shop'),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Please leave a star rating',
                    style: TextStyle(fontSize: 13)),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Text("$rating"),
                    buildRating(),
                  ],
                )
              ]),
          actions: [
            TextButton(
                onPressed: ()async {
setState(() {
  addrate(rating.toString(),id);
});
await Future.delayed(Duration(seconds: 10));
                   Navigator.pop(context);
                   Fluttertoast.showToast(
                     msg: "Rate added",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.BOTTOM,
                     backgroundColor: Colors.red,
                     textColor: Colors.white,
                     fontSize: 16.0,
                   );
                },
                child: Text('Ok', style: TextStyle(fontSize: 20))),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(fontSize: 20)))
          ],
        ),
      );

  _launchURLMail() async {
    const url =
        'mailto:ashennilura@gmail.com?subject=LifePlusApp&body=Your sugestions%20or Feedback..';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildRating() => RatingBar.builder(
        minRating: 1,
        itemSize: 20,
        itemPadding: EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
        updateOnDrag: true,
        onRatingUpdate: (rating) => setState(() {
          this.rating = rating;
        }),
      );

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void lanchwhatsapp({@required number, @required message}) async {
    String url = "whatsapp://send?phone=$number&text=$message";
    await canLaunch(url) ? launch(url) : print("can't open whatsapp");
  }
}
