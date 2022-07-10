import 'package:blogapp/Search/search.dart';
import 'package:blogapp/Search/user_model.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/shop/shopview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Api_service.dart';

class Searchitems extends StatefulWidget {
  @override
  _SearchitemsState createState() => _SearchitemsState();
}

class _SearchitemsState extends State<Searchitems> {
  double rating=4;
  FetchUserList _userList = FetchUserList();
  Widget buildRating(rating1)=>RatingBar.builder(
    minRating: 1,
    itemSize: 20,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder:(context,_)=>Icon(Icons.star,color:Colors.amber),
    updateOnDrag: false,
    onRatingUpdate:(rating)=>setState((){
      this.rating=rating1;
    }),);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchUser());
              },
              icon: Icon(Icons.search_sharp),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: FutureBuilder<List<Userlist>>(
              future: _userList.getuserList(),
              builder: (context, snapshot) {
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context, index) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Itemdetails(text: '${data[index].producyName}',price:'${data[index].description}',image:'https://source.unsplash.com/random?sig=$index',description:'${data[index].description}',quantity:'${data[index].description}',category:'${data[index].description}'),
                                  ));
                            },
                      /*      trailing: IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text('Item Added to Cart'),
                                  ));
                                  //String num="$item['price']";
                                  double  myDouble = double.parse("${data[index].price}");
                                  cart.addItem("${data[index].producyName}", "${data[index].producyName}",myDouble);
                                }),*/
                            title: Row(
                              children: [
                                GestureDetector(
                                  child:   Container(

                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreenAccent,
                                      image: DecorationImage(
                                        image: NetworkImage('https://source.unsplash.com/random?sig=$index'),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  /*  child: Center(
                                      child: Text(
                                        '${data[index].id}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),*/
                                  ),
                                  onTap: (){
                                    Navigator.push(context,MaterialPageRoute(
                                      builder: (context) => Shopview(text: '${data[index].producyName}',price:'${data[index].description}',image:'https://source.unsplash.com/random?sig=$index',description:'${data[index].description}',quantity:'${data[index].description}',category:'${data[index].description}'),));
                                  },
                                ),

                                SizedBox(width: 20),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${data[index].producyName}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${data[index].description}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ]),
                                buildRating(2),
                              ],

                            ),
                            // trailing: Text('More Info'),
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}
