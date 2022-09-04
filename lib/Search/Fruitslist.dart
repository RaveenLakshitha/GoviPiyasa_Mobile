import 'dart:convert';

import 'package:blogapp/NewCart/CartScreenNew.dart';

import 'package:blogapp/Search/search.dart';
import 'package:blogapp/Search/user_model.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/shop/ShopProfile/shopview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'Api_service.dart';

class FruitsList extends StatefulWidget {
  @override
  _FruitsListState createState() => _FruitsListState();
}

class _FruitsListState extends State<FruitsList>
    with SingleTickerProviderStateMixin {
  String category="Fruits";

  @override
  void initState() {
    itemCategory();

    super.initState();
  }
  FetchUserList _userList = FetchUserList();


  FlutterSecureStorage storage = FlutterSecureStorage();
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
  bool _isLoading = false;
  var _itemCategory = [];

  void itemCategory() async {

    try {
      final response = await get(Uri.parse("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/getItemsByParentCategory/63116f6796b22674427884a0"));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _itemCategory = jsonData;
      });
      print(_itemCategory);
      //print(_itemCategory[3]['Information'][0]['Title'].toString());
    } catch (err) {}
  }
  @override
  Widget build(BuildContext context) {
    //final cart1 = Provider.of<providerCart >(context);
    return SafeArea(
      child: Scaffold(
        /*      appBar: AppBar(
          title: Text('Product List'),
          leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchUser());
              },
              icon: Icon(Icons.search_sharp, color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreenNew()));
              },
              icon: Icon(Icons.shopping_bag_outlined, color: Colors.black),
            ),
            SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 6,
            ),
          ],
        ),*/
        body: _isLoading==true?SizedBox(child:Center(child:CircularProgressIndicator())):Column(
          children: [
            Expanded(
              //  padding: EdgeInsets.all(15),
              child: FutureBuilder<List<Userlist>>(
                  future: _userList.getuserList(),
                  builder: (context, snapshot) {
                    var data = snapshot.data;
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 2 / 2.5,
                            crossAxisCount: 2),
                        itemCount: _itemCategory?.length,
                        shrinkWrap: true,
                        primary: false,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {

                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Itemdetails(
                                      id:"${_itemCategory[index]['_id']}",
                                      text: "${_itemCategory[index]['productName']}",
                                      price: "${_itemCategory[index]['price']}",
                                      image: '${_itemCategory[index]['thumbnail'][0]['img']}',
                                      description: "${_itemCategory[index]['description']}",
                                      quantity: "${_itemCategory[index]['quantity']}",
                                      category: "${_itemCategory[index]['parentCategoryName']}",
                                      shopPic1:_itemCategory[index]['productPictures'],
                                    ),

                                  ));
                            },
                            child: Container(
                              // color: Colors.black,
                              //  height: 300,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 5.0,
                                // color: index.isEven
                                //     ? Colors.lightBlue[200]
                                //     : Colors.lightGreen[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                              color: Colors.lightBlueAccent,
                                            ),
                                            child:Image(
                                              height: 80,
                                              width: 80,
                                              image:_itemCategory[index]['thumbnail'][0]['img']!=''?NetworkImage(
                                                  "${_itemCategory[index]['thumbnail'][0]['img']}"):NetworkImage(
                                                  "https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80"),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${_itemCategory[index]['productName']}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  "Rs:${_itemCategory[index]['price']}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.w500),
                                                ),

                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Container(
                                                  child: _itemCategory[index]['quantity'] ==
                                                      0
                                                      ? Text(
                                                      "Quantity:out of stock",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ))
                                                      : Text(
                                                      "${_itemCategory[index]['quantity']}",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      )),
                                                ),
                                                buildRating1(
                                                    double.parse("${_itemCategory[index]['rating']}")),



                                                SizedBox(height: 2.0),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: IconButton(
                                                  onPressed: () {
                                                    addtowishlist("${data[index].id}");
                                                    Scaffold.of(context).showSnackBar(new SnackBar(
                                                        content: new Text("Item Added to wishlist")
                                                    ));
                                                   /* Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => Itemdetails(
                                                            text: "${_itemCategory[index]['productName']}",
                                                            price: "${_itemCategory[index]['price']}",
                                                            image: '${_itemCategory[index]['thumbnail'][0]['img']}',
                                                            description: "${_itemCategory[index]['description']}",
                                                            quantity: "${_itemCategory[index]['quantity']}",
                                                            category: "${_itemCategory[index]['parentCategoryName']}",
                                                            //   category: "${data[index].categoryName}"
                                                          ),
                                                        ));*/
                                                  },
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons.store,
                                                      size: 25,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(context, MaterialPageRoute(
                                                            builder: (context) => Shopview(
                                                              id: "${_itemCategory[index]['shopId']}",),
                                                          ));
                                                    }),
                                              ),
                                              Align(
                                                alignment:
                                                Alignment.bottomLeft,
                                                child: InkWell(
                                                  onTap: () async{
                                                    /*  setState(() {
                                                    _isLoading=true;
                                                  });*/
                                                    setState(()async {
                                                      await Future.delayed(
                                                          Duration(seconds: 2));
                                                      addtocart(data[index].id,1,data[index].price);
                                                      Scaffold.of(context).showSnackBar(new SnackBar(
                                                          content: new Text("Item Added to Cart")
                                                      ));
                                                    });

                                                    /*     setState(() {
                                                    _isLoading=false;
                                                  });*/
                                                    /*  Navigator.pop(context);
                                                      addtocart(data[index].id,
                                                          1, data[index].price);
                                                      Navigator.pop(context);*/
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8),
                                                      image:
                                                      new DecorationImage(
                                                        image: new AssetImage(
                                                            "assets/shopping_cart.png"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );




                        });
                  }),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildRating1(rating) => RatingBar.builder(
    minRating: 1,
    itemSize: 10,
    initialRating: rating,
    itemPadding: EdgeInsets.symmetric(horizontal: 2),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: false,
    onRatingUpdate: (rating) => setState(() {
      //this.rating = rating;
    }),
  );
}




