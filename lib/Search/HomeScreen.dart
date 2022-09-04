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
import 'Equipmentslist.dart';
import 'Fertilizer.dart';
import 'Flowerlist.dart';
import 'Fruitslist.dart';
import 'OrganicFertilizer.dart';
import 'Vegetableslist.dart';

class Searchitems extends StatefulWidget {
  @override
  _SearchitemsState createState() => _SearchitemsState();
}

class _SearchitemsState extends State<Searchitems>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String category;

  @override
  void initState() {
    itemCategory();
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }
  //  @override
  // Widget build(BuildContext context) {
  //   const title = 'Grid List';

  FetchUserList _userList = FetchUserList();


  FlutterSecureStorage storage = FlutterSecureStorage();
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];
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
      final response = await get(Uri.parse("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/itemCategories"));
      final jsonData = jsonDecode(response.body)['data'] as List;
      setState(() {
        _itemCategory = jsonData;
      });
      print(_itemCategory[0]['categoryType']);
      //print(_itemCategory[3]['Information'][0]['Title'].toString());
    } catch (err) {}
  }
  @override
  Widget build(BuildContext context) {
    //final cart1 = Provider.of<providerCart >(context);
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
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
          bottom: TabBar(
              isScrollable: true,
            indicatorColor: Colors.lightGreen,
            //labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
            tabs: [

              Tab(
                  iconMargin: EdgeInsets.zero,
                  icon: Icon(Icons.local_florist_outlined ,),child: Text("Flowers",style:TextStyle(fontSize: 12))),
              Tab(
                  iconMargin: EdgeInsets.zero,
                  icon: FaIcon(FontAwesomeIcons.lemon),child: Text("Fruits",style:TextStyle(fontSize: 12))),
              Tab(
                  iconMargin: EdgeInsets.zero,
                  icon: FaIcon(FontAwesomeIcons.carrot),child: Text("Vegetables",style:TextStyle(fontSize: 12))),
              Tab(
                  iconMargin: EdgeInsets.zero,
                  icon: FaIcon(FontAwesomeIcons.seedling),child: Text("Equipments",style:TextStyle(fontSize: 12))),
              Tab(
                  iconMargin: EdgeInsets.zero,
                  icon: FaIcon(FontAwesomeIcons.euroSign),child: Text("Fertilizer",style:TextStyle(fontSize: 12))),

              Tab(
                  iconMargin: EdgeInsets.zero,
                  icon: FaIcon(FontAwesomeIcons.euroSign),child: Text("OrganicFerilizer",style:TextStyle(fontSize: 12))),
              Tab(
                  iconMargin: EdgeInsets.zero,
                  icon: FaIcon(FontAwesomeIcons.euroSign),child: Text("Medical Plants",style:TextStyle(fontSize: 12))),


            ],
          ),
        ),
        body: _isLoading==true?SizedBox(child:Center(child:CircularProgressIndicator())):TabBarView(
          children: [
            FlowerList(),
            FruitsList(),
            Vegetables(),
            EquipMents(),
            Fertilizer(),
            OrganicFertilizerList(),
            OrganicFertilizerList(),
          ],
        )
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
// Container(
//   height: MediaQuery.of(context).size.height - 200.0,
//   child: TabBarView(
//     controller: tabController,
//     children: <Widget>[],
//   ),
// ),
/*            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Center(
                child: Badge(
                  showBadge: true,

                  animationType: BadgeAnimationType.fade,
                  animationDuration: Duration(milliseconds: 300),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),*/

// SizedBox(height: 6,
//   child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//   children: [for(int i=0; i<categories.length;i++)
//   GestureDetector(
//     onTap: (){
//       setState(() => selectId =categories[i].id);
//     },
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           Categories[i].name,
//           style: TextStyle(
//             color:selectId == 1
//             ?green
//             :black.withOpacity(0.7),
//             fontSize: 16.0;
//           ),
//         )
//       ],
//     ),
//   )],),),


