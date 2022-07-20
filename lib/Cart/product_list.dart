import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:blogapp/shop/shopview.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'Db_helper.dart';
import 'cart_model.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {


  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  ] ;
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/";
  var _itemsJson = [];
  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(url));
      final jsonData = jsonDecode(response.body)['data'] as List;
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
  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart  = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value , child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                  },
                ),
                animationType: BadgeAnimationType.fade,
                animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),

          SizedBox(width: 20.0)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _itemsJson.length,
                itemBuilder: (context, index){
                  final item = _itemsJson[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                height: 100,
                                width: 100,
                                image: NetworkImage(productImage[index].toString()),
                              ),
                              SizedBox(width: 10,),

                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${item['productName']}" ,
                                      style: TextStyle(fontSize: 16,  fontFamily: 'Roboto',fontWeight: FontWeight.bold,),
                                    ),
                                    SizedBox(height: 5,),
                                    Text("Rs${item['price']}" ,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    Text("${item['categoryName']}",style: TextStyle(
                                      color: Colors.blue,
                                    )),
                                    SizedBox(height: 5,),
                                    Container(
                                      child:IconButton(
                                          icon: Icon(Icons.store,size: 30,),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Shopview(
                                                      id:'${item['shopId']['_id']}',
                                                      text: '${item['shopId']['shopName']}',
                                                      price: '${item['shopId']['email']}',
                                                      image:'https://source.unsplash.com/random?sig=$index',
                                                      description: '${item['shopId']['address']}',
                                                      quantity: '${item['shopId']['rating']}',
                                                      category: '${item['categoryName']}',
                                                      itemCount:'${item['shopId']['itemCount']}',
                                                      shopitems:'${item['shopId']['shopItems']}',
                                                      latlang:'${item['shopId']['location']['coordinates'][0]}',
                                                      longitude:'${item['shopId']['location']['coordinates'][1]}'

                                                  ),

                                                ));
                                          }),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: (){
                                          print(index);
                                          print(index);
                                          print("${item['productName']}");
                                          print( productPrice[index].toString());
                                          print(item['price']);
                                          print('1');
                                          print(productUnit[index].toString());
                                          print(productImage[index].toString());

                                          dbHelper.insert(
                                              Cart(
                                                  id: index,
                                                  productId: index.toString(),
                                                  productName: "${item['productName']}",
                                                  initialPrice: item['price'],
                                                  productPrice: item['price'],
                                                  quantity: 1,
                                                  unitTag: productUnit[index].toString(),
                                                  image: productImage[index].toString())
                                          ).then((value){

                                            cart.addTotalPrice(double.parse( item['price'].toString()));
                                            cart.addCounter();

                                            final snackBar = SnackBar(backgroundColor: Colors.green,content: Text('Product is added to cart'), duration: Duration(seconds: 1),);

                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                          }).onError((error, stackTrace){
                                            print("error"+error.toString());
                                            final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Product is already added in cart'), duration: Duration(seconds: 1));

                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          });
                                        },
                                        child:  Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: const Center(
                                            child:  Text('Add to cart' , style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height:2.0),

                                  ],
                                ),
                              ),


                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),

        ],
      ),
    );
  }
}
