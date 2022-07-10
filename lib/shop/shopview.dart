import 'package:blogapp/shop/custom/BorderIcon.dart';
import 'package:blogapp/shop/utils/constants.dart';
import 'package:blogapp/shop/utils/custom_functions.dart';
import 'package:blogapp/shop/utils/widget_functions.dart';
import 'package:flutter/material.dart';

import 'custom/OptionButton.dart';



class Shopview extends StatelessWidget {
  final String text;
  final String price;
  final String image;
  final String quantity;
  final String description;
  final String category;

  Shopview(
      {Key key,
        @required this.text,
        @required this.price,
        @required this.image,
        @required this.quantity,
        @required this.description,
        @required this.category})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    return SafeArea(
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        image!=null?Image.network("$image"):AssetImage("assets/architect.jpg"),
                        Positioned(
                          width: size.width,
                          top: padding,
                          child: Padding(
                            padding: sidePadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: BorderIcon(
                                    height: 50,
                                    width: 50,
                                    child: Icon(Icons.keyboard_backspace,color: Colors.lightGreen,),
                                  ),
                                ),
                                BorderIcon(
                                  height: 50,
                                  width: 50,
                                  child: Icon(Icons.favorite_border,color:Colors.lightGreen,),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addVerticalSpace(5),
                              Text('items count:$price',style: themeData.textTheme.subtitle2,),
                            ],
                          ),
                          BorderIcon(child: Text('Shopname:$text',style: themeData.textTheme.headline5,),padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),)
                        ],
                      ),
                    ),
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Text("Shop Information",style: themeData.textTheme.headline4,),
                    ),
                    addVerticalSpace(padding),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          InformationTile(content: text,name: description),
                          InformationTile(content: text,name: description),
                          InformationTile(content: text,name: description,),
                          InformationTile(content: text,name: description)
                        ],
                      ),
                    ),
                    addVerticalSpace(padding),
                    Padding(
                      padding: sidePadding,
                      child: Text(description
                        ,textAlign: TextAlign.justify,style: themeData.textTheme.bodyText2,),
                    ),
                    addVerticalSpace(100),
                  ],
                ),
              ),
              Positioned(
                bottom: 15,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OptionButton(text: "Message",icon: Icons.message,width: size.width*0.35,),
                    addHorizontalSpace(10),
                    OptionButton(text: "Call",icon: Icons.call,width: size.width*0.35,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InformationTile extends StatelessWidget{

  final String content;
  final String name;

  const InformationTile({Key key,@required this.content,@required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    final double tileSize = size.width*0.20;
    return Container(
      margin: const EdgeInsets.only(left: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BorderIcon(
              width: tileSize,
              height: tileSize,
              child: Text(content,style: themeData.textTheme.headline3,)),
          addVerticalSpace(15),
          Text(name,style: themeData.textTheme.headline6,)
        ],
      ),
    );

  }

}