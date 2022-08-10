
import 'package:blogapp/wishlist/product_list.dart';
import 'package:blogapp/wishlist/wish_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class WishNew extends StatelessWidget {
  const WishNew({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider1(),
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

