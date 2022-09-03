import 'dart:convert';

import 'package:blogapp/shop/ShopProfile/shopview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
class Wishlist extends StatefulWidget {
  const Wishlist({Key key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
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
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    isLoading1();
    fetchWishlist();
    super.initState();
  }
  bool isLoading;
  void isLoading1() async{
    setState(() {
      isLoading=true;
      fetchWishlist();
    });

    await Future.delayed(
        Duration(seconds: 4));

    setState(() {
      isLoading=false;
    });

  }
  var length=[];
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/wishlist/getUsersList";
  var _wishJson = [];
  Future fetchWishlist() async {
    print("wishlist");
    String token = await storage.read(key: "token");
    try {
      final response = await get(Uri.parse(url),headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      final jsonData = jsonDecode(response.body)['data']['listItems'] as List;
      print(jsonData);
      setState(() {
        _wishJson = jsonData;


      });
      print("==================================");
      print(_wishJson);
      print("==================================");
    } catch (err) {}
  }

  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*  appBar: AppBar(
        title: Text("WishList"),
        backgroundColor: Colors.white,
      ),*/
      body:isLoading==true?SizedBox(child: Center(
        child: CircularProgressIndicator(),
      ),):Column(
        children: [
          Expanded(
        child:FutureBuilder(
          future: fetchWishlist(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: ListView.builder(
                  itemCount: _wishJson.length,
                  itemBuilder: (BuildContext context, index){
                    final item = items[index];

                     length=_wishJson[index]['item']['thumbnail'];
                    return Dismissible(
                      key: Key(item),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          _wishJson.removeAt(index);
                        });
                        Scaffold
                            .of(context)
                            .showSnackBar(SnackBar(content: Text(" dismissed")));
                      },
                      child: GestureDetector(
                        onTap:(){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Shopview(id: "${_wishJson[index]['_id']}",),));
                        },
                        child: Card(
                          color:HexColor("#e9fce4"),
                          margin: EdgeInsets.all(10),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text("${_wishJson[index]['item']['productName']}"),
                            subtitle:Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:[

                                  Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                      children:[
                                        Text("Rs:${_wishJson[index]['item']['price']}",style:TextStyle(color:Colors.red)),
                                        IconButton(
                                            icon: Icon(
                                              Icons.store,
                                              size: 25,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Shopview(
                                                      id: "${_wishJson[index]['shop']}",),
                                                  ));


                                            }),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children:[
                                              Text("(${_wishJson[index]['item']['rating']})"),
                                              buildRating1(double.parse("${_wishJson[index]['item']['rating']}")),
                                            ]
                                        )



                                      ]),

                                ]),

                            leading:Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),

                              ),
                              child:Image(
                                height: 80,
                                width: 80,
                                image:length.length==0?NetworkImage(
                                    "https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80"):NetworkImage("${_wishJson[index]['item']['thumbnail'][0]['img']}"),
                              ),
                            ),
                            trailing:
                            IconButton(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  size: 25,
                                ),
                                onPressed: () {
                                  setState(()async {
                                    await Future.delayed(
                                        Duration(seconds: 2));
                                    addtocart(_wishJson[index]['_id'],1,_wishJson[index]['item']['price']);
                                    Scaffold.of(context).showSnackBar(new SnackBar(
                                        content: new Text("Item Added to Cart")
                                    ));
                                  });
                                  /*   Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Shopview(
                                          id: "${data[index].shopId.id}",),
                                      ));*/
                                }),




                          ),
                        ),
                      ),
                    );
                  }




              ),);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        })

          )
        ],
      )
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
