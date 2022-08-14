import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
class Wishlist extends StatefulWidget {
  const Wishlist({Key key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  void initState() {
    // TODO: implement initState
    fetchPosts();
    super.initState();
  }
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/cart";
  var _wishJson = [];
  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;
      print(jsonData);
      setState(() {
        _wishJson = jsonData;
      });
    } catch (err) {}
  }

  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("WishList"),
      ),
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
                    child: ListTile(title: Text("${_wishJson[index]['cartTotalPrice']}")),
                  );

                }
            ),
          )
        ],
      )
    );
  }
}
