import 'dart:convert';

import 'package:blogapp/checkout/models/cart.dart';
import 'package:blogapp/checkout/models/products.dart';
import 'package:blogapp/checkout/screens/homepage.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/checkout/widgets/pdt_item.dart';

import 'package:blogapp/shop/shopview.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Allproduct extends StatefulWidget {
  @override
  _AllproductState createState() => _AllproductState();
}
class User {
  final String itemname;
  final String description;
  User({this.itemname, this.description});
}
class _AllproductState extends State<Allproduct> {
  List<String> categories = ["Plants", "Seeds", "Equipment"];
  int selectIndex = 0;
  bool order=true;
  double rating = 0;
  final url = "https://mongoapi3.herokuapp.com/items";
  var _itemsJson = [];

  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;
      setState(() {
        _itemsJson = jsonData;
      });
    } catch (err) {}
  }

  void initState() {
    super.initState();
    fetchPosts();
    _itemsJson.sort();
  }

//final List<itemmodel> itemdata=List.generate(_itemsJson.length, (index) => null)
  @override
  Widget build(BuildContext context) {
    // var myobj;
    final pdt = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 3.0,
            ),
            Container(
              child:IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(
                  Icons.sort_outlined,
                  size: 30,

                ),
                onPressed: (){
                  setState(() {
                    order=false;
                  });
                },
              ),
            ),

            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                    ),
                    width: 200,
                    child: const Center(
                        child: Text(
                          'Seeds',
                          style: TextStyle(fontSize: 18, color: Colors.lightGreen),
                        )),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                    ),
                    width: 200,
                    child: const Center(
                        child: Text(
                          'Plants',
                          style: TextStyle(fontSize: 18, color: Colors.lightGreen),
                        )),
                  ),
                  SizedBox(
                    width: 2.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                    ),
                    width: 200,
                    child: const Center(
                        child: Text(
                          'Equipment',
                          style: TextStyle(fontSize: 18, color: Colors.lightGreen),
                        )),
                  ),
                ],
              ),
            ),
           order!=true? GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _itemsJson.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1),
                itemBuilder: (BuildContext context, int index) {
                  int reverseorder=_itemsJson.length-1-index;
                  final item = _itemsJson[reverseorder];

                  final qty = _itemsJson[reverseorder]['quantity'];

                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.lightGreen, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Image.network(
                            "https://source.unsplash.com/random?sig=$index",
                            height: 250,
                          ),
                        ),
                        ListTile(
                          isThreeLine: true,
                          leading: GestureDetector(
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                  'https://source.unsplash.com/random?sig=$index'),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Shopview(
                                        text: '${item['itemname']}',
                                        price: '${item['price']}',
                                        image:
                                        'https://source.unsplash.com/random?sig=$index',
                                        description: '${item['description']}',
                                        quantity: '${item['quantity']}',
                                        category: '${item['category']}'),
                                  ));
                            },
                          ),
                          title: Text("Item:${item['itemname']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Price:Rs${item['price']}"),
                              Container(
                                child: qty == 0
                                    ? Text("Quantity:out of stock",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ))
                                    : Text("Quantity:${item['quantity']}"),
                              ),
                              buildRating(),
                            ],
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.shopping_cart),
                              onPressed: () {
                             //   Something._counter++;
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text('Item Added to Cart'),
                                ));
                                //String num="$item['price']";
                                double myDouble =
                                double.parse("${item['price']}");
                                cart.addItem("${item['itemname']}",
                                    "${item['itemname']}", myDouble);
                              }),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Itemdetails(
                                      text: '${item['itemname']}',
                                      price: '${item['price']}',
                                      image:
                                      'https://source.unsplash.com/random?sig=$index',
                                      description: '${item['description']}',
                                      quantity: '${item['quantity']}',
                                      category: '${item['category']}'),
                                ));
                          },
                        ),
                      ],
                    ),
                  );
                }):GridView.builder(
               physics: ScrollPhysics(),
               shrinkWrap: true,
               itemCount: _itemsJson.length,
               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 1),
               itemBuilder: (BuildContext context, int index) {
                 final item = _itemsJson[index];

                 final qty = _itemsJson[index]['quantity'];

                 return Card(
                   shape: RoundedRectangleBorder(
                     side: BorderSide(color: Colors.blue, width: 1),
                     borderRadius: BorderRadius.circular(10),
                   ),
                   elevation: 10.0,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Container(
                         padding: EdgeInsets.only(left: 5.0, right: 5.0),
                         decoration: BoxDecoration(
                           border:
                           Border.all(color: Colors.lightGreen, width: 1),
                           borderRadius:
                           BorderRadius.all(Radius.circular(5.0)),
                         ),
                         child: Image.network(
                           "https://source.unsplash.com/random?sig=$index",
                           height: 250,
                         ),
                       ),
                       ListTile(
                         isThreeLine: true,
                         leading: GestureDetector(
                           child: CircleAvatar(
                             radius: 28,
                             backgroundImage: NetworkImage(
                                 'https://source.unsplash.com/random?sig=$index'),
                           ),
                           onTap: () {
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => Shopview(
                                       text: '${item['itemname']}',
                                       price: '${item['price']}',
                                       image:
                                       'https://source.unsplash.com/random?sig=$index',
                                       description: '${item['description']}',
                                       quantity: '${item['quantity']}',
                                       category: '${item['category']}'),
                                 ));
                           },
                         ),
                         title: Text("Item:${item['itemname']}"),
                         subtitle: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Text("Price:Rs${item['price']}"),
                             Container(
                               child: qty == 0
                                   ? Text("Quantity:out of stock",
                                   style: TextStyle(
                                     color: Colors.red,
                                   ))
                                   : Text("Quantity:${item['quantity']}"),
                             ),
                             buildRating(),
                           ],
                         ),
                         trailing: IconButton(
                             icon: Icon(Icons.shopping_cart),
                             onPressed: () {
                               Scaffold.of(context).showSnackBar(SnackBar(
                                 duration: Duration(seconds: 3),
                                 content: Text('Item Added to Cart'),
                               ));
                               //String num="$item['price']";
                               double myDouble =
                               double.parse("${item['price']}");
                               cart.addItem("${item['itemname']}",
                                   "${item['itemname']}", myDouble);
                             }),
                         onTap: () {
                           Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => Itemdetails(
                                     text: '${item['itemname']}',
                                     price: '${item['price']}',
                                     image:
                                     'https://source.unsplash.com/random?sig=$index',
                                     description: '${item['description']}',
                                     quantity: '${item['quantity']}',
                                     category: '${item['category']}'),
                               ));
                         },
                       ),
                     ],
                   ),
                 );
               })
          ],
        ),
      ),
    );
  }

  Widget buildRating() => RatingBar.builder(
    minRating: 1,
    itemSize: 10,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: true,
    onRatingUpdate: (rating) => setState(() {
      this.rating = rating;
    }),
  );
}
