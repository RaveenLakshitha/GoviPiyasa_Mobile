import 'package:badges/badges.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/checkout/widgets/allproducts.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/cart_screen.dart';

class HomePage1 extends StatelessWidget {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');
  final FocusNode _textFocusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();
  static int _counter;
  @override
  void dispose() {
    _textFocusNode.dispose();
    _textEditingController.dispose();
    //super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              }),
          backgroundColor: Colors.lightGreen,
          title: Container(
            margin: EdgeInsets.fromLTRB(0, 1, 0, 1),

            decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: _textEditingController,
              focusNode: _textFocusNode,
              cursorColor: Colors.black,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
                hintText: 'Search here',
              ),
            ),
          ),
          actions: <Widget>[
        Container(
          child:Badge(
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeContent: Text(
              _counter.toString(),
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () =>
                Navigator.of(context).pushNamed(CartScreen.routeName)),
          )
        ),
       /*     IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  size: 30,
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName))*/
          ],
        ),
        body: Allproduct());
  }
}
