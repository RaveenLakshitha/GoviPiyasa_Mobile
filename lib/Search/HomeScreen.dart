import 'package:blogapp/Search/search.dart';
import 'package:blogapp/Search/user_model.dart';
import 'package:blogapp/checkout/widgets/itemdetails.dart';
import 'package:blogapp/shop/shopview.dart';
import 'package:flutter/material.dart';

import 'Api_service.dart';


class Searchitems extends StatefulWidget {
  @override
  _SearchitemsState createState() => _SearchitemsState();
}

class _SearchitemsState extends State<Searchitems> {
  FetchUserList _userList = FetchUserList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('UserList'),
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
                                    builder: (context) => Itemdetails(text: '${data[index].productName}',price:'${data[index].description}',image:'https://source.unsplash.com/random?sig=$index',description:'${data[index].description}',quantity:'${data[index].description}',category:'${data[index].description}'),
                                  ));
                            },
                            title: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){

                                 /*   Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Shopview(
                                              id:'${data[index].id}',
                                              text: '${data[index].productName}',
                                              price: '${data[index].description}',
                                              image:'https://source.unsplash.com/random?sig=$index',
                                              description: '${data[index].description}',
                                              quantity: '${data[index].description}',
                                              category: '${data[index].categoryName}',
                                              itemCount:'${data[index].quantity}',
                                              shopitems:'${data[index].description}',
                                              latlang:'${data[index].description}}',
                                              longitude:'${data[index].description}}'

                                          ),

                                        ));
                                    Navigator.push(context,MaterialPageRoute(
                                      builder: (context) => Shopview(text: '${data[index].productName}',price:'${data[index].description}',image:'https://source.unsplash.com/random?sig=$index',description:'${data[index].description}',quantity:'${data[index].description}',category:'${data[index].description}'),));*/
                                  },
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
                                    /*      child: Center(
                                    child: Text(
                                      '${data[index].id}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),*/
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        '${data[index].productName}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${data[index].categoryName}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${data[index].price}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ])
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