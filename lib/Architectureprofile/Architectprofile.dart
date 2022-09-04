import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blogapp/Architectureprofile/screens/ArchitectureProjects.dart';
import 'package:blogapp/checkout/widgets/viewgallery.dart';

import 'package:blogapp/shop/DataModel.dart';
import 'package:blogapp/shop/ShopProfile/updateitem.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'EditArchitecture.dart';
import 'constants.dart';

class Architectprofile extends StatefulWidget {

  _ArchitectprofileState createState() => _ArchitectprofileState();
}

class _ArchitectprofileState extends State<Architectprofile>{
  final storage = FlutterSecureStorage();
  File _image;
  final picker = ImagePicker();
  String businessName;
  String email;
  String shopid;
  String arcid;
  String description;
  String motto;
  List profilepic;
  List services;
  List shopPics;
  List projects;
  List proofDocuments;
  var _architecture;
  String _imagepath;

  void readuser() async {
    //ID = await storage.read(key: "id");
    String array= await storage.read(key: "array");
    Fluttertoast.showToast(
      msg: array,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  void fetcharchitect() async {
    print('architect');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architects/getUsersArchitect'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');

      print('Single architect : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      print(jsonData);
      setState(() {
        _architecture = jsonData;
        businessName = _architecture['businessName'].toString();
        description = _architecture['description'].toString();
        motto = _architecture['motto'].toString();
        email = _architecture['email'].toString();
        arcid = _architecture['_id'].toString();
        profilepic=_architecture['profilePicture'];
        shopPics = _architecture['shopImages'];
        services= _architecture['services'];
        projects = _architecture['projects'];
        proofDocuments = _architecture['proofDocuments'];
      });
    } catch (err) {}
  }

  var _architectjson = [];
  var selectedCard = 'WEIGHT';



  void SaveImage(path) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("imagepath", path);
    print(path);
  }

  Future deletePost(String id) async {
    print(id);
    final response = await http.delete(
        "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/deleteItem/$id");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<DataModel> DeleteData(String id) async {
    var response = await http.post(
        Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/$id'),
        body: {
          "shopId": shopid,
        });
    var data = response.body;
    print(data);
    if (response.statusCode == 201) {
      String responseString = response.body;
      dataModelFromJson(responseString);
    }
  }

  Future<String> deleteWithBodyExample(String id) async {
    print(id);
    print(shopid);
    final url =
    Uri.parse("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items/$id");
    final request = http.Request("DELETE", url);
    request.headers.addAll(<String, String>{
      "Accept": "application/json",
    });
    request.body = jsonEncode({"shopId": shopid});
    final response = await request.send();
    if (response.statusCode != 200)
      return Future.error("error: status code ${response.statusCode}");
    return await response.stream.bytesToString();
  }

  chooseImage(ImageSource source) async {
    final image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
    SaveImage(_image.path);
  }
  // AnimationController controller;
  void initState() {
    loadImage();
    readuser();
    fetcharchitect();
    super.initState();
  }

  Future<Item> Block(String id) async {
    print(id);
    final response = await http.put(
      Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/setShopVisibility/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'status':"Block",

      }),
    );
    print(response.body);

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {

      throw Exception('Failed to Deactivate.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_architecture==null?Center(child: CircularProgressIndicator()):Container(
        margin: const EdgeInsets.all(10.0),

        child:SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(8),

                          child:Text(
                            "${businessName.toString()}",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF545D68))
                          ),
                        ),
                      ),

                      SizedBox(height: 5.0),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 1.0),
                              child: Material(
                                type: MaterialType.transparency,
                                child: Ink(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green, width: 2.0),
                                    color: Colors.lightGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(500.0),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditArchitect(
                                                id: "${shopid}",
                                                businessName: "${businessName}",
                                                email: "${email}",
                                                motto: "${motto}",
                                                description: "${description}"),
                                          ));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.edit,
                                        size: 25.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Center(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: _image != null
                                                ? Container(
                                              height: 130,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${profilepic[0]['img']}'),
                                                ),
                                              ),
                                            )
                                                : Container(
                                              height: 130,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      'https://firebasestorage.googleapis.com/v0/b/myweb-72a93.appspot.com/o/govipiyasa%2Fshop.jpg?alt=media&token=fbe35e0b-76fc-4f7c-ad9b-730b9476860c'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              "${email}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: Center(
                                              child: Column(children: [/*
                                                GestureDetector(
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              chooseImage(ImageSource.gallery);
                                                            },
                                                            icon: Icon(Icons.camera_alt_sharp)),
                                                      ]),
                                                ),*/
                                              ]),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ]),

              ),

              SizedBox(height: 5,),
              Container(

                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: HexColor("#e9fce4"),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(22),
                                topRight: Radius.circular(22),
                                bottomLeft: Radius.circular(22),
                                bottomRight: Radius.circular(22),
                              ),
                            ),
                            child:Center(
                              child: motto==null?Center(child: CircularProgressIndicator()):Text(
                                "${motto}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                        ),
                      ),

                      SizedBox(height: 5.0),
                    ]),

              ),
              shopPics.length >0 ?Container(
                child: GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: shopPics.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => viewgallery(
                                      image: shopPics[index]["img"])));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            color: const Color(0x1A0097A7).withOpacity(0.1),
                          ),
                          child: Container(

                              child:Image.network(shopPics[index]["img"])),
                        ),
                      );
                    }),
              ):Container(child:Center(child:Text("No data"))),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 1.5, // 30 padding
                  vertical: kDefaultPadding / 4, // 5 top and bottom
                ),
                decoration: BoxDecoration(
                  color: HexColor("#e9fce4"),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: Center(
                  child:Text(
                    "${description.toString()}",
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
              Container(child:Text("Services",  style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),),),
              Container(
                  height: 100.0,
                  child: ListView.builder(
                      itemCount: services.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        return  _buildInfoCard('${services[index]}}', '', '');
                      }


                  )),
              Divider(),
              Container(child:Text("My Projects",  style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),),),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                height: 200,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ListView.builder(
                    itemCount: projects?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),

                        height: 160,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArchitectProject(title:"${projects[index]['title']}",description:"${projects[index]['description']}",pics:projects[index]['projectPictures'])));
                          },
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              // Those are our background
                              Container(
                                height: 116,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  color: index.isEven ? kBlueColor : kSecondaryColor,
                                  boxShadow: [kDefaultShadow],
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                              ),
                              // our product image
                              Positioned(
                                top: 20,
                                right: 0,
                                child: Hero(
                                  tag: 'mk',
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                                    height: 100,
                                    // image is square but we add extra 20 + 20 padding thats why width is 200
                                    width: 180,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "${projects[index]['projectPictures'][0]['img']}"),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ),

                              // Product title and price
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: SizedBox(
                                  height: 100,
                                  // our image take 200 width, thats why we set out total width - 200
                                  width:200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultPadding),
                                        child: Text(
                                          "${projects[index]['title']}",
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                      ),
                                      // it use the available space
                                      Spacer(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding * 1.5, // 30 padding
                                          vertical: kDefaultPadding / 4, // 5 top and bottom
                                        ),
                                        decoration: BoxDecoration(
                                          color: kSecondaryColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(22),
                                            topRight: Radius.circular(22),
                                          ),
                                        ),
                                        child: Text(
                                          "\$",
                                          style: Theme.of(context).textTheme.button,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Container(child:Text("Proof Documents",  style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),),),
              Container(
                  height: 150.0,
                  child: ListView.builder(
                      itemCount: proofDocuments.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        return  _buildInfoCard1('', '${proofDocuments[0]['img']}', '');
                      }


                  )),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

  Future loadImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _imagepath = pref.getString("imagepath");
      _image = File(_imagepath.toString());
    });
    print(_imagepath);
  }
  Widget _buildInfoCard1(String cardTitle, String info, String unit) {
    return InkWell(
        onTap: () {
          selectCard(cardTitle);
        },
        child: AnimatedContainer(
            margin: EdgeInsets.all(5),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color:
              cardTitle == selectedCard ? Colors.lightGreen : Colors.white,
              border: Border.all(
                  color: cardTitle == selectedCard
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 0.75),
            ),
            height: 100.0,
            width: 200.0,
            child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => viewgallery(
                                  image:info)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),

                      height: 100,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${info}"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                color: cardTitle == selectedCard
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(unit,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.0,
                              color: cardTitle == selectedCard
                                  ? Colors.white
                                  : Colors.black,
                            ))
                      ],
                    ),
                  )
                ])));
  }
  Widget _buildInfoCard(String cardTitle, String info, String unit) {
    return InkWell(
        onTap: () {
          selectCard(cardTitle);
        },
        child: AnimatedContainer(
            margin: EdgeInsets.all(5),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color:
              cardTitle == selectedCard ? Colors.lightGreen : Colors.white,
              border: Border.all(
                  color: cardTitle == selectedCard
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 0.75),
            ),
            height: 60.0,
            width: 100.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                    child: Text(cardTitle,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          color: cardTitle == selectedCard
                              ? Colors.white
                              : Colors.grey.withOpacity(0.7),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.0,
                                color: cardTitle == selectedCard
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(unit,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.0,
                              color: cardTitle == selectedCard
                                  ? Colors.white
                                  : Colors.black,
                            ))
                      ],
                    ),
                  )
                ])));
  }
  void alert(context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: "Shop Deactivate",
      buttonsTextStyle: const TextStyle(color: Colors.black),
      showCloseIcon: true,
      btnOkOnPress: () {
        //updateItem(shopid);
      },
    ).show();
  }
  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
}
