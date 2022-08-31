import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    fetchWishlist();
    super.initState();
  }
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/wishlist/getUsersList";
  var _wishJson = [];
  void fetchWishlist() async {
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
      print(_wishJson);
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
      body:Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _wishJson.length,
                itemBuilder: (BuildContext context, index){
                  final item = items[index];
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
                     //   Navigator.push(context, MaterialPageRoute(builder: (context) => Shopview(id: "${data[index].shopId.id}",),));
                      },
                      child: Card(
                        color: Colors.lightBlue.shade100,
                        margin: EdgeInsets.all(10),
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                            title: Text("${_wishJson[index]['cartTotalPrice']}"),
                          subtitle:Text("${_wishJson[index]['cartTotalPrice']}"),
                          trailing: IconButton(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  size: 25,
                                ),
                                onPressed: () {
                                  setState(()async {
                                    await Future.delayed(
                                        Duration(seconds: 2));
                                    //addtocart(data[index].id,1,data[index].price);
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
            ),
          )
        ],
      )
    );
  }
}
