
import 'package:blogapp/Cart/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';


class CartNew extends StatelessWidget {
  const CartNew({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context){
        return MaterialApp(
          title: 'New Cart',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home:ProductListScreen(),
        );
      }),

    );
  }
}

